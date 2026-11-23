// Board colours from lib/features/board/chess_board.dart and piece_token.dart.
// F1 replaces this with a generator reading the Dart constants (PORT.md).
export const BOARD = {
  light: '#FFFAF0',
  dark: '#C9A3E0',
  frame: '#7B4FA0',
  background: '#FFF4FB',
  selected: 'rgba(255, 201, 77, 0.55)',
  lastMove: 'rgba(255, 213, 92, 0.30)',
  dot: 'rgba(123, 79, 160, 0.55)',
} as const;

export const PLATE = { mine: '#FFC94D', theirs: '#4A3B5C' } as const;

/** '#RRGGBB' → [r, g, b] in 0..1. */
export function rgb01(css: string): [number, number, number] {
  const n = Number.parseInt(css.replace('#', ''), 16);
  return [((n >> 16) & 255) / 255, ((n >> 8) & 255) / 255, (n & 255) / 255];
}
