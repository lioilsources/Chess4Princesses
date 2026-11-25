import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/content_lang.dart';
import '../../app/providers.dart';
import '../../core/armies/army.dart';
import '../../core/audio/sounds.dart';
import '../../core/chess/types.dart';
import '../../core/games/game_record.dart';
import '../../core/settings/settings.dart';
import '../../core/voice/narrator.dart';
import '../../l10n/app_localizations.dart';
import '../battle/battle_overlay.dart';
import '../battle/battle_scene.dart';
import '../board/chess_board.dart';
import 'games_providers.dart';
import 'replay_controller.dart';

/// Loads a game by id and plays it (SLAVNE_PARTIE_PLAN §4).
class ReplayScreen extends ConsumerWidget {
  const ReplayScreen({super.key, required this.gameId, this.game});

  final String gameId;

  /// Already loaded game (live rounds pass it directly).
  final GameRecord? game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armies = ref.watch(boardArmiesProvider);
    final record = game != null ? AsyncData<GameRecord?>(game) : ref.watch(gameByIdProvider(gameId));
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9FF),
      body: SafeArea(
        child: switch ((record, armies)) {
          (AsyncData(value: final g?), AsyncData(value: (final mine, final rival))) => ReplayView(record: g, mine: mine, rival: rival),
          (AsyncData(value: null), _) => Center(child: IconButton(iconSize: 48, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())),
          (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Center(child: Text('$error')),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class ReplayView extends ConsumerStatefulWidget {
  const ReplayView({super.key, required this.record, required this.mine, required this.rival, this.autoplay = true});

  final GameRecord record;
  final Army mine;
  final Army rival;
  final bool autoplay;

  @override
  ConsumerState<ReplayView> createState() => _ReplayViewState();
}

class _ReplayViewState extends ConsumerState<ReplayView> {
  late final Sounds _sounds = ref.read(soundsProvider);
  late final Settings _settings = ref.read(settingsProvider).value ?? const Settings();
  late final c = ReplayController(widget.record, onSfx: _sounds.play, battlesOn: _settings.battlesShown)..addListener(_changed);
  Narrator? _narrator;
  int _lineHeard = 0;

  /// The sticker for this game is already given.
  bool _stuck = false;

  @override
  void initState() {
    super.initState();
    _sounds.music(Music.lesson);
    ref.read(narratorProvider.future).then((n) {
      if (mounted) _narrator = n;
    });
    if (widget.autoplay) c.play();
  }

  @override
  void dispose() {
    _narrator?.stop();
    _sounds.music(Music.map);
    c.dispose();
    super.dispose();
  }

  void _changed() {
    setState(() {});
    if (c.atEnd && !_stuck) {
      _stuck = true;
      ref.read(progressProvider.notifier).watchGame(widget.record.id);
    }
    if (c.lineTick != _lineHeard) {
      _lineHeard = c.lineTick;
      final l = c.line;
      if (l != null) _narrator?.say(context.contentLang, [lineText(AppLocalizations.of(context), l)]);
    }
  }

  /// White plays with my army (PLAN §4).
  Army _armyOf(Side s) => s == Side.white ? widget.mine : widget.rival;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = context.contentLang;
    final g = widget.record;
    final last = c.lastMove;
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), tooltip: l10n.back, onPressed: () => context.pop()),
                  Expanded(
                    child: Text(
                      '${g.white} – ${g.black}${g.year == null ? '' : ' · ${g.year}'}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5A3A7A)),
                    ),
                  ),
                  IconButton(
                    iconSize: 32,
                    tooltip: l10n.replayChronicle,
                    isSelected: c.chronicle,
                    icon: const Icon(Icons.menu_book_outlined),
                    selectedIcon: const Icon(Icons.menu_book_rounded),
                    onPressed: () => c.setChronicle(!c.chronicle),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 56,
              child: Center(
                child: c.line == null
                    ? const SizedBox.shrink()
                    : BubbleText(lineText(l10n, c.line!), key: ValueKey(c.lineTick), role: KidRole.dialog, size: 24, palette: KidPalette.lemon),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  // Top, so the board stays put while the panels below change height.
                  alignment: Alignment.topCenter,
                  child: ChessBoard(
                    position: c.position,
                    armyOf: _armyOf,
                    mySide: Side.white,
                    marks: BoardMarks(done: last == null ? const {} : {last.from, last.to}),
                    burst: c.burst,
                    slide: c.slide,
                    showCoordinates: c.chronicle,
                    classic: _settings.classicPieces,
                  ),
                ),
              ),
            ),
            if (c.chronicle) _ChronicleBar(c: c, l10n: l10n) else _StoryBar(c: c, l10n: l10n),
          ],
        ),
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
                onSfx: _sounds.play,
              ),
              onFinished: c.battleFinished,
            ),
          ),
        if (c.ended && !c.chronicle) EndCard(line: c.line ?? ReplayLine.endUnfinished, l10n: l10n, onAgain: c.restart, onDone: () => context.pop()),
      ],
    );
  }
}

