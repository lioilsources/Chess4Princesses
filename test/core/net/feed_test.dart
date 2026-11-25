import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/net/feed_client.dart';
import 'package:princesschess/features/games/live_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _live = '{"v":1,"tournaments":[{"id":"wch2026","name":{"cs":"Zápas o mistra světa 2026, Ženeva","en":"World Championship Match 2026, Geneva"},'
    '"emblem":"crown","rounds":[{"id":"xLgOJ6cb","n":1,"startsAt":1795528800000,"state":"finished"},{"id":"L3j03TZq","n":2,"startsAt":null,"state":"upcoming"}]}]}';

/// What the Worker serves for a round (see feed/test/clean.test.ts).
const _round = '''[Event "World Championship Match 2026, Geneva"]
[Round "1"]
[White "Gukesh D"]
[Black "Sindarov, Javokhir"]
[Result "1/2-1/2"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 1/2-1/2

[Event "World Championship Match 2026, Geneva"]
[White "A"]
[Black "B"]
[Result "*"]

*
''';

class FakeFeed extends FeedClient {
  FakeFeed({this.fail = false}) : super(baseUrl: 'http://feed.invalid');
  bool fail;
  int calls = 0;

  @override
  Future<String> liveJson() async {
    calls++;
    if (fail) throw Exception('offline');
    return _live;
  }

  @override
  Future<String> roundPgn(String tournamentId, String roundId) async {
    calls++;
    if (fail) throw Exception('offline');
    return _round;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('parseLive reads tournaments and rounds', () {
    final t = parseLive(_live).single;
    expect(t.nameIn('cs'), startsWith('Zápas'));
    expect(t.nameIn('de'), startsWith('World'));
    expect(t.rounds.map((r) => r.state), [RoundState.finished, RoundState.upcoming]);
    expect(t.rounds.first.startsAt!.toUtc().hour, 14);
    expect(() => parseLive('{"v":2,"tournaments":[]}'), throwsFormatException);
  });

  test('live list falls back to the stored copy when offline', () async {
    final feed = FakeFeed();
    var c = ProviderContainer(overrides: [feedClientProvider.overrideWithValue(feed)]);
    expect((await c.read(liveTournamentsProvider.future)).offline, isFalse);
    c.dispose();
    feed.fail = true;
    c = ProviderContainer(overrides: [feedClientProvider.overrideWithValue(feed)]);
    final cached = await c.read(liveTournamentsProvider.future);
    expect(cached.offline, isTrue);
    expect(cached.value.single.id, 'wch2026');
    c.dispose();
  });

  test('finished round is fetched once, empty games are skipped', () async {
    final feed = FakeFeed();
    final round = parseLive(_live).single.rounds.first;
    var c = ProviderContainer(overrides: [feedClientProvider.overrideWithValue(feed)]);
    final games = (await c.read(roundGamesProvider(('wch2026', round)).future)).value;
    expect(games.single.white, 'Gukesh D');
    expect(games.single.length, 6);
    c.dispose();
    c = ProviderContainer(overrides: [feedClientProvider.overrideWithValue(feed)]);
    await c.read(roundGamesProvider(('wch2026', round)).future);
    expect(feed.calls, 1);
    c.dispose();
  });

  test('a copy stored mid-round is fetched again once the round is finished', () async {
    // Saved at move 3 while the round was running (result *).
    SharedPreferences.setMockInitialValues({'feed.round.wch2026.xLgOJ6cb': '[White "Gukesh D"]\n[Black "Sindarov, Javokhir"]\n[Result "*"]\n\n1. e4 e5 2. Nf3 *\n'});
    final feed = FakeFeed();
    final round = parseLive(_live).single.rounds.first;
    final c = ProviderContainer(overrides: [feedClientProvider.overrideWithValue(feed)]);
    final games = (await c.read(roundGamesProvider(('wch2026', round)).future)).value;
    expect(feed.calls, 1);
    expect(games.single.length, 6);
    expect(roundComplete(_round), isTrue);
    c.dispose();
  });

  test('without a relay the live switch stays off', () async {
    final c = ProviderContainer();
    expect(feedConfigured, isFalse);
    await c.read(liveEnabledProvider.notifier).set(true);
    expect(c.read(liveEnabledProvider).value, isFalse);
    c.dispose();
  });
}
