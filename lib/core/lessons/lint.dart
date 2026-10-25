import '../chess/rules.dart';
import '../chess/types.dart';
import 'curriculum.dart';
import 'lesson.dart';
import 'lesson_engine.dart';
import 'solver.dart';

class LintIssue {
  const LintIssue(this.where, this.message, {this.isError = true});

  final String where;
  final String message;
  final bool isError;

  @override
  String toString() => '${isError ? 'ERROR' : 'warn '} $where: $message';
}

class LintReport {
  final issues = <LintIssue>[];

  /// `lesson/task → shortest solution length`, for the summary table.
  final solutions = <String, int>{};

  bool get ok => issues.every((i) => !i.isError);

  void error(String where, String msg) => issues.add(LintIssue(where, msg));
  void warn(String where, String msg) => issues.add(LintIssue(where, msg, isError: false));
}

/// Checks the curriculum: every listed lesson parses, matches its module and
/// every task is solvable within its `max_moves` (PLAN §5 — mandatory in CI).
/// [readLesson] returns a lesson's YAML or null when the file is missing;
/// [lessonFiles] lists ids found on disk, to catch files not in the index.
LintReport lintCurriculum(String indexYaml, String? Function(String id) readLesson, {Iterable<String> lessonFiles = const []}) {
  final r = LintReport();
  final Curriculum cur;
  try {
    cur = Curriculum.fromYaml(indexYaml);
  } on Object catch (e) {
    r.error('index.yaml', '$e');
    return r;
  }
  final listed = <String>{};
  for (final m in cur.modules) {
    _text(r, 'index module ${m.number}', 'title', m.title);
    for (final id in m.lessonIds) {
      if (!listed.add(id)) r.error(id, 'listed twice in index.yaml');
      final src = readLesson(id);
      if (src == null) {
        r.error(id, 'file ${Curriculum.lessonAsset(id)} missing');
        continue;
      }
      final Lesson lesson;
      try {
        lesson = Lesson.fromYaml(src);
      } on Object catch (e) {
        r.error(id, 'parse: $e');
        continue;
      }
      if (lesson.id != id) r.error(id, 'id in file is "${lesson.id}"');
      if (lesson.module != m.number) r.error(id, 'module ${lesson.module}, listed under ${m.number}');
      lintLesson(lesson, r);
    }
  }
  for (final f in lessonFiles) {
    if (!listed.contains(f)) r.warn(f, 'lesson file not listed in index.yaml');
  }
  return r;
}

void lintLesson(Lesson lesson, LintReport r) {
  _text(r, lesson.id, 'title', lesson.title);
  _text(r, lesson.id, 'story', lesson.story);
  if (lesson.tasks.isEmpty) r.error(lesson.id, 'no tasks');
  for (var i = 0; i < lesson.tasks.length; i++) {
    _lintTask(lesson.tasks[i], '${lesson.id}#${i + 1}', r);
  }
}

