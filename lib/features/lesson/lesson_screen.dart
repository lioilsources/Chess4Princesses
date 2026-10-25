import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/armies/army.dart';
import '../../core/chess/types.dart';
import '../../core/lessons/lesson.dart';
import '../../core/lessons/lesson_engine.dart';
import '../../core/voice/narrator.dart';
import '../../l10n/app_localizations.dart';
import '../battle/battle_overlay.dart';
import '../battle/battle_scene.dart';
import '../board/chess_board.dart';
import '../board/piece_token.dart';
import 'lesson_controller.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId));
    final armies = ref.watch(boardArmiesProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F7),
      body: SafeArea(
        child: switch ((lesson, armies)) {
          (AsyncData(value: final l), AsyncData(value: final a)) => _LessonView(key: ValueKey(l.id), lesson: l, mine: a.$1, rival: a.$2),
          (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Center(child: Text('$error')),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _LessonView extends ConsumerStatefulWidget {
  const _LessonView({super.key, required this.lesson, required this.mine, required this.rival});

  final Lesson lesson;
  final Army mine;
  final Army rival;

  @override
  ConsumerState<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<_LessonView> {
  late LessonController c = _newController();

  LessonController _newController() => LessonController(
    widget.lesson,
    onFinished: (stars) => ref.read(progressProvider.notifier).completeLesson(widget.lesson, stars),
  )..addListener(_changed);

  void _changed() {
    setState(() {});
    _speak();
  }

  @override
  void initState() {
    super.initState();
    ref.read(narratorProvider.future).then((n) {
      if (!mounted) return;
      _narrator = n;
      _speak();
    });
  }

  @override
  void dispose() {
    _narrator?.stop();
    c.dispose();
    super.dispose();
  }

  void _restart() {
    c.dispose();
    setState(() => c = _newController());
    _scene = null;
    _finishedHeard = false;
    _speak();
  }

  // ---- voice-over --------------------------------------------------------

  Narrator? _narrator;

  /// (story shown, task index, tap target) last read aloud.
  (bool, int, String?)? _scene;
  int _feedbackHeard = 0;
  bool _finishedHeard = false;

  /// Reads whatever just appeared: story, task prompt, next tap target,
  /// feedback or the finished card. Rebuilds without a change stay silent.
  void _speak() {
    final n = _narrator;
    if (n == null || !mounted) return;
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    if (c.finished) {
      if (!_finishedHeard) n.say(lang, [l10n.lessonDone]);
      _finishedHeard = true;
      return;
    }
    if (c.feedbackTick != _feedbackHeard) {
      _feedbackHeard = c.feedbackTick;
      if (c.feedback != LessonFeedback.none) n.say(lang, [feedbackText(l10n, c.feedback, '')]);
      return;
    }
    final target = c.task.currentTarget;
    final scene = (c.showStory, c.session.taskIndex, target);
    if (scene == _scene) return;
    final sameTask = _scene != null && !_scene!.$1 && _scene!.$2 == scene.$2;
    _scene = scene;
    if (c.showStory) {
      n.say(lang, [widget.lesson.story.of(lang)]);
    } else if (sameTask) {
      if (target != null) n.say(lang, [targetLabel(l10n, target)]);
    } else {
      _sayPrompt();
    }
  }

  void _sayPrompt() {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final target = c.task.currentTarget;
    _narrator?.say(lang, [c.task.task.prompt.of(lang), if (target != null) targetLabel(l10n, target)]);
  }

  void _sayStory() {
    final lang = Localizations.localeOf(context).languageCode;
    _narrator?.say(lang, [widget.lesson.story.of(lang)]);
  }

  Army _armyOf(Side s) => s == c.task.player ? widget.mine : widget.rival;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final lesson = widget.lesson;
    final t = c.task;

    return Stack(
      children: [
        Column(
          children: [
            _TopBar(lesson: lesson, lang: lang, taskIndex: c.session.taskIndex),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: _sayPrompt,
                child: _PromptBubble(task: t, lang: lang, feedback: c.feedback, l10n: l10n),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: ChessBoard(
                    position: t.position,
                    armyOf: _armyOf,
                    mySide: t.player,
                    marks: c.marks,
                    shake: c.shake,
                    burst: c.burst,
                    canDrag: c.canDrag,
                    onTap: c.tap,
                    onDragStart: c.dragStart,
                    onDrop: c.drop,
                  ),
                ),
              ),
            ),
            _BottomPanel(controller: c, armyOf: _armyOf, l10n: l10n),
          ],
        ),
        if (c.showStory) _StoryCard(lesson: lesson, lang: lang, onStart: c.startTask, onListen: _sayStory, l10n: l10n),
        if (c.battle case final b?)
          Positioned.fill(
            child: BattleOverlay(
              key: ObjectKey(b),
              request: BattleRequest(
                attackerArmy: _armyOf(b.attacker.side),
                attacker: b.attacker.type,
                defenderArmy: _armyOf(b.defender.side),
                defender: b.defender.type,
                lang: lang,
                onLine: (line) => _narrator?.say(lang, [line]),
              ),
              onFinished: c.battleFinished,
            ),
          ),
        if (c.finished) _FinishedCard(stars: c.session.stars, l10n: l10n, onAgain: _restart, onNext: () => _goNext(context)),
      ],
    );
  }

  Future<void> _goNext(BuildContext context) async {
    final cur = await ref.read(curriculumProvider.future);
    if (!context.mounted) return;
    final module = cur.modules.firstWhere((m) => m.number == widget.lesson.module);
    final i = module.lessonIds.indexOf(widget.lesson.id);
    if (i >= 0 && i + 1 < module.lessonIds.length) {
      context.pushReplacement('/lesson/${module.lessonIds[i + 1]}');
    } else {
      context.pop();
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.lesson, required this.lang, required this.taskIndex});

  final Lesson lesson;
  final String lang;
  final int taskIndex;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
    child: Row(
      children: [
        IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        Expanded(child: BubbleText(lesson.title.of(lang), role: KidRole.title, size: 26, palette: KidPalette.lavender)),
        for (var i = 0; i < lesson.tasks.length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(i < taskIndex ? Icons.circle : Icons.circle_outlined, size: 14, color: KidPalette.lavender.dark),
          ),
      ],
    ),
  );
}

