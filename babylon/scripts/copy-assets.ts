// npm run assets (runs before dev/build): copies each army's manifest and board
// sprites from the Flutter app unchanged into public/armies/ (gitignored), so the
// web never keeps a second copy in git. Battle poses and arenas come later (F3).
import { cpSync, existsSync, readdirSync, rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const src = fileURLToPath(new URL('../../assets/armies/', import.meta.url));
const dst = fileURLToPath(new URL('../public/armies/', import.meta.url));
rmSync(dst, { recursive: true, force: true });
let n = 0;
for (const id of readdirSync(src)) {
  if (!existsSync(`${src}${id}/manifest.json`)) continue;
  cpSync(`${src}${id}/manifest.json`, `${dst}${id}/manifest.json`);
  if (existsSync(`${src}${id}/sprites`)) cpSync(`${src}${id}/sprites`, `${dst}${id}/sprites`, { recursive: true, filter: (p) => !p.endsWith('.DS_Store') });
  n++;
}
console.log(`copied ${n} armies → ${dst}`);