void _lintTask(LessonTask t, String where, LintReport r) {
  final pos = t.position;
  final occupied = {for (final (s, _) in pos.pieces) s};
  final mine = pos.piecesOf(t.player).toList();
  final theirs = pos.piecesOf(t.player.opponent).toList();

  for (final s in t.stars) {
    if (occupied.contains(s)) r.error(where, 'star ${s.name} is under a piece');
  }
  for (final s in t.lava.squares) {
    if (t.stars.contains(s)) r.error(where, 'lava on star ${s.name}');
    if (occupied.contains(s)) r.error(where, 'lava ${s.name} is under a piece');
  }

  for (final h in t.hints) {
    final fits = switch (h.kind) {
      HintKind.legalMoves => t.goal.isMoveGoal,
      HintKind.solutionFirstMove => t.goal.isSolvable,
      HintKind.targets => t.goal.isTapGoal,
    };
    if (!fits) r.error(where, 'hint ${h.kind.id} does not fit goal ${t.goal.id}');
  }

  if (t.goal.isMoveGoal) {
    if (mine.isEmpty) r.error(where, 'player (${t.player.name}) has no pieces');
    if (Rules(t.rules).legalMoves(pos).isEmpty) r.error(where, 'player has no legal move');
    if (t.rules == RuleSet.full && pos.kingOf(t.player) == null && pos.kingOf(t.player.opponent) != null) {
      r.warn(where, 'full rules with only one king — did you mean piece_only?');
    }
  }

  switch (t.goal) {
    case GoalType.reachSquare || GoalType.collectStars || GoalType.avoidLava:
      if (t.stars.isEmpty) r.error(where, '${t.goal.id} needs stars');
      if (t.goal == GoalType.avoidLava && t.lava.isEmpty) r.error(where, 'avoid_lava needs lava');
    case GoalType.captureAll:
      if (theirs.isEmpty) r.error(where, 'capture_all without opponent pieces');
      if (theirs.any((e) => e.$2.type == PieceType.king)) r.error(where, 'capture_all: kings are never captured');
    case GoalType.promote:
      if (!mine.any((e) => e.$2.type == PieceType.pawn)) r.error(where, 'promote without a pawn');
    case GoalType.pawnWar:
      if ([...mine, ...theirs].any((e) => e.$2.type != PieceType.pawn)) r.error(where, 'pawn_war must have pawns only');
      if (theirs.isEmpty) r.error(where, 'pawn_war without opponent pawns');
    case GoalType.tapSquare:
      if (t.targets.isEmpty) r.error(where, 'tap_square needs targets');
      for (final x in t.targets) {
        if (!RegExp(r'^([a-h]|[1-8]|[a-h][1-8])$').hasMatch(x)) r.error(where, 'bad target "$x"');
      }
    case GoalType.tapAll when t.targets.length == 1 && t.targets.single == 'moves':
      if (mine.where((e) => e.$2.type != PieceType.pawn).length != 1) r.error(where, 'targets: [moves] needs exactly one non-pawn player piece');
      if (TaskSession(t).tapTargets.isEmpty) r.error(where, 'the piece has nowhere to go');
    case GoalType.tapAll:
      if (t.targets.isEmpty) r.error(where, 'tap_all needs targets');
      for (final x in t.targets) {
        if (Square.tryParse(x) == null) r.error(where, 'bad square "$x"');
      }
      if (t.targets.toSet().length != t.targets.length) r.error(where, 'duplicate targets');
    case GoalType.tapAttackers:
      final session = TaskSession(t);
      final s = session.threatened;
      if (s == null) {
        r.error(where, 'tap_attackers: nothing threatened (targets: [sq], or a king/queen)');
      } else if (pos[s]?.side != t.player) {
        r.error(where, 'tap_attackers: ${s.name} is not my piece');
      } else if (session.tapTargets.isEmpty) {
        r.error(where, 'tap_attackers: nobody attacks ${s.name}');
      }
    case GoalType.escapeCheck:
      if (t.rules != RuleSet.full) r.error(where, 'escape_check needs rules: full');
      if (!Rules(RuleSet.full).inCheck(pos, t.player)) r.error(where, 'escape_check: my king is not in check');
      if (t.escape case final k?) {
        final ways = Rules(RuleSet.full).legalMoves(pos).map((m) => Solver.escapeKind(pos, m)).toSet();
        if (!ways.contains(k)) r.error(where, 'escape_check: no way to ${k.name} (only ${ways.map((w) => w.name).join(', ')})');
      }
    case GoalType.setupPieces:
      final target = t.targetPosition;
      if (target == null) {
        r.error(where, 'setup_pieces needs target_fen');
      } else {
        for (final (s, p) in pos.pieces) {
          if (target[s] != p) r.error(where, '${p.fen} on ${s.name} is not in target_fen');
        }
        if (TaskSession(t).tray.isEmpty) r.error(where, 'nothing to place');
      }
    case GoalType.yesNo:
      if (t.answer == null) r.error(where, 'yes_no needs answer: true|false');
      if (t.verify == 'reachable') {
        if (t.stars.length != 1) {
          r.error(where, 'verify: reachable needs exactly one star');
        } else if (Solver(t).canReach(t.stars.single) != t.answer) {
          r.error(where, 'answer ${t.answer} is wrong — reachable is ${!t.answer!}');
        }
      } else if (t.verify != null) {
        r.error(where, 'unknown verify "${t.verify}"');
      }
  }

  if (t.goal.isSolvable) {
    final path = Solver(t).solve();
    if (path == null) {
      r.error(where, 'not solvable within 14 moves');
    } else {
      r.solutions[where] = path.length;
      final par = t.maxMoves;
      if (par == null) {
        r.warn(where, 'no max_moves (shortest solution: ${path.length})');
      } else if (path.length > par) {
        r.error(where, 'max_moves $par impossible — shortest is ${path.length} (${path.join(' ')})');
      } else if (path.length < par) {
        r.warn(where, 'max_moves $par is lax — shortest is ${path.length} (${path.join(' ')})');
      }
    }
  }
}

void _text(LintReport r, String where, String field, LocalizedText t) {
  if (t.values['cs']?.isNotEmpty != true) r.error(where, '$field: missing cs');
  if (t.values['en']?.isNotEmpty != true) r.warn(where, '$field: missing en');
}
