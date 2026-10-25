import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/chess/types.dart';
import '../../core/lessons/lesson.dart';
import '../../core/lessons/lesson_engine.dart';
import '../board/chess_board.dart';

enum LessonFeedback { none, wrong, lava, taskWon, botWon, promoted, thinking }

/// A capture waiting for its battle to finish before it lands on the board.
class PendingBattle {
  const PendingBattle(this.attacker, this.defender);
  final Piece attacker;
  final Piece defender;
}

/// Glue between [LessonSession] (pure rules) and the lesson screen:
/// selection, feedback pulses, battle hand-off, bot replies, timings.
class LessonController extends ChangeNotifier {
  LessonController(this.lesson, {this.onFinished, this.battles = true}) : session = LessonSession(lesson);

  final Lesson lesson;
  final LessonSession session;

  /// Called once with the lesson's stars.
  final void Function(int stars)? onFinished;

  /// Show battle animations on captures (parent setting later).
  final bool battles;

  /// `--dart-define=SKIP_STORY=true` jumps straight to the board (screenshots).
  bool showStory = !const bool.fromEnvironment('SKIP_STORY');
  bool finished = false;
  Square? selected;
  SquarePulse shake = const SquarePulse(null, 0);
  SquarePulse burst = const SquarePulse(null, 0);
  LessonFeedback feedback = LessonFeedback.none;
  PendingBattle? battle;

  void Function()? _afterBattle;
  bool _busy = false;
  bool _disposed = false;
  int _tick = 0;

  TaskSession get task => session.current;
  bool get inputEnabled => !_busy && !showStory && !finished && battle == null;

  void startTask() {
    showStory = false;
    _notify();
  }

  // ---- board marks -----------------------------------------------------

  BoardMarks get marks {
    final t = task;
    final hint = t.activeHint;
    var sel = selected;
    final mine = [for (final (s, _) in t.position.piecesOf(t.player)) s];
    // legal_moves hint with a single piece: just pick it up for the child.
    if (sel == null && hint == HintKind.legalMoves && mine.length == 1 && t.task.goal.isMoveGoal) sel = mine.single;

    final glow = <Square>{};
    (Square, Square)? hintMove;
    switch (hint) {
      case HintKind.targets:
        glow.addAll(t.tapTargets.difference(t.tapped));
      case HintKind.legalMoves when sel == null:
        glow.addAll(mine.where((s) => t.safeTargets(s).isNotEmpty));
      case HintKind.solutionFirstMove when inputEnabled:
        final m = _solutionHint();
        if (m != null) hintMove = (m.from, m.to);
      default:
        break;
    }
    return BoardMarks(
      selected: sel,
      dots: sel == null ? const {} : t.safeTargets(sel),
      stars: t.starsLeft,
      lava: t.task.lava.isEmpty ? const {} : t.lava,
      glow: glow,
      done: t.tapped,
      hintMove: hintMove,
    );
  }

  // The BFS runs once per board state, not on every rebuild.
  String? _hintKey;
  Move? _hintMove;

  Move? _solutionHint() {
    final key = '${task.position.fen}|${task.starsLeft.map((s) => s.name).join()}';
    if (key != _hintKey) {
      _hintKey = key;
      _hintMove = task.solutionFirstMove();
    }
    return _hintMove;
  }

  bool canDrag(Square s) => inputEnabled && task.task.goal.isMoveGoal && task.playersTurn && task.position[s]?.side == task.player;

  // ---- input -----------------------------------------------------------

  void tap(Square s) {
    if (!inputEnabled) return;
    final t = task;
    switch (t.task.goal) {
      case GoalType.tapSquare || GoalType.tapAll:
        if (t.tap(s)) {
          _burst(s);
          HapticFeedback.lightImpact();
        } else {
          _shake(s);
          _say(LessonFeedback.wrong);
        }
        _checkState();
      case _ when t.task.goal.isMoveGoal:
        final sel = selected ?? marks.selected;
        if (t.position[s]?.side == t.player && t.playersTurn) {
          selected = s;
          feedback = LessonFeedback.none;
          _notify();
        } else if (sel != null) {
          _tryMove(sel, s);
        }
      default:
        break;
    }
  }

