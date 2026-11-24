// Golden vectors for the Babylon.js web client (babylon/, plan 06 F1).
//
// Runs the pure Dart rules over fixed inputs and writes what they produce to
// babylon/test/golden/<name>.json as {"cases": [{"in": …, "out": …}]}.
// babylon/test/golden.test.ts replays the same inputs through the TS port and
// mirrors the scripted lesson runs below step for step (test/drivers.ts).
//
//   dart run tool/dump_vectors.dart     (from the repo root)
//
// Deterministic: no clock, Random only through the seeded Lcg. Rerunning on
// unchanged Dart code gives byte-identical files (CI diffs them).
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:princesschess/core/chess/position.dart';
import 'package:princesschess/core/chess/rules.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/engine/bot.dart';
import 'package:princesschess/core/lessons/content_catalog.dart';
import 'package:princesschess/core/lessons/curriculum.dart';
import 'package:princesschess/core/lessons/lesson.dart';
import 'package:princesschess/core/lessons/lesson_engine.dart';
import 'package:princesschess/core/lessons/solver.dart';

const outDir = 'babylon/test/golden';

/// Seeded LCG, mirrored bit for bit by babylon/src/rules/random.ts.
class Lcg {
  int _s;
  Lcg(int seed) : _s = seed & 0x7fffffff;
  int next(int n) {
    _s = (_s * 1103515245 + 12345) & 0x7fffffff;
    return _s % n;
  }

  T pick<T>(List<T> l) => l[next(l.length)];
}

/// The Lcg behind dart:math's Random interface, for Bot (only nextInt is used).
class LcgRandom implements Random {
  LcgRandom(int seed) : _lcg = Lcg(seed);
  final Lcg _lcg;

  @override
  int nextInt(int max) => _lcg.next(max);

  @override
  bool nextBool() => throw UnsupportedError('nextBool');

  @override
  double nextDouble() => throw UnsupportedError('nextDouble');
}

void write(String name, List<Map<String, Object?>> cases) {
  final f = File('$outDir/$name');
  f.parent.createSync(recursive: true);
  f.writeAsStringSync('${jsonEncode({'cases': cases})}\n');
  stdout.writeln('wrote ${f.path} (${cases.length} cases, ${f.lengthSync()} B)');
}

String ruleId(RuleSet r) => r == RuleSet.full ? 'full' : 'piece_only';
List<String> names(Iterable<Square> s) => (s.map((x) => x.index).toList()..sort()).map((i) => Square(i).name).toList();

const standardFens = [
  Position.initialFen,
  'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1',
  '8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1',
  'r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1',
  'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3',
  '7k/5Q2/6K1/8/8/8/8/8 b - - 0 1',
  // Disambiguation: two knights and two rooks reaching the same squares.
  '4k3/8/8/8/8/2N3N1/8/R3K2R w KQ - 0 1',
];

/// Positions along seeded random games: every 3rd ply of 60, full rules.
List<String> playouts({int every = 3}) {
  final out = <String>[];
  const rules = Rules();
  for (final seed in [1, 2, 3, 4, 5]) {
    final r = Lcg(seed);
    var pos = Position.initial();
    for (var ply = 0; ply < 60; ply++) {
      if (ply % every == 0) out.add(pos.fen);
      final moves = rules.legalMoves(pos);
      if (moves.isEmpty) break;
      pos = pos.apply(r.pick(moves));
    }
  }
  return out;
}

List<Lesson> loadLessons(Curriculum c) => [
  for (final m in c.modules)
    for (final id in m.lessonIds) Lesson.fromYaml(File(Curriculum.lessonAsset(id)).readAsStringSync()),
];

Map<String, Object?> movesCase(String fen, RuleSet rs) {
  final rules = Rules(rs);
  final pos = Position.fromFen(fen);
  final legal = rules.legalMoves(pos);
  final san = [for (final m in legal) rules.san(pos, m)];
  return {
    'in': {'fen': fen, 'rules': ruleId(rs)},
    'out': {
      'moves': [for (final m in legal) m.uci],
      'san': san,
      'parsed': [for (final s in san.take(3)) rules.parseSan(pos, s)?.uci],
      'status': rules.status(pos).name,
      'check': rules.inCheck(pos, pos.sideToMove),
      'attacked': names(rules.attackedSquares(pos, pos.sideToMove.opponent)),
      'attackers': [
        for (final (s, _) in pos.piecesOf(pos.sideToMove)) [s.name, names(rules.attackers(pos, s, pos.sideToMove.opponent))],
      ],
      'paths': [for (final m in legal.take(5)) names(Rules.path(m))],
    },
  };
}

