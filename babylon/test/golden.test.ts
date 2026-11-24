// Replays the golden vectors written by tool/dump_vectors.dart (plan 06, F1).
// Each test/golden/<name>.json is { "cases": [{ "in": …, "out": … }] }. Every file needs a
// replayer below and every replayer a file, so a vector set can't be silently skipped.
// Chess is all discrete (P0): ints, strings and bools must match exactly.
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

import { bot, lessons, moves } from './drivers';

type Case = { in: unknown; out: unknown };

const REPLAY: Record<string, (input: never) => unknown> = {
  'moves.json': moves,
  'bot.json': bot,
  'lessons.json': lessons,
};

const dir = fileURLToPath(new URL('./golden/', import.meta.url));
const files = readdirSync(dir).filter((f) => f.endsWith('.json')).sort();
const EPS = 1e-9;

function same(actual: unknown, expected: unknown, path: string): void {
  if (typeof expected === 'number' && typeof actual === 'number') {
    if (Number.isInteger(expected) ? actual !== expected : Math.abs(actual - expected) > EPS * Math.max(1, Math.abs(expected))) {
      expect.fail(`${path}: ${actual} ≠ ${expected}`);
    }
  } else if (Array.isArray(expected)) {
    if (!Array.isArray(actual) || actual.length !== expected.length) expect.fail(`${path}: ${JSON.stringify(actual)} vs ${JSON.stringify(expected)}`);
    expected.forEach((e, k) => same((actual as unknown[])[k], e, `${path}[${k}]`));
  } else if (expected !== null && typeof expected === 'object') {
    if (actual === null || typeof actual !== 'object') expect.fail(`${path}: not an object`);
    const keys = Object.keys(expected);
    expect(Object.keys(actual as object).sort(), `${path} keys`).toEqual([...keys].sort());
    for (const k of keys) same((actual as Record<string, unknown>)[k], (expected as Record<string, unknown>)[k], `${path}.${k}`);
  } else expect(actual, path).toEqual(expected);
}

describe('golden vectors', () => {
  it('every file has a replayer and every replayer a file', () => {
    expect(files).toEqual(Object.keys(REPLAY).sort());
  });
  for (const f of files) {
    it(f, { timeout: 120_000 }, () => {
      const { cases } = JSON.parse(readFileSync(dir + f, 'utf8')) as { cases: Case[] };
      expect(cases.length).toBeGreaterThan(0);
      cases.forEach((c, k) => same(REPLAY[f](c.in as never), c.out, `${f}#${k} ${JSON.stringify(c.in)}`));
    });
  }
});
