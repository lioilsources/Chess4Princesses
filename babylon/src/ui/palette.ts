// Board colours: generated from the Dart widgets (generated/palette.ts, npm run gen).
import { DART_PALETTE as P } from './generated/palette';

export const BOARD = {
  light: P.light,
  dark: P.dark,
  frame: P.frame,
  background: P.background,
  selected: P.selected,
  dot: P.dot,
  dotRing: P.dotRing,
  done: P.done,
  star: P.star,
} as const;

export const PLATE = { mine: P.plateMine, theirs: P.plateTheirs } as const;

/** '#RRGGBB' → [r, g, b] in 0..1. */
export function rgb01(css: string): [number, number, number] {
  const n = Number.parseInt(css.replace('#', ''), 16);
  return [((n >> 16) & 255) / 255, ((n >> 8) & 255) / 255, (n & 255) / 255];
}