class _PromptBubble extends StatelessWidget {
  const _PromptBubble({required this.task, required this.lang, required this.feedback, required this.l10n});

  final TaskSession task;
  final String lang;
  final LessonFeedback feedback;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final style = KidTheme.of(context).style(KidRole.dialog).copyWith(fontSize: 22, color: KidPalette.lavender.dark);
    final target = task.currentTarget;
    final text = feedbackText(l10n, feedback, task.task.prompt.of(lang));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: switch (feedback) {
          LessonFeedback.taskWon || LessonFeedback.promoted => const Color(0xFFE3F8EA),
          LessonFeedback.wrong || LessonFeedback.lava || LessonFeedback.botWon => const Color(0xFFFFE9E0),
          _ => Colors.white,
        },
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KidPalette.lavender.mid, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(text, style: style, textAlign: TextAlign.center)),
              Icon(Icons.volume_up_rounded, color: KidPalette.lavender.mid, size: 28),
            ],
          ),
          if (target != null && feedback == LessonFeedback.none) ...[
            const SizedBox(height: 4),
            BubbleText(targetLabel(l10n, target), role: KidRole.title, size: 40, palette: KidPalette.peach),
          ],
        ],
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.controller, required this.armyOf, required this.l10n});

  final LessonController controller;
  final Army Function(Side) armyOf;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final t = controller.task;
    return switch (t.task.goal) {
      GoalType.setupPieces => _Tray(pieces: t.tray, armyOf: armyOf, mySide: t.player),
      GoalType.yesNo => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BigButton(label: l10n.yes, icon: Icons.thumb_up_rounded, color: const Color(0xFF66BB6A), onTap: () => controller.answer(true)),
            _BigButton(label: l10n.no, icon: Icons.thumb_down_rounded, color: const Color(0xFFEF7D57), onTap: () => controller.answer(false)),
          ],
        ),
      ),
      _ => const SizedBox(height: 24),
    };
  }
}

/// Pieces to drag onto the board (setup_pieces).
class _Tray extends StatelessWidget {
  const _Tray({required this.pieces, required this.armyOf, required this.mySide});

