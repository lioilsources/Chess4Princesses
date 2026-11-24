// Store screenshots (App Store, Google Play): map, story, lesson, battle,
// armies, hall of fame, golden board, champion and challenger, replay, live.
// Run by tool/store_screenshots.sh (flutter drive on a simulator); the PNGs
// are written by test_driver/screenshot_driver.dart into SCREENSHOT_DIR.
//
// Languages: --dart-define=SCREENSHOT_LOCALES=cs,en (default cs,en).
// Built without FEED_BASE_URL, so the hall shows no live shelf and the app
// never touches the network: the live scene reads game 1 of the 2026 match
// (24. 11. 2026) from [_TodayFeed], as the relay served it, stopped after
// 23... Nxe5 with the adviser lines the source gave for that position.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:princesschess/app/app.dart';
import 'package:princesschess/app/content_lang.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/net/feed_client.dart';
import 'package:princesschess/features/games/live_providers.dart';

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

/// Plies of today's game shown live: 23... Nxe5, Black in time trouble.
const _livePlies = 46;

/// Relay output for game 1 (feed/test/fixtures/wch2026_r1_feed.pgn).
const _todayPgn = r'''
[Event "World Championship Match 2026, Geneva"]
[Date "2026.11.11"]
[Round "1.1"]
[White "Sindarov, Javokhir"]
[Black "Gukesh D"]
[Result "1/2-1/2"]
[ECO "C67"]
[WhiteElo "2782"]
[BlackElo "2710"]
[TimeControl "40/7200:1800+30"]

1. e4 {[%eval 0.18][%clk 1:59:50]} e5 {[%eval 0.22][%clk 1:59:52]} 2. Nf3
{[%eval 0.18][%clk 1:59:37]} Nc6 {[%eval 0.22][%clk 1:59:45]} 3. Bb5
{[%eval 0.15][%clk 1:59:20]} Nf6 {[%eval 0.17][%clk 1:59:36]} 4. O-O
{[%eval 0.11][%clk 1:58:09]} Nxe4 {[%eval 0.14][%clk 1:59:29]} 5. d4
{[%eval 0.14][%clk 1:57:56]} Nd6 {[%eval 0.16][%clk 1:59:20]} 6. Bxc6
{[%eval 0.07][%clk 1:57:44]} dxc6 {[%eval 0.17][%clk 1:59:12]} 7. dxe5
{[%eval 0.05][%clk 1:57:38]} Nf5 {[%eval 0.17][%clk 1:59:07]} 8. Qxd8+
{[%eval 0.09][%clk 1:57:29]} Kxd8 {[%eval 0.17][%clk 1:59:02]} 9. Rd1+
{[%eval 0.07][%clk 1:57:22]} Ke8 {[%eval 0.15][%clk 1:57:37]} 10. Nc3
{[%eval 0.15][%clk 1:57:14]} Ne7 {[%eval 0.19][%clk 1:54:15]} 11. h3
{[%eval 0.11][%clk 1:56:59]} Ng6 {[%eval 0.12][%clk 1:47:17]} 12. Be3
{[%eval 0.04][%clk 1:56:37]} Be7 {[%eval 0.1][%clk 1:34:45]} 13. Ne4
{[%eval 0.15][%clk 1:54:43]} Bd7 {[%eval 0.06][%clk 1:19:13]} 14. c4
{[%eval -0.04][%clk 1:31:51]} a5 {[%eval 0.06][%clk 1:16:37]} 15. Rd2
{[%eval 0.12][%clk 1:23:12]} a4 {[%eval 0.34][%clk 1:07:23]} 16. Rad1
{[%eval 0.29][%clk 1:19:14]} Be6 {[%eval 0.3][%clk 1:04:54]} 17. b3
{[%eval 0.39][%clk 1:18:08]} Bb4 {[%eval 0.36][%clk 0:28:40]} 18. Re2
{[%eval 0.23][%clk 1:15:48]} h6 {[%eval 0.36][%clk 0:23:30]} 19. Ng3
{[%eval 0.26][%clk 0:57:11]} c5 {[%eval 0.28][%clk 0:16:29]} 20. Nh5
{[%eval 0.29][%clk 0:55:56]} Rg8 {[%eval 0.3][%clk 0:16:18]} 21. g4
{[%eval 0.0][%clk 0:47:20]} Ke7 {[%eval 0.12][%clk 0:15:51]} 22. Ne1
{[%eval 0.0][%clk 0:27:41]} axb3 {[%eval 0.09][%clk 0:15:46]} 23. axb3
{[%eval 0.07][%clk 0:27:22]} Nxe5 {[%eval 0.1][%clk 0:11:06]} 24. f4
{[%eval -0.02][%clk 0:27:10]} g6 {[%eval -0.02][%clk 0:10:22]} 25. Ng3
{[%eval 0.0][%clk 0:27:00]} Nc6 {[%eval 0.0][%clk 0:09:26]} 26. f5
{[%eval 0.0][%clk 0:25:48]} gxf5 {[%eval 0.0][%clk 0:09:20]} 27. Nxf5+
{[%eval 0.0][%clk 0:25:31]} Kf6 {[%eval 0.0][%clk 0:08:39]} 28. Rf2
{[%eval 0.0][%clk 0:20:12]} Rgd8 {[%eval 0.0][%clk 0:08:16]} 29. Nd3
{[%eval 0.0][%clk 0:19:17]} Bxf5 {[%eval 0.0][%clk 0:07:13]} 30. Rxf5+
{[%eval 0.0][%clk 0:19:02]} Kg7 {[%eval 0.0][%clk 0:07:09]} 31. Rh5
{[%eval 0.0][%clk 0:18:53]} Bc3 {[%eval 0.0][%clk 0:05:42]} 32. Bxh6+
{[%eval 0.0][%clk 0:17:20]} Kg8 {[%eval 0.0][%clk 0:05:30]} 33. Rg5+
{[%eval 0.0][%clk 0:16:54]} Kh7 {[%eval 0.0][%clk 0:05:24]} 34. Rh5
{[%eval 0.0][%clk 0:16:51]} Kg8 {[%eval 0.0][%clk 0:04:49]} 35. Rg5+
{[%eval 0.0][%clk 0:16:22]} Kh7 {[%eval 0.0][%clk 0:04:44]} 36. Rh5
{[%eval 0.0][%clk 0:16:16]} Kg8 {[%eval 0.0][%clk 0:04:40]} 37. Rg5+
{[%eval 0.0][%clk 0:16:03]} Kh7 {[%eval 0.0][%clk 0:06:38]} 38. Rh5
{[%eval 0.0][%clk 0:15:51]} Kg8 {[%eval 0.0][%clk 0:06:32]} 1/2-1/2
''';

