import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/app/content_lang.dart';
import 'package:princesschess/core/lessons/content_catalog.dart';
import 'package:princesschess/core/lessons/lesson.dart';

void main() {
  tearDown(ContentCatalog.clear);

  test('content language keeps the variants the app ships', () {
    expect(contentLangFor(const Locale('de', 'AT')), 'de');
    expect(contentLangFor(const Locale('pt', 'BR')), 'pt-BR');
    expect(contentLangFor(const Locale('pt', 'PT')), 'pt-PT');
    expect(contentLangFor(const Locale('pt')), 'pt-BR');
    expect(contentLangFor(const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')), 'zh-Hant');
    expect(contentLangFor(const Locale('zh', 'TW')), 'zh-Hant');
    expect(contentLangFor(const Locale('zh', 'CN')), 'zh-Hans');
    expect(contentLangFor(const Locale('no')), 'nb');
  });

  test('inline text, then catalog, then English, then Czech', () {
    const t = LocalizedText({'cs': 'Hurá!', 'en': 'Hooray!'});
    expect(t.of('cs'), 'Hurá!');
    expect(t.of('en'), 'Hooray!');
    expect(t.of('de'), 'Hooray!');
    ContentCatalog.add('de', {' Hurá! ': 'Hurra!'});
    expect(t.of('de'), 'Hurra!');
    expect(const LocalizedText({'cs': 'Jen česky'}).of('de'), 'Jen česky');
  });

  test('every catalog file is a valid JSON map of strings', () {
    for (final lang in ContentCatalog.languages) {
      final f = File(ContentCatalog.asset(lang));
      if (!f.existsSync()) continue;
      final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      expect(j.values.every((v) => v is String && v.trim().isNotEmpty), isTrue, reason: lang);
    }
  });
}
