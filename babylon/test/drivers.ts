// TS side of tool/dump_vectors.dart: the same inputs and the same scripted lesson
// runs, step for step, so golden.test.ts can compare the outputs.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

import { Bot, evaluate, parseBotLevel, type BotGoal } from '../src/rules/bot';
import { ContentCatalog } from '../src/rules/content-catalog';
import { isAuthored, parseCurriculum } from '../src/rules/curriculum';
import { isMoveGoal, isTapGoal, Lesson, type LessonTask, type LocalizedText } from '../src/rules/lesson';
import { LessonSession, type TaskSession } from '../src/rules/lesson-engine';
import { Position } from '../src/rules/position';
import { lcg, nextInt } from '../src/rules/random';
import { parseRuleSet, Rules, type RuleSet } from '../src/rules/rules';
import { Solver } from '../src/rules/solver';
import { opponent, pieceFen, samePiece, squareName, uci, type Piece, type Square } from '../src/rules/types';

const root = fileURLToPath(new URL('../../', import.meta.url));
const generated = JSON.parse(readFileSync(fileURLToPath(new URL('../src/rules/generated/lessons.json', import.meta.url)), 'utf8')) as {
  index: unknown;
  lessons: Record<string, unknown>;
};
for (const lang of ['de', 'ja']) {
  ContentCatalog.add(lang, JSON.parse(readFileSync(`${root}assets/i18n/${lang}.json`, 'utf8')) as Record<string, string>);
}

const ruleId = (r: RuleSet): string => (r === 'full' ? 'full' : 'piece_only');
const names = (s: Iterable<Square>): string[] => [...s].sort((a, b) => a - b).map(squareName);
const pick = <T>(rand: () => number, l: readonly T[]): T => l[nextInt(rand, l.length)];

export function moves(i: { fen: string; rules: string }): unknown {
  const rules = new Rules(parseRuleSet(i.rules));
  const pos = Position.fromFen(i.fen);
  const legal = rules.legalMoves(pos);
  const san = legal.map((m) => rules.san(pos, m));
  const them = opponent(pos.sideToMove);
  return {
    moves: legal.map(uci),
    san,
    parsed: san.slice(0, 3).map((s) => {
      const m = rules.parseSan(pos, s);
      return m ? uci(m) : null;
    }),
    status: rules.status(pos),
    check: rules.inCheck(pos, pos.sideToMove),
    attacked: names(rules.attackedSquares(pos, them)),
    attackers: pos.piecesOf(pos.sideToMove).map(([s]) => [squareName(s), names(rules.attackers(pos, s, them))]),
    paths: legal.slice(0, 5).map((m) => names(Rules.path(m))),
  };
}

export function bot(i: { fen: string; rules: string; goal: BotGoal; level: string; seed: number }): unknown {
  const rules = new Rules(parseRuleSet(i.rules));
  const b = new Bot(parseBotLevel(i.level), lcg(i.seed), rules, i.goal);
  let pos = Position.fromFen(i.fen);
  const out: string[] = [];
  for (let ply = 0; ply < 4; ply++) {
    const m = b.chooseMove(pos);
    if (!m) break;
    out.push(uci(m));
    pos = pos.apply(m);
  }
  return { moves: out, eval: evaluate(Position.fromFen(i.fen)) };
}

const texts = (t: LocalizedText): Record<string, string> => Object.fromEntries(['cs', 'en', 'de', 'ja'].map((l) => [l, t.of(l)]));

function taskInfo(t: LessonTask): unknown {
  const solver = new Solver(t);
  const sol = solver.solve();
  return {
    goal: t.goal,
    rules: ruleId(t.rules),
    fen: t.position.fen,
    prompt: texts(t.prompt),
    stars: t.stars.map(squareName),
    lava: { squares: names(t.lava.squares), attacked: t.lava.attacked },
    maxMoves: t.maxMoves,
    hints: t.hints.map((h) => [h.afterFails, h.kind]),
    targets: [...t.targets],
    targetFen: t.targetPosition?.fen ?? null,
    answer: t.answer,
    verify: t.verify,
    bot: t.bot,
    escape: t.escape,
    solution: sol ? sol.map(uci) : null,
    reach: t.verify === 'reachable' && t.stars.length > 0 ? solver.canReach(t.stars[0]) : null,
  };
}

const fenOf = (p: Piece | null): string | null => (p ? pieceFen(p) : null);

