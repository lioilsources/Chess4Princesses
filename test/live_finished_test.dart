import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/features/games/live_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'live_screen_test.dart' show LiveFeedFake, ManualTimers, liveTestApp, pgnOf;

/// Own file: a second live screen in one isolate waits forever for the armies.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a finished game catches up to the result, then stays open for analysis', (t) async {
    t.view.physicalSize = const Size(1170, 2532);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    final feed = LiveFeedFake()..body = pgnOf(76, result: '1/2-1/2');
    final timers = ManualTimers();
    await t.pumpWidget(liveTestApp(LiveGameScreen(tournamentId: 'wch2026', roundId: 'xLgOJ6cb', timer: timers.call), feed));
    await t.pump();
    await t.pump();
    // Armies and progress load through real async I/O (asset bundle, prefs).
    for (var i = 0; i < 20 && find.text('Přeskočit').evaluate().isEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pump();
    }
    await t.tap(find.text('Přeskočit'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Živě'), findsNothing);
    expect(find.byIcon(Icons.handshake_rounded), findsOneWidget);
    await t.tap(find.byIcon(Icons.check_rounded));
    await t.pump();
    expect(find.text('Zkusím to sám'), findsOneWidget);
    await t.tap(find.text('Rádce'));
    await t.pump();
    await t.pump();
    expect(feed.adviceCalls, 1);
    await t.pumpWidget(const SizedBox());
    timers.fireAll();
  });

}
