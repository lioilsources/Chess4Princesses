import 'dart:async';

import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/content_lang.dart';
import '../../app/providers.dart';
import '../../core/armies/army.dart';
import '../../core/audio/sounds.dart';
import '../../core/chess/position.dart';
import '../../core/chess/rules.dart';
import '../../core/chess/types.dart';
import '../../core/games/game_record.dart';
import '../../core/games/live_config.dart';
import '../../core/games/live_game.dart';
import '../../core/games/pgn.dart';
import '../../core/games/uci_reader.dart';
import '../../core/net/feed_client.dart';
import '../../core/settings/settings.dart';
import '../../core/voice/narrator.dart';
import '../../l10n/app_localizations.dart';
import '../battle/battle_overlay.dart';
import '../battle/battle_scene.dart';
import '../board/chess_board.dart';
import 'live_controller.dart';
import 'live_providers.dart';
import 'live_watch.dart';
import 'replay_controller.dart';
import 'replay_screen.dart';

/// Adviser colours: first, second and third line.
const adviceColors = [Color(0xFF43A047), Color(0xFF1E88E5), Color(0xFFFB8C00)];

/// "Živě": one running game of a round (Prompts/06-ZIVY_PRENOS_PLAN.md).
/// Polls the relay while open, catches up, then plays every new move.
class LiveGameScreen extends ConsumerStatefulWidget {
  const LiveGameScreen({super.key, required this.tournamentId, required this.roundId, this.gameIndex = 0, this.timer, this.now});

  final String tournamentId;
  final String roundId;
  final int gameIndex;

  /// Test hooks (fake timers and clock).
  final Timer Function(Duration, void Function())? timer;
  final DateTime Function()? now;

  @override
  ConsumerState<LiveGameScreen> createState() => _LiveGameScreenState();
}

