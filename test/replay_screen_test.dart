import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/app/app.dart';
import 'package:princesschess/features/games/hall_screen.dart';
import 'package:princesschess/features/games/replay_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('hall lists the samples, a game opens and switches to the chronicle', (t) async {
    t.view.physicalSize = const Size(1170, 2532);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);

    await t.pumpWidget(const ProviderScope(child: PrincessChessApp(locale: Locale('cs'))));
    router.go('/hall');
    await t.pumpAndSettle();
    expect(find.byType(HallScreen), findsOneWidget);
    expect(find.text('Paul Morphy'), findsOneWidget);

    await t.tap(find.text('Paul Morphy'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));
    expect(find.byType(ReplayScreen), findsOneWidget);

    await t.tap(find.byTooltip('Kronika'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('1. e4'), findsOneWidget);
    await t.tap(find.byTooltip('Tah vpřed'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Tah 1 z 17'), findsOneWidget);

    router.go('/');
    await t.pumpAndSettle();
  });
}
