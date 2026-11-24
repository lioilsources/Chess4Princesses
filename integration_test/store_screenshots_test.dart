// Store screenshots (App Store, Google Play): map, story, lesson, battle,
// armies, hall of fame, golden board, champion and challenger, replay.
// Run by tool/store_screenshots.sh (flutter drive on a simulator); the PNGs
// are written by test_driver/screenshot_driver.dart into SCREENSHOT_DIR.
//
// Languages: --dart-define=SCREENSHOT_LOCALES=cs,en (default cs,en).
// Built without FEED_BASE_URL, so the hall shows no live shelf and the app
// never touches the network.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:princesschess/app/app.dart';
import 'package:princesschess/app/content_lang.dart';

const _locales = String.fromEnvironment('SCREENSHOT_LOCALES', defaultValue: 'cs,en');

/// A child halfway through: islands 0–3 done, Queen island open.
const _progress = {
  'lessonStars': {
    'm00_l01': 3, 'm00_l02': 3, 'm00_l03': 2, //
    'm01_l01': 3, 'm01_l02': 3, 'm01_l03': 2, 'm01_l04': 3, 'm01_l05': 3,
    'm02_l01': 3, 'm02_l02': 2, 'm02_l03': 3, 'm02_l04': 3,
    'm03_l01': 3, 'm03_l02': 3, 'm03_l03': 2, 'm03_l04': 3,
  },
  'unlocked': ['queen', 'pawn', 'rook', 'bishop'],
  'myArmy': 'fairies',
  'rivalArmy': 'witches',
  // The first row of the golden board already has its stickers.
  'gamesWatched': [
    '6569fbdb052b', '479412081d09', 'd0e8da818e76', '1f2bc0d78e0c', //
    'e607939977ff', '5df0d08d0f02', 'dda9802b72d3', 'f62e7d01cb5f',
    '6c5479cffbf0', '7ee906a65e27',
  ],
};

/// Fischer – Spassky, 1972, game 6 (golden board).
const _replayGame = 'ab8e4e410001';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Battles run on Flame's own loop: keep frames flowing, not only on pump.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('store screenshots', (tester) async {
    await loadContentCatalogs();
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();

    // One ProviderScope for all languages: disposing it mid-run tears down
    // audioplayers, which throws on iOS. Nothing is saved on the device.
    SharedPreferences.setMockInitialValues({'progress_v1': jsonEncode(_progress)});
    for (final code in _locales.split(',')) {
      router.go('/');
      await tester.pumpWidget(ProviderScope(child: PrincessChessApp(key: ValueKey(code), locale: Locale(code))));

      Future<void> shot(int n, String scene, {double settle = 1.5}) async {
        await _wait(tester, settle);
        await binding.takeScreenshot('${code}_${n.toString().padLeft(2, '0')}_$scene');
      }

      await shot(1, 'map', settle: 3);

      router.push('/lesson/m02_l03');
      await shot(2, 'story', settle: 3);
      await tester.tap(find.byIcon(Icons.play_arrow_rounded).last);
      await shot(3, 'lesson', settle: 2.5);

      router.go('/');
      await _wait(tester, 1);
      router.push('/battle');
      await _wait(tester, 2);
      await tester.tap(find.byIcon(Icons.bolt_rounded).last);
      await shot(4, 'battle', settle: 1.15);
      await _wait(tester, 4); // let the battle finish

      router.go('/');
      await _wait(tester, 1);
      router.push('/army');
      await shot(5, 'armies', settle: 2.5);

      router.go('/');
      await _wait(tester, 1);
      router.push('/hall');
      await shot(6, 'hall', settle: 2);
      router.push('/hall/golden');
      await shot(7, 'golden', settle: 2);
      router.pop();
      await _wait(tester, 1);
      router.push('/hall/challenge');
      await shot(8, 'challenge', settle: 2);
      router.pop();
      await _wait(tester, 1);

      router.push('/game/$_replayGame');
      await _wait(tester, 2);
      for (var i = 0; i < 12; i++) {
        final next = find.byIcon(Icons.chevron_right_rounded);
        if (next.evaluate().isEmpty) break;
        await tester.tap(next.first);
        await _wait(tester, .4);
      }
      await shot(9, 'replay', settle: 2);

      router.go('/');
      await _wait(tester, 1);
    }
  });
}

Future<void> _wait(WidgetTester tester, double seconds) async {
  final end = DateTime.now().add(Duration(milliseconds: (seconds * 1000).round()));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}
