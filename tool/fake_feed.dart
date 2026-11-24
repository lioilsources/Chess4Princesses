// Local stand-in for the live relay (Prompts/06-ZIVY_PRENOS_PLAN.md §9):
// plays game 1 of the 2026 match ply by ply with the relay's paths, ETag,
// TimeControl and LastMoveAt, plus a canned adviser answer.
//
//   dart run tool/fake_feed.dart [--every 5] [--start-ply 30] [--burst 1]
//                                [--correct-at 40] [--port 8787]
//   flutter run --dart-define=FEED_BASE_URL=http://localhost:8787
//   (Android emulator: adb reverse tcp:8787 tcp:8787)
import 'dart:convert';
import 'dart:io';

import 'package:princesschess/core/chess/rules.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/pgn.dart';

const _tour = 'wch2026';
const _round = 'Sim00001';

Future<void> main(List<String> args) async {
  int opt(String name, int fallback) {
    final i = args.indexOf('--$name');
    return i >= 0 && i + 1 < args.length ? int.parse(args[i + 1]) : fallback;
  }

  final every = Duration(seconds: opt('every', 5));
  final startPly = opt('start-ply', 30);
  final burst = opt('burst', 1);
  final correctAt = opt('correct-at', -1);
  final port = opt('port', 8787);

  final game = parsePgn(File('feed/test/fixtures/wch2026_r1_feed.pgn').readAsStringSync()).single;
  final started = DateTime.now();

  int pliesNow() {
    final steps = DateTime.now().difference(started).inMilliseconds ~/ every.inMilliseconds;
    return (startPly + steps * burst).clamp(0, game.sans.length);
  }

  DateTime lastMoveAt(int plies) {
    final steps = ((plies - startPly) / burst).ceil();
    return started.add(every * (steps < 0 ? 0 : steps));
  }

  String roundPgn() {
    final n = pliesNow();
    final done = n >= game.sans.length;
    final result = done ? game.result : '*';
    final b = StringBuffer();
    for (final e in game.headers.entries) {
      b.writeln('[${e.key} "${e.key == 'Result' ? result : e.value}"]');
    }
    if (!done) b.writeln('[LastMoveAt "${lastMoveAt(n).millisecondsSinceEpoch ~/ 1000}"]');
    b.writeln();
    for (var i = 0; i < n; i++) {
      if (i.isEven) b.write('${i ~/ 2 + 1}. ');
      // A source correction: for one step the move at --correct-at is a different legal one.
      final san = i == correctAt && n == correctAt + 1 ? _alternative(game, i) : game.sans[i];
      final clk = game.clocks[i], ev = game.evals[i];
      b.write('$san {${clk == null ? '' : '[%clk ${formatClock(clk)}]'}${ev == null ? '' : '[%eval $ev]'}} ');
    }
    b.writeln(result);
    return b.toString();
  }

  Map<String, Object> live() => {
    'v': 1,
    'tournaments': [
      {
        'id': _tour,
        'name': {'cs': 'Simulace: Zápas o mistra světa 2026', 'en': 'Simulation: World Championship Match 2026'},
        'emblem': 'crown',
        'rounds': [
          {'id': _round, 'n': 1, 'startsAt': started.millisecondsSinceEpoch, 'state': pliesNow() >= game.sans.length ? 'finished' : 'ongoing'},
        ],
      },
    ],
  };

  // No engine here: the adviser answers "still thinking" (the real relay asks the source).
  const advice = {'v': 1, 'depth': 0, 'lines': <Object>[]};

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  stdout.writeln('fake feed on http://localhost:$port  (every ${every.inSeconds}s, from ply $startPly, burst $burst)');
  await for (final req in server) {
    final path = req.uri.path;
    String? body;
    var type = 'application/json; charset=utf-8';
    if (path == '/v1/live.json') {
      body = jsonEncode(live());
    } else if (path == '/v1/t/$_tour/$_round.pgn') {
      body = roundPgn();
      type = 'application/x-chess-pgn; charset=utf-8';
    } else if (path == '/v1/advice') {
      body = jsonEncode(advice);
    }
    final res = req.response;
    if (body == null) {
      res.statusCode = 404;
    } else {
      final etag = 'W/"${body.hashCode.toRadixString(16)}"';
      res.headers
        ..set(HttpHeaders.etagHeader, etag)
        ..contentType = ContentType.parse(type);
      if (req.headers.value(HttpHeaders.ifNoneMatchHeader) == etag) {
        res.statusCode = 304;
      } else {
        res.write(body);
      }
    }
    stdout.writeln('${res.statusCode} $path  plies ${pliesNow()}');
    await res.close();
  }
}

/// Another legal SAN in the same position (for --correct-at).
String _alternative(PgnGame g, int ply) {
  const rules = Rules();
  final pos = GameRecord.fromPgn(g).positions[ply];
  final other = rules.legalMoves(pos).map((m) => rules.san(pos, m)).firstWhere((s) => s.replaceAll(RegExp('[+#]'), '') != g.sans[ply].replaceAll(RegExp('[+#]'), ''));
  return other;
}
