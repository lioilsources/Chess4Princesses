import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/games/game_record.dart';
import '../../core/games/pgn.dart';
import '../../core/net/feed_client.dart';

const _enabledKey = 'feed.enabled';
const _liveKey = 'feed.live';
String _roundKey(String t, String r) => 'feed.round.$t.$r';

/// Parent switch "partie z internetu" — off until a parent turns it on
/// (PLAN §6 / §10 q1). Without a configured relay it stays off.
final liveEnabledProvider = AsyncNotifierProvider<LiveEnabled, bool>(LiveEnabled.new);

class LiveEnabled extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    if (!feedConfigured) return false;
    return (await SharedPreferences.getInstance()).getBool(_enabledKey) ?? false;
  }

  Future<void> set(bool on) async {
    state = AsyncData(on && feedConfigured);
    await (await SharedPreferences.getInstance()).setBool(_enabledKey, on);
  }
}

final feedClientProvider = Provider((ref) => FeedClient());

/// Result of a fetch that may fall back to the last cached copy.
class Cached<T> {
  const Cached(this.value, {required this.offline});
  final T value;

  /// True when the network failed and this is the stored copy.
  final bool offline;
}

/// Tournaments on the relay; the last good answer is kept for offline use.
final liveTournamentsProvider = FutureProvider<Cached<List<FeedTournament>>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final body = await ref.read(feedClientProvider).liveJson();
    final list = parseLive(body);
    await prefs.setString(_liveKey, body);
    return Cached(list, offline: false);
  } catch (_) {
    final stored = prefs.getString(_liveKey);
    if (stored == null) rethrow;
    return Cached(parseLive(stored), offline: true);
  }
});

/// Every played game of a stored round has a result (a copy saved mid-round
/// does not). Games without moves never started and do not count.
bool roundComplete(String pgn) {
  final played = parsePgn(pgn).where((g) => g.sans.isNotEmpty).toList();
  return played.isNotEmpty && played.every((g) => g.result != '*');
}

/// Games of one round. A finished round is stored and not fetched again, but
/// only once the stored copy has every result: a copy saved while the round
/// was running is fetched again (it used to stop at the move it was saved on).
final roundGamesProvider = FutureProvider.family<Cached<List<GameRecord>>, (String, FeedRound)>((ref, arg) async {
  final (tour, round) = arg;
  final prefs = await SharedPreferences.getInstance();
  final key = _roundKey(tour, round.id);
  // A running round keeps games without moves yet: they are about to start.
  List<GameRecord> parse(String pgn) => [
    for (final g in parsePgn(pgn))
      if (g.sans.isNotEmpty || (round.state != RoundState.finished && g.result == '*')) GameRecord.fromPgn(g),
  ];
  final stored = prefs.getString(key);
  if (stored != null && round.state == RoundState.finished && roundComplete(stored)) return Cached(parse(stored), offline: false);
  try {
    final pgn = await ref.read(feedClientProvider).roundPgn(tour, round.id);
    final games = parse(pgn);
    await prefs.setString(key, pgn);
    return Cached(games, offline: false);
  } catch (_) {
    if (stored == null) rethrow;
    return Cached(parse(stored), offline: true);
  }
});
