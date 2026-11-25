import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';

/// A line someone tries from a position of the game: legal moves only,
/// undo, back to the start. Pure; the screen renders it.
class AnalysisLine {
  AnalysisLine(this.start, {this.rules = const Rules()});

  final Position start;
  final Rules rules;
  final List<Move> moves = [];
  final List<Position> _positions = [];

  Position get position => _positions.isEmpty ? start : _positions.last;
  Move? get lastMove => moves.isEmpty ? null : moves.last;
  bool get isEmpty => moves.isEmpty;
  GameStatus get status => rules.status(position);

  List<Move> legalFrom(Square s) => rules.legalMoves(position, from: s);

  /// Plays [from] → [to] when legal (a promotion becomes a queen). Returns the move or null.
  Move? play(Square from, Square to) {
    final options = legalFrom(from).where((m) => m.to == to).toList();
    if (options.isEmpty) return null;
    final m = options.firstWhere((m) => m.promotion == null || m.promotion == PieceType.queen, orElse: () => options.first);
    push(m);
    return m;
  }

  /// Adds a move known to be legal (a played adviser line).
  void push(Move m) {
    final next = position.apply(m);
    moves.add(m);
    _positions.add(next);
  }

  void undo() {
    if (moves.isEmpty) return;
    moves.removeLast();
    _positions.removeLast();
  }

  void reset() {
    moves.clear();
    _positions.clear();
  }

  /// SAN of the line, numbered from [start].
  List<String> sans() {
    final out = <String>[];
    var p = start;
    for (final m in moves) {
      out.add(rules.san(p, m));
      p = p.apply(m);
    }
    return out;
  }
}
