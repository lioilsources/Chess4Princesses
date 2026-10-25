import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/chess/position.dart';
import 'package:princesschess/core/chess/rules.dart';
import 'package:princesschess/core/chess/types.dart';

int perft(Rules r, Position p, int depth) {
  if (depth == 0) return 1;
  final moves = r.legalMoves(p);
  if (depth == 1) return moves.length;
  var n = 0;
  for (final m in moves) {
    n += perft(r, p.apply(m), depth - 1);
  }
  return n;
}

void main() {
  const full = Rules();
  const lesson = Rules(RuleSet.pieceOnly);

  group('perft (full rules)', () {
    test('initial position', () {
      final p = Position.initial();
      expect(perft(full, p, 1), 20);
      expect(perft(full, p, 2), 400);
      expect(perft(full, p, 3), 8902);
    });
    test('kiwipete', () {
      final p = Position.fromFen('r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
      expect(perft(full, p, 1), 48);
      expect(perft(full, p, 2), 2039);
      expect(perft(full, p, 3), 97862);
    });
    test('position 3 (en passant, pins)', () {
      final p = Position.fromFen('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1');
      expect(perft(full, p, 1), 14);
      expect(perft(full, p, 2), 191);
      expect(perft(full, p, 3), 2812);
      expect(perft(full, p, 4), 43238);
    });
    test('position 4 (promotions)', () {
      final p = Position.fromFen('r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1');
      expect(perft(full, p, 1), 6);
      expect(perft(full, p, 2), 264);
      expect(perft(full, p, 3), 9467);
    });
  });

  group('kingless lesson positions', () {
    test('lone rook has 14 moves', () {
      final p = Position.fromFen('8/8/8/8/8/8/R7/8');
      expect(lesson.legalMoves(p).length, 14);
      expect(full.legalMoves(p).length, 14);
    });
    test('pawn double step and diagonal capture', () {
      final p = Position.fromFen('8/8/8/8/8/3p4/4P3/8');
      expect(lesson.legalMoves(p).map((m) => m.uci).toSet(), {'e2e3', 'e2e4', 'e2d3'});
    });
    test('piece_only ignores check', () {
      final p = Position.fromFen('4r3/8/8/8/8/8/8/4K3 w - - 0 1');
      expect(lesson.legalMoves(p).length, 5);
      expect(full.legalMoves(p).length, 4); // e2 is attacked; d1,d2,f1,f2 ok
    });
  });

  test('FEN round trip', () {
    for (final fen in [Position.initialFen, '8/8/8/3p4/8/8/R7/8 b - - 3 7']) {
      expect(Position.fromFen(fen).fen, fen);
    }
    expect(Position.fromFen('8/8/8/8/8/8/R7/8').fen, '8/8/8/8/8/8/R7/8 w - - 0 1');
  });

  test('SAN', () {
    final p = Position.initial();
    expect(full.san(p, full.parseSan(p, 'Nf3')!), 'Nf3');
    final fools = ['f3', 'e5', 'g4'].fold(p, (pos, s) => pos.apply(full.parseSan(pos, s)!));
    final qh4 = full.parseSan(fools, 'Qh4')!;
    expect(full.san(fools, qh4), 'Qh4#');
    expect(full.status(fools.apply(qh4)), GameStatus.checkmate);
  });

  test('square colours: h1 light, a1 dark', () {
    expect(Square.parse('h1').isLight, isTrue);
    expect(Square.parse('a1').isLight, isFalse);
  });

  test('path for lava', () {
    expect(Rules.path(Move(Square.parse('a1'), Square.parse('a4'))).map((s) => s.name), ['a2', 'a3', 'a4']);
    expect(Rules.path(Move(Square.parse('g1'), Square.parse('f3'))).map((s) => s.name), ['f3']);
  });

  test('Piece value', () => expect(PieceType.queen.value, 9));
}
