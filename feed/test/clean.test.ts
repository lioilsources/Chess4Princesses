import assert from "node:assert/strict";
import { test } from "node:test";

import { readFileSync } from "node:fs";

import {
  activeTournaments,
  adviceFrom,
  cleanPgn,
  etagOf,
  feedRounds,
  keptAnnotation,
  lastMoveAt,
  stripMovetext,
  validFen,
  type Tournament,
} from "../src/clean.ts";

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

1. e4 { [%eval 0.18] [%clk 0:10:07] } 1... d5 { [%eval 0.54] [%clk 0:10:08] } 2. exd5 $1 { Great move! [%clk 0:09:58] } (2. e5 { [%clk 0:01:00] } c5) 2... Qxd5!? 1/2-1/2

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
  assert.doesNotMatch(out, /Site|GameURL|BroadcastName|Opening|Sponsor|Great|0:01:00|\$1|e5 c5|TimeControl|LastMoveAt/);
  assert.match(out.replace(/\s+/g, " "), /1\. e4 \{\[%eval 0\.18\]\[%clk 0:10:07\]\} d5 \{\[%eval 0\.54\]\[%clk 0:10:08\]\} 2\. exd5 \{\[%clk 0:09:58\]\} Qxd5 1\/2-1\/2/);
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

test("cleanPgn adds TimeControl and LastMoveAt only to unfinished games", () => {
  const out = cleanPgn(SOURCE, "X", { timeControl: "40/7200:1800+30", lastMoveAt: (i) => [100, 200][i] });
  assert.equal(out.match(/\[TimeControl "40\/7200:1800\+30"\]/g)?.length, 2);
  assert.doesNotMatch(out, /LastMoveAt "100"/);
  assert.match(out, /\[LastMoveAt "200"\]/);
});

test("keptAnnotation keeps clock and eval commands only", () => {
  assert.equal(keptAnnotation(" [%eval #-3] [%clk 0:00:59] [%cal Ge2e4] nice "), "{[%eval #-3][%clk 0:00:59]}");
  assert.equal(keptAnnotation(" only words "), null);
});

test("golden round: cleaned output matches the fixture the app tests read", () => {
  const source = readFileSync(`${import.meta.dirname}/fixtures/wch2026_r1_source.pgn`, "utf8");
  const expected = readFileSync(`${import.meta.dirname}/fixtures/wch2026_r1_feed.pgn`, "utf8");
  assert.equal(cleanPgn(source, "World Championship Match 2026, Geneva", { timeControl: "40/7200:1800+30" }), expected);
});

test("lastMoveAt subtracts think time from the fetch time", () => {
  assert.equal(lastMoveAt({ thinkTime: 30 }, 1_000_000), 970);
  assert.equal(lastMoveAt({}, 1_000_000), undefined);
  assert.equal(lastMoveAt(undefined, 1_000_000), undefined);
});

test("validFen accepts real positions and rejects junk", () => {
  assert.ok(validFen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"));
  assert.ok(validFen("r2r2k1/1pp2p2/2n4B/2p4R/2P3P1/1PbN3P/8/3R2K1 w - - 13 39"));
  assert.ok(!validFen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP w KQkq - 0 1"));
  assert.ok(!validFen("<script>"));
});

test("adviceFrom keeps three lines of ten UCI moves", () => {
  const a = adviceFrom({
    depth: 40,
    pvs: [
      { cp: 19, moves: "e1h1 f6e4 f1e1 e4d6 f3e5 c6e5 e1e5 f8e7 b5f1 e8h8 a2a3" },
      { mate: -2, moves: "d2d3 f8c5" },
      { cp: 0, moves: "" },
      { cp: 1, moves: "a2a3" },
    ],
  });
  assert.equal(a.depth, 40);
  assert.deepEqual(a.lines.map((l) => [l.cp, l.mate, l.moves.length]), [[19, undefined, 10], [undefined, -2, 2]]);
  assert.deepEqual(adviceFrom(null), { v: 1, depth: 0, lines: [] });
});

test("etagOf changes with the body", () => {
  assert.equal(etagOf("a"), etagOf("a"));
  assert.notEqual(etagOf("1. e4"), etagOf("1. e4 e5"));
  assert.match(etagOf("x"), /^W\/"/);
});
