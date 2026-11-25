import '../chess/types.dart';
import 'game_record.dart';
import 'time_control.dart';

/// How a new snapshot of a running game relates to the one we had.
class LiveChange {
  const LiveChange(this.common, this.added);

  /// Plies both snapshots share from the start.
  final int common;

  /// Plies of the new snapshot after [common].
  final int added;

  /// The source corrected a move: some of the old plies are gone.
  bool rewrittenFrom(int oldLength) => common < oldLength;
}

LiveChange diffGames(GameRecord old, GameRecord next) {
  var i = 0;
  while (i < old.length && i < next.length && old.moves[i] == next.moves[i]) {
    i++;
  }
  return LiveChange(i, next.length - i);
}

/// Clock state of both sides at one ply.
class LiveClocks {
  const LiveClocks({required this.white, required this.black, this.running, this.approximate = false, this.whiteShare, this.blackShare, this.trouble = const {}});

  final Duration? white;
  final Duration? black;

  /// Side whose clock runs (the game is live and we are on its last ply).
  final Side? running;

  /// No server time of the last move: ticking from when the app saw it.
  final bool approximate;

  /// Remaining part of the current period, 0..1, for the hourglass bar.
  final double? whiteShare;
  final double? blackShare;
  final Set<Side> trouble;

  Duration? of(Side s) => s == Side.white ? white : black;
  double? shareOf(Side s) => s == Side.white ? whiteShare : blackShare;
}

int _movesBy(GameRecord g, Side side, int ply) {
  var n = 0;
  for (var i = 0; i < ply; i++) {
    if (g.positions[i].sideToMove == side) n++;
  }
  return n;
}

/// Clocks after [ply] plies. When [ticking] (live, on the last ply), the
/// side to move loses the time since [lastMoveAt] (or [seenAt] when the
/// relay does not know it).
LiveClocks clocksAt(GameRecord g, int ply, {required DateTime now, bool ticking = false, DateTime? lastMoveAt, DateTime? seenAt}) {
  final tc = TimeControl.parse(g.headers['TimeControl']);
  final toMove = g.positions[ply].sideToMove;
  Duration? base(Side s) => g.clockOf(s, ply) ?? (g.clocks.isEmpty ? null : tc?.initial);
  var white = base(Side.white);
  var black = base(Side.black);
  var approximate = false;
  Side? running;
  if (ticking) {
    final since = lastMoveAt ?? seenAt;
    approximate = lastMoveAt == null;
    if (since != null) {
      final spent = now.difference(since);
      final pos = spent.isNegative ? Duration.zero : spent;
      running = toMove;
      if (toMove == Side.white && white != null) white = _floor(white - pos);
      if (toMove == Side.black && black != null) black = _floor(black - pos);
    }
  }
  double? share(Side s, Duration? left) {
    if (left == null || tc == null) return null;
    final period = tc.periodBase(_movesBy(g, s, ply));
    if (period <= Duration.zero) return null;
    return (left.inMilliseconds / period.inMilliseconds).clamp(0.0, 1.0);
  }

  final trouble = <Side>{
    for (final s in Side.values)
      if ((s == Side.white ? white : black) case final left?)
        if (inTimeTrouble(left, _movesBy(g, s, ply), tc)) s,
  };
  return LiveClocks(
    white: white,
    black: black,
    running: running,
    approximate: approximate,
    whiteShare: share(Side.white, white),
    blackShare: share(Side.black, black),
    trouble: trouble,
  );
}

Duration _floor(Duration d) => d.isNegative ? Duration.zero : d;

/// "Who is ahead" in five steps from the evaluation: -2 (Black winning)
/// … 0 (even) … 2 (White winning).
int aheadStep(int? cp, int? mate, List<int> steps) {
  if (mate != null) return mate > 0 ? 2 : -2;
  if (cp == null) return 0;
  final a = cp.abs();
  final step = a < steps[0] ? 0 : (a < steps[1] ? 1 : 2);
  return cp >= 0 ? step : -step;
}

/// Last-move time from the relay header (`LastMoveAt`, unix seconds).
DateTime? lastMoveAtOf(GameRecord g) {
  final v = int.tryParse(g.headers['LastMoveAt'] ?? '');
  return v == null ? null : DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true);
}
