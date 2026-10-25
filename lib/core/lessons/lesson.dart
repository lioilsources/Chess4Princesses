import 'package:yaml/yaml.dart';

import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';
import '../engine/bot.dart';

/// Text in several languages, `{cs: …, en: …}` in YAML. A bare string is
/// treated as Czech.
class LocalizedText {
  const LocalizedText(this.values);

  factory LocalizedText.parse(Object? y) => switch (y) {
    null => const LocalizedText({}),
    String s => LocalizedText({'cs': s}),
    Map m => LocalizedText({for (final e in m.entries) '${e.key}': '${e.value}'}),
    _ => throw FormatException('Expected text or {cs:, en:} map, got $y'),
  };

  final Map<String, String> values;

  bool get isEmpty => values.isEmpty;

  /// Requested language, then Czech, then anything.
  String of(String lang) => values[lang] ?? values['cs'] ?? (values.isEmpty ? '' : values.values.first);
}

/// Mini-game types (LESSONS "Mechaniky mini‑her" + module 0/3 extras).
enum GoalType {
  /// Tap the named square / street (file) / house number (rank), one after another.
  tapSquare('tap_square'),

  /// Tap every target square, any order.
  tapAll('tap_all'),

  /// Drag pieces from a tray to their home squares.
  setupPieces('setup_pieces'),

  /// Move a piece onto the star.
  reachSquare('reach_square'),

  /// Collect all stars in as few moves as possible.
  collectStars('collect_stars'),

  /// Reach the star, never stepping on or driving through lava.
  avoidLava('avoid_lava'),

  /// Take every opponent piece; the opponent does not move.
  captureAll('capture_all'),

  /// Walk a pawn to the last rank.
  promote('promote'),

  /// Pawns vs pawns against the bot; first pawn home wins.
  pawnWar('pawn_war'),

  /// Yes/no question about the shown position.
  yesNo('yes_no');

  const GoalType(this.id);

  final String id;

  static GoalType parse(String s) =>
      values.firstWhere((g) => g.id == s, orElse: () => throw FormatException('Unknown goal "$s"'));

  /// Goals where the player moves pieces on the board.
  bool get isMoveGoal => switch (this) {
    reachSquare || collectStars || avoidLava || captureAll || promote || pawnWar => true,
    _ => false,
  };

  /// Goals solvable by a single-player search (opponent passive).
  bool get isSolvable => isMoveGoal && this != pawnWar;
}

enum HintKind {
  /// Glow on the squares the player's pieces can go to.
  legalMoves('legal_moves'),

  /// Show the first move of a shortest solution.
  solutionFirstMove('solution_first_move'),

  /// Glow on the tap targets.
  targets('targets');

  const HintKind(this.id);

  final String id;

  static HintKind parse(String s) =>
      values.firstWhere((h) => h.id == s, orElse: () => throw FormatException('Unknown hint "$s"'));
}

class Hint {
  const Hint(this.afterFails, this.kind);

  final int afterFails;
  final HintKind kind;
}

/// Lava: a fixed list of squares, or every square the opponent attacks.
class LavaSpec {
  const LavaSpec({this.squares = const {}, this.attacked = false});

  factory LavaSpec.parse(Object? y) => switch (y) {
    null => const LavaSpec(),
    'attacked' => const LavaSpec(attacked: true),
    List l => LavaSpec(squares: {for (final s in l) Square.parse('$s')}),
    _ => throw FormatException('lava: expected list of squares or "attacked", got $y'),
  };

  final Set<Square> squares;
  final bool attacked;

  bool get isEmpty => squares.isEmpty && !attacked;

  Set<Square> on(Position pos, Side player, Rules rules) =>
      attacked ? {...squares, ...rules.attackedSquares(pos, player.opponent)} : squares;
}

/// One board puzzle. A lesson is 1..n tasks played in a row.
class LessonTask {
  LessonTask({
    required this.goal,
    required this.rules,
    required this.position,
    this.prompt = const LocalizedText({}),
    this.stars = const [],
    this.lava = const LavaSpec(),
    this.maxMoves,
    this.hints = const [],
    this.targets = const [],
    this.targetPosition,
    this.answer,
    this.verify,
    this.bot = BotLevel.baby,
  });

