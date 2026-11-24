import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/sounds.dart';
import '../../core/chess/position.dart';
import '../../core/chess/types.dart';
import '../../core/games/analysis.dart';
import '../../core/games/game_record.dart';
import '../../core/games/live_config.dart';
import '../../core/games/live_game.dart';
import '../../core/games/moments.dart';
import '../../core/games/replay_config.dart';
import '../board/chess_board.dart';
import 'replay_controller.dart';

/// Where the live screen is (Prompts/06-ZIVY_PRENOS_PLAN.md §3).
enum LivePhase { catchUp, live, ended }

/// What the viewer looks at besides the game itself.
enum LiveAway { none, browse, analysis, adviser }

/// A running game that grows while it is watched: catch-up, new moves with
/// battles, clocks, own analysis and adviser lines. Pure state + injected
/// timer and clock; the screen renders and polls.
class LiveController extends ChangeNotifier {
  LiveController(this._record, {this.onSfx, this.onWatched, ReplayTimer? timer, DateTime Function()? now, this.battlesOn = true})
    : _timer = timer ?? Timer.new,
      _now = now ?? DateTime.now {
    _moments = _findMoments(_record);
    _seenAt = _now();
  }

  GameRecord _record;
  final void Function(Sfx)? onSfx;

  /// Called once when the game ended and the viewer reached its end.
  final void Function(GameRecord)? onWatched;
  final ReplayTimer _timer;
  final DateTime Function() _now;
  final bool battlesOn;

  late Map<int, Moment> _moments;
  late DateTime _seenAt;

  /// Server minus device clock.
  Duration _clockOffset = Duration.zero;

  GameRecord get record => _record;

  /// Game plies shown: 0 = start, `record.length` = latest known.
  int ply = 0;
  LivePhase phase = LivePhase.catchUp;
  LiveAway away = LiveAway.none;
  bool chronicle = false;

  /// Own line or played adviser line, from [awayFrom] plies of the game.
  AnalysisLine? analysis;
  int awayFrom = 0;
  Square? selected;

  ReplayBattle? battle;
  MoveSlide? slide;
  SquarePulse burst = const SquarePulse(null, 0);
  ReplayLine? line;
  int lineTick = 0;

  int _tick = 0;
  Timer? _pending;
  bool _disposed = false;
  bool _watchedSent = false;
  final Set<Side> _troubleSaid = {};

  /// Plies being played quickly (catch-up or a burst): no battles, no lines.
  bool _fast = false;

  DateTime get now => _now().add(_clockOffset);
  bool get atLatest => ply >= _record.length;
  bool get inGame => away == LiveAway.none;
  bool get finished => _record.result != GameResult.unfinished;

  /// Plies that arrived while the viewer was away from the game (banner).
  int get missed => inGame ? 0 : (_record.length - _lengthAtLeave).clamp(0, 1 << 20);
  int _lengthAtLeave = 0;

  bool get ended => phase == LivePhase.ended && atLatest && battle == null && inGame;

  Position get position => switch (away) {
    LiveAway.analysis || LiveAway.adviser => analysis!.position,
    _ => _record.positions[ply],
  };

  Move? get lastMove {
    if (away == LiveAway.analysis || away == LiveAway.adviser) {
      return analysis!.lastMove ?? (awayFrom == 0 ? null : _record.moves[awayFrom - 1]);
    }
    return ply == 0 ? null : _record.moves[ply - 1];
  }

  /// Clocks for the game ply on screen (frozen while away or browsing).
  LiveClocks get clocks {
    final at = inGame ? ply : (away == LiveAway.browse ? ply : awayFrom);
    final ticking = inGame && atLatest && phase == LivePhase.live && !finished;
    return clocksAt(_record, at, now: now, ticking: ticking, lastMoveAt: lastMoveAtOf(_record), seenAt: _seenAt);
  }

  // ─── lifecycle ────────────────────────────────────────────────────────

  /// Starts the catch-up from the first move.
  void start() {
    phase = LivePhase.catchUp;
    _fast = true;
    if (atLatest) {
      _arrive();
    } else {
      _schedule(_catchUpDelay());
    }
    _changed();
  }

  /// Jumps over the catch-up to the latest position.
  void skipCatchUp() {
    if (phase != LivePhase.catchUp) return;
    _cancel();
    ply = _record.length;
    slide = null;
    _arrive();
    _changed();
  }

