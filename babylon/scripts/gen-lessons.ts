// npm run lessons (before dev, build and test): the lesson YAML of the Flutter app
// → src/rules/generated/lessons.json (gitignored), the same tree as JSON. The TS
// parser (rules/lesson.ts) reads it like Lesson.fromYaml reads the YAML.
import { mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { parse } from 'yaml';

const src = fileURLToPath(new URL('../../assets/lessons/', import.meta.url));
const dir = fileURLToPath(new URL('../src/rules/generated/', import.meta.url));

const index = parse(readFileSync(`${src}index.yaml`, 'utf8')) as unknown;
const lessons: Record<string, unknown> = {};
for (const m of readdirSync(src).filter((d) => /^m\d\d$/.test(d)).sort()) {
  for (const f of readdirSync(`${src}${m}`).filter((x) => x.endsWith('.yaml')).sort()) {
    lessons[f.replace(/\.yaml$/, '')] = parse(readFileSync(`${src}${m}/${f}`, 'utf8'));
  }
}
mkdirSync(dir, { recursive: true });
writeFileSync(`${dir}lessons.json`, JSON.stringify({ index, lessons }));
console.log(`wrote ${Object.keys(lessons).length} lessons → ${dir}lessons.json`);
