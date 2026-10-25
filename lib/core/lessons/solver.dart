import 'dart:collection';

import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';
import 'lesson.dart';

/// Breadth-first search over the player's moves with a passive opponent.
/// Shared by `tool/lesson_lint.dart` (is every lesson solvable, is `max_moves`
/// reachable?) and the `solution_first_move` hint.
class Solver {
  Solver(this.task) : rules = Rules(task.rules);

  final LessonTask task;
  final Rules rules;

  /// Moves allowed in [pos] — legal and not touching lava.
  List<Move> moves(Position pos) {
    final lava = task.lava.on(pos, task.player, rules);
    final kind = task.escape;
    final all = rules
        .legalMoves(pos)
        .where((m) => m.promotion == null || m.promotion == PieceType.queen)
        .where((m) => kind == null || escapeKind(pos, m) == kind);
    if (lava.isEmpty) return all.toList();
    return all.where((m) => !Rules.path(m).any(lava.contains)).toList();
  }

  /// Stars still uncollected after [m]: a piece picks up every star on its
  /// way, not only where it lands (a rook driving through a star takes it).
  static Set<Square> collect(Set<Square> remaining, Move m) {
    final path = Rules.path(m);
    return path.any(remaining.contains) ? remaining.difference(path.toSet()) : remaining;
  }

  /// Shortest move list reaching the goal from [start] with [remaining]
  /// stars, or null if none within [maxDepth].
  List<Move>? solve({Position? start, Set<Square>? remaining, bool promoted = false, int maxDepth = 14}) {
    if (!task.goal.isSolvable) return null;
    final root = _Node(start ?? task.position, remaining ?? task.stars.toSet(), promoted, null, null, 0);
    if (isWon(root.pos, root.stars, root.promoted)) return const [];
    final seen = <String>{root.key};
    final queue = Queue.of([root]);
    while (queue.isNotEmpty) {
      final n = queue.removeFirst();
      if (n.depth >= maxDepth) continue;
      for (final m in moves(n.pos)) {
        // Opponent is passive: hand the move straight back to the player.
        final next = n.pos.apply(m).passTurn();
        final child = _Node(next, collect(n.stars, m), n.promoted || m.promotion != null, n, m, n.depth + 1);
        if (isWon(child.pos, child.stars, child.promoted)) return child.path();
        if (seen.add(child.key)) queue.add(child);
      }
    }
    return null;
  }

  bool isWon(Position pos, Set<Square> stars, bool promoted) => switch (task.goal) {
    GoalType.reachSquare || GoalType.collectStars || GoalType.avoidLava => stars.isEmpty,
    GoalType.captureAll => stars.isEmpty && pos.piecesOf(task.player.opponent).isEmpty,
    GoalType.promote => stars.isEmpty && promoted,
    GoalType.escapeCheck => !rules.inCheck(pos, task.player),
    _ => false,
  };

  /// How [m] gets the mover's king out of check: taking a checking piece
  /// counts as capture (even by the king), other king moves as run, the
  /// rest as block.
  static EscapeKind escapeKind(Position pos, Move m) {
    final side = pos[m.from]!.side;
    final king = pos.kingOf(side);
    final checkers = king == null ? const <Square>{} : Rules(RuleSet.full).attackers(pos, king, side.opponent);
    if (checkers.contains(m.to)) return EscapeKind.capture;
    if (m.from == king) return EscapeKind.run;
    return EscapeKind.block;
  }

  /// Can any player piece reach [target] at all (yes/no "is the star
  /// reachable" puzzles, LESSONS m3 l2)?
  bool canReach(Square target) {
    final probe = LessonTask(goal: GoalType.reachSquare, rules: task.rules, position: task.position, stars: [target], lava: task.lava);
    return Solver(probe).solve(maxDepth: 8) != null;
  }
}

class _Node {
  _Node(this.pos, this.stars, this.promoted, this.parent, this.move, this.depth)
    : key = '${pos.boardKey}|${(stars.map((s) => s.index).toList()..sort()).join(',')}|$promoted';

  final Position pos;
  final Set<Square> stars;
  final bool promoted;
  final _Node? parent;
  final Move? move;
  final int depth;
  final String key;

  List<Move> path() {
    final out = <Move>[];
    for (var n = this; n.parent != null; n = n.parent!) {
      out.add(n.move!);
    }
    return out.reversed.toList();
  }
}
