// Port of lib/core/lessons/lesson.dart. Lessons arrive as JSON converted from the
// YAML files by scripts/gen-lessons.ts (same shape as the YAML), so parsing mirrors
// the Dart `fromYaml` key by key.
import { parseBotLevel, type BotLevel } from './bot';
import { ContentCatalog } from './content-catalog';
import { Position } from './position';
import { parseRuleSet, type Rules, type RuleSet } from './rules';
import { opponent, parseSquare, type Side, type Square } from './types';

type Json = unknown;
type Obj = Record<string, Json>;

const str = (v: Json): string => (typeof v === 'string' ? v : String(v));

/** Text in several languages, `{cs: …, en: …}`. A bare string is Czech. */
export class LocalizedText {
  constructor(readonly values: Readonly<Record<string, string>>) {}

  static parse(y: Json): LocalizedText {
    if (y === null || y === undefined) return new LocalizedText({});
    if (typeof y === 'string') return new LocalizedText({ cs: y });
    if (typeof y === 'object' && !Array.isArray(y)) {
      return new LocalizedText(Object.fromEntries(Object.entries(y as Obj).map(([k, v]) => [k, str(v)])));
    }
    throw new Error(`Expected text or {cs:, en:} map, got ${JSON.stringify(y)}`);
  }

  get isEmpty(): boolean { return Object.keys(this.values).length === 0; }

  /** Requested language (inline, then catalog), English for all but Czech, then Czech, then anything. */
  of(lang: string): string {
    const v = this.values;
    return v[lang]
      ?? ContentCatalog.lookup(lang, v.cs)
      ?? (lang === 'cs' ? undefined : v.en)
      ?? v.cs
      ?? (Object.values(v)[0] ?? '');
  }
}

export type GoalType =
  | 'tap_square' | 'tap_all' | 'setup_pieces' | 'reach_square' | 'collect_stars' | 'avoid_lava'
  | 'capture_all' | 'promote' | 'pawn_war' | 'yes_no' | 'tap_attackers' | 'escape_check';
const GOALS: readonly GoalType[] = [
  'tap_square', 'tap_all', 'setup_pieces', 'reach_square', 'collect_stars', 'avoid_lava',
  'capture_all', 'promote', 'pawn_war', 'yes_no', 'tap_attackers', 'escape_check',
];

export function parseGoal(s: string): GoalType {
  const g = GOALS.find((x) => x === s);
  if (!g) throw new Error(`Unknown goal "${s}"`);
  return g;
}

/** Goals where the player moves pieces on the board. */
export const isMoveGoal = (g: GoalType): boolean =>
  ['reach_square', 'collect_stars', 'avoid_lava', 'capture_all', 'promote', 'pawn_war', 'escape_check'].includes(g);
export const isTapGoal = (g: GoalType): boolean => g === 'tap_square' || g === 'tap_all' || g === 'tap_attackers';
/** Goals solvable by a single-player search (opponent passive). */
export const isSolvable = (g: GoalType): boolean => isMoveGoal(g) && g !== 'pawn_war';

export type HintKind = 'legal_moves' | 'solution_first_move' | 'targets';
export function parseHintKind(s: string): HintKind {
  if (s === 'legal_moves' || s === 'solution_first_move' || s === 'targets') return s;
  throw new Error(`Unknown hint "${s}"`);
}
export interface Hint { afterFails: number; kind: HintKind }

/** The three ways out of check (LESSONS m6 l4). */
export type EscapeKind = 'run' | 'block' | 'capture';
export function parseEscape(s: string): EscapeKind {
  if (s === 'run' || s === 'block' || s === 'capture') return s;
  throw new Error(`escape: run | block | capture, got "${s}"`);
}

/** Lava: a fixed list of squares, or every square the opponent attacks. */
export class LavaSpec {
  constructor(readonly squares: ReadonlySet<Square> = new Set(), readonly attacked = false) {}

  static parse(y: Json): LavaSpec {
    if (y === null || y === undefined) return new LavaSpec();
    if (y === 'attacked') return new LavaSpec(new Set(), true);
    if (Array.isArray(y)) return new LavaSpec(new Set(y.map((s) => parseSquare(str(s)))));
    throw new Error(`lava: expected list of squares or "attacked", got ${JSON.stringify(y)}`);
  }

  get isEmpty(): boolean { return this.squares.size === 0 && !this.attacked; }

  on(pos: Position, player: Side, rules: Rules): Set<Square> {
    return this.attacked ? new Set([...this.squares, ...rules.attackedSquares(pos, opponent(player))]) : new Set(this.squares);
  }
}

