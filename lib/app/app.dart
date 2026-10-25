import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/army/army_screen.dart';
import '../features/battle/battle_demo_screen.dart';
import '../features/lesson/lesson_screen.dart';
import '../features/map/map_screen.dart';
import '../features/map/module_screen.dart';
import '../l10n/app_localizations.dart';

final router = GoRouter(
  // Dev/screenshot hook: flutter run --dart-define=ROUTE=/lesson/m02_l03
  initialLocation: const String.fromEnvironment('ROUTE', defaultValue: '/'),
  routes: [
    GoRoute(path: '/', builder: (_, _) => const MapScreen()),
    GoRoute(path: '/module/:n', builder: (_, s) => ModuleScreen(number: int.parse(s.pathParameters['n']!))),
    GoRoute(path: '/lesson/:id', builder: (_, s) => LessonScreen(lessonId: s.pathParameters['id']!)),
    GoRoute(path: '/army', builder: (_, _) => const ArmyScreen()),
    GoRoute(path: '/battle', builder: (_, _) => const BattleDemoScreen()),
  ],
);

class PrincessChessApp extends StatelessWidget {
  const PrincessChessApp({super.key, this.locale});

  /// Forced locale (tests, parent setting); null = device language.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(colorSchemeSeed: const Color(0xFFEC6FAE), useMaterial3: true);
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(textTheme: KidTextTheme.apply(base.textTheme)),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
