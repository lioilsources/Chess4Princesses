// Free game against a bot (rules/bot.ts, a port of lib/core/engine/bot.dart) on the
// kid board. Tap-tap like chess_board.dart: tap a piece of yours to see its dots, tap
// a dot to move. Lessons, map and battles: F2–F3.
//
// Deep links: ?army=<id> (mine), ?rival=<id>, ?bot=1..4 or a level name,
// ?seed=<n> (repeatable bot), ?debug (FPS).
import { Engine } from '@babylonjs/core/Engines/engine';

import { Bot, parseBotLevel, type BotLevel } from '../rules/bot';
import { Position } from '../rules/position';
import { lcg } from '../rules/random';
import { Rules } from '../rules/rules';
import { opponent, type Move, type Side, type Square } from '../rules/types';
import { armyParam, loadArmy, type ArmyArt } from '../ui/armies';
import { byId, Hud } from '../ui/hud';
import { BoardScene } from './board-scene';
import '../ui/style.css';

const t0 = performance.now();
const params = new URLSearchParams(location.search);
const debug = params.has('debug');
const seed = params.get('seed');
const random = lcg(seed !== null ? Number(seed) || 1 : Date.now());
const BOT_DELAY_MS = 600;

const me: Side = 'white';
const rules = new Rules('full');
const botLevel = ((): BotLevel => {
  try {
    return parseBotLevel(params.get('bot') ?? 'baby');
  } catch {
    return 'baby';
  }
})();
const bot = new Bot(botLevel, random, rules);
const canvas = byId('game') as HTMLCanvasElement;
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: false, antialias: true }, true);
engine.setHardwareScalingLevel(1 / (devicePixelRatio || 1));

const [mine, rival] = await Promise.all([
  loadArmy(armyParam(params.get('army'), 'fairies')),
  loadArmy(armyParam(params.get('rival'), 'witches')),
]);
const armyOf = (s: Side): ArmyArt => (s === me ? mine : rival);
const board = new BoardScene(engine, armyOf, me);

let pos = Position.initial();
let selected: Square | null = null;
let dots = new Map<Square, Move>();
let botTimer = 0;

const hud = new Hud(restart);

function restart(): void {
  clearTimeout(botTimer);
  pos = Position.initial();
  selected = null;
  dots = new Map();
  board.setPosition(pos);
  refresh();
}

function refresh(): void {
  board.paint({ selected, dots: new Set(dots.keys()) });
  hud.setTurn(armyOf(pos.sideToMove));
  const status = rules.status(pos);
  if (status === 'ongoing') {
    hud.showEnd(null, null);
  } else if (status === 'stalemate') {
    hud.showEnd('draw', null);
  } else {
    const winner = opponent(pos.sideToMove);
    hud.showEnd(winner === me ? 'won' : 'lost', armyOf(winner));
  }
}

function play(m: Move): void {
  pos = pos.apply(m);
  selected = null;
  dots = new Map();
  board.setPosition(pos, m);
  refresh();
  if (pos.sideToMove !== me && rules.status(pos) === 'ongoing') {
    botTimer = window.setTimeout(() => {
      const reply = bot.chooseMove(pos);
      if (reply) play(reply);
    }, BOT_DELAY_MS);
  }
}

function tap(s: Square): void {
  if (pos.sideToMove !== me || rules.status(pos) !== 'ongoing') return;
  const target = dots.get(s);
  if (target) {
    // Promotion: always a queen for now; the Flutter picker comes with the lessons (F3).
    play(target.promotion && target.promotion !== 'queen' ? { ...target, promotion: 'queen' } : target);
    return;
  }
  const p = pos.at(s);
  if (p && p.side === me && s !== selected) {
    selected = s;
    dots = new Map(rules.legalMoves(pos, s).map((m) => [m.to, m] as [Square, Move]));
  } else {
    selected = null;
    dots = new Map();
  }
  refresh();
}

canvas.addEventListener('pointerdown', (e) => {
  const r = canvas.getBoundingClientRect();
  const s = board.squareAt(e.clientX - r.left, e.clientY - r.top);
  if (s !== null) tap(s);
});

function layout(): void {
  engine.resize();
  const w = innerWidth;
  const h = innerHeight;
  const top = 76;
  board.fit({ left: 8, top, width: w - 16, height: h - top - 8 }, w, h);
}
addEventListener('resize', layout);
layout();
board.setPosition(pos);
refresh();

let frames = 0;
let fpsT = performance.now();
let lastT = performance.now();
let firstFrame = true;
engine.runRenderLoop(() => {
  const now = performance.now();
  board.tick(Math.min((now - lastT) / 1000, 0.1));
  lastT = now;
  board.scene.render();
  if (firstFrame && board.scene.isReady()) {
    // First frame with every mesh and sprite drawn, not just the clear colour.
    firstFrame = false;
    (window as unknown as { __firstFrameMs: number }).__firstFrameMs = now;
    console.info(`first frame ${Math.round(now - t0)} ms after script start, ${Math.round(now)} ms after navigation`);
  }
  frames++;
  if (now - fpsT >= 1000) {
    if (debug) hud.showFps(`${Math.round((frames * 1000) / (now - fpsT))} fps`);
    frames = 0;
    fpsT = now;
  }
});