function runTask(s: TaskSession, r: () => number): unknown[] {
  const log: unknown[] = [];
  const t = s.task;
  const first = s.solutionFirstMove();
  log.push({
    safe: t.position.piecesOf(t.player).map(([sq]) => [squareName(sq), names(s.safeTargets(sq))]),
    tapTargets: names(s.tapTargets),
    tray: s.tray.map(pieceFen),
    first: first ? uci(first) : null,
  });
  if (t.goal === 'pawn_war') {
    for (let ply = 0; ply < 80 && s.state === 'playing'; ply++) {
      if (s.playersTurn) {
        const ms = s.rules.legalMoves(s.position).filter((m) => !m.promotion || m.promotion === 'queen');
        if (ms.length === 0) break;
        const m = pick(r, ms);
        const v = s.check(m.from, m.to);
        const ev = s.play(m.from, m.to);
        log.push([uci(m), v, fenOf(ev.captured), s.state]);
      } else {
        const m = s.botMove();
        if (!m) break;
        const ev = s.playBot(m);
        log.push([uci(m), 'bot', fenOf(ev.captured), s.state]);
      }
    }
  } else if (isMoveGoal(t.goal)) {
    const mine = t.position.piecesOf(t.player).map(([sq]) => sq);
    for (let i = 0; i < 3 && mine.length > 0; i++) {
      const from = pick(r, mine);
      const to = nextInt(r, 64);
      const v = s.check(from, to);
      if (v !== 'ok') s.fail();
      log.push([squareName(from), squareName(to), v, s.activeHint]);
    }
    for (let step = 0; step < 20 && s.state === 'playing'; step++) {
      const m = s.solutionFirstMove();
      if (!m) break;
      const v = s.check(m.from, m.to);
      const ev = s.play(m.from, m.to);
      log.push([uci(m), v, fenOf(ev.captured), ev.starCollected, s.state, names(s.starsLeft)]);
    }
  } else if (isTapGoal(t.goal)) {
    const targets = s.tapTargets;
    const wrong: Square[] = [];
    for (let i = 0; i < 64; i++) if (!targets.has(i)) wrong.push(i);
    if (wrong.length > 0) {
      const sq = pick(r, wrong);
      log.push([squareName(sq), s.tap(sq)]);
    }
    for (let i = 0; i < 70 && s.state === 'playing'; i++) {
      const left = [...s.tapTargets].filter((x) => !s.tapped.has(x)).sort((a, b) => a - b);
      if (left.length === 0) break;
      const sq = left[0];
      log.push([squareName(sq), s.tap(sq), s.state]);
    }
  } else if (t.goal === 'setup_pieces') {
    const target = t.targetPosition as Position;
    if (s.tray.length > 0) {
      const p = s.tray[0];
      const bad: Square[] = [];
      for (let i = 0; i < 64; i++) if (!samePiece(target.at(i), p)) bad.push(i);
      if (bad.length > 0) log.push([pieceFen(p), squareName(bad[0]), s.drop(p, bad[0])]);
    }
    for (let i = 0; i < 40 && s.state === 'playing' && s.tray.length > 0; i++) {
      const p = s.tray[0];
      let to: Square | null = null;
      for (let k = 0; k < 64; k++) {
        if (samePiece(target.at(k), p) && !samePiece(s.position.at(k), p)) {
          to = k;
          break;
        }
      }
      if (to === null) break;
      log.push([pieceFen(p), squareName(to), s.drop(p, to), s.state]);
    }
  } else if (t.goal === 'yes_no') {
    const a = t.answer ?? false;
    log.push([s.answer(!a), s.answer(a)]);
  }
  log.push({ state: s.state, fails: s.fails, moves: s.moves, stars: s.starsEarned, hint: s.activeHint, fen: s.position.fen });
  return log;
}

export function lessons(i: { id: string }): unknown {
  if (i.id === 'index') {
    return {
      modules: parseCurriculum(generated.index).map((m) => ({
        number: m.number, title: texts(m.title), icon: m.icon, lessons: m.lessonIds, unlock: m.unlock, authored: isAuthored(m),
      })),
    };
  }
  const l = Lesson.fromJson(generated.lessons[i.id]);
  const session = new LessonSession(l, lcg(5));
  const r = lcg(11);
  const runs: unknown[] = [];
  for (;;) {
    runs.push(runTask(session.current, r));
    if (session.current.state !== 'won') break;
    session.nextTask();
    if (session.isFinished) break;
  }
  return {
    module: l.module,
    title: texts(l.title),
    story: texts(l.story),
    skills: [...l.skills],
    reward: { stars: l.reward.stars, unlock: l.reward.unlock },
    tasks: l.tasks.map(taskInfo),
    runs,
    finished: session.isFinished,
    stars: session.stars,
  };
}
