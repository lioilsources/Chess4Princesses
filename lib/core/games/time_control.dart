import 'live_config.dart';

/// One period of a PGN `TimeControl` field: [moves] moves (null = rest of
/// the game) in [base], plus [increment] per move.
class TimePeriod {
  const TimePeriod({this.moves, required this.base, this.increment = Duration.zero});
  final int? moves;
  final Duration base;
  final Duration increment;
}

/// Standard PGN `TimeControl` (`40/7200:1800+30`, `5400+30`). The relay
/// writes it from the curated list; the source only has free text.
class TimeControl {
  const TimeControl(this.periods);

  final List<TimePeriod> periods;

  static TimeControl? parse(String? s) {
    if (s == null || s.isEmpty || s == '?' || s == '-') return null;
    final periods = <TimePeriod>[];
    for (final part in s.split(':')) {
      final m = RegExp(r'^(?:(\d+)/)?(\d+)(?:\+(\d+))?$').firstMatch(part.trim());
      if (m == null) return null;
      periods.add(
        TimePeriod(
          moves: m.group(1) == null ? null : int.parse(m.group(1)!),
          base: Duration(seconds: int.parse(m.group(2)!)),
          increment: Duration(seconds: int.parse(m.group(3) ?? '0')),
        ),
      );
    }
    return periods.isEmpty ? null : TimeControl(periods);
  }

  /// Starting time of each side.
  Duration get initial => periods.first.base;

  /// Next move control after [movesDone] of the side's own moves:
  /// (moves still to play until it, the time added there) or null after the last one.
  (int, Duration)? nextControl(int movesDone) {
    var at = 0;
    for (var i = 0; i < periods.length; i++) {
      final p = periods[i];
      if (p.moves == null) return null;
      at += p.moves!;
      if (movesDone < at) {
        final added = i + 1 < periods.length ? periods[i + 1].base : Duration.zero;
        return (at - movesDone, added);
      }
    }
    return null;
  }

  /// Full time of the current period (for the hourglass bar).
  Duration periodBase(int movesDone) {
    var at = 0;
    for (final p in periods) {
      if (p.moves == null) return p.base;
      at += p.moves!;
      if (movesDone < at) return p.base;
    }
    return periods.last.base;
  }
}

/// Is a side with [left] on the clock in time trouble, after [movesDone] of its own moves?
bool inTimeTrouble(Duration left, int movesDone, TimeControl? tc) {
  if (tc == null) return left < liveTroubleUnknown;
  final next = tc.nextControl(movesDone);
  if (next == null) return left < liveTroubleFinal;
  return left < liveTroublePerMove * next.$1;
}
