import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../armies/army.dart';
import '../chess/types.dart';
import '../lessons/lesson.dart';

/// Voice-over is pre-generated (PLAN M3): every sentence the app can say is a
/// clip in `assets/voice/<lang>/<key>.mp3`, where the key is derived from the
/// text itself. Edit a prompt and its old clip simply stops matching;
/// `tool/voice_gen.py` fills in whatever is missing.
String voiceKey(String text) => sha1.convert(utf8.encode(normalizeVoiceText(text))).toString().substring(0, 16);

String normalizeVoiceText(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

String voiceAsset(String lang, String text) => 'assets/voice/$lang/${voiceKey(text)}.mp3';

class VoiceLine {
  const VoiceLine(this.lang, this.text, {String? say, required this.source}) : say = say ?? text;

  final String lang;

  /// What the app shows (and hashes).
  final String text;

  /// What the narrator reads; differs when TTS would mangle the display text
  /// ("komnatu e4" → "komnatu É čtyři").
  final String say;

  /// Where the line comes from, for humans reading the manifest.
  final String source;

  String get key => voiceKey(text);

  Map<String, Object> toJson() => {'lang': lang, 'key': key, 'text': normalizeVoiceText(text), 'say': normalizeVoiceText(say), 'source': source};
}

/// ARB keys the lesson screen speaks (feedback bubble + finished card).
const spokenArbKeys = ['wellDone', 'lessonDone', 'taskWon', 'tryAgain', 'botWon', 'promoted', 'lavaWarning', 'opponentThinking', 'dragHint'];

const _files = 'abcdefgh';

/// Tap-square target labels, built the same way as the lesson screen does.
/// [arb] holds the raw ARB strings (`street`, `house`, `room` with `{name}`).
List<VoiceLine> targetLines(String lang, Map<String, String> arb) {
  String fill(String key, String name) => arb[key]!.replaceAll('{name}', name);
  final czech = lang == 'cs';
  const csDigits = ['jedna', 'dva', 'tři', 'čtyři', 'pět', 'šest', 'sedm', 'osm'];
  // A lone "a" or "c" reads as a word; spell Czech letter names out.
  const csLetters = {'a': 'á', 'b': 'bé', 'c': 'cé', 'd': 'dé', 'e': 'é', 'f': 'ef', 'g': 'gé', 'h': 'há'};
  String letter(String f) => czech ? csLetters[f]! : f.toUpperCase();
  return [
    for (final f in _files.split('')) VoiceLine(lang, fill('street', f.toUpperCase()), say: fill('street', letter(f)), source: 'target:$f'),
    for (var r = 1; r <= 8; r++) VoiceLine(lang, fill('house', '$r'), say: czech ? fill('house', csDigits[r - 1]) : null, source: 'target:$r'),
    for (final s in Square.all)
      VoiceLine(lang, fill('room', s.name), say: fill('room', '${letter(s.name[0])} ${czech ? csDigits[s.rank] : s.name[1]}'), source: 'target:${s.name}'),
  ];
}

/// Every line for [lang], deduplicated by text.
List<VoiceLine> collectVoiceLines({
  required String lang,
  required Iterable<Lesson> lessons,
  required Map<String, String> arb,
  required Iterable<Army> armies,
}) {
  final out = <String, VoiceLine>{};
  void add(VoiceLine l) {
    if (l.text.trim().isEmpty) return;
    out.putIfAbsent(normalizeVoiceText(l.text), () => l);
  }

  for (final k in spokenArbKeys) {
    if (arb[k] case final t?) add(VoiceLine(lang, t, source: 'arb:$k'));
  }
  for (final lesson in lessons) {
    add(VoiceLine(lang, lesson.story.of(lang), source: '${lesson.id}:story'));
    for (final (i, t) in lesson.tasks.indexed) {
      add(VoiceLine(lang, t.prompt.of(lang), source: '${lesson.id}#${i + 1}:prompt'));
    }
  }
  targetLines(lang, arb).forEach(add);
  for (final army in armies) {
    for (final t in PieceType.values) {
      final p = army[t];
      add(VoiceLine(lang, p.motto.of(lang), source: '${army.id}.${t.name}:motto'));
      for (final e in p.lines.entries) {
        add(VoiceLine(lang, e.value.of(lang), source: '${army.id}.${t.name}:${e.key}'));
      }
    }
  }
  return out.values.toList();
}
