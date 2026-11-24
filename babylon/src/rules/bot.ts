// Port of lib/core/engine/bot.dart. Never "spiteful": no traps, no delaying mate.
// The random source is injected: the seeded Lcg (random.ts) makes it repeatable
// and bit-identical to Dart's Bot driven by the same Lcg.
import type { Position } from './position';
import { nextInt } from './random';
import { Rules } from './rules';
import { opponent, rankOf, VALUE, type Move, type Side } from './types';

export type BotLevel = 'baby' | 'puppy' | 'knightess' | 'dragoness';
export const BOT_LEVELS: readonly BotLevel[] = ['baby', 'puppy', 'knightess', 'dragoness'];

export function parseBotLevel(s: string): BotLevel {
  switch (s) {
    case 'baby': case '1': return 'baby';
    case 'puppy': case '2': return 'puppy';
    case 'knightess': case '3': return 'knightess';
    case 'dragoness': case '4': return 'dragoness';
    default: throw new Error(`Unknown bot level "${s}"`);
  }
}

/** Extra terminal condition for mini-games (pawn war: first pawn home wins). */
export type BotGoal = 'material' | 'pawnWar';

const MIN = -(1 << 30);
const MAX = 1 << 30;

export class Bot {
  constructor(
    readonly level: BotLevel,
    private readonly rand: () => number,
    readonly rules: Rules = new Rules(),
    readonly goal: BotGoal = 'material',
  ) {}

  chooseMove(pos: Position): Move | null {
    const moves = this.rules.legalMoves(pos);
    if (moves.length === 0) return null;
    // Promotions: always a queen (kids' games, no underpromotion tricks).
    const candidates = moves.filter((m) => !m.promotion || m.promotion === 'queen');
    switch (this.level) {
      case 'baby':
        return candidates[nextInt(this.rand, candidates.length)];
      case 'puppy': {
        const free = candidates.filter((m) => {
          if (!pos.capturedBy(m)) return false;
          return !this.rules.isAttacked(pos.apply(m), m.to, opponent(pos.sideToMove));
        });
        const pool = free.length > 0 ? free : candidates;
        return pool[nextInt(this.rand, pool.length)];
      }
      case 'knightess': return this.search(pos, candidates, 2, 60);
      case 'dragoness': return this.search(pos, candidates, 3, 20);
    }
  }

  private search(pos: Position, moves: Move[], depth: number, noise: number): Move {
    let best: Move[] = [];
    let bestScore = MIN;
    for (const m of moves) {
      const score = -this.negamax(pos.apply(m), depth - 1, MIN, MAX) + nextInt(this.rand, noise + 1);
      if (score > bestScore) {
        bestScore = score;
        best = [m];
      } else if (score === bestScore) {
        best.push(m);
      }
    }
    return best[nextInt(this.rand, best.length)];
  }

  private negamax(pos: Position, depth: number, alpha: number, beta: number): number {
    const moves = this.rules.legalMoves(pos);
    if (moves.length === 0) return this.rules.status(pos) === 'checkmate' ? -100000 - depth : 0;
    const won = goalScore(this.goal, pos);
    if (won !== null) return won;
    if (depth === 0) return evaluate(pos);
    let a = alpha;
    for (const m of moves) {
      const s = -this.negamax(pos.apply(m), depth - 1, -beta, -a);
      if (s >= beta) return s;
      if (s > a) a = s;
    }
    return a;
  }
}

/** Material (centipawns) from the side to move's view, plus a small pawn-advance bonus. */
export function evaluate(pos: Position): number {
  let score = 0;
  for (const [s, p] of pos.pieces()) {
    let v = VALUE[p.type] * 100;
    if (p.type === 'pawn') v += 6 * (p.side === 'white' ? rankOf(s) - 1 : 6 - rankOf(s));
    score += p.side === pos.sideToMove ? v : -v;
  }
  return score;
}

/** Terminal score from the side to move's view, or null when not over. */
function goalScore(goal: BotGoal, pos: Position): number | null {
  if (goal !== 'pawnWar') return null;
  const winner = pawnWarWinner(pos);
  if (winner === null) return null;
  return winner === pos.sideToMove ? 50000 : -50000;
}

/** Pawn war: a side wins when its pawn reaches the last rank or the rival has no pawns left. */
export function pawnWarWinner(pos: Position): Side | null {
  let white = 0;
  let black = 0;
  for (const [s, p] of pos.pieces()) {
    if (p.side === 'white' && (p.type !== 'pawn' || rankOf(s) === 7)) return 'white';
    if (p.side === 'black' && (p.type !== 'pawn' || rankOf(s) === 0)) return 'black';
    if (p.side === 'white') white++;
    else black++;
  }
  if (white === 0) return 'black';
  if (black === 0) return 'white';
  return null;
}
