import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/app/app.dart';
import 'package:princesschess/features/lesson/lesson_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Taps the centre of a board square (white at the bottom).
Future<void> tapSquare(WidgetTester t, String name) async {
  final board = t.getRect(find.byType(ClipRRect).first);
  final f = name.codeUnitAt(0) - 0x61, r = name.codeUnitAt(1) - 0x31;
  final cell = board.width / 8;
  await t.tapAt(Offset(board.left + cell * (f + .5), board.bottom - cell * (r + .5)));
  await t.pump();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('rook lesson: story, move to the star, next task', (t) async {
    t.view.physicalSize = const Size(1170, 2532);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);

    await t.pumpWidget(const ProviderScope(child: PrincessChessApp(locale: Locale('cs'))));
    router.go('/lesson/m02_l01');
    await t.pumpAndSettle();
    expect(find.byType(LessonScreen), findsOneWidget);
    expect(find.text('Hrát!'), findsOneWidget);

    await t.tap(find.text('Hrát!'));
    await t.pumpAndSettle();
    expect(find.text('Doveď Věžku na hvězdu.'), findsOneWidget);

    // Wrong move first: rook cannot go diagonally.
    await tapSquare(t, 'a1');
    await tapSquare(t, 'b2');
    expect(find.text('Zkusíme to znovu!'), findsOneWidget);

    await tapSquare(t, 'a6');
    expect(find.text('Hurá!'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1400));
    await t.pumpAndSettle();
    expect(find.text('Doveď Věžku na hvězdu.'), findsOneWidget);
    router.go('/');
    await t.pumpAndSettle();
  });
}
