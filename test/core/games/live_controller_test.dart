import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/net/feed_client.dart';
import 'package:princesschess/features/games/live_controller.dart';
import 'package:princesschess/features/games/live_watch.dart';
import 'package:princesschess/features/games/replay_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'replay_controller_test.dart' show FakeTimers;

final golden = File('test/fixtures/wch2026_r1_feed.pgn').readAsStringSync();
final full = parsePgn(golden).single;

/// The first [plies] of game 1, still running unless [result] is given.
GameRecord upTo(int plies, {String result = '*'}) => GameRecord.fromPgn(
  PgnGame(
    headers: {...full.headers, 'Result': result},
    sans: full.sans.take(plies).toList(),
    result: result,
    clocks: full.clocks.take(plies).toList(),
    evals: full.evals.take(plies).toList(),
  ),
);

String pgnOf(int plies, {String result = '*'}) {
  final b = StringBuffer();
  for (final e in full.headers.entries) {
    b.writeln('[${e.key} "${e.key == 'Result' ? result : e.value}"]');
  }
  b.writeln();
  for (var i = 0; i < plies; i++) {
    if (i.isEven) b.write('${i ~/ 2 + 1}. ');
    b.write('${full.sans[i]} {[%clk ${formatClock(full.clocks[i]!)}]} ');
  }
  b.writeln(result);
  return b.toString();
}

