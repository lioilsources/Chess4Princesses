import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';
import '../engine/bot.dart';
import 'lesson.dart';
import 'solver.dart';

enum MoveVerdict {
  ok,

  /// Not the piece's pattern — the piece "shakes its head" and shows where it may go.
  illegal,

  /// Would step on or drive through lava.
  lava,

  /// Not the player's piece, or not the player's turn.
  notYours,
}

enum TaskState { playing, won, lost }

/// Result of one applied move, for the UI (battle, sparkles, promotion anim).
class MoveEvent {
  const MoveEvent({required this.move, required this.mover, this.captured, this.starCollected = false});

  final Move move;
  final Piece mover;
  final Piece? captured;
  final bool starCollected;

  bool get isCapture => captured != null;
  bool get isPromotion => move.promotion != null;
}

/// Runtime state of one [LessonTask]. Pure Dart; the Flutter controller wraps it.
class TaskSession {
  TaskSession(this.task, {Bot? bot})
    : rules = Rules(task.rules),
      _bot = bot ?? Bot(task.bot, rules: Rules(task.rules), goal: BotGoal.pawnWar) {
    reset();
  }

  final LessonTask task;
  final Rules rules;
  final Bot _bot;

  late Position position;
  late Set<Square> starsLeft;
  late Set<Square> tapped;
  late int tapIndex;
  bool promoted = false;
  int moves = 0;
  TaskState state = TaskState.playing;

  /// Mistakes so far; drives hints and stars. Survives [reset].
  int fails = 0;


  /// Restarts the board (after a lost pawn war); fails are kept.
  void reset() {
    position = task.position;
    starsLeft = task.stars.toSet();
    tapped = {};
    tapIndex = 0;
    promoted = false;
    moves = 0;
    state = TaskState.playing;
  }

  Side get player => task.player;
  bool get playersTurn => position.sideToMove == player && state == TaskState.playing;

  Set<Square> get lava => task.lava.on(position, player, rules);

  // ---- moving ---------------------------------------------------------

  /// Moves the player's piece on [from] may make right now.
  List<Move> movesFrom(Square from) {
    final p = position[from];
    if (p == null || p.side != player) return const [];
    return rules.movesFrom(position, from);
  }

  /// Destinations that are both legal and lava-free.
  Set<Square> safeTargets(Square from) {
    final l = lava;
    return {
      for (final m in movesFrom(from))
        if (!Rules.path(m).any(l.contains)) m.to,
    };
  }

  /// Turns a from→to drag into a move; pawns promote to a queen
  /// (the "princess" — LESSONS m1 l4).
  Move? resolve(Square from, Square to) {
    final options = movesFrom(from).where((m) => m.to == to).toList();
    if (options.isEmpty) return null;
    return options.firstWhere((m) => m.promotion == null || m.promotion == PieceType.queen);
  }

  MoveVerdict check(Square from, Square to) {
    if (!task.goal.isMoveGoal || !playersTurn || position[from]?.side != player) return MoveVerdict.notYours;
    final m = resolve(from, to);
    if (m == null) return MoveVerdict.illegal;
    if (Rules.path(m).any(lava.contains)) return MoveVerdict.lava;
    // "Run away with the king" means the king: other legal escapes are wrong here.
    if (task.escape case final k? when Solver.escapeKind(position, m) != k) return MoveVerdict.illegal;
    return MoveVerdict.ok;
  }

  /// Records a mistake (wrong move, wrong tap, wrong answer).
  void fail() => fails++;

  /// Applies a checked player move. The opponent then passes, except in
  /// pawn war, where the UI asks for [botMove].
  MoveEvent play(Square from, Square to) {
    assert(check(from, to) == MoveVerdict.ok);
    final m = resolve(from, to)!;
    final ev = _apply(m);
    moves++;
    if (task.goal != GoalType.pawnWar && state == TaskState.playing) position = position.passTurn();
    return ev;
  }

  /// The pawn-war opponent's reply (null if it has no move).
  Move? botMove() => state == TaskState.playing && !playersTurn ? _bot.chooseMove(position) : null;

  MoveEvent playBot(Move m) => _apply(m);

  MoveEvent _apply(Move m) {
    final mover = position[m.from]!;
    final captured = position.capturedBy(m);
    final before = starsLeft.length;
    position = position.apply(m);
    if (mover.side == player) {
      starsLeft = Solver.collect(starsLeft, m);
      if (m.promotion != null) promoted = true;
    }
    _evaluate();
    return MoveEvent(move: m, mover: mover, captured: captured, starCollected: starsLeft.length < before);
  }

  void _evaluate() {
    if (task.goal == GoalType.pawnWar) {
      final w = pawnWarWinner(position);
      if (w != null) {
        state = w == player ? TaskState.won : TaskState.lost;
      } else if (rules.legalMoves(position).isEmpty) {
        state = TaskState.lost; // blocked: nobody wins, play again
      }
      return;
    }
    if (Solver(task).isWon(position, starsLeft, promoted)) state = TaskState.won;
  }

  // ---- tapping ---------------------------------------------------------