String lineText(AppLocalizations l10n, ReplayLine l) => switch (l) {
  ReplayLine.check => l10n.replayCheck,
  ReplayLine.mate => l10n.replayMate,
  ReplayLine.castle => l10n.replayCastle,
  ReplayLine.promotion => l10n.promoted,
  ReplayLine.sacrifice => l10n.replaySacrifice,
  ReplayLine.endMate => l10n.replayEndMate,
  ReplayLine.endResign => l10n.replayEndResign,
  ReplayLine.endDraw => l10n.replayEndDraw,
  ReplayLine.endUnfinished => l10n.replayEndUnfinished,
  ReplayLine.timeTrouble => l10n.liveTimeTrouble,
};

/// Story mode: no text, big buttons, a timeline with battle dots.
class _StoryBar extends StatelessWidget {
  const _StoryBar({required this.c, required this.l10n});
  final ReplayController c;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final n = c.record.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, box) => SizedBox(
              height: 22,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(value: n == 0 ? 1 : c.ply / n, minHeight: 10, color: const Color(0xFFAB47BC), backgroundColor: const Color(0xFFE1D0F0)),
                  ),
                  for (final p in c.battles)
                    PositionedDirectional(
                      start: (box.maxWidth - 14) * (p + 1) / (n == 0 ? 1 : n),
                      child: Icon(Icons.flash_on_rounded, size: 14, color: p < c.ply ? const Color(0xFF7B1FA2) : const Color(0xFFFFA000)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(iconSize: 36, tooltip: l10n.again, onPressed: c.restart, icon: const Icon(Icons.replay_rounded)),
              const SizedBox(width: 24),
              IconButton.filled(
                iconSize: 56,
                tooltip: c.playing ? l10n.replayPause : l10n.replayPlay,
                onPressed: c.toggle,
                icon: Icon(c.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
              ),
              const SizedBox(width: 24),
              IconButton.filledTonal(
                iconSize: 36,
                tooltip: l10n.replayNextBattle,
                onPressed: c.nextBattlePly == null ? null : c.skipToBattle,
                icon: const Icon(Icons.flash_on_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chronicle (parent): notation, stepping, no battles.
class _ChronicleBar extends StatelessWidget {
  const _ChronicleBar({required this.c, required this.l10n});
  final ReplayController c;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final g = c.record;
    final current = c.ply - 1;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            [g.event, g.headers['Site'], g.headers['Date'], g.result.pgn].whereType<String>().where((s) => s.isNotEmpty && s != '?').join(' · '),
            style: const TextStyle(color: Color(0xFF6D4C41)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: false,
              itemCount: g.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: ChoiceChip(
                  label: Text(i.isEven ? '${i ~/ 2 + 1}. ${g.sans[i]}' : g.sans[i]),
                  selected: i == current,
                  onSelected: (_) => c.jumpTo(i + 1),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(iconSize: 36, tooltip: l10n.replayStepBack, onPressed: c.ply == 0 ? null : c.stepBack, icon: const Icon(Icons.chevron_left_rounded)),
              IconButton(iconSize: 36, tooltip: c.playing ? l10n.replayPause : l10n.replayPlay, onPressed: c.toggle, icon: Icon(c.playing ? Icons.pause_rounded : Icons.play_arrow_rounded)),
              IconButton(iconSize: 36, tooltip: l10n.replayStepForward, onPressed: c.atEnd ? null : c.stepForward, icon: const Icon(Icons.chevron_right_rounded)),
              const SizedBox(width: 8),
              Text(l10n.replayMoveOf((c.ply + 1) ~/ 2, (g.length + 1) ~/ 2)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mate: crown. Resignation: the king bows. Draw: handshake (PLAN §1).
class EndCard extends StatelessWidget {
  const EndCard({super.key, required this.line, required this.l10n, required this.onAgain, required this.onDone});
  final ReplayLine line;
  final AppLocalizations l10n;
  final VoidCallback onAgain;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final icon = switch (line) {
      ReplayLine.endMate => Icons.emoji_events_rounded,
      ReplayLine.endDraw => Icons.handshake_rounded,
      ReplayLine.endResign => Icons.workspace_premium_rounded,
      _ => Icons.hourglass_top_rounded,
    };
    return ColoredBox(
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
                Icon(icon, size: 96, color: const Color(0xFFFFB300)),
                const SizedBox(height: 12),
                BubbleText(lineText(l10n, line), role: KidRole.dialog, size: 26, palette: KidPalette.mint),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(iconSize: 40, onPressed: onAgain, icon: const Icon(Icons.replay_rounded), tooltip: l10n.again),
                    const SizedBox(width: 24),
                    IconButton.filled(iconSize: 40, onPressed: onDone, icon: const Icon(Icons.check_rounded), tooltip: l10n.back),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
