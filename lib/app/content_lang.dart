import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core/lessons/content_catalog.dart';

/// Language key of the lesson/army texts and voice clips for [l]: the
/// language code, plus region or script where the app ships two variants
/// (`pt-BR` / `pt-PT`, `zh-Hans` / `zh-Hant`).
String contentLangFor(Locale l) => switch (l.languageCode) {
  'pt' => l.countryCode == 'PT' ? 'pt-PT' : 'pt-BR',
  'zh' => l.scriptCode == 'Hant' || const {'TW', 'HK', 'MO'}.contains(l.countryCode) ? 'zh-Hant' : 'zh-Hans',
  'no' || 'nn' => 'nb',
  final code => code,
};

extension ContentLangContext on BuildContext {
  /// [contentLangFor] the app's current locale.
  String get contentLang => contentLangFor(Localizations.localeOf(this));
}

/// Loads every `assets/i18n/<lang>.json` into [ContentCatalog]. A missing or
/// broken file only means that language falls back to English.
Future<void> loadContentCatalogs([AssetBundle? bundle]) async {
  final b = bundle ?? rootBundle;
  await Future.wait([
    for (final lang in ContentCatalog.languages)
      () async {
        try {
          final j = jsonDecode(await b.loadString(ContentCatalog.asset(lang))) as Map<String, dynamic>;
          ContentCatalog.add(lang, j.map((k, v) => MapEntry(k, '$v')));
        } on Object catch (e) {
          debugPrint('content catalog $lang: $e');
        }
      }(),
  ]);
}
