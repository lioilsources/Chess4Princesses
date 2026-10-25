import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/chess/position.dart';
import 'package:princesschess/core/chess/rules.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/engine/bot.dart';
import 'package:princesschess/core/lessons/curriculum.dart';
import 'package:princesschess/core/lessons/lesson.dart';
import 'package:princesschess/core/lessons/lesson_engine.dart';
import 'package:princesschess/core/lessons/lint.dart';

Square sq(String s) => Square.parse(s);

LessonTask task(String yaml) => Lesson.fromYaml('id: t\nmodule: 0\ntitle: x\nstory: x\n$yaml').tasks.single;

void main() {
  test('all shipped lessons pass lint', () {
    final report = lintCurriculum(File('assets/lessons/index.yaml').readAsStringSync(), (id) {
      final f = File(Curriculum.lessonAsset(id));
      return f.existsSync() ? f.readAsStringSync() : null;
    });
    expect(report.issues.where((i) => i.isError), isEmpty, reason: report.issues.join('\n'));
    expect(report.solutions.length, greaterThan(20));
  });

  test('reach_square: wrong move fails, right move wins with 2 stars', () {
    final s = TaskSession(task('goal: reach_square\nfen: "8/8/8/8/8/8/R7/8"\nstars: [a6]\nmax_moves: 1'));
    expect(s.check(sq('a2'), sq('b3')), MoveVerdict.illegal);
    s.fail();
    expect(s.check(sq('a2'), sq('a6')), MoveVerdict.ok);
    final ev = s.play(sq('a2'), sq('a6'));
    expect(ev.starCollected, isTrue);
    expect(s.state, TaskState.won);
    expect(s.starsEarned, 2);
  });

  test('collect_stars picks up stars along the path', () {
    final s = TaskSession(task('goal: collect_stars\nfen: "8/8/8/8/8/8/8/R7"\nstars: [a4, a8, e8, h8]\nmax_moves: 2'));
    s.play(sq('a1'), sq('a8'));
    expect(s.starsLeft.map((x) => x.name).toSet(), {'e8', 'h8'});
    expect(s.playersTurn, isTrue, reason: 'opponent passes');
    s.play(sq('a8'), sq('h8'));
    expect(s.state, TaskState.won);
    expect(s.starsEarned, 3);
  });

  test('lava blocks driving through', () {
    final s = TaskSession(task('goal: avoid_lava\nfen: "8/8/8/8/8/8/R7/8"\nstars: [d5]\nlava: [a5, b2, c3]'));
    expect(s.check(sq('a2'), sq('a8')), MoveVerdict.lava);
    expect(s.check(sq('a2'), sq('d2')), MoveVerdict.lava);
    expect(s.check(sq('a2'), sq('a4')), MoveVerdict.ok);
    expect(s.safeTargets(sq('a2')).contains(sq('a5')), isFalse);
  });

  test('capture_all reports the captured piece', () {
    final s = TaskSession(task('goal: capture_all\nfen: "8/8/8/8/p7/8/8/R7"'));
    final ev = s.play(sq('a1'), sq('a4'));
    expect(ev.captured, const Piece(Side.black, PieceType.pawn));
    expect(s.state, TaskState.won);
  });

  test('promote turns the pawn into a queen', () {
    final s = TaskSession(task('goal: promote\nfen: "8/4P3/8/8/8/8/8/8"'));
    final ev = s.play(sq('e7'), sq('e8'));
    expect(ev.isPromotion, isTrue);
    expect(s.position[sq('e8')], const Piece(Side.white, PieceType.queen));
    expect(s.state, TaskState.won);
  });

  test('tap_square accepts streets, houses and rooms', () {
    final s = TaskSession(task('goal: tap_square\ntargets: [e, "4", a1]'));
    expect(s.tap(sq('e7')), isTrue);
    expect(s.tap(sq('b1')), isFalse);
    expect(s.tap(sq('h4')), isTrue);
    expect(s.tap(sq('a1')), isTrue);
    expect(s.state, TaskState.won);
    expect(s.fails, 1);
  });

  test('setup_pieces tray and drops', () {
    final s = TaskSession(task('goal: setup_pieces\nfen: "8/8/8/8/8/8/8/8"\ntarget_fen: "8/8/8/8/8/8/8/R6R"'));
    expect(s.tray.length, 2);
    const rook = Piece(Side.white, PieceType.rook);
    expect(s.drop(rook, sq('b1')), isFalse);
    expect(s.drop(rook, sq('a1')), isTrue);
    expect(s.drop(rook, sq('h1')), isTrue);
    expect(s.state, TaskState.won);
  });

  test('tap_all [moves]: every knight square, pawns are scenery', () {
    final s = TaskSession(task('goal: tap_all\nfen: "8/8/8/3P4/2PNP3/3P4/8/8"\ntargets: [moves]'));
    expect(s.tapTargets, {for (final x in ['b3', 'b5', 'c2', 'c6', 'e2', 'e6', 'f3', 'f5']) sq(x)});
    expect(s.tap(sq('d5')), isFalse);
  });

  test('tap_attackers: blocked pieces do not count', () {
    final s = TaskSession(task('goal: tap_attackers\nfen: "8/8/5n2/3Q4/8/3P4/8/3r3b"'));
    expect(s.threatened, sq('d5'));
    expect(s.tapTargets, {sq('f6'), sq('h1')});
    expect(s.tap(sq('d1')), isFalse);
    s.tap(sq('f6'));
    s.tap(sq('h1'));
    expect(s.state, TaskState.won);
  });

  test('Rules.attackers: pawns attack forward diagonally only', () {
    final pos = Position.fromFen('8/8/8/3p4/4K3/8/8/8 w - - 0 1');
    expect(const Rules(RuleSet.pieceOnly).attackers(pos, sq('e4'), Side.black), {sq('d5')});
    expect(const Rules(RuleSet.pieceOnly).attackers(pos, sq('c4'), Side.black), {sq('d5')});
    expect(const Rules(RuleSet.pieceOnly).attackers(pos, sq('d4'), Side.black), isEmpty);
  });

  test('escape_check: only the asked way counts', () {
    final block = TaskSession(task('goal: escape_check\nrules: full\nescape: block\nfen: "4r2k/8/8/8/8/8/R7/4K3 w - - 0 1"\nmax_moves: 1'));
    expect(block.check(sq('e1'), sq('d1')), MoveVerdict.illegal); // running is not blocking
    expect(block.check(sq('a2'), sq('a3')), MoveVerdict.illegal); // still in check
    expect(block.check(sq('a2'), sq('e2')), MoveVerdict.ok);
    block.play(sq('a2'), sq('e2'));
    expect(block.state, TaskState.won);

    final take = TaskSession(task('goal: escape_check\nrules: full\nescape: capture\nfen: "4r2k/8/8/1B6/8/8/8/4K3 w - - 0 1"'));
    expect(take.solutionFirstMove()?.uci, 'b5e8');
  });

  test('yes_no', () {
    final s = TaskSession(task('goal: yes_no\nfen: "8/8/8/8/8/8/8/2B5"\nstars: [e4]\nanswer: false'));
    expect(s.answer(true), isFalse);
    expect(s.answer(false), isTrue);
  });

  test('hints unlock with fails and give a solution move', () {
    final s = TaskSession(task(
      'goal: reach_square\nfen: "8/8/8/8/8/8/1R6/8"\nstars: [g7]\nhints:\n  - {after_fails: 1, highlight: legal_moves}\n  - {after_fails: 2, highlight: solution_first_move}',
    ));
    expect(s.activeHint, isNull);
    s.fail();
    expect(s.activeHint, HintKind.legalMoves);
    s.fail();
    expect(s.activeHint, HintKind.solutionFirstMove);
    final m = s.solutionFirstMove()!;
    expect(m.from, sq('b2'));
    expect(['b7', 'g2'], contains(m.to.name));
  });

  test('pawn war: bot replies and someone wins', () {
    final t = task('goal: pawn_war\nfen: "8/4pppp/8/8/8/8/4PPPP/8"');
    for (var game = 0; game < 10; game++) {
      const rules = Rules(RuleSet.pieceOnly);
      final s = TaskSession(t, bot: Bot(BotLevel.baby, rules: rules, goal: BotGoal.pawnWar));
      final me = Bot(BotLevel.knightess, rules: rules, goal: BotGoal.pawnWar);
      var plies = 0;
      while (s.state == TaskState.playing && plies < 200) {
        if (s.playersTurn) {
          final m = me.chooseMove(s.position)!;
          s.play(m.from, m.to);
        } else {
          s.playBot(s.botMove()!);
        }
        plies++;
      }
      expect(s.state, isNot(TaskState.playing));
    }
  });

  test('bot levels: puppy takes a free piece', () {
    final p = Position.fromFen('8/8/8/3q4/8/8/8/3R3k w - - 0 1');
    expect(Bot(BotLevel.puppy).chooseMove(p)!.uci, 'd1d5');
    expect(Bot(BotLevel.knightess).chooseMove(p)!.uci, 'd1d5');
  });

  test('lesson stars average over tasks', () {
    final l = Lesson.fromYaml('''
id: t
module: 0
title: x
story: x
rules: piece_only
tasks:
  - {goal: reach_square, fen: "8/8/8/8/8/8/R7/8", stars: [a3], max_moves: 1}
  - {goal: reach_square, fen: "8/8/8/8/8/8/R7/8", stars: [a4], max_moves: 1}
''');
    final s = LessonSession(l);
    s.current.play(sq('a2'), sq('a3'));
    s.nextTask();
    s.current.fail();
    s.current.play(sq('a2'), sq('a4'));
    s.nextTask();
    expect(s.isFinished, isTrue);
    expect(s.stars, 3); // (3 + 2) / 2 = 2.5 → 3
  });
}
