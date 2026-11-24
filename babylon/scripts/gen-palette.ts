// npm run gen: board colours from the Dart widgets → src/ui/generated/palette.ts (committed).
import { mkdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

import { dartPalette, renderPalette } from './dart-palette';

const out = fileURLToPath(new URL('../src/ui/generated/palette.ts', import.meta.url));
mkdirSync(fileURLToPath(new URL('../src/ui/generated/', import.meta.url)), { recursive: true });
writeFileSync(out, renderPalette(dartPalette()));
console.log(`wrote ${out}`);
