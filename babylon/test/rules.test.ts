import { describe, expect, it } from 'vitest';

import { INITIAL_FEN, Position } from '../src/rules/position';
import { Rules } from '../src/rules/rules';

const rules = new Rules();

function perft(pos: Position, depth: number): number {
  if (depth === 0) return 1;
  let n = 0;
  for (const m of rules.legalMoves(pos)) n += perft(pos.apply(m), depth - 1);
  return n;
}

describe('Position', () => {
  it('round-trips FEN', () => {
    expect(Position.initial().fen).toBe(INITIAL_FEN);
    const kiwi = 'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1';
    expect(Position.fromFen(kiwi).fen).toBe(kiwi);
  });

  it('defaults missing FEN fields', () => {
    expect(Position.fromFen('8/8/8/8/8/8/8/4K3').fen).toBe('8/8/8/8/8/8/8/4K3 w - - 0 1');
  });
});

// Standard perft counts (chessprogramming.org) cover castling, en passant and promotion.
describe('Rules perft', () => {
  it('initial position', () => {
    expect([1, 2, 3].map((d) => perft(Position.initial(), d))).toEqual([20, 400, 8902]);
  });

  it('kiwipete', () => {
    const p = Position.fromFen('r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
    expect([1, 2].map((d) => perft(p, d))).toEqual([48, 2039]);
  });

  it('position 3 (en passant, pins)', () => {
    const p = Position.fromFen('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1');
    expect([1, 2, 3].map((d) => perft(p, d))).toEqual([14, 191, 2812]);
  });

  it('position 4 (promotions)', () => {
    const p = Position.fromFen('r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1');
    expect([1, 2].map((d) => perft(p, d))).toEqual([6, 264]);
  });
});

describe('Rules status', () => {
  it('detects mate and stalemate', () => {
    expect(rules.status(Position.fromFen('rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3'))).toBe('checkmate');
    expect(rules.status(Position.fromFen('7k/5Q2/6K1/8/8/8/8/8 b - - 0 1'))).toBe('stalemate');
  });

  it('piece_only ignores check and works without kings', () => {
    const lesson = new Rules('pieceOnly');
    expect(lesson.legalMoves(Position.fromFen('8/8/8/8/3R4/8/8/8 w')).length).toBe(14);
  });
});
