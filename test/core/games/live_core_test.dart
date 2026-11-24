import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/chess/position.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/games/analysis.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/live_config.dart';
import 'package:princesschess/core/games/live_game.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/games/time_control.dart';
import 'package:princesschess/core/games/uci_reader.dart';

/// The relay's output for game 1 of the 2026 match (feed/test/fixtures, same file).
final golden = File('test/fixtures/wch2026_r1_feed.pgn').readAsStringSync();

GameRecord prefix(GameRecord g, int plies, {String result = '*', Map<String, String> extra = const {}}) {
  final p = parsePgn(golden).single;
  return GameRecord.fromPgn(
    PgnGame(
      headers: {...p.headers, 'Result': result, ...extra},
      sans: p.sans.take(plies).toList(),
      result: result,
      clocks: p.clocks.take(plies).toList(),
      evals: p.evals.take(plies).toList(),
    ),
  );
}

void main() {
  final pgn = parsePgn(golden).single;
  final game = GameRecord.fromPgn(pgn);

  test('relay PGN keeps clocks and evals per ply', () {
    expect(game.length, 76);
    expect(pgn.clocks.length, 76);
    expect(pgn.clocks.first, const Duration(hours: 1, minutes: 59, seconds: 50));
    expect(pgn.evals.first, const Eval.cp(18));
    expect(game.clockOf(Side.black, 2), const Duration(hours: 1, minutes: 59, seconds: 52));
    expect(game.evalAt(76), const Eval.cp(0));
    expect(game.headers['TimeControl'], '40/7200:1800+30');
  });

  test('library PGN without annotations parses as before', () {
    final g = parsePgn('[White "A"]\n[Black "B"]\n\n1. e4 {nice} e5 (1... c5) 2. Nf3 *').single;
    expect(g.sans, ['e4', 'e5', 'Nf3']);
    expect(g.clocks, isEmpty);
    expect(Eval.parse('#-3'), const Eval.mate(-3));
    expect(parseClock('0:05'), const Duration(seconds: 5));
    expect(formatClock(const Duration(hours: 1, minutes: 2, seconds: 3)), '1:02:03');
    expect(formatClock(const Duration(minutes: 4, seconds: 9)), '04:09');
  });

  test('time control: periods, next control and time trouble', () {
    final tc = TimeControl.parse('40/7200:1800+30')!;
    expect(tc.initial, const Duration(hours: 2));
    expect(tc.nextControl(0), (40, const Duration(minutes: 30)));
    expect(tc.nextControl(39), (1, const Duration(minutes: 30)));
    expect(tc.nextControl(40), isNull);
    expect(tc.periodBase(45), const Duration(minutes: 30));
    expect(TimeControl.parse('120\'/40m'), isNull);
    // 10 moves to the control: under 10 minutes is trouble.
    expect(inTimeTrouble(const Duration(minutes: 9), 30, tc), isTrue);
    expect(inTimeTrouble(const Duration(minutes: 11), 30, tc), isFalse);
    expect(inTimeTrouble(const Duration(minutes: 1), 50, tc), isTrue);
    expect(inTimeTrouble(const Duration(minutes: 3), 50, tc), isFalse);
    expect(inTimeTrouble(const Duration(minutes: 4), 10, null), isTrue);
  });

  test('readUci accepts both castling forms and cuts illegal lines', () {
    final pos = Position.fromFen('r1bqkb1r/pppp1ppp/2n2n2/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4');
    expect(readUci(pos, 'e1h1')!.isCastle, isTrue);
    expect(readUci(pos, 'e1g1')!.isCastle, isTrue);
    expect(readUci(pos, 'e1e2'), isNotNull);
    expect(readUci(pos, 'a1a5'), isNull);
    expect(readUci(pos, 'e7e8x'), isNull);
    expect(readUciLine(pos, ['e1h1', 'f6e4', 'a1a8', 'f1e1']).length, 2);
  });

  test('analysis line: legal moves, undo and reset', () {
    final a = AnalysisLine(Position.initial());
    expect(a.play(Square.parse('e2'), Square.parse('e5')), isNull);
    expect(a.play(Square.parse('e2'), Square.parse('e4')), isNotNull);
    a.play(Square.parse('e7'), Square.parse('e5'));
    expect(a.sans(), ['e4', 'e5']);
    a.undo();
    expect(a.position.sideToMove, Side.black);
    a.reset();
    expect(a.isEmpty, isTrue);
  });

  test('diff: a longer snapshot adds plies, a corrected move rewrites', () {
    final a = prefix(game, 20), b = prefix(game, 23);
    expect(diffGames(a, b).added, 3);
    expect(diffGames(a, b).rewrittenFrom(a.length), isFalse);
    final other = GameRecord.fromPgn(parsePgn('1. e4 e5 2. Nf3 Nc6 3. Bc4 *').single);
    final c = diffGames(prefix(game, 6), other);
    expect(c.common, 4);
    expect(c.rewrittenFrom(6), isTrue);
  });

  test('clocks tick for the side to move from LastMoveAt', () {
    final at = DateTime.utc(2026, 11, 25, 15);
    final g = prefix(game, 30, extra: {'LastMoveAt': '${at.millisecondsSinceEpoch ~/ 1000}'});
    // After 30 plies (15... a4) White is to move with 1:23:12 left.
    final c = clocksAt(g, 30, now: at.add(const Duration(minutes: 5)), ticking: true, lastMoveAt: lastMoveAtOf(g));
    expect(c.running, Side.white);
    expect(c.white, const Duration(hours: 1, minutes: 18, seconds: 12));
    expect(c.black, const Duration(hours: 1, minutes: 7, seconds: 23));
    expect(c.approximate, isFalse);
    expect(c.trouble, isEmpty);
    // 23... Nxe5 left Black 11:06 for 17 moves to the control: trouble.
    expect(clocksAt(game, 46, now: at).trouble, contains(Side.black));
    final frozen = clocksAt(g, 30, now: at.add(const Duration(minutes: 5)));
    expect(frozen.white, const Duration(hours: 1, minutes: 23, seconds: 12));
    final noTime = clocksAt(prefix(game, 30), 30, now: at.add(const Duration(seconds: 10)), ticking: true, seenAt: at);
    expect(noTime.approximate, isTrue);
    expect(noTime.white, const Duration(hours: 1, minutes: 23, seconds: 2));
  });

  test('who is ahead: five steps', () {
    expect(aheadStep(20, null, liveAheadSteps), 0);
    expect(aheadStep(120, null, liveAheadSteps), 1);
    expect(aheadStep(-500, null, liveAheadSteps), -2);
    expect(aheadStep(null, 3, liveAheadSteps), 2);
    expect(aheadStep(null, null, liveAheadSteps), 0);
  });
}
