// Port of lib/core/chess/position.dart: immutable position that accepts any
// piece set (lessons often have no kings at all).
import { fileOf, opponent, parseSquare, pieceFen, pieceFromFen, rankOf, sq, squareName, type Move, type Piece, type Side, type Square } from './types';

export const INITIAL_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

export class Position {
  private constructor(
    private readonly board: readonly (Piece | null)[],
    readonly sideToMove: Side,
    /** Castling rights subset of `KQkq`, empty for none. */
    readonly castling: string,
    readonly epSquare: Square | null,
    readonly halfmove: number,
    readonly fullmove: number,
  ) {}

  static empty(sideToMove: Side = 'white'): Position {
    return new Position(new Array<Piece | null>(64).fill(null), sideToMove, '', null, 0, 1);
  }

  static initial(): Position { return Position.fromFen(INITIAL_FEN); }

  /** Only the placement field is required; missing fields default to `w - - 0 1`. */
  static fromFen(fen: string): Position {
    const parts = fen.trim().split(/\s+/);
    const rows = parts[0].split('/');
    if (rows.length !== 8) throw new Error(`FEN needs 8 ranks: "${fen}"`);
    const board = new Array<Piece | null>(64).fill(null);
    for (let i = 0; i < 8; i++) {
      const rank = 7 - i;
      let file = 0;
      for (const c of rows[i]) {
        if (/\d/.test(c)) {
          file += Number(c);
        } else {
          if (file > 7) throw new Error(`Rank ${rank + 1} too long: "${fen}"`);
          board[sq(file, rank)] = pieceFromFen(c);
          file++;
        }
      }
      if (file !== 8) throw new Error(`Rank ${rank + 1} has ${file} files: "${fen}"`);
    }
    const side: Side = parts.length > 1 && parts[1] === 'b' ? 'black' : 'white';
    const castling = parts.length > 2 && parts[2] !== '-' ? parts[2] : '';
    const ep = parts.length > 3 && parts[3] !== '-' ? parseSquare(parts[3]) : null;
    const half = parts.length > 4 ? Number.parseInt(parts[4], 10) : 0;
    const full = parts.length > 5 ? Number.parseInt(parts[5], 10) : 1;
    return new Position(board, side, castling, ep, half, full);
  }

  at(s: Square): Piece | null { return this.board[s]; }

  *pieces(): Generator<[Square, Piece]> {
    for (let i = 0; i < 64; i++) {
      const p = this.board[i];
      if (p) yield [i, p];
    }
  }

  piecesOf(side: Side): [Square, Piece][] {
    return [...this.pieces()].filter(([, p]) => p.side === side);
  }

  kingOf(side: Side): Square | null {
    for (const [s, p] of this.pieces()) if (p.side === side && p.type === 'king') return s;
    return null;
  }

  get fen(): string {
    let b = '';
    for (let rank = 7; rank >= 0; rank--) {
      let empty = 0;
      for (let file = 0; file < 8; file++) {
        const p = this.board[sq(file, rank)];
        if (!p) {
          empty++;
        } else {
          if (empty > 0) b += String(empty);
          empty = 0;
          b += pieceFen(p);
        }
      }
      if (empty > 0) b += String(empty);
      if (rank > 0) b += '/';
    }
    b += ` ${this.sideToMove === 'white' ? 'w' : 'b'}`;
    b += ` ${this.castling || '-'}`;
    b += ` ${this.epSquare === null ? '-' : squareName(this.epSquare)}`;
    b += ` ${this.halfmove} ${this.fullmove}`;
    return b;
  }

  /** Placement + side to move — a cheap, unique key for search. */
  get boardKey(): string { return this.fen.split(' ').slice(0, 2).join(' '); }

  /** Copy with pieces changed — for lesson setup and editors. */
  edit(set: ReadonlyMap<Square, Piece | null>, sideToMove?: Side): Position {
    const board = [...this.board];
    for (const [s, p] of set) board[s] = p;
    return new Position(board, sideToMove ?? this.sideToMove, this.castling, this.epSquare, this.halfmove, this.fullmove);
  }

  /** Applies m without any legality check (castling, en passant, promotion bookkeeping). */
  apply(m: Move): Position {
    const board = [...this.board];
    const piece = board[m.from];
    if (!piece) throw new Error(`No piece on ${squareName(m.from)}`);
    const captured = board[m.to];
    board[m.from] = null;
    board[m.to] = m.promotion ? { side: piece.side, type: m.promotion } : piece;

    if (m.isEnPassant) board[sq(fileOf(m.to), rankOf(m.from))] = null;
    if (m.isCastle) {
      const rank = rankOf(m.from);
      const kingSide = fileOf(m.to) === 6;
      const rookFrom = sq(kingSide ? 7 : 0, rank);
      const rookTo = sq(kingSide ? 5 : 3, rank);
      board[rookTo] = board[rookFrom];
      board[rookFrom] = null;
    }

    let castling = this.castling;
    if (castling) {
      const strip = (rights: string, s: Square): string => {
        switch (squareName(s)) {
          case 'e1': return rights.replace(/[KQ]/g, '');
          case 'e8': return rights.replace(/[kq]/g, '');
          case 'h1': return rights.replaceAll('K', '');
          case 'a1': return rights.replaceAll('Q', '');
          case 'h8': return rights.replaceAll('k', '');
          case 'a8': return rights.replaceAll('q', '');
          default: return rights;
        }
      };
      castling = strip(strip(castling, m.from), m.to);
    }

    let ep: Square | null = null;
    if (piece.type === 'pawn' && Math.abs(rankOf(m.to) - rankOf(m.from)) === 2) {
      ep = sq(fileOf(m.from), (rankOf(m.from) + rankOf(m.to)) >> 1);
    }

    const resetsClock = piece.type === 'pawn' || captured !== null || !!m.isEnPassant;
    return new Position(
      board,
      opponent(this.sideToMove),
      castling,
      ep,
      resetsClock ? 0 : this.halfmove + 1,
      this.sideToMove === 'black' ? this.fullmove + 1 : this.fullmove,
    );
  }

  /** Piece captured by m (including en passant), or null. */
  capturedBy(m: Move): Piece | null {
    return m.isEnPassant ? this.board[sq(fileOf(m.to), rankOf(m.from))] : this.board[m.to];
  }

  /** Same position with the other side to move (`capture_all` lessons). */
  passTurn(): Position {
    return new Position(this.board, opponent(this.sideToMove), this.castling, null, this.halfmove, this.fullmove);
  }
}