class _LiveGameScreenState extends ConsumerState<LiveGameScreen> {
  late final Sounds _sounds = ref.read(soundsProvider);
  late final Settings _settings = ref.read(settingsProvider).value ?? const Settings();
  late final LiveRoundWatcher _watch;
  AppLifecycleListener? _life;
  LiveController? c;
  Narrator? _narrator;
  int _lineHeard = 0;
  Timer? _clockTimer;
  bool _offline = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _sounds.music(Music.lesson);
    ref.read(narratorProvider.future).then((n) {
      if (mounted) _narrator = n;
    });
    _watch = LiveRoundWatcher(
      client: ref.read(feedClientProvider),
      tournamentId: widget.tournamentId,
      roundId: widget.roundId,
      timer: widget.timer,
      onGames: _onGames,
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _offline = true;
          if (c == null) _error = e;
        });
      },
    )..start();
    _life = AppLifecycleListener(onResume: _watch.resume, onPause: _watch.pause, onHide: _watch.pause, onShow: _watch.resume);
    _clockTimer = (widget.timer == null) ? Timer.periodic(liveClockTick, (_) => c?.tick()) : null;
    _wake(true);
  }

  /// Keep the screen on while a live game is open (PLAN §15 q2).
  void _wake(bool on) {
    if (widget.timer != null) return; // widget tests: no plugin
    unawaited(WakelockPlus.toggle(enable: on).catchError((Object _) {}));
  }

  void _onGames(List<GameRecord> games, DateTime? serverTime) {
    if (!mounted || widget.gameIndex >= games.length) return;
    final g = games[widget.gameIndex];
    setState(() {
      _offline = false;
      _error = null;
    });
    final existing = c;
    if (existing == null) {
      final created = LiveController(
        g,
        onSfx: _sounds.play,
        onWatched: (r) => ref.read(progressProvider.notifier).watchGame(r.id),
        timer: widget.timer,
        now: widget.now,
        battlesOn: _settings.battlesShown,
      );
      c = created;
      created
        ..addListener(_changed)
        ..update(g, serverTime: serverTime)
        ..start();
    } else {
      existing.update(g, serverTime: serverTime);
    }
  }

  @override
  void dispose() {
    _wake(false);
    _clockTimer?.cancel();
    _life?.dispose();
    _watch.dispose();
    _narrator?.stop();
    _sounds.music(Music.map);
    c?.dispose();
    super.dispose();
  }

  void _changed() {
    if (!mounted) return;
    setState(() {});
    final ctl = c!;
    if (ctl.lineTick != _lineHeard) {
      _lineHeard = ctl.lineTick;
      final l = ctl.line;
      if (l != null) _narrator?.say(context.contentLang, [lineText(AppLocalizations.of(context), l)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final armies = ref.watch(boardArmiesProvider);
    final ctl = c;
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9FF),
      body: SafeArea(
        child: switch ((ctl, armies)) {
          (final ctl?, AsyncData(value: (final mine, final rival))) => _LiveView(
            c: ctl,
            mine: mine,
            rival: rival,
            settings: _settings,
            offline: _offline,
            onLine: (line) => _narrator?.say(context.contentLang, [line]),
          ),
          _ when _error != null => _Message(text: l10n.liveError),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      Expanded(child: Center(child: Text(text))),
    ],
  );
}

class _LiveView extends ConsumerStatefulWidget {
  const _LiveView({required this.c, required this.mine, required this.rival, required this.settings, required this.offline, required this.onLine});

  final LiveController c;
  final Army mine;
  final Army rival;
  final Settings settings;
  final bool offline;
  final void Function(String) onLine;

  @override
  ConsumerState<_LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends ConsumerState<_LiveView> {
  bool _adviserOpen = false;
  final Map<String, Future<Advice>> _advice = {};

  LiveController get c => widget.c;

  /// White plays with my army (PLAN §4).
  Army _armyOf(Side s) => s == Side.white ? widget.mine : widget.rival;

  /// Position the adviser talks about: the game ply on screen.
  Position get _advicePosition => c.record.positions[c.inGame || c.away == LiveAway.browse ? c.ply : c.awayFrom];

  Future<Advice> _adviceFor(Position p) => _advice.putIfAbsent(p.fen, () => ref.read(feedClientProvider).advice(p.fen));

  void _openAdviser() {
    setState(() => _adviserOpen = !_adviserOpen);
  }

  void _playLine(AdviceLine line) {
    final moves = readUciLine(_advicePosition, line.moves);
    if (moves.isNotEmpty) c.playAdvice(moves);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = c.record;
    final last = c.lastMove;
    final clocks = c.clocks;
    final away = !c.inGame;
    final arrows = <BoardArrow>[];
    final adviceAt = _advicePosition;
    final showArrows = (_adviserOpen || c.chronicle) && (c.inGame || c.away == LiveAway.browse) && c.phase != LivePhase.catchUp;
    final advice = showArrows ? _adviceFor(adviceAt) : null;
    return Stack(
      children: [
        Column(
          children: [
            _TopBar(c: c, l10n: l10n),
            if (widget.offline) _OfflineNote(text: l10n.liveOffline),
            _ClockRow(name: g.black, side: Side.black, clocks: clocks, chronicle: c.chronicle),
            SizedBox(
              height: 48,
              child: Center(
                child: c.line == null
                    ? const SizedBox.shrink()
                    : BubbleText(lineText(l10n, c.line!), key: ValueKey(c.lineTick), role: KidRole.dialog, size: 22, palette: KidPalette.lemon),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: FutureBuilder<Advice>(
                    future: advice,
                    builder: (context, snap) {
                      if (showArrows && snap.data != null) {
                        for (final (i, l) in snap.data!.lines.indexed) {
                          final m = l.moves.isEmpty ? null : readUci(adviceAt, l.moves.first);
                          if (m != null) arrows.add(BoardArrow(m.from, m.to, adviceColors[i % adviceColors.length]));
                        }
                      }
                      return ChessBoard(
                        position: c.position,
                        armyOf: _armyOf,
                        mySide: Side.white,
                        marks: BoardMarks(done: last == null ? const {} : {last.from, last.to}, selected: c.selected, dots: c.dots, arrows: arrows),
                        burst: c.burst,
                        slide: c.slide,
                        showCoordinates: c.chronicle,
                        classic: widget.settings.classicPieces,
                        frameColor: away ? const Color(0xFF2E7D6B) : null,
                        canDrag: c.canDrag,
                        onTap: c.tap,
                        onDragStart: c.dragStart,
                        onDrop: (d, to) {
                          if (d case DragFromSquare(:final from)) c.drop(from, to);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            _ClockRow(name: g.white, side: Side.white, clocks: clocks, chronicle: c.chronicle),
            if (away && c.missed > 0) _NewMoveBanner(n: c.missed, l10n: l10n, onTap: c.backToGame),
            if (c.chronicle) _LiveChronicle(c: c, l10n: l10n, advice: advice, at: adviceAt) else _bottom(l10n, advice, adviceAt),
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
                lang: context.contentLang,
                onLine: widget.onLine,
                onSfx: ref.read(soundsProvider).play,
              ),
              onFinished: c.battleFinished,
            ),
          ),
        if (c.ended && !c.chronicle)
          EndCard(
            line: c.line ?? ReplayLine.endUnfinished,
            l10n: l10n,
            onAgain: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ReplayScreen(gameId: g.id, game: g))),
            onDone: () => context.pop(),
          ),
      ],
    );
  }

  Widget _bottom(AppLocalizations l10n, Future<Advice>? advice, Position at) {
    if (c.phase == LivePhase.catchUp && c.inGame) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.tonalIcon(onPressed: c.skipCatchUp, icon: const Icon(Icons.fast_forward_rounded), label: Text(l10n.liveSkip)),
      );
    }
    if (!c.inGame) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (c.away == LiveAway.adviser)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton.tonalIcon(onPressed: c.continueAlone, icon: const Icon(Icons.pan_tool_alt_rounded), label: Text(l10n.liveAdviserContinue)),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                IconButton.filledTonal(iconSize: 32, tooltip: l10n.replayStepBack, onPressed: c.undoOwn, icon: const Icon(Icons.undo_rounded)),
                IconButton.filledTonal(iconSize: 32, tooltip: l10n.liveReset, onPressed: c.resetOwn, icon: const Icon(Icons.restart_alt_rounded)),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
                  onPressed: () {
                    setState(() => _adviserOpen = false);
                    c.backToGame();
                  },
                  icon: const Icon(Icons.live_tv_rounded),
                  label: Text(l10n.liveBackToGame),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AheadBar(eval: c.record.evalAt(c.ply), mine: widget.mine, rival: widget.rival, label: l10n.liveAhead),
          if (_adviserOpen) _AdviceBubbles(advice: advice, at: at, l10n: l10n, onPlay: _playLine),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
                onPressed: () {
                  setState(() => _adviserOpen = false);
                  c.tryOwn();
                },
                icon: const Icon(Icons.touch_app_rounded),
                label: Text(l10n.liveTryOwn),
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 56), backgroundColor: _adviserOpen ? const Color(0xFFC8E6C9) : null),
                onPressed: _openAdviser,
                icon: const Icon(Icons.lightbulb_rounded),
                label: Text(l10n.liveAdviser),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.c, required this.l10n});
  final LiveController c;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final g = c.record;
    final live = c.phase != LivePhase.ended;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 8, 0),
      child: Row(
        children: [
          IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), tooltip: l10n.back, onPressed: () => context.pop()),
          if (live) const _LiveBadge(),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${g.white} – ${g.black}',
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
    );
  }
}