  /// A new snapshot from the relay. [serverTime] corrects the device clock.
  void update(GameRecord next, {DateTime? serverTime}) {
    if (serverTime != null) _clockOffset = serverTime.difference(_now());
    final change = diffGames(_record, next);
    final oldLength = _record.length;
    if (next.length != oldLength || change.rewrittenFrom(oldLength)) _seenAt = _now();
    if (change.rewrittenFrom(oldLength)) {
      if (ply > change.common) {
        _cancel();
        battle = null;
        slide = null;
        ply = change.common;
      }
      if (awayFrom > change.common) awayFrom = change.common;
      if (_lengthAtLeave > change.common) _lengthAtLeave = change.common;
    }
    final resultChanged = next.result != _record.result;
    _record = next;
    _moments = _findMoments(next);
    if (phase == LivePhase.catchUp) {
      if (_pending == null) _schedule(_catchUpDelay());
    } else if (inGame && (change.added > 0 || change.rewrittenFrom(oldLength) || resultChanged)) {
      _playNew();
    }
    _changed();
  }

  // ─── game ─────────────────────────────────────────────────────────────

  Duration _catchUpDelay() {
    final n = _record.length;
    if (n == 0) return liveCatchUpPly;
    final each = liveCatchUpMax ~/ n;
    return each < liveCatchUpPly ? each : liveCatchUpPly;
  }

  void _playNew() {
    if (battle != null || _pending != null) return;
    final left = _record.length - ply;
    if (left <= 0) {
      _arrive();
      return;
    }
    _fast = left > liveBurstMax;
    if (_fast) phase = LivePhase.catchUp;
    _step();
  }

  void _step() {
    if (atLatest) {
      _arrive();
      return;
    }
    final i = ply;
    final m = _record.moves[i];
    ply++;
    slide = MoveSlide(m, ++_tick, duration: _fast ? liveCatchUpPly : replaySlide);
    final moment = _moments[i];
    final quiet = _fast;
    if (moment != null && moment.isCapture) {
      if (!quiet && battlesOn && !chronicle) {
        battle = ReplayBattle(moment.attacker!, moment.victim!);
      } else {
        burst = SquarePulse(m.to, _tick);
        if (!quiet) onSfx?.call(Sfx.poof);
      }
    } else if (!quiet) {
      onSfx?.call(Sfx.move);
    }
    if (!quiet) {
      if (m.promotion != null) onSfx?.call(Sfx.promote);
      _say(_lineFor(moment));
    }
    if (battle == null) _continue();
    _changed();
  }

  void _continue() {
    if (atLatest) {
      _arrive();
    } else {
      _schedule(_fast ? _catchUpDelay() : replayPlyDelay);
    }
  }

  void _arrive() {
    _fast = false;
    _cancel();
    if (!atLatest) return;
    if (finished) {
      final first = phase != LivePhase.ended;
      phase = LivePhase.ended;
      if (first) _say(_endLine());
      if (!_watchedSent) {
        _watchedSent = true;
        onWatched?.call(_record);
      }
    } else {
      phase = LivePhase.live;
    }
  }

  /// Called by the battle overlay when its animation ends.
  void battleFinished() {
    battle = null;
    _continue();
    _changed();
  }

  /// Called every second by the screen: time-trouble line once per side.
  void tick() {
    if (!inGame || phase != LivePhase.live) return;
    final c = clocks;
    for (final s in c.trouble) {
      if (s == c.running && _troubleSaid.add(s)) _say(ReplayLine.timeTrouble);
    }
    _changed();
  }

  // ─── chronicle (parent) ──────────────────────────────────────────────

  void setChronicle(bool on) {
    chronicle = on;
    if (!on && away == LiveAway.browse) backToGame();
    _changed();
  }

  /// Chronicle: look at game ply [target]; the live game goes on underneath.
  void browse(int target) {
    if (phase == LivePhase.catchUp) skipCatchUp();
    _cancel();
    battle = null;
    slide = null;
    ply = target.clamp(0, _record.length);
    if (inGame) _lengthAtLeave = _record.length;
    away = ply >= _record.length ? LiveAway.none : LiveAway.browse;
    if (inGame) _arrive();
    _changed();
  }

  // ─── own analysis and adviser ────────────────────────────────────────

  /// "Zkusím to sám" from the game ply on screen.
  void tryOwn() {
    if (phase == LivePhase.catchUp) skipCatchUp();
    _leaveGame();
    analysis = AnalysisLine(_record.positions[awayFrom]);
    away = LiveAway.analysis;
    _changed();
  }

  /// Plays an adviser line (legal UCI prefix already read) from the game ply on screen.
  void playAdvice(List<Move> moves) {
    if (phase == LivePhase.catchUp) skipCatchUp();
    if (away != LiveAway.adviser && away != LiveAway.analysis) _leaveGame();
    analysis = AnalysisLine(_record.positions[awayFrom]);
    away = LiveAway.adviser;
    _cancel();
    _queueAdvice(moves, 0);
    _changed();
  }

