import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/net/feed_client.dart';
import 'package:princesschess/features/games/live_game_screen.dart';
import 'package:princesschess/features/games/live_providers.dart';
import 'package:princesschess/features/settings/settings_screen.dart';
import 'package:princesschess/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/games/live_controller_test.dart' show full, pgnOf;

class _Feed extends FeedClient {
  _Feed() : super(baseUrl: 'http://feed.invalid');
  String body = '';
  int adviceCalls = 0;

  @override
  Future<FeedFetch> roundIfChanged(String tournamentId, String roundId, {String? etag}) async =>
      FeedFetch(body: body, etag: '${body.length}', serverTime: DateTime.now());

  @override
  Future<Advice> advice(String fen) async {
    adviceCalls++;
    return const Advice(depth: 30, lines: [AdviceLine(moves: ['a2a3'], cp: 10)]);
  }
}

/// Timers the test fires by hand; the screen never waits on real time.
class _Timers {
  final pending = <void Function()>[];
  Timer call(Duration d, void Function() f) {
    pending.add(f);
    return _T(() => pending.remove(f));
  }

  void fireAll() {
    for (var i = 0; i < 300 && pending.isNotEmpty; i++) {
      pending.removeAt(0)();
    }
  }
}

class _T implements Timer {
  _T(this._c);
  final void Function() _c;
  @override
  void cancel() => _c();
  @override
  bool get isActive => true;
  @override
  int get tick => 0;
}

Widget _app(Widget home, _Feed feed) => ProviderScope(
  overrides: [feedClientProvider.overrideWithValue(feed)],
  child: MaterialApp(
    locale: const Locale('cs'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('live game: catch-up, skip, a new move without restart, own try and back', (t) async {
    t.view.physicalSize = const Size(1170, 2532);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    final feed = _Feed()..body = pgnOf(20);
    final timers = _Timers();
    await t.pumpWidget(_app(LiveGameScreen(tournamentId: 'wch2026', roundId: 'L3j03TZq', timer: timers.call), feed));
    await t.pump();
    await t.pump();
    expect(find.text('Přeskočit'), findsOneWidget);
    expect(find.text('Živě'), findsOneWidget);
    await t.tap(find.text('Přeskočit'));
    await t.pump();
    expect(find.text('Zkusím to sám'), findsOneWidget);
    expect(find.text(full.headers['White']!), findsOneWidget);

    // The relay has a new move: the poll timer fires, no restart.
    feed.body = pgnOf(21);
    timers.fireAll();
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));

    await t.tap(find.text('Rádce'));
    await t.pump();
    await t.pump();
    expect(feed.adviceCalls, 1);

    await t.tap(find.text('Zkusím to sám'));
    await t.pump();
    expect(find.text('Zpět k partii'), findsOneWidget);
    feed.body = pgnOf(22);
    timers.fireAll();
    await t.pump();
    expect(find.text('Nový tah!'), findsOneWidget);
    await t.tap(find.text('Zpět k partii'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Zpět k partii'), findsNothing);

    await t.tap(find.byTooltip('Kronika'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('Ng6  1:47:17'), findsOneWidget);
    await t.pump();
    expect(find.textContaining('hloubka 30'), findsOneWidget);

    await t.pumpWidget(const SizedBox());
    timers.fireAll();
  });

  testWidgets('settings: classic pieces turn the battle switch off', (t) async {
    await t.pumpWidget(_app(const SettingsScreen(), _Feed()));
    await t.pumpAndSettle();
    expect(find.text('Bitvy při braní'), findsOneWidget);
    await t.tap(find.text('Klasické šachové figurky'));
    await t.pumpAndSettle();
    final battles = t.widget<SwitchListTile>(find.byKey(const ValueKey('settings.battles')));
    expect(battles.onChanged, isNull);
    expect((await SharedPreferences.getInstance()).getBool('settings.classicPieces'), isTrue);
  });

  test('formatClock is what the clock row shows', () => expect(formatClock(const Duration(minutes: 1, seconds: 2)), '01:02'));
}
