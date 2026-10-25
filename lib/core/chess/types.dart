/// Basic chess types. Pure Dart — no Flutter import, so `tool/` scripts can
/// use the rules too.
library;

enum Side {
  white,
  black;

  Side get opponent => this == white ? black : white;

  /// Direction pawns of this side move in (rank delta).
  int get forward => this == white ? 1 : -1;
}

enum PieceType {
  pawn('p', 1),
  knight('n', 3),
  bishop('b', 3),
  rook('r', 5),
  queen('q', 9),
  king('k', 0);

  const PieceType(this.letter, this.value);

  /// Lowercase FEN letter.
  final String letter;

  /// Material value in "apples" (LESSONS module 7). King has no price.
  final int value;

  static PieceType fromLetter(String l) =>
      values.firstWhere((t) => t.letter == l.toLowerCase(), orElse: () => throw FormatException('Unknown piece letter "$l"'));
}

class Piece {
  const Piece(this.side, this.type);

  factory Piece.fromFen(String c) => Piece(c == c.toUpperCase() ? Side.white : Side.black, PieceType.fromLetter(c));

  final Side side;
  final PieceType type;

  String get fen => side == Side.white ? type.letter.toUpperCase() : type.letter;

  @override
  bool operator ==(Object other) => other is Piece && other.side == side && other.type == type;

  @override
  int get hashCode => side.index * 8 + type.index;

  @override
  String toString() => fen;
}

/// Board square 0..63, `index = rank * 8 + file`, a1 = 0, h8 = 63.
extension type const Square(int index) {
  factory Square.at(int file, int rank) => Square(rank * 8 + file);

  factory Square.parse(String name) {
    final s = tryParse(name);
    if (s == null) throw FormatException('Invalid square "$name"');
    return s;
  }

  static Square? tryParse(String name) {
    if (name.length != 2) return null;
    final f = name.codeUnitAt(0) - 0x61;
    final r = name.codeUnitAt(1) - 0x31;
    if (f < 0 || f > 7 || r < 0 || r > 7) return null;
    return Square.at(f, r);
  }

  static Iterable<Square> get all => Iterable.generate(64, Square.new);

  int get file => index & 7;
  int get rank => index >> 3;

  /// Light squares: h1 is light ("bílá vpravo dole").
  bool get isLight => (file + rank).isOdd;

  String get fileName => String.fromCharCode(0x61 + file);
  String get rankName => '${rank + 1}';
  String get name => '$fileName$rankName';

  /// Square shifted by (df, dr) or null when it falls off the board.
  Square? offset(int df, int dr) {
    final f = file + df, r = rank + dr;
    if (f < 0 || f > 7 || r < 0 || r > 7) return null;
    return Square.at(f, r);
  }
}

class Move {
  const Move(this.from, this.to, {this.promotion, this.isCastle = false, this.isEnPassant = false});

  final Square from;
  final Square to;
  final PieceType? promotion;
  final bool isCastle;
  final bool isEnPassant;

  /// UCI-style notation, e.g. `e2e4`, `e7e8q`.
  String get uci => '${from.name}${to.name}${promotion?.letter ?? ''}';

  @override
  bool operator ==(Object other) =>
      other is Move && other.from == from && other.to == to && other.promotion == promotion;

  @override
  int get hashCode => Object.hash(from, to, promotion);

  @override
  String toString() => uci;
}
