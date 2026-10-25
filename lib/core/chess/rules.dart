import 'position.dart';
import 'types.dart';

/// Which rules a board obeys (PLAN §2: LessonEngine `rules: full | piece_only`).
enum RuleSet {
  /// Real chess: own king may not be left in check, castling allowed.
  /// A side without a king simply has nothing to protect.
  full,

  /// Lesson mode: every piece moves by its pattern, check is ignored and
  /// there is no castling or en passant (taught in module 9). Works with
  /// any piece set.
  pieceOnly;

  static RuleSet parse(String s) => switch (s) {
    'full' => full,
    'piece_only' => pieceOnly,
    _ => throw FormatException('Unknown rules "$s" (full | piece_only)'),
  };
}

enum GameStatus { ongoing, checkmate, stalemate }

const _rookDirs = [(1, 0), (-1, 0), (0, 1), (0, -1)];
const _bishopDirs = [(1, 1), (1, -1), (-1, 1), (-1, -1)];
const _kingDirs = [..._rookDirs, ..._bishopDirs];
const _knightJumps = [(1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)];
const _promotions = [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight];

class Rules {
  const Rules([this.ruleSet = RuleSet.full]);

  final RuleSet ruleSet;

  /// Legal moves for the side to move (optionally only from [from]).
  List<Move> legalMoves(Position pos, {Square? from}) {
    final side = pos.sideToMove;
    final moves = <Move>[];
    for (final (sq, p) in pos.piecesOf(side)) {
      if (from != null && sq != from) continue;
      _pseudoMoves(pos, sq, p, moves);
    }
    if (ruleSet == RuleSet.pieceOnly || pos.kingOf(side) == null) return moves;
    return moves.where((m) => !inCheck(pos.apply(m), side)).toList();
  }

  /// Squares the piece on [from] can move to, ignoring whose turn it is —
  /// for highlighting (the board shows "where can I go" for any of my pieces).
  List<Move> movesFrom(Position pos, Square from) {
    final p = pos[from];
    if (p == null) return const [];
    final asMover = p.side == pos.sideToMove ? pos : pos.passTurn();
    return legalMoves(asMover, from: from);
  }

  bool inCheck(Position pos, Side side) {
    final k = pos.kingOf(side);
    return k != null && isAttacked(pos, k, side.opponent);
  }

  GameStatus status(Position pos) {
    if (legalMoves(pos).isNotEmpty) return GameStatus.ongoing;
    if (ruleSet == RuleSet.full && inCheck(pos, pos.sideToMove)) return GameStatus.checkmate;
    return GameStatus.stalemate;
  }

  /// Is [target] attacked by any piece of [by]? Used for check and for
  /// "lava" squares (LESSONS module 6: where the king may not step).
  bool isAttacked(Position pos, Square target, Side by) {
    // Pawns attack diagonally forward, so look one rank "behind" the target.
    for (final df in const [-1, 1]) {
      final s = target.offset(df, -by.forward);
      if (s != null && pos[s] == Piece(by, PieceType.pawn)) return true;
    }
    for (final (df, dr) in _knightJumps) {
      final s = target.offset(df, dr);
      if (s != null && pos[s] == Piece(by, PieceType.knight)) return true;
    }
    for (final (df, dr) in _kingDirs) {
      final s = target.offset(df, dr);
      if (s != null && pos[s] == Piece(by, PieceType.king)) return true;
    }
    bool slides(List<(int, int)> dirs, Set<PieceType> types) {
      for (final (df, dr) in dirs) {
        var s = target.offset(df, dr);
        while (s != null) {
          final p = pos[s];
          if (p != null) {
            if (p.side == by && types.contains(p.type)) return true;
            break;
          }
          s = s.offset(df, dr);
        }
      }
      return false;
    }

    return slides(_rookDirs, const {PieceType.rook, PieceType.queen}) ||
        slides(_bishopDirs, const {PieceType.bishop, PieceType.queen});
  }

