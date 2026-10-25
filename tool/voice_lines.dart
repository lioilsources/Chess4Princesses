// Writes assets/voice/lines.json: every sentence the app speaks, per language,
// with the clip key the app looks up. Input for tool/voice_gen.py.
// Usage: dart run tool/voice_lines.dart [--check]
//   --check  exit 1 when a clip is missing (CI, once clips are committed)
import 'dart:convert';
import 'dart:io';

import 'package:princesschess/core/armies/army.dart';
import 'package:princesschess/core/lessons/curriculum.dart';
import 'package:princesschess/core/lessons/lesson.dart';
import 'package:princesschess/core/voice/voice_lines.dart';

const langs = ['cs', 'en'];

void main(List<String> args) {
  final curriculum = Curriculum.fromYaml(File('assets/lessons/index.yaml').readAsStringSync());
  final lessons = [
    for (final m in curriculum.modules)
      for (final id in m.lessonIds) Lesson.fromYaml(File(Curriculum.lessonAsset(id)).readAsStringSync()),
  ];
  final armies = [for (final id in Army.baseIds) Army.parse(File(Army.manifestAsset(id)).readAsStringSync())];

  final all = <VoiceLine>[];
  for (final lang in langs) {
    final arb = (jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, '$v'));
    all.addAll(collectVoiceLines(lang: lang, lessons: lessons, arb: arb, armies: armies));
  }

  final out = File('assets/voice/lines.json')..createSync(recursive: true);
  out.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert([for (final l in all) l.toJson()])}\n');

  final missing = all.where((l) => !File(voiceAsset(l.lang, l.text)).existsSync()).toList();
  for (final lang in langs) {
    final n = all.where((l) => l.lang == lang).length;
    final m = missing.where((l) => l.lang == lang).length;
    stdout.writeln('voice $lang: $n lines, ${n - m} clips, $m missing');
  }
  if (args.contains('--check') && missing.isNotEmpty) {
    for (final l in missing.take(20)) {
      stdout.writeln('  missing ${l.lang}/${l.key}  ${l.source}  "${l.text}"');
    }
    exit(1);
  }
}
