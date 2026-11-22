import assert from "node:assert/strict";
import { test } from "node:test";

import { activeTournaments, cleanPgn, feedRounds, stripMovetext, type Tournament } from "../src/clean.ts";

const SOURCE = `[Event "Round 7: Lundberg, David - Eklund, Joel"]
[Site "https://example.org/broadcast/x/round-7/abc"]
[Date "2026.11.21"]
[Round "7.1"]
[White "Lundberg, David"]
[Black "Eklund, Joel"]
[Result "1/2-1/2"]
[WhiteElo "2188"]
[Opening "Scandinavian Defense"]
[BroadcastName "Some Sponsor Cup 2026"]
[GameURL "https://example.org/x"]

1. e4 { [%eval 0.18] [%clk 0:10:07] } 1... d5 { [%eval 0.54] [%clk 0:10:08] } 2. exd5 $1 (2. e5 c5) 2... Qxd5!? 1/2-1/2

[Event "Round 7: B - C"]
[White "B"]
[Black "C"]
[Result "*"]

*
`;

test("cleanPgn keeps the main line and safe headers only", () => {
  const out = cleanPgn(SOURCE, "World Championship Match 2026, Geneva");
  assert.match(out, /^\[Event "World Championship Match 2026, Geneva"\]$/m);
  assert.match(out, /^\[Round "7.1"\]$/m);
  assert.doesNotMatch(out, /Site|GameURL|BroadcastName|Opening|Sponsor|%clk|%eval|\$1|e5 c5/);
  assert.match(out, /1\. e4 d5 2\. exd5 Qxd5 1\/2-1\/2/);
  assert.equal(out.match(/\[Event /g)?.length, 2);
});

test("stripMovetext drops nested variations and move-number continuations", () => {
  assert.equal(stripMovetext("1. e4 (1. d4 (1. c4) d5) 1... e5 ; note\n2. Nf3 *"), "1. e4 e5 2. Nf3 *");
});

test("feedRounds numbers rounds and derives their state", () => {
  const now = Date.parse("2026-11-25T15:00:00Z");
  const r = feedRounds(
    [
      { id: "aaaaaaaa", startsAt: Date.parse("2026-11-24T14:00:00Z"), finished: true },
      { id: "bbbbbbbb", startsAt: Date.parse("2026-11-25T14:00:00Z") },
      { id: "cccccccc", startsAt: Date.parse("2026-11-26T14:00:00Z") },
    ],
    now,
  );
  assert.deepEqual(r.map((x) => [x.n, x.state]), [[1, "finished"], [2, "ongoing"], [3, "upcoming"]]);
});

test("activeTournaments keeps the window with a day of slack", () => {
  const t: Tournament = { id: "x", source: "s", name: { cs: "x", en: "x" }, emblem: "crown", from: "2026-11-22", to: "2026-12-20" };
  assert.equal(activeTournaments([t], Date.parse("2026-11-21T12:00:00Z")).length, 1);
  assert.equal(activeTournaments([t], Date.parse("2026-12-25T12:00:00Z")).length, 0);
});
