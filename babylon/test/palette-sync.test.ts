// The committed palette must equal what the Dart widgets say right now.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { expect, it } from 'vitest';

import { dartPalette, renderPalette } from '../scripts/dart-palette';

it('src/ui/generated/palette.ts is in sync with the Dart board colours (npm run gen)', () => {
  const committed = readFileSync(fileURLToPath(new URL('../src/ui/generated/palette.ts', import.meta.url)), 'utf8');
  expect(committed).toBe(renderPalette(dartPalette()));
});
