/// Translations of lesson, map and army texts beyond the inline `{cs:, en:}`
/// maps in the data files. One file per language, `assets/i18n/<lang>.json`,
/// maps the Czech source text to its translation. Edit a Czech text and its
/// translations simply stop matching (the app falls back to English) until
/// `dart run tool/content_i18n.dart` reports them and they are redone.
///
/// Pure Dart (no Flutter) so the lint and voice tools can use it.
abstract final class ContentCatalog {
  static final Map<String, Map<String, String>> _byLang = {};

  /// Languages with a catalog file, BCP 47 (`pt-BR`, `zh-Hant`). Czech and
  /// English live inline in the data files.
  static const languages = [
    'ar', 'bn', 'ca', 'da', 'de', 'el', 'es', 'fi', 'fr', 'gu', 'he', 'hi', 'hr', 'hu', 'id', 'it', 'ja', 'kn', //
    'ko', 'ml', 'mr', 'ms', 'nb', 'nl', 'or', 'pa', 'pl', 'pt-BR', 'pt-PT', 'ro', 'ru', 'sk', 'sl', 'sv', 'ta', //
    'te', 'th', 'tr', 'uk', 'ur', 'vi', 'zh-Hans', 'zh-Hant',
  ];

  static String asset(String lang) => 'assets/i18n/$lang.json';

  static String normalize(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  static void add(String lang, Map<String, String> entries) {
    final m = _byLang.putIfAbsent(lang, () => {});
    for (final e in entries.entries) {
      m[normalize(e.key)] = e.value;
    }
  }

  static void clear() => _byLang.clear();

  /// Translation of the Czech [source] into [lang], or null.
  static String? lookup(String lang, String? source) => source == null ? null : _byLang[lang]?[normalize(source)];
}
