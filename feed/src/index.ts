// Live games relay for PrincessChess (SLAVNE_PARTIE_PLAN §6, docs/feed.md).
// The app never talks to the source: it asks this Worker, which serves a
// curated list and cleaned PGN, cached at the edge so the source sees about
// one request per minute per location, however many phones ask.
import { activeTournaments, cleanPgn, feedRounds, type SourceRound, type Tournament } from "./clean.ts";
import tournaments from "./tournaments.json";

const LIST = tournaments as Tournament[];
const UA = "princesschess-feed/1 (+https://github.com/lioilsources/Chess4Princesses)";

const json = (body: unknown, maxAge: number) =>
  new Response(JSON.stringify(body), {
    headers: { "content-type": "application/json; charset=utf-8", "cache-control": `public, max-age=${maxAge}` },
  });

const notFound = () => new Response("not found", { status: 404 });

/** GET from the source through the edge cache. */
async function cachedSource(env: Env, ctx: ExecutionContext, path: string, ttl: number): Promise<Response> {
  const url = `${env.SOURCE_BASE}${path}`;
  const cache = caches.default;
  const key = new Request(url);
  const hit = await cache.match(key);
  if (hit) return hit;
  const res = await fetch(url, { headers: { "user-agent": UA } });
  if (!res.ok) return res;
  const copy = new Response(res.body, res);
  copy.headers.set("cache-control", `public, max-age=${ttl}`);
  ctx.waitUntil(cache.put(key, copy.clone()));
  return copy;
}

async function sourceRounds(env: Env, ctx: ExecutionContext, t: Tournament): Promise<SourceRound[] | null> {
  const res = await cachedSource(env, ctx, `/api/broadcast/${t.source}`, 300);
  if (!res.ok) return null;
  const body = (await res.json()) as { rounds?: SourceRound[] };
  return body.rounds ?? [];
}

async function live(env: Env, ctx: ExecutionContext): Promise<Response> {
  const now = Date.now();
  const out = [];
  for (const t of activeTournaments(LIST, now)) {
    const rounds = await sourceRounds(env, ctx, t);
    if (rounds === null) continue;
    out.push({ id: t.id, name: t.name, emblem: t.emblem, rounds: feedRounds(rounds, now) });
  }
  return json({ v: 1, tournaments: out }, 60);
}

async function round(env: Env, ctx: ExecutionContext, tourId: string, roundId: string): Promise<Response> {
  const t = LIST.find((x) => x.id === tourId);
  if (!t) return notFound();
  const rounds = await sourceRounds(env, ctx, t);
  const r = rounds?.find((x) => x.id === roundId);
  if (!r) return notFound();
  const done = r.finished === true;
  const res = await cachedSource(env, ctx, `/api/broadcast/round/${r.id}.pgn`, done ? 3600 : 60);
  if (!res.ok) return new Response("source unavailable", { status: 502 });
  const pgn = cleanPgn(await res.text(), t.name.en);
  return new Response(pgn, {
    headers: { "content-type": "application/x-chess-pgn; charset=utf-8", "cache-control": `public, max-age=${done ? 3600 : 60}` },
  });
}

export default {
  async fetch(request, env, ctx): Promise<Response> {
    if (request.method !== "GET") return new Response("method not allowed", { status: 405 });
    const { pathname } = new URL(request.url);
    try {
      if (pathname === "/v1/live.json") return await live(env, ctx);
      const m = /^\/v1\/t\/([\w-]+)\/([A-Za-z0-9]{8})\.pgn$/.exec(pathname);
      if (m) return await round(env, ctx, m[1], m[2]);
      return notFound();
    } catch (e) {
      // No request data in logs: the app sends nothing personal and we keep it that way.
      console.error(JSON.stringify({ msg: "feed error", path: pathname, error: String(e) }));
      return new Response("feed error", { status: 500 });
    }
  },
} satisfies ExportedHandler<Env>;