/// Today's game as a running round, cut after [_livePlies].
class _TodayFeed extends FeedClient {
  _TodayFeed() : super(baseUrl: 'http://feed.invalid');

  @override
  Future<FeedFetch> roundIfChanged(String tournamentId, String roundId, {String? etag}) async {
    final g = parsePgn(_todayPgn).single;
    final b = StringBuffer();
    for (final e in g.headers.entries) {
      b.writeln('[${e.key} "${e.key == 'Result' ? '*' : e.value}"]');
    }
    // The move came 1 min 40 s ago.
    b.writeln('[LastMoveAt "${DateTime.now().millisecondsSinceEpoch ~/ 1000 - 100}"]');
    b.writeln();
    for (var i = 0; i < _livePlies; i++) {
      if (i.isEven) b.write('${i ~/ 2 + 1}. ');
      b.write('${g.sans[i]} {[%clk ${formatClock(g.clocks[i]!)}][%eval ${g.evals[i]}]} ');
    }
    b.writeln('*');
    return FeedFetch(body: b.toString(), etag: 'today', serverTime: DateTime.now());
  }

  /// Lichess cloud evaluation of the position after 23... Nxe5 (depth 32).
  @override
  Future<Advice> advice(String fen) async => const Advice(
    depth: 32,
    lines: [
      AdviceLine(moves: ['e1c2', 'a8d8', 'd1d8', 'e7d8', 'c2b4', 'c5b4', 'f2f4', 'e5c6', 'f4f5', 'e6d7'], cp: 3),
      AdviceLine(moves: ['e3f4', 'e5c6', 'e1d3', 'a8d8', 'f4c7', 'd8d7', 'c7b6', 'c6d4', 'e2e3', 'd4b3'], cp: 0),
      AdviceLine(moves: ['f2f4', 'g7g6', 'h5g3', 'e5c6', 'e1d3', 'a8d8', 'f4f5', 'g6f5', 'g3f5', 'e7f6'], cp: -8),
    ],
  );
}

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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [feedClientProvider.overrideWithValue(_TodayFeed())],
          child: PrincessChessApp(key: ValueKey(code), locale: Locale(code)),
        ),
      );

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
      router.push('/live/wch2026/xLgOJ6cb/0');
      await _wait(tester, 1.5);
      final skip = find.byIcon(Icons.fast_forward_rounded);
      if (skip.evaluate().isNotEmpty) await tester.tap(skip.first);
      await _wait(tester, 1);
      await tester.tap(find.byIcon(Icons.lightbulb_rounded).first);
      await shot(10, 'live', settle: 2);

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