  /// Squares of the [by] pieces attacking [target] ("who threatens the
  /// princess?", "who gives check?" — LESSONS m4 l4, m6 l3).
  Set<Square> attackers(Position pos, Square target, Side by) => {
    for (final (s, p) in pos.piecesOf(by))
      if (_attacks(pos, s, p, target)) s,
  };

  static bool _attacks(Position pos, Square from, Piece p, Square target) {
    final df = target.file - from.file;
    final dr = target.rank - from.rank;
    bool clear() {
      final m = Move(from, target);
      return path(m).takeWhile((s) => s != target).every((s) => pos[s] == null);
    }

    return switch (p.type) {
      PieceType.pawn => dr == p.side.forward && df.abs() == 1,
      PieceType.knight => (df.abs() == 1 && dr.abs() == 2) || (df.abs() == 2 && dr.abs() == 1),
      PieceType.king => (df != 0 || dr != 0) && df.abs() <= 1 && dr.abs() <= 1,
      PieceType.rook => (df == 0) != (dr == 0) && clear(),
      PieceType.bishop => df != 0 && df.abs() == dr.abs() && clear(),
      PieceType.queen => ((df == 0) != (dr == 0) || (df != 0 && df.abs() == dr.abs())) && clear(),
    };
  }

  /// All squares attacked by [by] — the "lava" overlay.
  Set<Square> attackedSquares(Position pos, Side by) =>
      Square.all.where((s) => isAttacked(pos, s, by)).toSet();

  /// Squares a move passes through, excluding `from`, including `to`.
  /// Knights jump, so only `to`. Used by lava (a rook cannot drive across fire).
  static List<Square> path(Move m) {
    final df = (m.to.file - m.from.file).sign;
    final dr = (m.to.rank - m.from.rank).sign;
    final straight = m.from.file == m.to.file || m.from.rank == m.to.rank;
    final diagonal = (m.to.file - m.from.file).abs() == (m.to.rank - m.from.rank).abs();
    if (!straight && !diagonal) return [m.to];
    final out = <Square>[];
    var s = m.from.offset(df, dr);
    while (s != null && s != m.to) {
      out.add(s);
      s = s.offset(df, dr);
    }
    out.add(m.to);
    return out;
  }

  void _pseudoMoves(Position pos, Square from, Piece p, List<Move> out) {
    switch (p.type) {
      case PieceType.pawn:
        _pawnMoves(pos, from, p.side, out);
      case PieceType.knight:
        _steps(pos, from, p.side, _knightJumps, out);
      case PieceType.king:
        _steps(pos, from, p.side, _kingDirs, out);
        if (ruleSet == RuleSet.full) _castles(pos, from, p.side, out);
      case PieceType.bishop:
        _slides(pos, from, p.side, _bishopDirs, out);
      case PieceType.rook:
        _slides(pos, from, p.side, _rookDirs, out);
      case PieceType.queen:
        _slides(pos, from, p.side, _kingDirs, out);
    }
  }

  void _steps(Position pos, Square from, Side side, List<(int, int)> deltas, List<Move> out) {
    for (final (df, dr) in deltas) {
      final to = from.offset(df, dr);
      if (to != null && pos[to]?.side != side) out.add(Move(from, to));
    }
  }

  void _slides(Position pos, Square from, Side side, List<(int, int)> dirs, List<Move> out) {
    for (final (df, dr) in dirs) {
      var to = from.offset(df, dr);
      while (to != null) {
        final occ = pos[to];
        if (occ == null) {
          out.add(Move(from, to));
        } else {
          if (occ.side != side) out.add(Move(from, to));
          break;
        }
        to = to.offset(df, dr);
      }
    }
  }