/// Pulsing red dot: something is being played right now.
class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).liveBadge,
    child: FadeTransition(
      opacity: Tween(begin: .35, end: 1.0).animate(_a),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, size: 10, color: Colors.white),
            const SizedBox(width: 4),
            Text(AppLocalizations.of(context).liveBadge, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    ),
  );
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [const Icon(Icons.cloud_off_rounded, size: 18), const SizedBox(width: 6), Expanded(child: Text(text))]),
  );
}

/// One player's clock: an hourglass bar for the child, digits next to it.
class _ClockRow extends StatelessWidget {
  const _ClockRow({required this.name, required this.side, required this.clocks, required this.chronicle});
  final String name;
  final Side side;
  final LiveClocks clocks;
  final bool chronicle;

  @override
  Widget build(BuildContext context) {
    final left = clocks.of(side);
    final share = clocks.shareOf(side);
    final running = clocks.running == side;
    final trouble = clocks.trouble.contains(side);
    final color = trouble ? const Color(0xFFE53935) : (running ? const Color(0xFF7B1FA2) : const Color(0xFFB39DDB));
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Icon(side == Side.white ? Icons.circle_outlined : Icons.circle, size: 14, color: const Color(0xFF5A3A7A)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: running ? FontWeight.w800 : FontWeight.w500)),
          ),
          if (left != null) ...[
            _Pulse(on: trouble, child: Icon(Icons.hourglass_bottom_rounded, color: color, size: 22)),
            if (share != null)
              SizedBox(
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: share, minHeight: 10, color: color, backgroundColor: const Color(0xFFE1D0F0)),
                ),
              ),
            const SizedBox(width: 8),
            Tooltip(
              message: clocks.approximate && running ? l10n.liveClockApprox : '',
              child: Text(
                '${clocks.approximate && running ? '≈' : ''}${formatClock(left)}',
                style: TextStyle(fontFeatures: const [FontFeature.tabularFigures()], fontSize: chronicle ? 16 : 18, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.on, required this.child});
  final bool on;
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

  @override
  void didUpdateWidget(covariant _Pulse old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void initState() {
    super.initState();
    _sync();
  }

  void _sync() {
    if (widget.on && !_a.isAnimating) _a.repeat(reverse: true);
    if (!widget.on && _a.isAnimating) _a.stop();
  }

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: Tween(begin: 1.0, end: widget.on ? 1.3 : 1.0).animate(_a), child: widget.child);
}

