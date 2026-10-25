import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/voice/voice_lines.dart';
import 'package:princesschess/features/lesson/lesson_screen.dart';
import 'package:princesschess/l10n/app_localizations.dart';

void main() {
  test('key ignores whitespace differences', () {
    expect(voiceKey(' Hurá!\n'), voiceKey('Hurá!'));
    expect(voiceKey('Hurá!'), isNot(voiceKey('Hurá')));
  });

  for (final lang in ['cs', 'en']) {
    test('$lang target lines match what the lesson screen shows', () async {
      final l10n = await AppLocalizations.delegate.load(Locale(lang));
      final arb = (jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, '$v'));
      final texts = targetLines(lang, arb).map((l) => l.text).toSet();
      for (final t in ['a', 'h', '1', '8', 'a1', 'e4', 'h8']) {
        expect(texts, contains(targetLabel(l10n, t)));
      }
    });
  }

  test('every voice line has a clip (run tool/voice_gen.py after editing texts)', () {
    final result = Process.runSync('dart', ['run', 'tool/voice_lines.dart', '--check']);
    expect(result.exitCode, 0, reason: '${result.stdout}');
  });
}
