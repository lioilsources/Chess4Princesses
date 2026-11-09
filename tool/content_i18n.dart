// Lesson, map and army texts in the catalog languages (assets/i18n/<lang>.json,
// Czech source text → translation; cs + en stay inline in the data files).
// Usage: dart run tool/content_i18n.dart [--check] [--sources]
//   --check    exit 1 when a language misses a text
//   --sources  print every Czech source text with its English, as JSON
// Stale entries (Czech text no longer used) are listed so they can be dropped.
import 'dart:convert';
import 'dart:io';

import 'package:princesschess/core/armies/army.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/lessons/content_catalog.dart';
import 'package:princesschess/core/lessons/curriculum.dart';
import 'package:princesschess/core/lessons/lesson.dart';

void main(List<String> args) {
  final curriculum = Curriculum.fromYaml(File('assets/lessons/index.yaml').readAsStringSync());
  final texts = <LocalizedText>[for (final m in curriculum.modules) m.title];
  for (final m in curriculum.modules) {
    for (final id in m.lessonIds) {
      final l = Lesson.fromYaml(File(Curriculum.lessonAsset(id)).readAsStringSync());
      texts.addAll([l.title, l.story, for (final t in l.tasks) t.prompt]);
    }
  }
  for (final id in Army.baseIds) {
    final a = Army.parse(File(Army.manifestAsset(id)).readAsStringSync());
    texts.add(a.name);
    for (final t in PieceType.values) {
      texts.addAll([a[t].name, a[t].motto, ...a[t].lines.values]);
    }
  }
  final sources = <String, String>{
    for (final t in texts)
      if (t.values['cs'] case final cs? when cs.trim().isNotEmpty) ContentCatalog.normalize(cs): ContentCatalog.normalize(t.values['en'] ?? ''),
  };

  if (args.contains('--sources')) {
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(sources));
    return;
  }

  var missingAny = false;
  for (final lang in ContentCatalog.languages) {
    final f = File(ContentCatalog.asset(lang));
    final have = f.existsSync()
        ? {for (final k in (jsonDecode(f.readAsStringSync()) as Map<String, dynamic>).keys) ContentCatalog.normalize(k)}
        : <String>{};
    final missing = sources.keys.where((s) => !have.contains(s)).toList();
    final stale = have.where((s) => !sources.containsKey(s)).toList();
    missingAny |= missing.isNotEmpty;
    stdout.writeln('content $lang: ${sources.length} texts, ${missing.length} missing, ${stale.length} stale');
    for (final s in missing.take(5)) {
      stdout.writeln('  missing "$s"');
    }
    for (final s in stale.take(5)) {
      stdout.writeln('  stale "$s"');
    }
  }
  if (args.contains('--check') && missingAny) exit(1);
}
