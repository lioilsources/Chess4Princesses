// Pure helpers: clean broadcast PGN and shape the tournament list.
// No Worker APIs here, so `node --test` can run them directly.

/** Headers the app keeps (SLAVNE_PARTIE_PLAN §6: no URLs, clocks or sponsor names). */
export const KEEP_HEADERS = ["Event", "Date", "Round", "White", "Black", "Result", "ECO", "WhiteElo", "BlackElo", "FEN", "SetUp"];

const HEADER = /^\[(\w+)\s+"((?:[^"\\]|\\.)*)"\]\s*$/;

/**
 * Drops comments (`{ [%eval …] [%clk …] }`), `;` comments, variations and
 * NAGs, keeps only [KEEP_HEADERS] and replaces `Event` with [eventName].
 */
export function cleanPgn(pgn: string, eventName: string): string {
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
    games.push(`${out.join("\n")}\n\n${wrap(stripMovetext(moves.join("\n")))}\n`);
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

/** Main line only: no comments, variations, NAGs or annotation glyphs. */
export function stripMovetext(text: string): string {
  let out = "";
  let depth = 0;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (c === "{") {
      const end = text.indexOf("}", i);
      i = end < 0 ? text.length : end;
      out += " ";
    } else if (c === ";") {
      const end = text.indexOf("\n", i);
      i = end < 0 ? text.length : end;
      out += " ";
    } else if (c === "(") {
      depth++;
    } else if (c === ")") {
      depth = Math.max(0, depth - 1);
    } else if (depth === 0) {
      out += c;
    }
  }
  return out
    .split(/\s+/)
    .filter((t) => t.length > 0 && !t.startsWith("$") && !/^\d+\.\.\.$/.test(t))
    .map((t) => t.replace(/[!?]+$/, ""))
    .join(" ");
}

function wrap(text: string, width = 80): string {
  const lines: string[] = [];
  let line = "";
  for (const tok of text.split(" ")) {
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
}

export interface SourceRound {
  id: string;
  name?: string;
  startsAt?: number;
  ongoing?: boolean;
  finished?: boolean;
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