Map<String, Object?> botCase(String fen, RuleSet rs, BotGoal goal, BotLevel level, int seed) {
  final rules = Rules(rs);
  final bot = Bot(level, rules: rules, random: LcgRandom(seed), goal: goal);
  var pos = Position.fromFen(fen);
  final moves = <String>[];
  for (var ply = 0; ply < 4; ply++) {
    final m = bot.chooseMove(pos);
    if (m == null) break;
    moves.add(m.uci);
    pos = pos.apply(m);
  }
  return {
    'in': {'fen': fen, 'rules': ruleId(rs), 'goal': goal.name, 'level': level.name, 'seed': seed},
    'out': {'moves': moves, 'eval': bot.evaluate(Position.fromFen(fen))},
  };
}

Map<String, String> texts(LocalizedText t) => {for (final l in const ['cs', 'en', 'de', 'ja']) l: t.of(l)};

Map<String, Object?> taskInfo(LessonTask t) {
  final solver = Solver(t);
  return {
    'goal': t.goal.id,
    'rules': ruleId(t.rules),
    'fen': t.position.fen,
    'prompt': texts(t.prompt),
    'stars': [for (final s in t.stars) s.name],
    'lava': {'squares': names(t.lava.squares), 'attacked': t.lava.attacked},
    'maxMoves': t.maxMoves,
    'hints': [
      for (final h in t.hints) [h.afterFails, h.kind.id],
    ],
    'targets': t.targets,
    'targetFen': t.targetPosition?.fen,
    'answer': t.answer,
    'verify': t.verify,
    'bot': t.bot.name,
    'escape': t.escape?.name,
    'solution': solver.solve()?.map((m) => m.uci).toList(),
    'reach': t.verify == 'reachable' && t.stars.isNotEmpty ? solver.canReach(t.stars.first) : null,
  };
}

/// Scripted play of the current task: a few mistakes, then the right moves.
/// babylon/test/drivers.ts runs exactly the same script.
List<Object?> runTask(TaskSession s, Lcg r) {
  final log = <Object?>[];
  final t = s.task;
  log.add({
    'safe': [
      for (final (sq, _) in t.position.piecesOf(t.player)) [sq.name, names(s.safeTargets(sq))],
    ],
    'tapTargets': names(s.tapTargets),
    'tray': [for (final p in s.tray) p.fen],
    'first': s.solutionFirstMove()?.uci,
  });
  switch (t.goal) {
    case GoalType.pawnWar:
      for (var ply = 0; ply < 80 && s.state == TaskState.playing; ply++) {
        if (s.playersTurn) {
          final moves = s.rules.legalMoves(s.position).where((m) => m.promotion == null || m.promotion == PieceType.queen).toList();
          if (moves.isEmpty) break;
          final m = r.pick(moves);
          final v = s.check(m.from, m.to);
          final ev = s.play(m.from, m.to);
          log.add([m.uci, v.name, ev.captured?.fen, s.state.name]);
        } else {
          final m = s.botMove();
          if (m == null) break;
          final ev = s.playBot(m);
          log.add([m.uci, 'bot', ev.captured?.fen, s.state.name]);
        }
      }
    case final g when g.isMoveGoal:
      final mine = [for (final (sq, _) in t.position.piecesOf(t.player)) sq];
      for (var i = 0; i < 3 && mine.isNotEmpty; i++) {
        final from = r.pick(mine);
        final to = Square(r.next(64));
        final v = s.check(from, to);
        if (v != MoveVerdict.ok) s.fail();
        log.add([from.name, to.name, v.name, s.activeHint?.id]);
      }
      for (var step = 0; step < 20 && s.state == TaskState.playing; step++) {
        final m = s.solutionFirstMove();
        if (m == null) break;
        final v = s.check(m.from, m.to);
        final ev = s.play(m.from, m.to);
        log.add([m.uci, v.name, ev.captured?.fen, ev.starCollected, s.state.name, names(s.starsLeft)]);
      }
    case final g when g.isTapGoal:
      final wrong = [for (var i = 0; i < 64; i++) if (!s.tapTargets.contains(Square(i))) Square(i)];
      if (wrong.isNotEmpty) {
        final sq = r.pick(wrong);
        log.add([sq.name, s.tap(sq)]);
      }
      for (var i = 0; i < 70 && s.state == TaskState.playing; i++) {
        final left = (s.tapTargets.where((x) => !s.tapped.contains(x)).map((x) => x.index).toList()..sort());
        if (left.isEmpty) break;
        final sq = Square(left.first);
        log.add([sq.name, s.tap(sq), s.state.name]);
      }
    case GoalType.setupPieces:
      final target = t.targetPosition!;
      if (s.tray.isNotEmpty) {
        final p = s.tray.first;
        final bad = [for (var i = 0; i < 64; i++) if (target[Square(i)] != p) Square(i)];
        if (bad.isNotEmpty) log.add([p.fen, bad.first.name, s.drop(p, bad.first)]);
      }
      for (var i = 0; i < 40 && s.state == TaskState.playing && s.tray.isNotEmpty; i++) {
        final p = s.tray.first;
        Square? to;
        for (var k = 0; k < 64; k++) {
          if (target[Square(k)] == p && s.position[Square(k)] != p) {
            to = Square(k);
            break;
          }
        }
        if (to == null) break;
        log.add([p.fen, to.name, s.drop(p, to), s.state.name]);
      }
    case GoalType.yesNo:
      log.add([s.answer(!(t.answer ?? false)), s.answer(t.answer ?? false)]);
    default:
      break;
  }
  log.add({
    'state': s.state.name,
    'fails': s.fails,
    'moves': s.moves,
    'stars': s.starsEarned,
    'hint': s.activeHint?.id,
    'fen': s.position.fen,
  });
  return log;
}