export interface LessonTaskInit {
  goal: GoalType;
  rules: RuleSet;
  position: Position;
  prompt?: LocalizedText;
  stars?: Square[];
  lava?: LavaSpec;
  maxMoves?: number | null;
  hints?: Hint[];
  targets?: string[];
  targetPosition?: Position | null;
  answer?: boolean | null;
  verify?: string | null;
  bot?: BotLevel;
  escape?: EscapeKind | null;
}

/** One board puzzle. A lesson is 1..n tasks played in a row. */
export class LessonTask {
  readonly goal: GoalType;
  readonly rules: RuleSet;
  readonly position: Position;
  readonly prompt: LocalizedText;
  readonly stars: readonly Square[];
  readonly lava: LavaSpec;
  /** Par for 3 stars (not a hard limit). */
  readonly maxMoves: number | null;
  readonly hints: readonly Hint[];
  readonly targets: readonly string[];
  readonly targetPosition: Position | null;
  readonly answer: boolean | null;
  readonly verify: string | null;
  readonly bot: BotLevel;
  readonly escape: EscapeKind | null;

  constructor(i: LessonTaskInit) {
    this.goal = i.goal;
    this.rules = i.rules;
    this.position = i.position;
    this.prompt = i.prompt ?? new LocalizedText({});
    this.stars = i.stars ?? [];
    this.lava = i.lava ?? new LavaSpec();
    this.maxMoves = i.maxMoves ?? null;
    this.hints = i.hints ?? [];
    this.targets = i.targets ?? [];
    this.targetPosition = i.targetPosition ?? null;
    this.answer = i.answer ?? null;
    this.verify = i.verify ?? null;
    this.bot = i.bot ?? 'baby';
    this.escape = i.escape ?? null;
  }

  /** Parses one task; defaults are lesson-level keys every task inherits. */
  static parse(y: Obj, defaults: Obj = {}): LessonTask {
    const m: Obj = { ...defaults, ...y };
    const n = (k: string): Json => m[k] ?? null;
    return new LessonTask({
      goal: parseGoal(req(m, 'goal')),
      rules: parseRuleSet(str(n('rules') ?? 'piece_only')),
      position: Position.fromFen(str(n('fen') ?? '8/8/8/8/8/8/8/8')),
      prompt: LocalizedText.parse(n('prompt')),
      stars: ((n('stars') as Json[] | null) ?? []).map((s) => parseSquare(str(s))),
      lava: LavaSpec.parse(n('lava')),
      maxMoves: n('max_moves') as number | null,
      hints: ((n('hints') as Obj[] | null) ?? []).map((h) => ({ afterFails: h.after_fails as number, kind: parseHintKind(str(h.highlight)) })),
      targets: ((n('targets') as Json[] | null) ?? []).map(str),
      targetPosition: n('target_fen') !== null ? Position.fromFen(str(n('target_fen'))) : null,
      answer: n('answer') as boolean | null,
      verify: n('verify') as string | null,
      bot: n('bot') !== null ? parseBotLevel(str(n('bot'))) : 'baby',
      escape: n('escape') !== null ? parseEscape(str(n('escape'))) : null,
    });
  }

  get player(): Side { return this.position.sideToMove; }
}

export interface LessonReward { stars: number; unlock: string | null }

export class Lesson {
  /** Keys copied to every task unless the task overrides them. */
  static readonly inheritedKeys = ['rules', 'fen', 'hints', 'max_moves', 'stars', 'lava', 'bot', 'prompt'];

  constructor(
    readonly id: string,
    readonly module: number,
    readonly title: LocalizedText,
    readonly story: LocalizedText,
    readonly tasks: readonly LessonTask[],
    readonly skills: readonly string[] = [],
    readonly reward: LessonReward = { stars: 3, unlock: null },
  ) {}

  /** From the JSON image of the lesson YAML. */
  static fromJson(y: Json): Lesson {
    if (y === null || typeof y !== 'object' || Array.isArray(y)) throw new Error('Lesson must be a YAML map');
    const o = y as Obj;
    const defaults: Obj = {};
    for (const k of Lesson.inheritedKeys) if (k in o) defaults[k] = o[k];
    const rawTasks = (o.tasks as Obj[] | undefined) ?? [o]; // single-task shorthand
    const r = o.reward;
    const reward: LessonReward = r && typeof r === 'object'
      ? { stars: ((r as Obj).stars as number | undefined) ?? 3, unlock: ((r as Obj).unlock as string | undefined) ?? null }
      : { stars: 3, unlock: null };
    return new Lesson(
      req(o, 'id'),
      o.module as number,
      LocalizedText.parse(o.title),
      LocalizedText.parse(o.story),
      rawTasks.map((t) => LessonTask.parse(t, defaults)),
      ((o.skills as Json[] | undefined) ?? []).map(str),
      reward,
    );
  }
}

function req(m: Obj, key: string): string {
  const v = m[key];
  if (v === null || v === undefined) throw new Error(`Missing "${key}"`);
  return str(v);
}
