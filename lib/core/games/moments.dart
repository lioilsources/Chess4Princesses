import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';
import 'game_record.dart';
import 'replay_config.dart';

enum MomentKind { capture, check, mate, castle, promotion, sacrifice }

/// What happened on one ply — found from the moves alone, no engine.
class Moment {
  const Moment({required this.ply, required this.kinds, this.attacker, this.victim});

  /// Index into [GameRecord.moves].
  final int ply;
  final Set<MomentKind> kinds;

  /// For captures: who took whom.
  final Piece? attacker;
  final Piece? victim;

  bool get isCapture => kinds.contains(MomentKind.capture);

  /// Anything worth a narrator line.
  bool get isNotable => kinds.any((k) => k != MomentKind.capture);
}

/// Material of [side] minus the opponent's, in apples.
int materialBalance(Position pos, Side side) {
  var n = 0;
  for (final (_, p) in pos.pieces) {
    n += p.side == side ? p.type.value : -p.type.value;
  }
  return n;
}

/// Moments of every ply that has one.
List<Moment> findMoments(GameRecord g) {
  const rules = Rules();
  final out = <Moment>[];
  final lastSacrifice = <Side, int>{};
  for (var i = 0; i < g.length; i++) {
    final before = g.positions[i];
    final after = g.positions[i + 1];
    final m = g.moves[i];
    final mover = before[m.from]!;
    final victim = before.capturedBy(m);
    final kinds = <MomentKind>{
      if (victim != null) MomentKind.capture,
      if (m.isCastle) MomentKind.castle,
      if (m.promotion != null) MomentKind.promotion,
    };
    if (rules.inCheck(after, after.sideToMove)) {
      kinds.add(rules.status(after) == GameStatus.checkmate ? MomentKind.mate : MomentKind.check);
    }
    // Only the first move of a combination counts.
    if (_isSacrifice(g, i, mover.side)) {
      if (lastSacrifice[mover.side] != i - 2) kinds.add(MomentKind.sacrifice);
      lastSacrifice[mover.side] = i;
    }
    if (kinds.isNotEmpty) out.add(Moment(ply: i, kinds: kinds, attacker: victim == null ? null : mover, victim: victim));
  }
  return out;
}

/// The mover gives material and stays down for a while, and the game ends
/// in their favour — the moves of a combination, not a blunder.
bool _isSacrifice(GameRecord g, int ply, Side side) {
  if (g.result.winner != side) return false;
  final start = materialBalance(g.positions[ply], side);
  final probe = ply + 2;
  if (probe >= g.positions.length) return false;
  if (materialBalance(g.positions[probe], side) > start - sacrificeMaterial) return false;
  final end = (probe + sacrificeWindow).clamp(0, g.positions.length - 1);
  for (var j = probe; j <= end; j++) {
    if (materialBalance(g.positions[j], side) > start - sacrificeMaterial) return false;
  }
  return true;
}

/// Plies that get a full-screen battle in story mode: the mate, sacrifices,
/// the first capture, queen captures, then the biggest remaining captures,
/// at most [max] (PLAN §4 battle cap).
Set<int> battlePlies(List<Moment> moments, {int max = replayMaxBattles}) {
  final captures = moments.where((m) => m.isCapture).toList();
  if (captures.isEmpty) return const {};
  int score(Moment m) {
    var s = m.victim!.type.value * 10;
    if (m.kinds.contains(MomentKind.mate)) s += 1000;
    if (m.kinds.contains(MomentKind.sacrifice)) s += 500;
    if (identical(m, captures.first)) s += 300;
    if (m.victim!.type == PieceType.queen) s += 200;
    return s;
  }

  final ranked = [...captures]..sort((a, b) => score(b).compareTo(score(a)));
  return {for (final m in ranked.take(max)) m.ply};
}
