import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';

final _san = RegExp(r'^([NBRQK])?([a-h])?([1-8])?(x)?([a-h][1-8])(?:=?([NBRQ]))?$');

/// Fast SAN → move. `Rules.parseSan` writes SAN for every legal move and
/// compares; this one filters the legal moves by piece, target and
/// disambiguation, so long games and big archives lint quickly.
/// Accepts `O-O` / `0-0`, `e8=Q` / `e8Q`, check and annotation suffixes.
Move? readSan(Position pos, String san, {Rules rules = const Rules()}) {
  final clean = san.replaceAll(RegExp(r'[+#!?]+$'), '').replaceAll('0', 'O');
  final moves = rules.legalMoves(pos);
  if (clean == 'O-O' || clean == 'O-O-O') {
    final file = clean == 'O-O' ? 6 : 2;
    for (final m in moves) {
      if (m.isCastle && m.to.file == file) return m;
    }
    return null;
  }
  final mt = _san.firstMatch(clean);
  if (mt == null) return null;
  final type = mt.group(1) == null ? PieceType.pawn : PieceType.fromLetter(mt.group(1)!);
  final fromFile = mt.group(2) == null ? null : mt.group(2)!.codeUnitAt(0) - 0x61;
  final fromRank = mt.group(3) == null ? null : int.parse(mt.group(3)!) - 1;
  final to = Square.parse(mt.group(5)!);
  final promo = mt.group(6) == null ? null : PieceType.fromLetter(mt.group(6)!);

  Move? found;
  for (final m in moves) {
    if (m.to != to || m.isCastle) continue;
    if (pos[m.from]!.type != type) continue;
    if (fromFile != null && m.from.file != fromFile) continue;
    if (fromRank != null && m.from.rank != fromRank) continue;
    if (m.promotion != promo) continue;
    if (found != null) return null; // ambiguous
    found = m;
  }
  return found;
}
