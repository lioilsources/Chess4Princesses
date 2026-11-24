// Pure helpers: clean broadcast PGN and shape the tournament list.
// No Worker APIs here, so `node --test` can run them directly.

/** Headers the app keeps (SLAVNE_PARTIE_PLAN §6: no URLs, clocks or sponsor names). */
export const KEEP_HEADERS = ["Event", "Date", "Round", "White", "Black", "Result", "ECO", "WhiteElo", "BlackElo", "FEN", "SetUp"];

const HEADER = /^\[(\w+)\s+"((?:[^"\\]|\\.)*)"\]\s*$/;

export interface CleanOptions {
  /** Standard `TimeControl` header written for every game (from the curated list). */
  timeControl?: string;
  /** Unix seconds of the last move per game index, only for unfinished games. */
  lastMoveAt?: (gameIndex: number) => number | undefined;
}

/**
 * Drops text comments, `;` comments, variations and NAGs, keeps only
 * [KEEP_HEADERS] (plus `TimeControl` / `LastMoveAt` from [opts]) and replaces
 * `Event` with [eventName]. Clock and eval commands survive as `{[%clk …][%eval …]}`.
 */
export function cleanPgn(pgn: string, eventName: string, opts: CleanOptions = {}): string {
  const games: string[] = [];
  let headers: [string, string][] = [];
  let moves: string[] = [];

  const flush = () => {
    if (headers.length === 0 && moves.length === 0) return;
    const out: string[] = [];
    const map = new Map(headers);
    map.set("Event", eventName);
    for (const k of KEEP_HEADERS) {
      const v = map.get(k);
      if (v !== undefined) out.push(`[${k} "${v}"]`);
    }
    if (opts.timeControl) out.push(`[TimeControl "${opts.timeControl}"]`);
    const result = map.get("Result") ?? "*";
    const at = result === "*" ? opts.lastMoveAt?.(games.length) : undefined;
    if (at !== undefined) out.push(`[LastMoveAt "${Math.floor(at)}"]`);
    games.push(`${out.join("\n")}\n\n${wrap(movetextTokens(moves.join("\n"), true))}\n`);
    headers = [];
    moves = [];
  };

  for (const raw of pgn.replace(/\r\n/g, "\n").split("\n")) {
    const line = raw.trim();
    const h = HEADER.exec(line);
    if (h) {
      if (moves.length > 0) flush();
      headers.push([h[1], h[2]]);
    } else if (line.length > 0) {
      moves.push(line);
    }
  }
  flush();
  return games.join("\n");
}

const COMMAND = /\[%(clk|eval)\s+([^\]\s]+)\]/g;

/** `{[%clk 1:59:50][%eval 0.18]}` from a source comment, or null. */
export function keptAnnotation(comment: string): string | null {
  const parts: string[] = [];
  for (const m of comment.matchAll(COMMAND)) parts.push(`[%${m[1]} ${m[2]}]`);
  return parts.length === 0 ? null : `{${parts.join("")}}`;
}

/** Main line only: no comments, variations, NAGs or annotation glyphs. */
export function stripMovetext(text: string): string {
  return movetextTokens(text, false).join(" ");
}

/** Main-line tokens; with [annotations], clock/eval comments stay as one token each. */
export function movetextTokens(text: string, annotations: boolean): string[] {
  const tokens: string[] = [];
  let word = "";
  let depth = 0;
  const push = () => {
    if (word.length > 0) tokens.push(word);
    word = "";
  };
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (c === "{") {
      const end = text.indexOf("}", i);
      const body = text.slice(i + 1, end < 0 ? text.length : end);
      i = end < 0 ? text.length : end;
      push();
      if (annotations && depth === 0) {
        const kept = keptAnnotation(body);
        if (kept) tokens.push(kept);
      }
    } else if (c === ";") {
      const end = text.indexOf("\n", i);
      i = end < 0 ? text.length : end;
      push();
    } else if (c === "(") {
      push();
      depth++;
    } else if (c === ")") {
      push();
      depth = Math.max(0, depth - 1);
    } else if (depth > 0) {
      continue;
    } else if (/\s/.test(c)) {
      push();
    } else {
      word += c;
    }
  }
  push();
  return tokens
    .filter((t) => t.startsWith("{") || (!t.startsWith("$") && !/^\d+\.\.\.$/.test(t)))
    .map((t) => (t.startsWith("{") ? t : t.replace(/[!?]+$/, "")))
    .filter((t) => t.length > 0);
}