class _NewMoveBanner extends StatelessWidget {
  const _NewMoveBanner({required this.n, required this.l10n, required this.onTap});
  final int n;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
    child: Material(
      color: const Color(0xFFFFE082),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.notifications_active_rounded, color: Color(0xFFE65100)),
              const SizedBox(width: 8),
              Expanded(child: Text(n == 1 ? l10n.liveNewMove : l10n.liveNewMoves(n), style: const TextStyle(fontWeight: FontWeight.w700))),
              const Icon(Icons.live_tv_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}

/// "Kdo vede": a bar between the two armies, five steps, from the source's evaluation.
class _AheadBar extends StatelessWidget {
  const _AheadBar({required this.eval, required this.mine, required this.rival, required this.label});
  final Eval? eval;
  final Army mine;
  final Army rival;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (eval == null) return const SizedBox.shrink();
    final step = aheadStep(eval!.cp, eval!.mate, liveAheadSteps);
    final white = .5 + step * .2;
    return Semantics(
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.shield_rounded, color: Color(mine.primary)),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      Expanded(flex: (white * 100).round(), child: ColoredBox(color: Color(mine.primary), child: const SizedBox.expand())),
                      Expanded(flex: 100 - (white * 100).round(), child: ColoredBox(color: Color(rival.primary), child: const SizedBox.expand())),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.shield_rounded, color: Color(rival.primary)),
          ],
        ),
      ),
    );
  }
}

/// Three coloured bubbles; a tap plays the line on the board.
class _AdviceBubbles extends StatelessWidget {
  const _AdviceBubbles({required this.advice, required this.at, required this.l10n, required this.onPlay});
  final Future<Advice>? advice;
  final Position at;
  final AppLocalizations l10n;
  final void Function(AdviceLine) onPlay;