void main() {
  late FakeTimers timers;
  final watched = <String>[];
  final now = DateTime.utc(2026, 11, 25, 15);
  LiveController make(GameRecord g, {bool battles = true}) =>
      LiveController(g, timer: timers.call, now: () => now, battlesOn: battles, onWatched: (r) => watched.add(r.id))..start();

  setUp(() {
    timers = FakeTimers();
    watched.clear();
  });

  void runAll(LiveController c) {
    var guard = 0;
    while (guard++ < 500) {
      if (c.battle != null) {
        c.battleFinished();
      } else if (!timers.fire()) {
        break;
      }
    }
  }

  test('catch-up plays every ply quickly and waits live', () {
    final c = make(upTo(20));
    expect(c.phase, LivePhase.catchUp);
    expect(timers.pending.single.$1, const Duration(milliseconds: 120));
    runAll(c);
    expect(c.ply, 20);
    expect(c.battle, isNull);
    expect(c.phase, LivePhase.live);
  });

  test('skip jumps to the latest position', () {
    final c = make(upTo(30))..skipCatchUp();
    expect(c.ply, 30);
    expect(c.phase, LivePhase.live);
    expect(timers.pending, isEmpty);
  });

  test('a new capture arrives with a battle, a quiet move just slides', () {
    final c = make(upTo(5))..skipCatchUp();
    c.update(upTo(6)); // 3... Nf6
    expect(c.ply, 6);
    expect(c.battle, isNull);
    runAll(c);
    c.update(upTo(8)); // 4. O-O Nxe4
    runAll(c);
    expect(c.ply, 8);
    expect(c.line, ReplayLine.castle);
    final d = make(upTo(7))..skipCatchUp();
    d.update(upTo(8));
    expect(d.battle, isNotNull);
    expect(d.battle!.attacker.type, PieceType.knight);
  });

  test('more than four new plies come quickly without battles', () {
    final c = make(upTo(10))..skipCatchUp();
    c.update(upTo(20));
    expect(c.phase, LivePhase.catchUp);
    var battles = 0;
    var guard = 0;
    while (timers.fire() && guard++ < 100) {
      if (c.battle != null) battles++;
    }
    expect(battles, 0);
    expect(c.ply, 20);
    expect(c.phase, LivePhase.live);
  });

  test('own analysis is not interrupted; the banner counts missed plies', () {
    final c = make(upTo(10))..skipCatchUp();
    c.tryOwn();
    expect(c.away, LiveAway.analysis);
    c.tap(Square.parse('a2'));
    c.tap(Square.parse('a3'));
    expect(c.analysis!.moves.length, 1);
    c.update(upTo(12));
    expect(c.ply, 10);
    expect(c.missed, 2);
    expect(c.position.sideToMove, Side.black);
    c.backToGame();
    runAll(c);
    expect(c.ply, 12);
    expect(c.missed, 0);
  });

  test('adviser line plays on the board, then the viewer goes on alone', () {
    final c = make(upTo(6))..skipCatchUp();
    final pos = c.record.positions[6];
    final m1 = pos.sideToMove == Side.white;
    expect(m1, isTrue);
    c.playAdvice([for (final u in ['e1g1', 'f6e4']) Move(Square.parse(u.substring(0, 2)), Square.parse(u.substring(2)), isCastle: u == 'e1g1')]);
    expect(c.away, LiveAway.adviser);
    timers.fire();
    timers.fire();
    expect(c.analysis!.moves.length, 2);
    c.continueAlone();
    expect(c.away, LiveAway.analysis);
    c.undoOwn();
    expect(c.analysis!.moves.length, 1);
  });

  test('the end: result card line and one sticker', () {
    final c = make(upTo(76))..skipCatchUp();
    expect(c.phase, LivePhase.live);
    c.update(upTo(76, result: '1/2-1/2'));
    expect(c.phase, LivePhase.ended);
    expect(c.line, ReplayLine.endDraw);
    c.update(upTo(76, result: '1/2-1/2'));
    expect(watched.length, 1);
  });

  test('a corrected move rewinds to the shared start', () {
    final c = make(upTo(8))..skipCatchUp();
    final corrected = GameRecord.fromPgn(parsePgn('1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. d3 *').single);
    c.update(corrected);
    runAll(c);
    expect(c.ply, 7);
    expect(c.record.sans.last, 'd3');
  });

  test('chronicle browsing keeps the game going underneath', () {
    final c = make(upTo(10))..skipCatchUp();
    c.setChronicle(true);
    c.browse(4);
    expect(c.away, LiveAway.browse);
    c.update(upTo(11));
    expect(c.ply, 4);
    expect(c.missed, 1);
    c.browse(11);
    expect(c.inGame, isTrue);
  });

  test('chronicle steps slide the piece both ways, a jump does not', () {
    final c = make(upTo(10))..skipCatchUp();
    c.setChronicle(true);
    c.browse(9);
    expect(c.slide!.move.from, c.record.moves[9].to);
    expect(c.slide!.move.to, c.record.moves[9].from);
    c.browse(10);
    expect(c.slide!.move, c.record.moves[9]);
    c.browse(2);
    expect(c.slide, isNull);
  });

  group('watcher', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('asks with the ETag, backs off on errors, stores a finished round', () async {
      final client = _FakeClient();
      final seen = <int>[];
      final w = LiveRoundWatcher(client: client, tournamentId: 'wch2026', roundId: 'L3j03TZq', timer: timers.call, onGames: (g, _) => seen.add(g.single.length));
      client.next = pgnOf(10);
      w.start();
      await Future<void>.delayed(Duration.zero);
      expect(seen, [10]);
      expect(timers.pending.single.$1, const Duration(seconds: 10));
      client.notModified = true;
      timers.fire();
      await Future<void>.delayed(Duration.zero);
      expect(client.lastEtag, 'e1');
      expect(seen, [10]);
      client.fail = true;
      timers.fire();
      await Future<void>.delayed(Duration.zero);
      expect(w.interval, const Duration(seconds: 20));
      client
        ..fail = false
        ..notModified = false
        ..next = pgnOf(12, result: '1/2-1/2');
      timers.fire();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(seen, [10, 12]);
      expect(w.done, isTrue);
      expect(timers.pending, isEmpty);
      expect((await SharedPreferences.getInstance()).getString(liveRoundKey('wch2026', 'L3j03TZq')), isNotNull);
    });

    test('pause stops asking, resume asks again', () async {
      final client = _FakeClient()..next = pgnOf(4);
      final w = LiveRoundWatcher(client: client, tournamentId: 't', roundId: 'r', timer: timers.call, onGames: (_, _) {})..start();
      await Future<void>.delayed(Duration.zero);
      w.pause();
      expect(timers.pending, isEmpty);
      w.resume();
      await Future<void>.delayed(Duration.zero);
      expect(client.calls, 2);
    });
  });
}

class _FakeClient extends FeedClient {
  _FakeClient() : super(baseUrl: 'http://feed.invalid');
  String next = '';
  bool fail = false;
  bool notModified = false;
  String? lastEtag;
  int calls = 0;

  @override
  Future<FeedFetch> roundIfChanged(String tournamentId, String roundId, {String? etag}) async {
    calls++;
    lastEtag = etag;
    if (fail) throw Exception('offline');
    if (notModified) return FeedFetch(etag: etag);
    return FeedFetch(body: next, etag: 'e$calls', serverTime: DateTime.utc(2026, 11, 25, 15));
  }
}