function wrap(tokens: string[], width = 80): string {
  const lines: string[] = [];
  let line = "";
  for (const tok of tokens) {
    if (line.length > 0 && line.length + 1 + tok.length > width) {
      lines.push(line);
      line = tok;
    } else {
      line = line.length === 0 ? tok : `${line} ${tok}`;
    }
  }
  if (line.length > 0) lines.push(line);
  return lines.join("\n");
}

export interface Tournament {
  id: string;
  source: string;
  name: { cs: string; en: string };
  emblem: string;
  from: string;
  to: string;
  /** Standard PGN `TimeControl` (e.g. `40/7200:1800+30`); the source only has free text. */
  tc?: string;
}

export interface SourceRound {
  id: string;
  name?: string;
  startsAt?: number;
  ongoing?: boolean;
  finished?: boolean;
}

/** One game of the source's round JSON (`/api/broadcast/-/-/{roundId}`). */
export interface SourceGame {
  id?: string;
  status?: string;
  /** Seconds since the last move, while the game runs. */
  thinkTime?: number;
}

/** Unix seconds of the last move: fetch time minus think time, if known. */
export function lastMoveAt(game: SourceGame | undefined, fetchedAtMs: number): number | undefined {
  if (game?.thinkTime === undefined || game.thinkTime < 0) return undefined;
  return Math.floor(fetchedAtMs / 1000) - game.thinkTime;
}

/** FEN accepted by `/v1/advice`: six fields, board of 8 ranks. */
export function validFen(fen: string): boolean {
  if (fen.length > 100) return false;
  return /^([pnbrqkPNBRQK1-8]{1,8}\/){7}[pnbrqkPNBRQK1-8]{1,8} [wb] (-|K?Q?k?q?) (-|[a-h][36]) \d{1,3} \d{1,4}$/.test(fen);
}

export interface AdviceLine {
  cp?: number;
  mate?: number;
  moves: string[];
}

/** Source cloud-eval answer → `{v, depth, lines}` (at most 3 lines of 10 plies). */
export function adviceFrom(body: unknown): { v: 1; depth: number; lines: AdviceLine[] } {
  const b = (body ?? {}) as { depth?: number; pvs?: { cp?: number; mate?: number; moves?: string }[] };
  const lines: AdviceLine[] = [];
  for (const pv of (b.pvs ?? []).slice(0, 3)) {
    const moves = (pv.moves ?? "").split(" ").filter((m) => /^[a-h][1-8][a-h][1-8][nbrq]?$/.test(m)).slice(0, 10);
    if (moves.length === 0) continue;
    const line: AdviceLine = { moves };
    if (typeof pv.mate === "number") line.mate = pv.mate;
    else if (typeof pv.cp === "number") line.cp = pv.cp;
    lines.push(line);
  }
  return { v: 1, depth: typeof b.depth === "number" ? b.depth : 0, lines };
}

/** Weak ETag of a body (FNV-1a, enough to tell versions apart). */
export function etagOf(body: string): string {
  let h = 0x811c9dc5;
  for (let i = 0; i < body.length; i++) {
    h ^= body.charCodeAt(i);
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return `W/"${h.toString(16)}-${body.length.toString(16)}"`;
}

export interface FeedRound {
  id: string;
  n: number;
  startsAt: number | null;
  state: "upcoming" | "ongoing" | "finished";
}

/** Rounds in the order of the source, numbered from 1. */
export function feedRounds(rounds: SourceRound[], now: number): FeedRound[] {
  return rounds.map((r, i) => ({
    id: r.id,
    n: i + 1,
    startsAt: r.startsAt ?? null,
    state: r.finished ? "finished" : r.ongoing || (r.startsAt !== undefined && r.startsAt <= now) ? "ongoing" : "upcoming",
  }));
}

/** Curated tournaments whose window contains [now]. */
export function activeTournaments(list: Tournament[], now: number): Tournament[] {
  const day = 24 * 3600 * 1000;
  return list.filter((t) => Date.parse(t.from) - day <= now && now <= Date.parse(t.to) + day);
}
