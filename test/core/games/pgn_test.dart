import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/chess/position.dart';
import 'package:princesschess/core/chess/rules.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/moments.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/games/san_reader.dart';

void main() {
  final samples = parsePgn(File('assets/games/samples.pgn').readAsStringSync());

  test('parser skips comments, variations, NAGs and clock tags', () {
    final g = parsePgn('''
[Event "Test"]
[White "A \\"B\\" C"]
[Result "1-0"]

1. e4 { [%eval 0.18] [%clk 0:10:07] } 1... e5 \$1 (1... c5 2. Nf3 (2. c3)) 2. Nf3!? ; line comment
Nc6 1-0
''').single;
    expect(g.headers['White'], 'A "B" C');
    expect(g.sans, ['e4', 'e5', 'Nf3', 'Nc6']);
    expect(g.result, '1-0');
  });

  test('several games and a header-only game', () {
    final gs = parsePgn('[Event "A"]\n\n1. d4 *\n\n[Event "B"]\n[Result "*"]\n\n *\n');
    expect(gs.map((g) => g.header('Event')), ['A', 'B']);
    expect(gs.last.sans, isEmpty);
  });

  test('writer round-trips and keeps only requested headers', () {
    final g = samples.first;
    final out = writePgn(g, keep: {'White', 'Black', 'Result'});
    final back = parsePgn(out).single;
    expect(back.sans, g.sans);
    expect(back.headers.keys, ['White', 'Black', 'Result']);
    expect(out, isNot(contains('Site')));
  });

  test('readSan agrees with Rules.parseSan on every sample ply', () {
    const rules = Rules();
    for (final g in samples) {
      var pos = Position.initial();
      for (final san in g.sans) {
        final fast = readSan(pos, san);
        expect(fast, isNotNull, reason: san);
        expect(fast, rules.parseSan(pos, san), reason: san);
        pos = pos.apply(fast!);
      }
    }
  });

  test('readSan accepts 0-0, missing = and rejects ambiguity', () {
    final pos = Position.fromFen('4k3/P7/8/8/8/8/8/R3K2R w KQ - 0 1');
    expect(readSan(pos, '0-0')!.isCastle, isTrue);
    expect(readSan(pos, 'a8Q')!.promotion?.letter, 'q');
    final twoRooks = Position.fromFen('4k3/8/8/8/8/4K3/8/R6R w - - 0 1');
    expect(readSan(twoRooks, 'Rd1'), isNull);
    expect(readSan(twoRooks, 'Rad1'), isNotNull);
  });

  test('samples replay legally and match their results', () {
    final records = samples.map(GameRecord.fromPgn).toList();
    expect(records.map((r) => r.length), [33, 82, 41]);
    expect(records[0].endsInMate, isTrue);
    expect(records[1].endsInMate, isTrue);
    expect(records[2].endsInMate, isFalse);
    // Final position given on Wikipedia for Menchik–Graf.
    expect(records[2].finalPosition.fen.split(' ').first, 'r4rk1/pbqRbp2/1p2p1p1/6Np/2P3n1/2B4Q/PPB2PPP/5RK1');
    for (final r in records) {
      expect(r.problems(), isEmpty);
    }
    expect(records.map((r) => r.id).toSet().length, 3);
  });

  test('illegal move is reported with the move number', () {
    final g = parsePgn('[White "A"]\n[Black "B"]\n\n1. e4 e5 2. Ke3 *').single;
    expect(() => GameRecord.fromPgn(g), throwsA(isA<GameFormatException>().having((e) => e.message, 'message', contains('2.Ke3'))));
  });

  test('a mate the header contradicts is a problem', () {
    final g = parsePgn('[Result "0-1"]\n\n1. f3 e5 2. g4 Qh4# 1-0').single;
    expect(GameRecord.fromPgn(g).problems(), isNotEmpty);
  });

  test('moments: mate, castle, sacrifice; battles capped', () {
    final opera = GameRecord.fromPgn(samples.first);
    final ms = findMoments(opera);
    expect(ms.last.kinds, contains(MomentKind.mate));
    expect(ms.any((m) => m.kinds.contains(MomentKind.castle)), isTrue);
    expect(ms.where((m) => m.kinds.contains(MomentKind.sacrifice)), isNotEmpty);
    final battles = battlePlies(ms);
    expect(battles.length, lessThanOrEqualTo(4));
    expect(battles, contains(ms.firstWhere((m) => m.isCapture).ply));
    final fischer = GameRecord.fromPgn(samples[1]);
    expect(battlePlies(findMoments(fischer)).length, 4);
  });
}
