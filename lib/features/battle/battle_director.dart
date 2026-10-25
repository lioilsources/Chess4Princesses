/// Battle choreography as a pure state machine (BATTLES_PLAN §3), so timing
/// is testable without Flame. The scene feeds it `dt` and reacts to events.
library;

enum BattlePhase { enter, idle, attack, victory, exit, done }

enum BattleEvent {
  /// Phase changed — read [BattleDirector.phase].
  phase,

  /// The attack's hit frame: defender starts `defeat`, fx, shake, sfx.
  hit,
}

/// Lengths of the four clips for one duel, from the atlases' JSON
/// (placeholders use [ClipTiming.placeholder]).
class ClipTiming {
  const ClipTiming({required this.attack, required this.hitAt, required this.defeat, required this.victory});

  /// Fits the plan's ≤ 3 s budget: 0.3 + 0.3 + 1.3 + 0.7 + 0.3 = 2.9 s.
  static const placeholder = ClipTiming(attack: 1.0, hitAt: 0.5, defeat: 0.8, victory: 0.7);

  final double attack;

  /// Seconds into `attack` when the blow lands (`hit_frame`).
  final double hitAt;
  final double defeat;
  final double victory;
}

class BattleDirector {
  BattleDirector({this.timing = ClipTiming.placeholder});

  static const enterTime = 0.3;
  static const idleTime = 0.3;
  static const exitTime = 0.3;

  /// Tapping skips only after this (BATTLES §0: "od 0,5 s přeskočitelné").
  static const skippableAfter = 0.5;

  final ClipTiming timing;

  BattlePhase phase = BattlePhase.enter;
  double elapsed = 0;
  double _inPhase = 0;
  bool _hit = false;
  bool skipped = false;

  /// Attack lasts until both the swing and the defender's defeat finish.
  double get _attackSpan {
    final defeatEnd = timing.hitAt + timing.defeat;
    return defeatEnd > timing.attack ? defeatEnd : timing.attack;
  }

  double get totalTime => enterTime + idleTime + _attackSpan + timing.victory + exitTime;

  double get phaseProgress {
    final len = _length(phase);
    return len <= 0 ? 1 : (_inPhase / len).clamp(0, 1);
  }

  double get timeInPhase => _inPhase;

  bool get canSkip => elapsed >= skippableAfter && phase != BattlePhase.exit && phase != BattlePhase.done;

  double _length(BattlePhase p) => switch (p) {
    BattlePhase.enter => enterTime,
    BattlePhase.idle => idleTime,
    BattlePhase.attack => _attackSpan,
    BattlePhase.victory => timing.victory,
    BattlePhase.exit => exitTime,
    BattlePhase.done => 0,
  };

  /// Advances time; returns events in order.
  List<BattleEvent> update(double dt) {
    if (phase == BattlePhase.done) return const [];
    final events = <BattleEvent>[];
    elapsed += dt;
    _inPhase += dt;
    while (phase != BattlePhase.done) {
      if (phase == BattlePhase.attack && !_hit && _inPhase >= timing.hitAt) {
        _hit = true;
        events.add(BattleEvent.hit);
      }
      final len = _length(phase);
      if (_inPhase < len) break;
      _inPhase -= len;
      phase = BattlePhase.values[phase.index + 1];
      events.add(BattleEvent.phase);
    }
    return events;
  }

  /// Jumps to `exit`. Returns false when not yet allowed.
  bool skip() {
    if (!canSkip) return false;
    skipped = true;
    phase = BattlePhase.exit;
    _inPhase = 0;
    return true;
  }
}
