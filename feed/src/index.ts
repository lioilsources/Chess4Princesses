// Live games relay for PrincessChess (SLAVNE_PARTIE_PLAN §6, docs/feed.md).
// The app never talks to the source: it asks this Worker, which serves a
// curated list and cleaned PGN, cached at the edge so the source sees about
// one request per minute per location, however many phones ask.
import {
  activeTournaments,
  adviceFrom,
  cleanPgn,
  etagOf,
  feedRounds,
  lastMoveAt,
  validFen,
  type SourceGame,
  type SourceRound,
  type Tournament,
} from "./clean.ts";
import tournaments from "./tournaments.json";

const LIST = tournaments as Tournament[];
const UA = "princesschess-feed/1 (+https://github.com/lioilsources/Chess4Princesses)";

/** Seconds a running round stays cached (the source allows 10 s). */
const ONGOING_TTL = 10;
const FINISHED_TTL = 3600;
const ADVICE_TTL = 600;
const ADVICE_MISS_TTL = 60;

/** Body with a weak ETag; `304` when the client already has it. */
function versioned(request: Request, body: string, contentType: string, maxAge: number): Response {
  const etag = etagOf(body);
  const headers = { "content-type": contentType, "cache-control": `public, max-age=${maxAge}`, etag };
  if (request.headers.get("if-none-match") === etag) return new Response(null, { status: 304, headers });
  return new Response(body, { headers });
}

const json = (request: Request, body: unknown, maxAge: number) =>
  versioned(request, JSON.stringify(body), "application/json; charset=utf-8", maxAge);

const notFound = () => new Response("not found", { status: 404 });

/** GET from the source through the edge cache; a 404 is kept for [missTtl] seconds when given. */
async function cachedSource(env: Env, ctx: ExecutionContext, path: string, ttl: number, missTtl?: number): Promise<Response> {
  const url = `${env.SOURCE_BASE}${path}`;
  const cache = caches.default;
  const key = new Request(url);
  const hit = await cache.match(key);
  if (hit) return hit;
  const res = await fetch(url, { headers: { "user-agent": UA } });
  if (res.status === 404 && missTtl !== undefined) {
    const miss = new Response(null, { status: 404, headers: { "cache-control": `public, max-age=${missTtl}` } });
    ctx.waitUntil(cache.put(key, miss.clone()));
    return miss;
  }
  if (!res.ok) return res;
  const copy = new Response(res.body, res);
  copy.headers.set("cache-control", `public, max-age=${ttl}`);
  // When the source answered: the think time in round JSON is relative to it.
  copy.headers.set("x-fetched-at", String(Date.now()));
  ctx.waitUntil(cache.put(key, copy.clone()));
  return copy;
}

async function sourceRounds(env: Env, ctx: ExecutionContext, t: Tournament): Promise<SourceRound[] | null> {
  const res = await cachedSource(env, ctx, `/api/broadcast/${t.source}`, 300);
  if (!res.ok) return null;
  const body = (await res.json()) as { rounds?: SourceRound[] };
  return body.rounds ?? [];
}

async function live(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
  const now = Date.now();
  const out = [];
  for (const t of activeTournaments(LIST, now)) {
    const rounds = await sourceRounds(env, ctx, t);
    if (rounds === null) continue;
    out.push({ id: t.id, name: t.name, emblem: t.emblem, rounds: feedRounds(rounds, now) });
  }
  return json(request, { v: 1, tournaments: out }, 60);
}

/** Think time per game of a running round, from the source's round JSON. */
async function thinkTimes(env: Env, ctx: ExecutionContext, roundId: string): Promise<{ games: SourceGame[]; fetchedAt: number } | null> {
  const res = await cachedSource(env, ctx, `/api/broadcast/-/-/${roundId}`, ONGOING_TTL);
  if (!res.ok) return null;
  const fetchedAt = Number(res.headers.get("x-fetched-at") ?? Date.now());
  const body = (await res.json()) as { games?: SourceGame[] };
  return { games: body.games ?? [], fetchedAt };
}

async function round(request: Request, env: Env, ctx: ExecutionContext, tourId: string, roundId: string): Promise<Response> {
  const t = LIST.find((x) => x.id === tourId);
  if (!t) return notFound();
  const rounds = await sourceRounds(env, ctx, t);
  const r = rounds?.find((x) => x.id === roundId);
  if (!r) return notFound();
  const done = r.finished === true;
  const ttl = done ? FINISHED_TTL : ONGOING_TTL;
  const res = await cachedSource(env, ctx, `/api/broadcast/round/${r.id}.pgn`, ttl);
  if (!res.ok) return new Response("source unavailable", { status: 502 });
  const source = await res.text();
  const think = done ? null : await thinkTimes(env, ctx, r.id).catch(() => null);
  const pgn = cleanPgn(source, t.name.en, {
    timeControl: t.tc,
    lastMoveAt: think ? (i) => lastMoveAt(think.games[i], think.fetchedAt) : undefined,
  });
  return versioned(request, pgn, "application/x-chess-pgn; charset=utf-8", ttl);
}

/** Until this time (ms) the source said "too many requests": do not ask. */
let adviceBackoffUntil = 0;

async function advice(request: Request, env: Env, ctx: ExecutionContext, fen: string): Promise<Response> {
  if (!validFen(fen)) return new Response("bad fen", { status: 400 });
  if (Date.now() < adviceBackoffUntil) return new Response("busy", { status: 503, headers: { "retry-after": "60" } });
  const path = `/api/cloud-eval?multiPv=3&fen=${encodeURIComponent(fen)}`;
  const res = await cachedSource(env, ctx, path, ADVICE_TTL, ADVICE_MISS_TTL);
  if (res.status === 429) {
    adviceBackoffUntil = Date.now() + 60_000;
    return new Response("busy", { status: 503, headers: { "retry-after": "60" } });
  }
  if (res.status === 404) return json(request, { v: 1, depth: 0, lines: [] }, ADVICE_MISS_TTL);
  if (!res.ok) return new Response("source unavailable", { status: 502 });
  return json(request, adviceFrom(await res.json()), ADVICE_TTL);
}

export default {
  async fetch(request, env, ctx): Promise<Response> {
    if (request.method !== "GET") return new Response("method not allowed", { status: 405 });
    const { pathname, searchParams } = new URL(request.url);
    try {
      if (pathname === "/v1/live.json") return await live(request, env, ctx);
      if (pathname === "/v1/advice") return await advice(request, env, ctx, searchParams.get("fen") ?? "");
      const m = /^\/v1\/t\/([\w-]+)\/([A-Za-z0-9]{8})\.pgn$/.exec(pathname);
      if (m) return await round(request, env, ctx, m[1], m[2]);
      return notFound();
    } catch (e) {
      // No request data in logs: the app sends nothing personal and we keep it that way.
      console.error(JSON.stringify({ msg: "feed error", path: pathname, error: String(e) }));
      return new Response("feed error", { status: 500 });
    }
  },
} satisfies ExportedHandler<Env>;
