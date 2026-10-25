import 'types.dart';

/// Immutable chess position. Unlike the `chess` pub package it accepts any
/// piece set — lessons often have no kings at all (PLAN §2).
class Position {
  Position._(this._board, this.sideToMove, this.castling, this.epSquare, this.halfmove, this.fullmove);

  factory Position.empty({Side sideToMove = Side.white}) =>
      Position._(List.filled(64, null), sideToMove, '', null, 0, 1);

  factory Position.initial() => Position.fromFen(initialFen);

  /// Parses FEN. Only the placement field is required; missing fields
  /// default to `w - - 0 1`.
  factory Position.fromFen(String fen) {
    final parts = fen.trim().split(RegExp(r'\s+'));
    final rows = parts[0].split('/');
    if (rows.length != 8) throw FormatException('FEN needs 8 ranks: "$fen"');
    final board = List<Piece?>.filled(64, null);
    for (var i = 0; i < 8; i++) {
      final rank = 7 - i;
      var file = 0;
      for (final c in rows[i].split('')) {
        final n = int.tryParse(c);
        if (n != null) {
          file += n;
        } else {
          if (file > 7) throw FormatException('Rank ${rank + 1} too long: "$fen"');
          board[Square.at(file, rank).index] = Piece.fromFen(c);
          file++;
        }
      }
      if (file != 8) throw FormatException('Rank ${rank + 1} has $file files: "$fen"');
    }
    final side = parts.length > 1 && parts[1] == 'b' ? Side.black : Side.white;
    final castling = parts.length > 2 && parts[2] != '-' ? parts[2] : '';
    final ep = parts.length > 3 && parts[3] != '-' ? Square.parse(parts[3]) : null;
    final half = parts.length > 4 ? int.parse(parts[4]) : 0;
    final full = parts.length > 5 ? int.parse(parts[5]) : 1;
    return Position._(board, side, castling, ep, half, full);
  }

  static const initialFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  final List<Piece?> _board;
  final Side sideToMove;

  /// Castling rights subset of `KQkq`, empty for none.
  final String castling;
  final Square? epSquare;
  final int halfmove;
  final int fullmove;

  Piece? operator [](Square s) => _board[s.index];

  Iterable<(Square, Piece)> get pieces sync* {
    for (var i = 0; i < 64; i++) {
      final p = _board[i];
      if (p != null) yield (Square(i), p);
    }
  }

  Iterable<(Square, Piece)> piecesOf(Side side) => pieces.where((e) => e.$2.side == side);

  Square? kingOf(Side side) {
    for (final (s, p) in pieces) {
      if (p.side == side && p.type == PieceType.king) return s;
    }
    return null;
  }

  /// Placement-only FEN — a cheap, unique key for search (with side to move).
  String get boardKey => fen.split(' ').take(2).join(' ');

  String get fen {
    final b = StringBuffer();
    for (var rank = 7; rank >= 0; rank--) {
      var empty = 0;
      for (var file = 0; file < 8; file++) {
        final p = _board[Square.at(file, rank).index];
        if (p == null) {
          empty++;
        } else {
          if (empty > 0) b.write(empty);
          empty = 0;
          b.write(p.fen);
        }
      }
      if (empty > 0) b.write(empty);
      if (rank > 0) b.write('/');
    }
    b.write(' ${sideToMove == Side.white ? 'w' : 'b'}');
    b.write(' ${castling.isEmpty ? '-' : castling}');
    b.write(' ${epSquare?.name ?? '-'}');
    b.write(' $halfmove $fullmove');
    return b.toString();
  }

  /// Returns a copy with pieces changed — for lesson setup and editors.
  Position edit({Map<Square, Piece?> set = const {}, Side? sideToMove}) {
    final board = List<Piece?>.of(_board);
    for (final e in set.entries) {
      board[e.key.index] = e.value;
    }
    return Position._(board, sideToMove ?? this.sideToMove, castling, epSquare, halfmove, fullmove);
  }

  /// Applies [m] without any legality check. Handles castling, en passant
  /// and promotion bookkeeping.
  Position apply(Move m) {
    final board = List<Piece?>.of(_board);
    final piece = board[m.from.index]!;
    final captured = board[m.to.index];
    board[m.from.index] = null;
    board[m.to.index] = m.promotion != null ? Piece(piece.side, m.promotion!) : piece;

    if (m.isEnPassant) {
      board[Square.at(m.to.file, m.from.rank).index] = null;
    }
    if (m.isCastle) {
      final rank = m.from.rank;
      final kingSide = m.to.file == 6;
      final rookFrom = Square.at(kingSide ? 7 : 0, rank);
      final rookTo = Square.at(kingSide ? 5 : 3, rank);
      board[rookTo.index] = board[rookFrom.index];
      board[rookFrom.index] = null;
    }

    var castling = this.castling;
    if (castling.isNotEmpty) {
      String strip(String rights, Square s) => switch (s.name) {
        'e1' => rights.replaceAll(RegExp('[KQ]'), ''),
        'e8' => rights.replaceAll(RegExp('[kq]'), ''),
        'h1' => rights.replaceAll('K', ''),
        'a1' => rights.replaceAll('Q', ''),
        'h8' => rights.replaceAll('k', ''),
        'a8' => rights.replaceAll('q', ''),
        _ => rights,
      };
      castling = strip(strip(castling, m.from), m.to);
    }

    Square? ep;
    if (piece.type == PieceType.pawn && (m.to.rank - m.from.rank).abs() == 2) {
      ep = Square.at(m.from.file, (m.from.rank + m.to.rank) ~/ 2);
    }

    final resetsClock = piece.type == PieceType.pawn || captured != null || m.isEnPassant;
    return Position._(
      board,
      sideToMove.opponent,
      castling,
      ep,
      resetsClock ? 0 : halfmove + 1,
      sideToMove == Side.black ? fullmove + 1 : fullmove,
    );
  }

  /// Piece captured by [m] (including en passant), or null.
  Piece? capturedBy(Move m) =>
      m.isEnPassant ? _board[Square.at(m.to.file, m.from.rank).index] : _board[m.to.index];

  /// Same position with the other side to move — lessons where the
  /// opponent "does not move" (`capture_all`) pass the turn back this way.
  Position passTurn() => Position._(_board, sideToMove.opponent, castling, null, halfmove, fullmove);
}
