import '../../core/chess/types.dart';

/// Placeholder art until the ComfyUI sprites exist (PLAN M0): the filled
/// chess glyph, coloured by army. U+FE0E keeps ♟ from turning into an emoji.
String pieceGlyph(PieceType t) => switch (t) {
  PieceType.king => '♚',
  PieceType.queen => '♛',
  PieceType.rook => '♜',
  PieceType.bishop => '♝',
  PieceType.knight => '♞',
  PieceType.pawn => '♟︎',
};