  /// Parses one task; [defaults] are lesson-level keys every task inherits.
  factory LessonTask.parse(Map y, {Map defaults = const {}}) {
    final m = {...defaults, ...y};
    final goal = GoalType.parse(_req(m, 'goal'));
    return LessonTask(
      goal: goal,
      rules: RuleSet.parse('${m['rules'] ?? 'piece_only'}'),
      position: Position.fromFen('${m['fen'] ?? '8/8/8/8/8/8/8/8'}'),
      prompt: LocalizedText.parse(m['prompt']),
      stars: [for (final s in (m['stars'] as List? ?? const [])) Square.parse('$s')],
      lava: LavaSpec.parse(m['lava']),
      maxMoves: m['max_moves'] as int?,
      hints: [
        for (final h in (m['hints'] as List? ?? const []))
          Hint(h['after_fails'] as int, HintKind.parse('${h['highlight']}')),
      ],
      targets: [for (final t in (m['targets'] as List? ?? const [])) '$t'],
      targetPosition: m['target_fen'] != null ? Position.fromFen('${m['target_fen']}') : null,
      answer: m['answer'] as bool?,
      verify: m['verify'] as String?,
      bot: m['bot'] != null ? BotLevel.parse('${m['bot']}') : BotLevel.baby,
    );
  }

  final GoalType goal;
  final RuleSet rules;
  final Position position;
  final LocalizedText prompt;
  final List<Square> stars;
  final LavaSpec lava;

  /// Par for 3 stars (not a hard limit — kids are never cut off).
  final int? maxMoves;
  final List<Hint> hints;

  /// tap_square: `e` (street/file), `4` (house/rank) or `e4`. tap_all: squares.
  final List<String> targets;

  /// setup_pieces: what the board must look like at the end.
  final Position? targetPosition;

  /// yes_no: the right answer.
  final bool? answer;

  /// yes_no: how `tool/lesson_lint.dart` checks [answer] (`reachable`).
  final String? verify;

  /// pawn_war: opponent strength.
  final BotLevel bot;

  Side get player => position.sideToMove;
}

class LessonReward {
  const LessonReward({this.stars = 3, this.unlock});

  factory LessonReward.parse(Object? y) =>
      y is Map ? LessonReward(stars: y['stars'] as int? ?? 3, unlock: y['unlock'] as String?) : const LessonReward();

  final int stars;

  /// Character / costume id unlocked on completion (e.g. `queen`).
  final String? unlock;
}

class Lesson {
  Lesson({
    required this.id,
    required this.module,
    required this.title,
    required this.story,
    required this.tasks,
    this.skills = const [],
    this.reward = const LessonReward(),
  });

  /// Keys copied to every task unless the task overrides them.
  static const inheritedKeys = {'rules', 'fen', 'hints', 'max_moves', 'stars', 'lava', 'bot', 'prompt'};

  factory Lesson.fromYaml(String source) {
    final y = loadYaml(source);
    if (y is! Map) throw const FormatException('Lesson must be a YAML map');
    final defaults = {for (final k in inheritedKeys) if (y.containsKey(k)) k: y[k]};
    final rawTasks = y['tasks'] as List? ?? [y]; // single-task shorthand: goal at top level
    return Lesson(
      id: _req(y, 'id'),
      module: y['module'] as int,
      title: LocalizedText.parse(y['title']),
      story: LocalizedText.parse(y['story']),
      skills: [for (final s in (y['skills'] as List? ?? const [])) '$s'],
      reward: LessonReward.parse(y['reward']),
      tasks: [for (final t in rawTasks) LessonTask.parse(t as Map, defaults: defaults)],
    );
  }

  final String id;
  final int module;
  final LocalizedText title;
  final LocalizedText story;
  final List<String> skills;
  final LessonReward reward;
  final List<LessonTask> tasks;
}

String _req(Map m, String key) {
  final v = m[key];
  if (v == null) throw FormatException('Missing "$key"');
  return '$v';
}
