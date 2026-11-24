// Seeded LCG, bit-identical to the Dart `Lcg` in tool/dump_vectors.dart.
// Math.imul keeps the multiply exact: a plain `s * 1103515245` passes 2^53 and silently
// rounds, so the sequence drifts from Dart (ints are 64-bit there).
export function lcg(seed: number): () => number {
  let s = Math.trunc(seed) & 0x7fffffff;
  return () => (s = (Math.imul(s, 1103515245) + 12345) & 0x7fffffff);
}

/** next(n) of the Dart Lcg: an integer in [0, n). */
export const nextInt = (rand: () => number, n: number): number => rand() % n;

export const pick = <T>(items: readonly T[], rand: () => number): T => items[nextInt(rand, items.length)];