  @override
  Widget build(BuildContext context) => FutureBuilder<Advice>(
    future: advice,
    builder: (context, snap) {
      final lines = snap.data?.lines ?? const <AdviceLine>[];
      if (snap.connectionState != ConnectionState.done) return const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator());
      if (lines.isEmpty) return Padding(padding: const EdgeInsets.all(8), child: Text(l10n.liveAdviserThinking));
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (i, l) in lines.indexed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: IconButton.filled(
                  iconSize: 32,
                  style: IconButton.styleFrom(backgroundColor: adviceColors[i % adviceColors.length]),
                  tooltip: _sanLine(at, l.moves).take(3).join(' '),
                  onPressed: () => onPlay(l),
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
              ),
          ],
        ),
      );
    },
  );
}

/// SAN of a UCI line from [at] (legal prefix only).
List<String> _sanLine(Position at, List<String> uci) {
  const rules = Rules();
  final out = <String>[];
  var p = at;
  for (final m in readUciLine(at, uci)) {
    out.add(rules.san(p, m));
    p = p.apply(m);
  }
  return out;
}

String _evalText(int? cp, int? mate) => mate != null ? '#$mate' : (cp == null ? '' : '${cp >= 0 ? '+' : ''}${(cp / 100).toStringAsFixed(2)}');

/// Chronicle in live mode: notation with clocks and evals, stepping, adviser lines.
class _LiveChronicle extends StatelessWidget {
  const _LiveChronicle({required this.c, required this.l10n, required this.advice, required this.at});
  final LiveController c;
  final AppLocalizations l10n;
  final Future<Advice>? advice;
  final Position at;

  @override
  Widget build(BuildContext context) {
    final g = c.record;
    final current = c.ply - 1;
    final ev = g.evalAt(c.ply);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            [g.event, g.headers['Date'], g.result.pgn, if (ev != null) _evalText(ev.cp, ev.mate)].whereType<String>().where((s) => s.isNotEmpty && s != '?').join(' · '),
            style: const TextStyle(color: Color(0xFF6D4C41)),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: g.length,
              itemBuilder: (context, j) {
                final i = g.length - 1 - j;
                final clock = i < g.clocks.length ? g.clocks[i] : null;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ChoiceChip(
                    label: Text('${i.isEven ? '${i ~/ 2 + 1}. ' : ''}${g.sans[i]}${clock == null ? '' : '  ${formatClock(clock)}'}'),
                    selected: i == current && c.inGame || (c.away == LiveAway.browse && i == current),
                    onSelected: (_) => c.browse(i + 1),
                  ),
                );
              },
            ),
          ),
          FutureBuilder<Advice>(
            future: advice,
            builder: (context, snap) {
              final a = snap.data;
              if (a == null || a.lines.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, l) in a.lines.indexed)
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(child: Icon(Icons.circle, size: 10, color: adviceColors[i % adviceColors.length])),
                          TextSpan(text: ' ${_evalText(l.cp, l.mate)}  ${_sanLine(at, l.moves).join(' ')}'),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  Text(l10n.liveDepth(a.depth), style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(iconSize: 32, tooltip: l10n.replayStepBack, onPressed: c.ply == 0 ? null : () => c.browse(c.ply - 1), icon: const Icon(Icons.chevron_left_rounded)),
              IconButton(iconSize: 32, tooltip: l10n.replayStepForward, onPressed: c.atLatest ? null : () => c.browse(c.ply + 1), icon: const Icon(Icons.chevron_right_rounded)),
              IconButton(iconSize: 32, tooltip: l10n.liveBackToGame, onPressed: c.inGame ? null : c.backToGame, icon: const Icon(Icons.live_tv_rounded)),
              IconButton(iconSize: 32, tooltip: l10n.liveTryOwn, onPressed: c.tryOwn, icon: const Icon(Icons.touch_app_rounded)),
              const SizedBox(width: 8),
              Text(l10n.replayMoveOf((c.ply + 1) ~/ 2, (g.length + 1) ~/ 2)),
            ],
          ),
        ],
      ),
    );
  }
}