  void dragStart(Square from) {
    selected = from;
    _notify();
  }

  void drop(BoardDrag d, Square to) {
    if (!inputEnabled) return;
    switch (d) {
      case DragFromSquare(:final from):
        if (from != to) _tryMove(from, to);
      case DragFromTray(:final piece):
        if (task.drop(piece, to)) {
          _burst(to);
        } else {
          _shake(to);
          _say(LessonFeedback.wrong);
        }
        _checkState();
    }
  }

  void answer(bool yes) {
    if (!inputEnabled) return;
    if (!task.answer(yes)) _say(LessonFeedback.wrong);
    _checkState();
  }

  void _tryMove(Square from, Square to) {
    final t = task;
    switch (t.check(from, to)) {
      case MoveVerdict.ok:
        selected = null;
        final victim = t.position.capturedBy(t.resolve(from, to)!);
        _withBattle(t.position[from]!, victim, () => _commit(t.play(from, to)));
      case MoveVerdict.illegal:
        t.fail();
        selected = from;
        _shake(from);
        _say(LessonFeedback.wrong);
        HapticFeedback.mediumImpact();
      case MoveVerdict.lava:
        t.fail();
        selected = from;
        _shake(from);
        _say(LessonFeedback.lava);
        HapticFeedback.mediumImpact();
      case MoveVerdict.notYours:
        break;
    }
  }

  /// Runs [apply] after the battle (if there is a capture) or right away.
  void _withBattle(Piece attacker, Piece? victim, void Function() apply) {
    if (victim == null || !battles) {
      apply();
      return;
    }
    battle = PendingBattle(attacker, victim);
    _afterBattle = apply;
    _notify();
  }

  /// The battle overlay calls this when the animation ends or is skipped.
  void battleFinished() {
    battle = null;
    final f = _afterBattle;
    _afterBattle = null;
    f?.call();
    _notify();
  }

  void _commit(MoveEvent ev) {
    if (ev.starCollected || ev.isCapture) _burst(ev.move.to);
    if (ev.isPromotion) {
      _burst(ev.move.to);
      _say(LessonFeedback.promoted);
    } else {
      feedback = LessonFeedback.none;
    }
    _checkState();
    if (task.task.goal == GoalType.pawnWar && task.state == TaskState.playing && !task.playersTurn) _botTurn();
  }

  void _botTurn() {
    _busy = true;
    _say(LessonFeedback.thinking);
    _later(const Duration(milliseconds: 700), () {
      final t = task;
      final m = t.botMove();
      if (m == null) {
        _busy = false;
        _checkState();
        return;
      }
      _withBattle(t.position[m.from]!, t.position.capturedBy(m), () {
        final ev = t.playBot(m);
        _busy = false;
        feedback = LessonFeedback.none;
        if (ev.isCapture) _burst(m.to);
        _checkState();
      });
    });
  }

  void _checkState() {
    final t = task;
    switch (t.state) {
      case TaskState.playing:
        _notify();
      case TaskState.won:
        _busy = true;
        _say(LessonFeedback.taskWon);
        HapticFeedback.heavyImpact();
        _later(const Duration(milliseconds: 1300), () {
          session.nextTask();
          _busy = false;
          selected = null;
          feedback = LessonFeedback.none;
          if (session.isFinished) {
            finished = true;
            onFinished?.call(session.stars);
          }
          _notify();
        });
      case TaskState.lost:
        _busy = true;
        t.fail();
        _say(LessonFeedback.botWon);
        _later(const Duration(milliseconds: 1800), () {
          t.reset();
          _busy = false;
          feedback = LessonFeedback.none;
          _notify();
        });
    }
  }

  // ---- helpers ---------------------------------------------------------

  void _shake(Square s) => shake = SquarePulse(s, ++_tick);
  void _burst(Square s) => burst = SquarePulse(s, ++_tick);

  void _say(LessonFeedback f) {
    feedback = f;
    _notify();
  }

  void _later(Duration d, void Function() f) => Timer(d, () {
    if (!_disposed) f();
  });

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
