import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/sounds.dart';
import '../../core/chess/position.dart';
import '../../core/chess/types.dart';
import '../../core/games/game_record.dart';
import '../../core/games/moments.dart';
import '../../core/games/replay_config.dart';
import '../board/chess_board.dart';

/// What the narrator says after a ply or at the end (SLAVNE_PARTIE_PLAN §5:
/// generic event lines cover every game).
enum ReplayLine { check, mate, castle, promotion, sacrifice, endMate, endResign, endDraw, endUnfinished, timeTrouble }

/// A full-screen battle waiting to be shown.
class ReplayBattle {
  const ReplayBattle(this.attacker, this.defender);
  final Piece attacker;
  final Piece defender;
}

typedef ReplayTimer = Timer Function(Duration, void Function());

/// Plays a [GameRecord] like a film (story mode) or step by step
/// (chronicle mode for the parent). Pure state + a timer; the screen renders.
class ReplayController extends ChangeNotifier {
  ReplayController(this.record, {this.onSfx, ReplayTimer? timer, bool battlesOn = true})
    : _timer = timer ?? Timer.new,
      moments = {for (final m in findMoments(record)) m.ply: m} {
    battles = battlesOn ? battlePlies(moments.values.toList()) : <int>{};
  }

  final GameRecord record;
  final void Function(Sfx)? onSfx;
  final ReplayTimer _timer;

  /// Moments by ply index.
  final Map<int, Moment> moments;

  /// Plies that get a full-screen battle in story mode.
  late final Set<int> battles;

  /// Number of moves applied: 0 = start position, `record.length` = end.
  int ply = 0;
  bool playing = false;
  bool chronicle = false;
  ReplayBattle? battle;
  MoveSlide? slide;
  SquarePulse burst = const SquarePulse(null, 0);

  /// Last narrator line and a tick so the screen speaks each one once.
  ReplayLine? line;
  int lineTick = 0;

  int _tick = 0;
  Timer? _pending;
  bool _disposed = false;

  Position get position => record.positions[ply];
  bool get atEnd => ply >= record.length;
  bool get ended => atEnd && !playing && battle == null;
  Move? get lastMove => ply == 0 ? null : record.moves[ply - 1];

  /// Next ply index with a full-screen battle, or null.
  int? get nextBattlePly {
    for (var i = ply; i < record.length; i++) {
      if (battles.contains(i)) return i;
    }
    return null;
  }

  void play() {
    if (atEnd) _seek(0);
    playing = true;
    _schedule(ply == 0 ? replayEdgeDelay : replayPlyDelay);
    _changed();
  }

  void pause() {
    playing = false;
    _cancel();
    _changed();
  }

  void toggle() => playing ? pause() : play();

  /// Chronicle step: one ply forward without battles.
  void stepForward() {
    if (atEnd) return;
    pause();
    _apply(battlesOn: false);
  }

  void stepBack() {
    if (ply == 0) return;
    pause();
    _seek(ply - 1);
  }

  void jumpTo(int target) {
    pause();
    _seek(target.clamp(0, record.length));
  }

  /// "Skoč na další bitvu": quietly fast-forward to just before the next
  /// battle and play it.
  void skipToBattle() {
    final target = nextBattlePly;
    if (target == null) return;
    _cancel();
    _seek(target);
    playing = true;
    _apply(battlesOn: true);
  }

  void restart() {
    _cancel();
    _seek(0);
    play();
  }

  void setChronicle(bool on) {
    chronicle = on;
    if (on) pause();
    _changed();
  }

  /// Called by the battle overlay when its animation ends.
  void battleFinished() {
    battle = null;
    if (playing) _schedule(_delayAfter(ply - 1));
    _changed();
  }

  void _seek(int target) {
    ply = target;
    battle = null;
    slide = null;
    line = null;
    _changed();
  }

  void _apply({required bool battlesOn}) {
    final i = ply;
    final m = record.moves[i];
    ply++;
    slide = MoveSlide(m, ++_tick, duration: replaySlide);
    final moment = moments[i];
    final story = battlesOn && !chronicle;
    if (moment != null && moment.isCapture) {
      if (story && battles.contains(i)) {
        battle = ReplayBattle(moment.attacker!, moment.victim!);
      } else {
        burst = SquarePulse(m.to, _tick);
        onSfx?.call(Sfx.poof);
      }
    } else {
      onSfx?.call(Sfx.move);
    }
    if (m.promotion != null) onSfx?.call(Sfx.promote);
    _say(_lineFor(moment));
    if (atEnd) {
      playing = false;
      _cancel();
      _say(_endLine());
    } else if (playing && battle == null) {
      _schedule(_delayAfter(i));
    }
    _changed();
  }

  Duration _delayAfter(int i) {
    if (i + 1 >= record.length) return replayEdgeDelay;
    final m = moments[i];
    return m != null && m.isNotable ? replayMomentDelay : replayPlyDelay;
  }

  ReplayLine? _lineFor(Moment? m) {
    if (m == null) return null;
    final k = m.kinds;
    if (k.contains(MomentKind.mate)) return ReplayLine.mate;
    if (k.contains(MomentKind.sacrifice)) return ReplayLine.sacrifice;
    if (k.contains(MomentKind.promotion)) return ReplayLine.promotion;
    if (k.contains(MomentKind.castle)) return ReplayLine.castle;
    if (k.contains(MomentKind.check)) return ReplayLine.check;
    return null;
  }

  ReplayLine _endLine() {
    if (record.endsInMate) return ReplayLine.endMate;
    return switch (record.result) {
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
      if (_disposed || !playing || battle != null || atEnd) return;
      _apply(battlesOn: true);
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
