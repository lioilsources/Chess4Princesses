import 'dart:math';

import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';

/// Bot levels from PLAN §2. Never "spiteful": no traps, no delaying mate.
enum BotLevel {
  /// Random legal move.
  baby,

  /// Takes a free piece, otherwise random.
  puppy,

  /// Minimax depth 2 + material, a bit of randomness.
  knightess,

  /// Minimax depth 3 + material.
  dragoness;

  static BotLevel parse(String s) => switch (s) {
    'baby' || '1' => baby,
    'puppy' || '2' => puppy,
    'knightess' || '3' => knightess,
    'dragoness' || '4' => dragoness,
    _ => throw FormatException('Unknown bot level "$s"'),
  };
}

class Bot {
  Bot(this.level, {this.rules = const Rules(), Random? random, this.goal = BotGoal.material})
    : _rnd = random ?? Random();

  final BotLevel level;
  final Rules rules;
  final BotGoal goal;
  final Random _rnd;

  Move? chooseMove(Position pos) {
    final moves = rules.legalMoves(pos);
    if (moves.isEmpty) return null;
    // Promotions: always a queen (kids' games, PLAN — no underpromotion tricks).
    final candidates = moves.where((m) => m.promotion == null || m.promotion == PieceType.queen).toList();

    switch (level) {
      case BotLevel.baby:
        return candidates[_rnd.nextInt(candidates.length)];
      case BotLevel.puppy:
        final free = candidates.where((m) {
          final victim = pos.capturedBy(m);
          if (victim == null) return false;
          final after = pos.apply(m);
          return !rules.isAttacked(after, m.to, pos.sideToMove.opponent);
        }).toList();
        final pool = free.isNotEmpty ? free : candidates;
        return pool[_rnd.nextInt(pool.length)];
      case BotLevel.knightess:
        return _search(pos, candidates, 2, noise: 60);
      case BotLevel.dragoness:
        return _search(pos, candidates, 3, noise: 20);
    }
  }

  Move _search(Position pos, List<Move> moves, int depth, {required int noise}) {
    var best = <Move>[];
    var bestScore = -1 << 30;
    for (final m in moves) {
      final score = -_negamax(pos.apply(m), depth - 1, -1 << 30, 1 << 30) + _rnd.nextInt(noise + 1);
      if (score > bestScore) {
        bestScore = score;
        best = [m];
      } else if (score == bestScore) {
        best.add(m);
      }
    }
    return best[_rnd.nextInt(best.length)];
  }

  int _negamax(Position pos, int depth, int alpha, int beta) {
    final moves = rules.legalMoves(pos);
    if (moves.isEmpty) {
      return rules.status(pos) == GameStatus.checkmate ? -100000 - depth : 0;
    }
    final won = goal.score(pos, rules);
    if (won != null) return won;
    if (depth == 0) return evaluate(pos);
    var a = alpha;
    for (final m in moves) {
      final s = -_negamax(pos.apply(m), depth - 1, -beta, -a);
      if (s >= beta) return s;
      if (s > a) a = s;
    }
    return a;
  }

  /// Material (centipawns) from the side to move's point of view, plus a
  /// small pawn-advance bonus so pawn wars move forward.
  int evaluate(Position pos) {
    var score = 0;
    for (final (sq, p) in pos.pieces) {
      var v = p.type.value * 100;
      if (p.type == PieceType.pawn) {
        v += 6 * (p.side == Side.white ? sq.rank - 1 : 6 - sq.rank);
      }
      score += p.side == pos.sideToMove ? v : -v;
    }
    return score;
  }
}

/// Extra terminal condition for mini-games (pawn war: first pawn home wins).
enum BotGoal {
  material,
  pawnWar;

  /// Terminal score from the side to move's view, or null when not over.
  int? score(Position pos, Rules rules) {
    if (this != pawnWar) return null;
    final winner = pawnWarWinner(pos);
    if (winner == null) return null;
    return winner == pos.sideToMove ? 50000 : -50000;
  }
}

/// Pawn war (LESSONS m1): a side wins when its pawn reaches the last rank
/// (promotion) or the opponent has no pawns left.
Side? pawnWarWinner(Position pos) {
  var whitePawns = 0, blackPawns = 0;
  for (final (sq, p) in pos.pieces) {
    if (p.side == Side.white && (p.type != PieceType.pawn || sq.rank == 7)) return Side.white;
    if (p.side == Side.black && (p.type != PieceType.pawn || sq.rank == 0)) return Side.black;
    if (p.side == Side.white) whitePawns++;
    if (p.side == Side.black) blackPawns++;
  }
  if (whitePawns == 0) return Side.black;
  if (blackPawns == 0) return Side.white;
  return null;
}