Map<String, Object?> lessonCase(Lesson l) {
  final session = LessonSession(l, random: LcgRandom(5));
  final r = Lcg(11);
  final runs = <Object?>[];
  while (true) {
    runs.add(runTask(session.current, r));
    if (session.current.state != TaskState.won) break;
    session.nextTask();
    if (session.isFinished) break;
  }
  return {
    'in': {'id': l.id},
    'out': {
      'module': l.module,
      'title': texts(l.title),
      'story': texts(l.story),
      'skills': l.skills,
      'reward': {'stars': l.reward.stars, 'unlock': l.reward.unlock},
      'tasks': [for (final t in l.tasks) taskInfo(t)],
      'runs': runs,
      'finished': session.isFinished,
      'stars': session.stars,
    },
  };
}

void main() {
  if (!File('assets/lessons/index.yaml').existsSync()) {
    stderr.writeln('Run from the repo root.');
    exit(2);
  }
  for (final lang in const ['de', 'ja']) {
    final j = jsonDecode(File(ContentCatalog.asset(lang)).readAsStringSync()) as Map<String, dynamic>;
    ContentCatalog.add(lang, j.map((k, v) => MapEntry(k, '$v')));
  }
  final curriculum = Curriculum.fromYaml(File('assets/lessons/index.yaml').readAsStringSync());
  final lessons = loadLessons(curriculum);

  // moves.json: standard positions, every lesson board, random games.
  final seen = <String>{};
  final moveCases = <Map<String, Object?>>[];
  void addMoves(String fen, RuleSet rs) {
    if (seen.add('$fen|${ruleId(rs)}')) moveCases.add(movesCase(fen, rs));
  }

  for (final f in standardFens) {
    addMoves(f, RuleSet.full);
  }
  for (final l in lessons) {
    for (final t in l.tasks) {
      addMoves(t.position.fen, t.rules);
      if (t.targetPosition != null) addMoves(t.targetPosition!.fen, t.rules);
    }
  }
  for (final f in playouts()) {
    addMoves(f, RuleSet.full);
  }
  write('moves.json', moveCases);

  // bot.json: every level on full-board positions and on lesson boards.
  final botCases = <Map<String, Object?>>[];
  final full = [...standardFens.take(4), ...playouts(every: 15).skip(1).take(8)];
  for (final f in full) {
    for (final level in BotLevel.values) {
      for (final seed in const [7, 99]) {
        botCases.add(botCase(f, RuleSet.full, BotGoal.material, level, seed));
      }
    }
  }
  final lessonBoards = <String>{};
  for (final l in lessons) {
    for (final t in l.tasks) {
      if (!t.goal.isMoveGoal || !lessonBoards.add('${t.position.fen}|${t.goal.id}')) continue;
      final goal = t.goal == GoalType.pawnWar ? BotGoal.pawnWar : BotGoal.material;
      for (final level in BotLevel.values) {
        botCases.add(botCase(t.position.passTurn().fen, t.rules, goal, level, 3));
      }
    }
  }
  write('bot.json', botCases);

  // lessons.json: the map, then every lesson parsed and played through.
  write('lessons.json', [
    {
      'in': {'id': 'index'},
      'out': {
        'modules': [
          for (final m in curriculum.modules)
            {'number': m.number, 'title': texts(m.title), 'icon': m.icon, 'lessons': m.lessonIds, 'unlock': m.unlock, 'authored': m.isAuthored},
        ],
      },
    },
    for (final l in lessons) lessonCase(l),
  ]);
}