  void _pawnMoves(Position pos, Square from, Side side, List<Move> out) {
    final fwd = side.forward;
    final lastRank = side == Side.white ? 7 : 0;
    final startRank = side == Side.white ? 1 : 6;

    void add(Square to, {bool ep = false}) {
      if (to.rank == lastRank) {
        for (final t in _promotions) {
          out.add(Move(from, to, promotion: t));
        }
      } else {
        out.add(Move(from, to, isEnPassant: ep));
      }
    }

    final one = from.offset(0, fwd);
    if (one != null && pos[one] == null) {
      add(one);
      final two = from.offset(0, 2 * fwd);
      if (from.rank == startRank && two != null && pos[two] == null) add(two);
    }
    for (final df in const [-1, 1]) {
      final to = from.offset(df, fwd);
      if (to == null) continue;
      final occ = pos[to];
      if (occ != null && occ.side != side) {
        add(to);
      } else if (occ == null && to == pos.epSquare && ruleSet == RuleSet.full) {
        final victim = pos[Square.at(to.file, from.rank)];
        if (victim == Piece(side.opponent, PieceType.pawn)) add(to, ep: true);
      }
    }
  }

  void _castles(Position pos, Square from, Side side, List<Move> out) {
    final rank = side == Side.white ? 0 : 7;
    if (from != Square.at(4, rank)) return;
    final rights = side == Side.white ? pos.castling.replaceAll(RegExp('[kq]'), '') : pos.castling.replaceAll(RegExp('[KQ]'), '');
    if (rights.isEmpty || isAttacked(pos, from, side.opponent)) return;
    final rook = Piece(side, PieceType.rook);

    if (rights.toLowerCase().contains('k') &&
        pos[Square.at(7, rank)] == rook &&
        pos[Square.at(5, rank)] == null &&
        pos[Square.at(6, rank)] == null &&
        !isAttacked(pos, Square.at(5, rank), side.opponent)) {
      out.add(Move(from, Square.at(6, rank), isCastle: true));
    }
    if (rights.toLowerCase().contains('q') &&
        pos[Square.at(0, rank)] == rook &&
        pos[Square.at(1, rank)] == null &&
        pos[Square.at(2, rank)] == null &&
        pos[Square.at(3, rank)] == null &&
        !isAttacked(pos, Square.at(3, rank), side.opponent)) {
      out.add(Move(from, Square.at(2, rank), isCastle: true));
    }
  }

  /// Standard Algebraic Notation for a legal [m] in [pos] (English letters).
  String san(Position pos, Move m) {
    final p = pos[m.from]!;
    String s;
    if (m.isCastle) {
      s = m.to.file == 6 ? 'O-O' : 'O-O-O';
    } else {
      final capture = pos.capturedBy(m) != null;
      if (p.type == PieceType.pawn) {
        s = '${capture ? '${m.from.fileName}x' : ''}${m.to.name}';
        if (m.promotion != null) s += '=${m.promotion!.letter.toUpperCase()}';
      } else {
        final rivals = legalMoves(pos)
            .where((o) => o.to == m.to && o.from != m.from && pos[o.from]?.type == p.type)
            .toList();
        var dis = '';
        if (rivals.isNotEmpty) {
          if (rivals.every((o) => o.from.file != m.from.file)) {
            dis = m.from.fileName;
          } else if (rivals.every((o) => o.from.rank != m.from.rank)) {
            dis = m.from.rankName;
          } else {
            dis = m.from.name;
          }
        }
        s = '${p.type.letter.toUpperCase()}$dis${capture ? 'x' : ''}${m.to.name}';
      }
    }
    final next = pos.apply(m);
    if (inCheck(next, next.sideToMove)) s += status(next) == GameStatus.checkmate ? '#' : '+';
    return s;
  }

  /// Finds the legal move written as SAN (`Nf3`, `exd5`, `O-O`, `e8=Q`).
  Move? parseSan(Position pos, String san) {
    final clean = san.replaceAll(RegExp(r'[+#!?]'), '');
    for (final m in legalMoves(pos)) {
      if (this.san(pos, m).replaceAll(RegExp(r'[+#]'), '') == clean) return m;
    }
    return null;
  }
}
