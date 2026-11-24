// Port of lib/core/lessons/solver.dart: breadth-first search over the player's
// moves with a passive opponent (lesson lint par, `solution_first_move` hint).
import { isSolvable, LessonTask, type EscapeKind } from './lesson';
import type { Position } from './position';
import { Rules } from './rules';
import { opponent, type Move, type Square } from './types';

interface Node {
  pos: Position;
  stars: Set<Square>;
  promoted: boolean;
  parent: Node | null;
  move: Move | null;
  depth: number;
  key: string;
}

const node = (pos: Position, stars: Set<Square>, promoted: boolean, parent: Node | null, move: Move | null, depth: number): Node => ({
  pos, stars, promoted, parent, move, depth,
  key: `${pos.boardKey}|${[...stars].sort((a, b) => a - b).join(',')}|${promoted}`,
});

function pathOf(n: Node): Move[] {
  const out: Move[] = [];
  for (let c: Node = n; c.parent; c = c.parent) out.push(c.move as Move);
  return out.reverse();
}

export class Solver {
  readonly rules: Rules;

  constructor(readonly task: LessonTask) {
    this.rules = new Rules(task.rules);
  }

  /** Moves allowed in pos — legal and not touching lava. */
  moves(pos: Position): Move[] {
    const lava = this.task.lava.on(pos, this.task.player, this.rules);
    const kind = this.task.escape;
    const all = this.rules
      .legalMoves(pos)
      .filter((m) => !m.promotion || m.promotion === 'queen')
      .filter((m) => kind === null || Solver.escapeKind(pos, m) === kind);
    if (lava.size === 0) return all;
    return all.filter((m) => !Rules.path(m).some((s) => lava.has(s)));
  }

  /** Stars still uncollected after m: a piece picks up every star on its way. */
  static collect(remaining: ReadonlySet<Square>, m: Move): Set<Square> {
    const path = Rules.path(m);
    if (!path.some((s) => remaining.has(s))) return new Set(remaining);
    return new Set([...remaining].filter((s) => !path.includes(s)));
  }

  /** Shortest move list reaching the goal, or null if none within maxDepth. */
  solve(opts: { start?: Position; remaining?: ReadonlySet<Square>; promoted?: boolean; maxDepth?: number } = {}): Move[] | null {
    if (!isSolvable(this.task.goal)) return null;
    const maxDepth = opts.maxDepth ?? 14;
    const root = node(opts.start ?? this.task.position, new Set(opts.remaining ?? this.task.stars), opts.promoted ?? false, null, null, 0);
    if (this.isWon(root.pos, root.stars, root.promoted)) return [];
    const seen = new Set([root.key]);
    const queue: Node[] = [root];
    for (let head = 0; head < queue.length; head++) {
      const n = queue[head];
      if (n.depth >= maxDepth) continue;
      for (const m of this.moves(n.pos)) {
        // Opponent is passive: hand the move straight back to the player.
        const next = n.pos.apply(m).passTurn();
        const child = node(next, Solver.collect(n.stars, m), n.promoted || !!m.promotion, n, m, n.depth + 1);
        if (this.isWon(child.pos, child.stars, child.promoted)) return pathOf(child);
        if (!seen.has(child.key)) {
          seen.add(child.key);
          queue.push(child);
        }
      }
    }
    return null;
  }

  isWon(pos: Position, stars: ReadonlySet<Square>, promoted: boolean): boolean {
    switch (this.task.goal) {
      case 'reach_square': case 'collect_stars': case 'avoid_lava': return stars.size === 0;
      case 'capture_all': return stars.size === 0 && pos.piecesOf(opponent(this.task.player)).length === 0;
      case 'promote': return stars.size === 0 && promoted;
      case 'escape_check': return !this.rules.inCheck(pos, this.task.player);
      default: return false;
    }
  }

  /** Capture (of a checker, even by the king), run (other king moves) or block. */
  static escapeKind(pos: Position, m: Move): EscapeKind {
    const p = pos.at(m.from);
    if (!p) throw new Error('escapeKind: empty from square');
    const king = pos.kingOf(p.side);
    const checkers = king === null ? new Set<Square>() : new Rules('full').attackers(pos, king, opponent(p.side));
    if (checkers.has(m.to)) return 'capture';
    if (m.from === king) return 'run';
    return 'block';
  }

  /** Can any player piece reach target at all (yes/no "is the star reachable")? */
  canReach(target: Square): boolean {
    const t = this.task;
    const probe = new LessonTask({ goal: 'reach_square', rules: t.rules, position: t.position, stars: [target], lava: t.lava });
    return new Solver(probe).solve({ maxDepth: 8 }) !== null;
  }
}
