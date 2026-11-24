// Port of lib/core/lessons/lesson_engine.dart: runtime state of a lesson task.
// Pure; the game layer wraps it like the Flutter LessonController.
import { Bot, pawnWarWinner } from './bot';
import { isMoveGoal, isSolvable, type HintKind, type Lesson, type LessonTask } from './lesson';
import type { Position } from './position';
import { Rules } from './rules';
import { Solver } from './solver';
import { opponent, parseSquare, rankOf, samePiece, squareName, tryParseSquare, type Move, type Piece, type Side, type Square } from './types';

export type MoveVerdict = 'ok' | 'illegal' | 'lava' | 'notYours';
export type TaskState = 'playing' | 'won' | 'lost';

/** Result of one applied move, for the UI (battle, sparkles, promotion). */
export interface MoveEvent {
  move: Move;
  mover: Piece;
  captured: Piece | null;
  starCollected: boolean;
}

export class TaskSession {
  readonly rules: Rules;
  private readonly bot: Bot;

  position!: Position;
  starsLeft!: Set<Square>;
  tapped!: Set<Square>;
  tapIndex = 0;
  promoted = false;
  moves = 0;
  state: TaskState = 'playing';
  /** Mistakes so far; drives hints and stars. Survives reset. */
  fails = 0;

  /** rand feeds the pawn-war bot unless a bot is given. */
  constructor(readonly task: LessonTask, rand: () => number, bot?: Bot) {
    this.rules = new Rules(task.rules);
    this.bot = bot ?? new Bot(task.bot, rand, new Rules(task.rules), 'pawnWar');
    this.reset();
  }

  /** Restarts the board (after a lost pawn war); fails are kept. */
  reset(): void {
    this.position = this.task.position;
    this.starsLeft = new Set(this.task.stars);
    this.tapped = new Set();
    this.tapIndex = 0;
    this.promoted = false;
    this.moves = 0;
    this.state = 'playing';
  }

  get player(): Side { return this.task.player; }
  get playersTurn(): boolean { return this.position.sideToMove === this.player && this.state === 'playing'; }
  get lava(): Set<Square> { return this.task.lava.on(this.position, this.player, this.rules); }

  // ---- moving ----

  movesFrom(from: Square): Move[] {
    const p = this.position.at(from);
    if (!p || p.side !== this.player) return [];
    return this.rules.movesFrom(this.position, from);
  }

  /** Destinations that are both legal and lava-free. */
  safeTargets(from: Square): Set<Square> {
    const l = this.lava;
    const out = new Set<Square>();
    for (const m of this.movesFrom(from)) if (!Rules.path(m).some((s) => l.has(s))) out.add(m.to);
    return out;
  }

  /** from→to as a move; pawns promote to a queen (the "princess"). */
  resolve(from: Square, to: Square): Move | null {
    const options = this.movesFrom(from).filter((m) => m.to === to);
    if (options.length === 0) return null;
    const m = options.find((o) => !o.promotion || o.promotion === 'queen');
    if (!m) throw new Error('Bad state: no element');
    return m;
  }

  check(from: Square, to: Square): MoveVerdict {
    if (!isMoveGoal(this.task.goal) || !this.playersTurn || this.position.at(from)?.side !== this.player) return 'notYours';
    const m = this.resolve(from, to);
    if (!m) return 'illegal';
    const lava = this.lava;
    if (Rules.path(m).some((s) => lava.has(s))) return 'lava';
    // "Run away with the king" means the king: other legal escapes are wrong here.
    if (this.task.escape !== null && Solver.escapeKind(this.position, m) !== this.task.escape) return 'illegal';
    return 'ok';
  }

  fail(): void { this.fails++; }

  /** Applies a checked player move. The opponent then passes, except in pawn war. */
  play(from: Square, to: Square): MoveEvent {
    const m = this.resolve(from, to);
    if (!m) throw new Error('play: unchecked move');
    const ev = this.apply(m);
    this.moves++;
    if (this.task.goal !== 'pawn_war' && this.state === 'playing') this.position = this.position.passTurn();
    return ev;
  }

  /** The pawn-war opponent's reply (null if it has no move). */
  botMove(): Move | null {
    return this.state === 'playing' && !this.playersTurn ? this.bot.chooseMove(this.position) : null;
  }

  playBot(m: Move): MoveEvent { return this.apply(m); }

  private apply(m: Move): MoveEvent {
    const mover = this.position.at(m.from);
    if (!mover) throw new Error('apply: empty from square');
    const captured = this.position.capturedBy(m);
    const before = this.starsLeft.size;
    this.position = this.position.apply(m);
    if (mover.side === this.player) {
      this.starsLeft = Solver.collect(this.starsLeft, m);
      if (m.promotion) this.promoted = true;
    }
    this.evaluate();
    return { move: m, mover, captured, starCollected: this.starsLeft.size < before };
  }

  private evaluate(): void {
    if (this.task.goal === 'pawn_war') {
      const w = pawnWarWinner(this.position);
      if (w !== null) this.state = w === this.player ? 'won' : 'lost';
      else if (this.rules.legalMoves(this.position).length === 0) this.state = 'lost'; // blocked: play again
      return;
    }
    if (new Solver(this.task).isWon(this.position, this.starsLeft, this.promoted)) this.state = 'won';
  }

  // ---- tapping ----

  /** Current tap_square target (`e`, `4` or `e4`). */
  get currentTarget(): string | null {
    return this.task.goal === 'tap_square' && this.tapIndex < this.task.targets.length ? this.task.targets[this.tapIndex] : null;
  }