  void _queueAdvice(List<Move> moves, int i) {
    if (i >= moves.length) return;
    _pending = _timer(replayPlyDelay, () {
      _pending = null;
      if (_disposed || away != LiveAway.adviser) return;
      _pushAway(moves[i]);
      _queueAdvice(moves, i + 1);
      _changed();
    });
  }

  /// After an adviser line: keep its position and go on alone.
  void continueAlone() {
    if (away != LiveAway.adviser) return;
    _cancel();
    away = LiveAway.analysis;
    _changed();
  }

  void _leaveGame() {
    _cancel();
    battle = null;
    slide = null;
    awayFrom = ply;
    selected = null;
    if (inGame) _lengthAtLeave = _record.length;
  }

  void _pushAway(Move m) {
    final captured = analysis!.position.capturedBy(m);
    analysis!.push(m);
    slide = MoveSlide(m, ++_tick, duration: replaySlide);
    if (captured != null) {
      burst = SquarePulse(m.to, _tick);
      onSfx?.call(Sfx.poof);
    } else {
      onSfx?.call(Sfx.move);
    }
  }

  bool canDrag(Square s) => away == LiveAway.analysis && analysis!.position[s]?.side == analysis!.position.sideToMove;

  Set<Square> get dots => selected == null || away != LiveAway.analysis ? const {} : {for (final m in analysis!.legalFrom(selected!)) m.to};

  void tap(Square s) {
    if (away != LiveAway.analysis) return;
    final pos = analysis!.position;
    if (selected != null && selected != s && _tryMove(selected!, s)) return;
    selected = pos[s]?.side == pos.sideToMove && selected != s ? s : null;
    _changed();
  }

  void dragStart(Square s) {
    selected = s;
    _changed();
  }

  void drop(Square from, Square to) {
    if (!_tryMove(from, to)) {
      selected = null;
      _changed();
    }
  }

  bool _tryMove(Square from, Square to) {
    final options = analysis!.legalFrom(from).where((m) => m.to == to).toList();
    if (options.isEmpty) return false;
    final m = options.firstWhere((m) => m.promotion == null || m.promotion == PieceType.queen, orElse: () => options.first);
    selected = null;
    _pushAway(m);
    if (m.promotion != null) onSfx?.call(Sfx.promote);
    _changed();
    return true;
  }

  void undoOwn() {
    if (analysis == null || analysis!.isEmpty) return;
    _cancel();
    if (away == LiveAway.adviser) away = LiveAway.analysis;
    analysis!.undo();
    slide = null;
    selected = null;
    _changed();
  }

  void resetOwn() {
    if (analysis == null) return;
    _cancel();
    if (away == LiveAway.adviser) away = LiveAway.analysis;
    analysis!.reset();
    slide = null;
    selected = null;
    _changed();
  }

  /// "Zpět k partii": missed plies follow (a burst quickly).
  void backToGame() {
    _cancel();
    analysis = null;
    selected = null;
    slide = null;
    away = LiveAway.none;
    if (phase != LivePhase.catchUp) {
      if (ply < awayFrom) ply = awayFrom;
      _playNew();
    }
    _changed();
  }

  // ─── helpers ─────────────────────────────────────────────────────────

  /// Sacrifices need plies that have not been played yet: never live.
  static Map<int, Moment> _findMoments(GameRecord g) => {
    for (final m in findMoments(g)) m.ply: m,
  };

  ReplayLine? _lineFor(Moment? m) {
    if (m == null) return null;
    final k = m.kinds;
    if (k.contains(MomentKind.mate)) return ReplayLine.mate;
    if (k.contains(MomentKind.promotion)) return ReplayLine.promotion;
    if (k.contains(MomentKind.castle)) return ReplayLine.castle;
    if (k.contains(MomentKind.check)) return ReplayLine.check;
    return null;
  }

  ReplayLine _endLine() {
    if (_record.endsInMate) return ReplayLine.endMate;
    return switch (_record.result) {
      GameResult.whiteWins || GameResult.blackWins => ReplayLine.endResign,
      GameResult.draw => ReplayLine.endDraw,
      GameResult.unfinished => ReplayLine.endUnfinished,
    };
  }

  void _say(ReplayLine? l) {
    if (l == null) return;
    line = l;
    lineTick++;
  }

  void _schedule(Duration d) {
    _cancel();
    _pending = _timer(d, () {
      _pending = null;
      if (_disposed || battle != null) return;
      if (phase == LivePhase.catchUp && !_fast) _fast = true;
      if (!inGame) return;
      _step();
    });
  }

  void _cancel() {
    _pending?.cancel();
    _pending = null;
  }

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancel();
    super.dispose();
  }
}
