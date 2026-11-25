import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/games/game_record.dart';
import '../../core/games/live_config.dart';
import '../../core/games/pgn.dart';
import '../../core/net/feed_client.dart';
import 'replay_controller.dart';

/// Key of a stored round, shared with `roundGamesProvider`.
String liveRoundKey(String tour, String round) => 'feed.round.$tour.$round';

List<GameRecord> parseRoundGames(String pgn) => [
  for (final g in parsePgn(pgn))
    if (g.sans.isNotEmpty || g.result == '*') GameRecord.fromPgn(g),
];

/// Asks the relay for a running round every [livePollEvery] while the live
/// screen is open and the app is in front (PLAN §7). Errors stretch the
/// interval up to [livePollMax]. When every game has a result the round is
/// stored for offline replay and polling stops.
class LiveRoundWatcher {
  LiveRoundWatcher({
    required this.client,
    required this.tournamentId,
    required this.roundId,
    required this.onGames,
    this.onError,
    ReplayTimer? timer,
  }) : _timer = timer ?? Timer.new;

  final FeedClient client;
  final String tournamentId;
  final String roundId;
  final void Function(List<GameRecord> games, DateTime? serverTime) onGames;
  final void Function(Object error)? onError;
  final ReplayTimer _timer;

  String? _etag;
  Timer? _next;
  bool _running = false;
  bool _busy = false;
  bool done = false;
  Duration interval = livePollEvery;

  /// Number of failed polls in a row (the screen shows "offline" after one).
  int failures = 0;

  void start() {
    if (_running || done) return;
    _running = true;
    unawaited(poll());
  }

  /// App went to the background or the screen closed.
  void pause() {
    _running = false;
    _next?.cancel();
    _next = null;
  }

  void resume() => start();

  Future<void> poll() async {
    if (_busy || done) return;
    _busy = true;
    try {
      final f = await client.roundIfChanged(tournamentId, roundId, etag: _etag);
      failures = 0;
      interval = livePollEvery;
      _etag = f.etag ?? _etag;
      if (f.body case final body?) {
        final games = parseRoundGames(body);
        onGames(games, f.serverTime);
        if (games.isNotEmpty && games.every((g) => g.result != GameResult.unfinished)) {
          done = true;
          await (await SharedPreferences.getInstance()).setString(liveRoundKey(tournamentId, roundId), body);
        }
      }
    } catch (e) {
      failures++;
      final longer = interval * 2;
      interval = longer > livePollMax ? livePollMax : longer;
      onError?.call(e);
    } finally {
      _busy = false;
    }
    if (_running && !done) {
      _next?.cancel();
      _next = _timer(interval, () {
        _next = null;
        if (_running) unawaited(poll());
      });
    }
  }

  void dispose() => pause();
}
