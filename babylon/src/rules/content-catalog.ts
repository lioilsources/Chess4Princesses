// Port of lib/core/lessons/content_catalog.dart: translations of lesson, map and
// army texts, assets/i18n/<lang>.json, keyed by the Czech source text.

/** Languages with a catalog file; Czech and English live inline in the data files. */
export const CATALOG_LANGUAGES = [
  'ar', 'bn', 'ca', 'da', 'de', 'el', 'es', 'fi', 'fr', 'gu', 'he', 'hi', 'hr', 'hu', 'id', 'it', 'ja', 'kn',
  'ko', 'ml', 'mr', 'ms', 'nb', 'nl', 'or', 'pa', 'pl', 'pt-BR', 'pt-PT', 'ro', 'ru', 'sk', 'sl', 'sv', 'ta',
  'te', 'th', 'tr', 'uk', 'ur', 'vi', 'zh-Hans', 'zh-Hant',
] as const;

const byLang = new Map<string, Map<string, string>>();

export const normalize = (text: string): string => text.trim().replace(/\s+/g, ' ');

export const ContentCatalog = {
  add(lang: string, entries: Record<string, string>): void {
    let m = byLang.get(lang);
    if (!m) byLang.set(lang, (m = new Map()));
    for (const [k, v] of Object.entries(entries)) m.set(normalize(k), v);
  },
  clear(): void { byLang.clear(); },
  /** Translation of the Czech source into lang, or null. */
  lookup(lang: string, source: string | undefined): string | null {
    return source === undefined ? null : byLang.get(lang)?.get(normalize(source)) ?? null;
  },
};
