import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';

/// UCI → legal move. Castling may come as king-to-target (`e1g1`) or as
/// king-takes-rook (`e1h1`, what the analysis source sends).
Move? readUci(Position pos, String uci, {Rules rules = const Rules()}) {
  if (uci.length < 4 || uci.length > 5) return null;
  final from = Square.tryParse(uci.substring(0, 2));
  final to = Square.tryParse(uci.substring(2, 4));
  if (from == null || to == null) return null;
  if (uci.length == 5 && !'nbrq'.contains(uci[4])) return null;
  final promo = uci.length == 5 ? PieceType.fromLetter(uci[4]) : null;
  final piece = pos[from];
  for (final m in rules.legalMoves(pos, from: from)) {
    if (m.promotion != promo) continue;
    if (m.to == to) return m;
    if (m.isCastle && piece?.type == PieceType.king && pos[to]?.type == PieceType.rook && pos[to]?.side == piece?.side) {
      final kingside = to.file > from.file;
      if ((m.to.file > from.file) == kingside) return m;
    }
  }
  return null;
}

/// Legal prefix of a UCI line from [pos]: stops at the first illegal move.
List<Move> readUciLine(Position pos, List<String> line, {Rules rules = const Rules()}) {
  final out = <Move>[];
  var p = pos;
  for (final u in line) {
    final m = readUci(p, u, rules: rules);
    if (m == null) break;
    out.add(m);
    p = p.apply(m);
  }
  return out;
}
