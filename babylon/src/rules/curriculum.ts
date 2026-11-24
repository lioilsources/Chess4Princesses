// Port of lib/core/lessons/curriculum.dart: assets/lessons/index.yaml, the kingdom
// map with modules as islands (JSON image from scripts/gen-lessons.ts).
import { LocalizedText } from './lesson';

export interface ModuleInfo {
  number: number;
  title: LocalizedText;
  icon: string;
  /** Empty for modules not yet authored ("brzy"). */
  lessonIds: string[];
  /** Character granted after the module (e.g. `queen`). */
  unlock: string | null;
}

export const isAuthored = (m: ModuleInfo): boolean => m.lessonIds.length > 0;

export function parseCurriculum(y: unknown): ModuleInfo[] {
  const modules = (y as { modules: Record<string, unknown>[] }).modules;
  return modules.map((m) => ({
    number: m.module as number,
    title: LocalizedText.parse(m.title),
    icon: String(m.icon ?? 'castle'),
    lessonIds: ((m.lessons as unknown[] | undefined) ?? []).map(String),
    unlock: (m.unlock as string | undefined) ?? null,
  }));
}