  /// Current tap_square target (`e`, `4` or `e4`).
  String? get currentTarget =>
      task.goal == GoalType.tapSquare && tapIndex < task.targets.length ? task.targets[tapIndex] : null;

  Set<Square> get tapTargets => switch (task.goal) {
    GoalType.tapSquare => currentTarget == null ? {} : squaresFor(currentTarget!),
    GoalType.tapAll when task.targets.length == 1 && task.targets.single == 'moves' => {
      // Pawns around the piece are scenery ("he jumps over friends").
      for (final (s, p) in task.position.piecesOf(player))
        if (p.type != PieceType.pawn) ...rules.movesFrom(task.position, s).map((m) => m.to),
    },
    GoalType.tapAll => {for (final t in task.targets) Square.parse(t)},
    GoalType.tapAttackers => switch (threatened) {
      final s? => rules.attackers(task.position, s, player.opponent),
      null => {},
    },
    _ => {},
  };

  /// tap_attackers: the square under threat — `targets: [sq]`, else my
  /// king, else my queen.
  Square? get threatened {
    if (task.targets.isNotEmpty) return Square.tryParse(task.targets.first);
    return task.position.kingOf(player) ??
        task.position.piecesOf(player).where((e) => e.$2.type == PieceType.queen).map((e) => e.$1).firstOrNull;
  }

  /// Squares matching a target label: a whole street, a house row or one room.
  static Set<Square> squaresFor(String target) {
    if (RegExp(r'^[a-h]$').hasMatch(target)) return Square.all.where((s) => s.fileName == target).toSet();
    if (RegExp(r'^[1-8]$').hasMatch(target)) return Square.all.where((s) => s.rankName == target).toSet();
    return {Square.parse(target)};
  }

  /// Returns true when the tap was right.
  bool tap(Square s) {
    if (state != TaskState.playing) return false;
    switch (task.goal) {
      case GoalType.tapSquare:
        if (!tapTargets.contains(s)) return _wrong();
        tapIndex++;
        if (tapIndex >= task.targets.length) state = TaskState.won;
        return true;
      case GoalType.tapAll || GoalType.tapAttackers:
        if (!tapTargets.contains(s)) return _wrong();
        tapped.add(s);
        if (tapped.containsAll(tapTargets)) state = TaskState.won;
        return true;
      default:
        return false;
    }
  }

  bool _wrong() {
    fail();
    return false;
  }

  // ---- setup -----------------------------------------------------------

  /// Pieces still to be placed for setup_pieces (target minus board).
  List<Piece> get tray {
    final target = task.targetPosition;
    if (target == null) return const [];
    return [
      for (final (s, p) in target.pieces)
        if (position[s] != p) p,
    ];
  }

  /// Drops a tray piece on [s]; true when it belongs there.
  bool drop(Piece piece, Square s) {
    final target = task.targetPosition;
    if (target == null || state != TaskState.playing) return false;
    if (target[s] != piece || position[s] == piece) return _wrong();
    position = position.edit(set: {s: piece});
    if (tray.isEmpty) state = TaskState.won;
    return true;
  }

  // ---- yes / no --------------------------------------------------------

  bool answer(bool yes) {
    if (state != TaskState.playing) return false;
    if (yes != task.answer) return _wrong();
    state = TaskState.won;
    return true;
  }

  // ---- hints & stars ---------------------------------------------------

  /// The strongest hint unlocked by the fail count, if any.
  HintKind? get activeHint {
    HintKind? h;
    for (final hint in task.hints) {
      if (fails >= hint.afterFails) h = hint.kind;
    }
    return h;
  }

  /// Fails only grow, so a hint unlocked once stays unlocked.
  bool get usedHint => activeHint != null;

  /// First move of a shortest solution from the current state.
  Move? solutionFirstMove() {
    if (!task.goal.isSolvable) return null;
    final path = Solver(task).solve(start: position, remaining: starsLeft, promoted: promoted);
    return path == null || path.isEmpty ? null : path.first;
  }

  /// 3 = no hint, no mistake, within par; 2 = few mistakes; 1 = finished.
  int get starsEarned {
    final withinPar = task.maxMoves == null || moves <= task.maxMoves!;
    if (fails == 0 && !usedHint && withinPar) return 3;
    if (fails <= 2) return 2;
    return 1;
  }
}

/// A whole lesson: tasks one after another.
class LessonSession {
  LessonSession(this.lesson) : current = TaskSession(lesson.tasks.first);

  final Lesson lesson;
  int taskIndex = 0;
  TaskSession current;
  final List<int> _taskStars = [];

  bool get isLastTask => taskIndex >= lesson.tasks.length - 1;
  bool get isFinished => _taskStars.length == lesson.tasks.length;

  /// Call once the current task is won; moves to the next one.
  void nextTask() {
    assert(current.state == TaskState.won);
    _taskStars.add(current.starsEarned);
    if (!isLastTask) {
      taskIndex++;
      current = TaskSession(lesson.tasks[taskIndex]);
    }
  }

  /// Rounded average over tasks, at least 1.
  int get stars {
    if (_taskStars.isEmpty) return 0;
    final avg = _taskStars.reduce((a, b) => a + b) / _taskStars.length;
    return avg.round().clamp(1, 3);
  }
}