  get tapTargets(): Set<Square> {
    const t = this.task;
    switch (t.goal) {
      case 'tap_square': {
        const c = this.currentTarget;
        return c === null ? new Set() : TaskSession.squaresFor(c);
      }
      case 'tap_all': {
        if (t.targets.length === 1 && t.targets[0] === 'moves') {
          // Pawns around the piece are scenery ("he jumps over friends").
          const out = new Set<Square>();
          for (const [s, p] of t.position.piecesOf(this.player)) {
            if (p.type !== 'pawn') for (const m of this.rules.movesFrom(t.position, s)) out.add(m.to);
          }
          return out;
        }
        return new Set(t.targets.map(parseSquare));
      }
      case 'tap_attackers': {
        const s = this.threatened;
        return s === null ? new Set() : this.rules.attackers(t.position, s, opponent(this.player));
      }
      default: return new Set();
    }
  }

  /** tap_attackers: `targets: [sq]`, else my king, else my queen. */
  get threatened(): Square | null {
    const t = this.task;
    if (t.targets.length > 0) return tryParseSquare(t.targets[0]);
    const king = t.position.kingOf(this.player);
    if (king !== null) return king;
    const queen = t.position.piecesOf(this.player).find(([, p]) => p.type === 'queen');
    return queen ? queen[0] : null;
  }

  /** Squares matching a target label: a whole street, a house row or one room. */
  static squaresFor(target: string): Set<Square> {
    const out = new Set<Square>();
    if (/^[a-h]$/.test(target)) {
      for (let s = 0; s < 64; s++) if (squareName(s)[0] === target) out.add(s);
      return out;
    }
    if (/^[1-8]$/.test(target)) {
      for (let s = 0; s < 64; s++) if (rankOf(s) + 1 === Number(target)) out.add(s);
      return out;
    }
    return new Set([parseSquare(target)]);
  }

  /** True when the tap was right. */
  tap(s: Square): boolean {
    if (this.state !== 'playing') return false;
    switch (this.task.goal) {
      case 'tap_square':
        if (!this.tapTargets.has(s)) return this.wrong();
        this.tapIndex++;
        if (this.tapIndex >= this.task.targets.length) this.state = 'won';
        return true;
      case 'tap_all':
      case 'tap_attackers': {
        const targets = this.tapTargets;
        if (!targets.has(s)) return this.wrong();
        this.tapped.add(s);
        if ([...targets].every((x) => this.tapped.has(x))) this.state = 'won';
        return true;
      }
      default:
        return false;
    }
  }

  private wrong(): boolean {
    this.fail();
    return false;
  }

  // ---- setup ----

  /** Pieces still to be placed for setup_pieces (target minus board). */
  get tray(): Piece[] {
    const target = this.task.targetPosition;
    if (!target) return [];
    return [...target.pieces()].filter(([s, p]) => !samePiece(this.position.at(s), p)).map(([, p]) => p);
  }

  /** Drops a tray piece on s; true when it belongs there. */
  drop(piece: Piece, s: Square): boolean {
    const target = this.task.targetPosition;
    if (!target || this.state !== 'playing') return false;
    if (!samePiece(target.at(s), piece) || samePiece(this.position.at(s), piece)) return this.wrong();
    this.position = this.position.edit(new Map([[s, piece]]));
    if (this.tray.length === 0) this.state = 'won';
    return true;
  }

  // ---- yes / no ----

  answer(yes: boolean): boolean {
    if (this.state !== 'playing') return false;
    if (yes !== this.task.answer) return this.wrong();
    this.state = 'won';
    return true;
  }

  // ---- hints & stars ----

  /** The strongest hint unlocked by the fail count, if any. */
  get activeHint(): HintKind | null {
    let h: HintKind | null = null;
    for (const hint of this.task.hints) if (this.fails >= hint.afterFails) h = hint.kind;
    return h;
  }

  get usedHint(): boolean { return this.activeHint !== null; }

  /** First move of a shortest solution from the current state. */
  solutionFirstMove(): Move | null {
    if (!isSolvable(this.task.goal)) return null;
    const path = new Solver(this.task).solve({ start: this.position, remaining: this.starsLeft, promoted: this.promoted });
    return path === null || path.length === 0 ? null : path[0];
  }

  /** 3 = no hint, no mistake, within par; 2 = few mistakes; 1 = finished. */
  get starsEarned(): number {
    const withinPar = this.task.maxMoves === null || this.moves <= this.task.maxMoves;
    if (this.fails === 0 && !this.usedHint && withinPar) return 3;
    if (this.fails <= 2) return 2;
    return 1;
  }
}

/** A whole lesson: tasks one after another. */
export class LessonSession {
  taskIndex = 0;
  current: TaskSession;
  private readonly taskStars: number[] = [];

  constructor(readonly lesson: Lesson, private readonly rand: () => number) {
    this.current = new TaskSession(lesson.tasks[0], rand);
  }

  get isLastTask(): boolean { return this.taskIndex >= this.lesson.tasks.length - 1; }
  get isFinished(): boolean { return this.taskStars.length === this.lesson.tasks.length; }

  /** Call once the current task is won; moves to the next one. */
  nextTask(): void {
    this.taskStars.push(this.current.starsEarned);
    if (!this.isLastTask) {
      this.taskIndex++;
      this.current = new TaskSession(this.lesson.tasks[this.taskIndex], this.rand);
    }
  }

  /** Rounded average over tasks, clamped to 1..3. */
  get stars(): number {
    if (this.taskStars.length === 0) return 0;
    const avg = this.taskStars.reduce((a, b) => a + b, 0) / this.taskStars.length;
    return Math.min(3, Math.max(1, dartRound(avg)));
  }
}

/** Dart's double.round(): half away from zero (Math.round rounds half up). */
export const dartRound = (x: number): number => Math.sign(x) * Math.round(Math.abs(x));
