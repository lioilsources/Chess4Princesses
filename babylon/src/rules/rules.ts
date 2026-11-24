// Port of lib/core/chess/rules.dart (move generation, check, status).
// SAN and attackers()/path() follow in F1 with the golden vectors.
import type { Position } from './position';
import { fileOf, forward, offset, opponent, rankOf, samePiece, sq, type Move, type Piece, type PieceType, type Side, type Square } from './types';

/** full = real chess; pieceOnly = lesson mode (no check, castling, en passant). */
export type RuleSet = 'full' | 'pieceOnly';
export type GameStatus = 'ongoing' | 'checkmate' | 'stalemate';

type Dir = readonly [number, number];
const ROOK: readonly Dir[] = [[1, 0], [-1, 0], [0, 1], [0, -1]];
const BISHOP: readonly Dir[] = [[1, 1], [1, -1], [-1, 1], [-1, -1]];
const KING: readonly Dir[] = [...ROOK, ...BISHOP];
const KNIGHT: readonly Dir[] = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]];
const PROMOTIONS: readonly PieceType[] = ['queen', 'rook', 'bishop', 'knight'];

export class Rules {
  constructor(readonly ruleSet: RuleSet = 'full') {}

  /** Legal moves for the side to move (optionally only from `from`). */
  legalMoves(pos: Position, from?: Square): Move[] {
    const side = pos.sideToMove;
    const moves: Move[] = [];
    for (const [s, p] of pos.piecesOf(side)) {
      if (from !== undefined && s !== from) continue;
      this.pseudoMoves(pos, s, p, moves);
    }
    if (this.ruleSet === 'pieceOnly' || pos.kingOf(side) === null) return moves;
    return moves.filter((m) => !this.inCheck(pos.apply(m), side));
  }

  /** Squares the piece on `from` can move to, whoever's turn it is (highlighting). */
  movesFrom(pos: Position, from: Square): Move[] {
    const p = pos.at(from);
    if (!p) return [];
    return this.legalMoves(p.side === pos.sideToMove ? pos : pos.passTurn(), from);
  }

  inCheck(pos: Position, side: Side): boolean {
    const k = pos.kingOf(side);
    return k !== null && this.isAttacked(pos, k, opponent(side));
  }

  status(pos: Position): GameStatus {
    if (this.legalMoves(pos).length > 0) return 'ongoing';
    if (this.ruleSet === 'full' && this.inCheck(pos, pos.sideToMove)) return 'checkmate';
    return 'stalemate';
  }

  /** Is target attacked by any piece of `by`? (check, "lava" squares) */
  isAttacked(pos: Position, target: Square, by: Side): boolean {
    for (const df of [-1, 1]) {
      const s = offset(target, df, -forward(by));
      if (s !== null && samePiece(pos.at(s), { side: by, type: 'pawn' })) return true;
    }
    for (const [df, dr] of KNIGHT) {
      const s = offset(target, df, dr);
      if (s !== null && samePiece(pos.at(s), { side: by, type: 'knight' })) return true;
    }
    for (const [df, dr] of KING) {
      const s = offset(target, df, dr);
      if (s !== null && samePiece(pos.at(s), { side: by, type: 'king' })) return true;
    }
    const slides = (dirs: readonly Dir[], types: readonly PieceType[]): boolean => {
      for (const [df, dr] of dirs) {
        let s = offset(target, df, dr);
        while (s !== null) {
          const p = pos.at(s);
          if (p) {
            if (p.side === by && types.includes(p.type)) return true;
            break;
          }
          s = offset(s, df, dr);
        }
      }
      return false;
    };
    return slides(ROOK, ['rook', 'queen']) || slides(BISHOP, ['bishop', 'queen']);
  }

  private pseudoMoves(pos: Position, from: Square, p: Piece, out: Move[]): void {
    switch (p.type) {
      case 'pawn': this.pawnMoves(pos, from, p.side, out); break;
      case 'knight': this.steps(pos, from, p.side, KNIGHT, out); break;
      case 'king':
        this.steps(pos, from, p.side, KING, out);
        if (this.ruleSet === 'full') this.castles(pos, from, p.side, out);
        break;
      case 'bishop': this.slides(pos, from, p.side, BISHOP, out); break;
      case 'rook': this.slides(pos, from, p.side, ROOK, out); break;
      case 'queen': this.slides(pos, from, p.side, KING, out); break;
    }
  }

  private steps(pos: Position, from: Square, side: Side, deltas: readonly Dir[], out: Move[]): void {
    for (const [df, dr] of deltas) {
      const to = offset(from, df, dr);
      if (to !== null && pos.at(to)?.side !== side) out.push({ from, to });
    }
  }

  private slides(pos: Position, from: Square, side: Side, dirs: readonly Dir[], out: Move[]): void {
    for (const [df, dr] of dirs) {
      let to = offset(from, df, dr);
      while (to !== null) {
        const occ = pos.at(to);
        if (!occ) {
          out.push({ from, to });
        } else {
          if (occ.side !== side) out.push({ from, to });
          break;
        }
        to = offset(to, df, dr);
      }
    }
  }

  private pawnMoves(pos: Position, from: Square, side: Side, out: Move[]): void {
    const fwd = forward(side);
    const lastRank = side === 'white' ? 7 : 0;
    const startRank = side === 'white' ? 1 : 6;
    const add = (to: Square, ep = false): void => {
      if (rankOf(to) === lastRank) for (const t of PROMOTIONS) out.push({ from, to, promotion: t });
      else out.push(ep ? { from, to, isEnPassant: true } : { from, to });
    };
    const one = offset(from, 0, fwd);
    if (one !== null && !pos.at(one)) {
      add(one);
      const two = offset(from, 0, 2 * fwd);
      if (rankOf(from) === startRank && two !== null && !pos.at(two)) add(two);
    }
    for (const df of [-1, 1]) {
      const to = offset(from, df, fwd);
      if (to === null) continue;
      const occ = pos.at(to);
      if (occ && occ.side !== side) {
        add(to);
      } else if (!occ && to === pos.epSquare && this.ruleSet === 'full') {
        if (samePiece(pos.at(sq(fileOf(to), rankOf(from))), { side: opponent(side), type: 'pawn' })) add(to, true);
      }
    }
  }

  private castles(pos: Position, from: Square, side: Side, out: Move[]): void {
    const rank = side === 'white' ? 0 : 7;
    if (from !== sq(4, rank)) return;
    const rights = side === 'white' ? pos.castling.replace(/[kq]/g, '') : pos.castling.replace(/[KQ]/g, '');
    const them = opponent(side);
    if (!rights || this.isAttacked(pos, from, them)) return;
    const rook: Piece = { side, type: 'rook' };
    const empty = (f: number): boolean => !pos.at(sq(f, rank));
    const lower = rights.toLowerCase();
    if (lower.includes('k') && samePiece(pos.at(sq(7, rank)), rook) && empty(5) && empty(6) && !this.isAttacked(pos, sq(5, rank), them)) {
      out.push({ from, to: sq(6, rank), isCastle: true });
    }
    if (lower.includes('q') && samePiece(pos.at(sq(0, rank)), rook) && empty(1) && empty(2) && empty(3) && !this.isAttacked(pos, sq(3, rank), them)) {
      out.push({ from, to: sq(2, rank), isCastle: true });
    }
  }
}
