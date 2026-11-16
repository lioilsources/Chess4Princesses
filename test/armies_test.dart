import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/armies/army.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/core/lessons/lesson.dart';

/// No fallback to cs: the text must exist in [lang] itself.
String _in(LocalizedText? t, String lang) => t?.values[lang] ?? '';

/// Every army in `assets/armies/` is complete: in [Army.baseIds], six
/// sprites, a valid manifest with cs + en texts, and bundled in pubspec.
void main() {
  final dirs = Directory('assets/armies').listSync().whereType<Directory>().map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last).toSet();
  final pubspec = File('pubspec.yaml').readAsStringSync();

  test('baseIds match the army folders', () {
    expect(Army.baseIds.toSet(), dirs);
    expect(Army.baseIds.toSet().length, Army.baseIds.length, reason: 'duplicate id');
  });

  for (final id in Army.baseIds) {
    test('army $id', () {
      final army = Army.parse(File(Army.manifestAsset(id)).readAsStringSync());
      expect(army.id, id);
      for (final lang in ['cs', 'en']) {
        expect(_in(army.name, lang), isNotEmpty, reason: '$id name.$lang');
      }
      expect(pubspec, contains('- assets/armies/$id/\n'));
      expect(pubspec, contains('- assets/armies/$id/sprites/\n'));
      if (army.arenaAsset case final a?) expect(File(a).existsSync(), isTrue, reason: a);

      final names = <String>{};
      for (final t in PieceType.values) {
        final p = army[t];
        final sprite = army.spriteAsset(t);
        expect(sprite, isNotNull, reason: '$id.${t.name} sprite');
        expect(File(sprite!).existsSync(), isTrue, reason: sprite);
        for (final lang in ['cs', 'en']) {
          expect(_in(p.name, lang), isNotEmpty, reason: '$id.${t.name} name.$lang');
          expect(_in(p.motto, lang), isNotEmpty, reason: '$id.${t.name} motto.$lang');
          for (final line in ['attack', 'defeat', 'victory']) {
            expect(_in(p.lines[line], lang), isNotEmpty, reason: '$id.${t.name} $line.$lang');
          }
        }
        expect(names.add(p.name.of('cs')), isTrue, reason: '$id: two pieces named ${p.name.of('cs')}');
        final stand = File(army.standAsset(t) ?? '');
        if (stand.existsSync()) expect(pubspec, contains('- assets/armies/$id/stand/\n'));
        // Bundled poses: a pose folder must be listed, or the app can't load it.
        final poses = Directory('assets/armies/$id/battle/${t.name}');
        if (poses.existsSync()) expect(pubspec, contains('- ${poses.path}/\n'));
      }
    });
  }
}
