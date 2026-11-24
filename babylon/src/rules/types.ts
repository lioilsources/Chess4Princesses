// Port of lib/core/chess/types.dart. Squares are plain numbers 0..63,
// index = rank * 8 + file, a1 = 0, h8 = 63.

export type Side = 'white' | 'black';
export const opponent = (s: Side): Side => (s === 'white' ? 'black' : 'white');
/** Direction pawns of this side move in (rank delta). */
export const forward = (s: Side): number => (s === 'white' ? 1 : -1);

export type PieceType = 'pawn' | 'knight' | 'bishop' | 'rook' | 'queen' | 'king';
export const PIECE_TYPES: readonly PieceType[] = ['pawn', 'knight', 'bishop', 'rook', 'queen', 'king'];
const LETTERS: Record<PieceType, string> = { pawn: 'p', knight: 'n', bishop: 'b', rook: 'r', queen: 'q', king: 'k' };
/** Material value in "apples" (LESSONS module 7). King has no price. */
export const VALUE: Record<PieceType, number> = { pawn: 1, knight: 3, bishop: 3, rook: 5, queen: 9, king: 0 };

export const letterOf = (t: PieceType): string => LETTERS[t];
export function typeFromLetter(l: string): PieceType {
  const t = PIECE_TYPES.find((x) => LETTERS[x] === l.toLowerCase());
  if (!t) throw new Error(`Unknown piece letter "${l}"`);
  return t;
}

export interface Piece { readonly side: Side; readonly type: PieceType }
export const pieceFromFen = (c: string): Piece => ({ side: c === c.toUpperCase() ? 'white' : 'black', type: typeFromLetter(c) });
export const pieceFen = (p: Piece): string => (p.side === 'white' ? LETTERS[p.type].toUpperCase() : LETTERS[p.type]);
export const samePiece = (a: Piece | null | undefined, b: Piece): boolean => !!a && a.side === b.side && a.type === b.type;

export type Square = number;
export const sq = (file: number, rank: number): Square => rank * 8 + file;
export const fileOf = (s: Square): number => s & 7;
export const rankOf = (s: Square): number => s >> 3;
/** Light squares: h1 is light ("bílá vpravo dole"). */
export const isLight = (s: Square): boolean => (fileOf(s) + rankOf(s)) % 2 === 1;
export const squareName = (s: Square): string => String.fromCharCode(0x61 + fileOf(s)) + String(rankOf(s) + 1);
export function tryParseSquare(name: string): Square | null {
  if (name.length !== 2) return null;
  const f = name.charCodeAt(0) - 0x61;
  const r = name.charCodeAt(1) - 0x31;
  if (f < 0 || f > 7 || r < 0 || r > 7) return null;
  return sq(f, r);
}
export function parseSquare(name: string): Square {
  const s = tryParseSquare(name);
  if (s === null) throw new Error(`Invalid square "${name}"`);
  return s;
}
/** Square shifted by (df, dr) or null when it falls off the board. */
export function offset(s: Square, df: number, dr: number): Square | null {
  const f = fileOf(s) + df;
  const r = rankOf(s) + dr;
  if (f < 0 || f > 7 || r < 0 || r > 7) return null;
  return sq(f, r);
}

export interface Move {
  readonly from: Square;
  readonly to: Square;
  readonly promotion?: PieceType;
  readonly isCastle?: boolean;
  readonly isEnPassant?: boolean;
}
/** UCI-style notation, e.g. `e2e4`, `e7e8q`. */
export const uci = (m: Move): string => squareName(m.from) + squareName(m.to) + (m.promotion ? LETTERS[m.promotion] : '');