  final List<Piece> pieces;
  final Army Function(Side) armyOf;
  final Side mySide;

  @override
  Widget build(BuildContext context) => Container(
    height: 96,
    margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: KidPalette.lavender.mid, width: 3)),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final p in pieces)
          Padding(
            padding: const EdgeInsets.all(6),
            child: Draggable<BoardDrag>(
              data: DragFromTray(p),
              feedback: PieceToken(piece: p, army: armyOf(p.side), mine: p.side == mySide, size: 72),
              childWhenDragging: Opacity(opacity: .25, child: PieceToken(piece: p, army: armyOf(p.side), mine: p.side == mySide, size: 72)),
              child: PieceToken(piece: p, army: armyOf(p.side), mine: p.side == mySide, size: 72),
            ),
          ),
      ],
    ),
  );
}

class _BigButton extends StatelessWidget {
  const _BigButton({required this.label, required this.icon, required this.color, required this.onTap});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    style: FilledButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(150, 72),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      textStyle: KidTheme.of(context).style(KidRole.title).copyWith(fontSize: 28),
    ),
    onPressed: onTap,
    icon: Icon(icon, size: 34),
    label: Text(label),
  );
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.lesson, required this.lang, required this.onStart, required this.onListen, required this.l10n});

  final Lesson lesson;
  final String lang;
  final VoidCallback onStart;
  final VoidCallback onListen;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xCC3A1F5C),
    child: Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFFFFFAF0), borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BubbleText(lesson.title.of(lang), role: KidRole.title, size: 34, palette: KidPalette.peach),
            const SizedBox(height: 16),
            Text(
              lesson.story.of(lang),
              textAlign: TextAlign.center,
              style: KidTheme.of(context).style(KidRole.body).copyWith(fontSize: 22, color: const Color(0xFF4A3B5C)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filledTonal(iconSize: 40, onPressed: onListen, icon: const Icon(Icons.volume_up_rounded)),
                const SizedBox(width: 24),
                _BigButton(label: l10n.start, icon: Icons.play_arrow_rounded, color: const Color(0xFFEC6FAE), onTap: onStart),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _FinishedCard extends StatelessWidget {
  const _FinishedCard({required this.stars, required this.l10n, required this.onAgain, required this.onNext});

  final int stars;
  final AppLocalizations l10n;
  final VoidCallback onAgain;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xCC3A1F5C),
    child: Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: .6, end: 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, s, child) => Transform.scale(scale: s, child: child),
        child: Container(
          margin: const EdgeInsets.all(28),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: const Color(0xFFFFFAF0), borderRadius: BorderRadius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BubbleText(l10n.lessonDone, role: KidRole.title, size: 34, palette: KidPalette.mint),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Icon(Icons.star_rounded, size: 72, color: i < stars ? const Color(0xFFFFC107) : const Color(0xFFE0D6E8)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(iconSize: 40, onPressed: onAgain, icon: const Icon(Icons.replay_rounded), tooltip: l10n.again),
                  const SizedBox(width: 24),
                  _BigButton(label: l10n.next, icon: Icons.arrow_forward_rounded, color: const Color(0xFF66BB6A), onTap: onNext),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Tap-square target in words ("ulici E", "řadu 4", "komnatu e4"); the voice
/// lines are generated from the same strings (core/voice/voice_lines.dart).
String targetLabel(AppLocalizations l10n, String t) {
  if (RegExp(r'^[a-h]$').hasMatch(t)) return l10n.street(t.toUpperCase());
  if (RegExp(r'^[1-8]$').hasMatch(t)) return l10n.house(t);
  return l10n.room(t);
}

String feedbackText(AppLocalizations l10n, LessonFeedback f, String prompt) => switch (f) {
  LessonFeedback.taskWon => l10n.taskWon,
  LessonFeedback.botWon => l10n.botWon,
  LessonFeedback.promoted => l10n.promoted,
  LessonFeedback.lava => l10n.lavaWarning,
  LessonFeedback.thinking => l10n.opponentThinking,
  LessonFeedback.wrong => l10n.tryAgain,
  LessonFeedback.none => prompt,
};
