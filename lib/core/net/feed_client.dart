import 'dart:convert';
import 'dart:io';

/// Base URL of the live games relay (`feed/`, docs/feed.md), e.g.
/// `flutter run --dart-define=FEED_BASE_URL=https://…`. Empty = no live
/// shelf at all, so builds without a deployed relay never touch the network.
const feedBaseUrl = String.fromEnvironment('FEED_BASE_URL');

bool get feedConfigured => feedBaseUrl.isNotEmpty;

enum RoundState { upcoming, ongoing, finished }

class FeedRound {
  const FeedRound({required this.id, required this.n, required this.state, this.startsAt});

  factory FeedRound.fromJson(Map<String, dynamic> j) => FeedRound(
    id: j['id'] as String,
    n: j['n'] as int,
    state: RoundState.values.firstWhere((s) => s.name == j['state'], orElse: () => RoundState.upcoming),
    startsAt: switch (j['startsAt']) {
      final int ms => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
      _ => null,
    },
  );

  final String id;
  final int n;
  final RoundState state;
  final DateTime? startsAt;
}

class FeedTournament {
  const FeedTournament({required this.id, required this.name, required this.emblem, required this.rounds});

  factory FeedTournament.fromJson(Map<String, dynamic> j) => FeedTournament(
    id: j['id'] as String,
    name: Map<String, String>.from(j['name'] as Map),
    emblem: j['emblem'] as String? ?? 'crown',
    rounds: [for (final r in j['rounds'] as List) FeedRound.fromJson(r as Map<String, dynamic>)],
  );

  final String id;
  final Map<String, String> name;
  final String emblem;
  final List<FeedRound> rounds;

  String nameIn(String lang) => name[lang] ?? name['en'] ?? id;
}

/// Parses `/v1/live.json`.
List<FeedTournament> parseLive(String body) {
  final j = jsonDecode(body) as Map<String, dynamic>;
  if (j['v'] != 1) throw const FormatException('Unknown feed version');
  return [for (final t in j['tournaments'] as List) FeedTournament.fromJson(t as Map<String, dynamic>)];
}

/// Plain GETs with no identifiers: no cookies, no accounts, no analytics
/// (PLAN §6). Callers cache what they get so rounds replay offline.
class FeedClient {
  FeedClient({String? baseUrl}) : base = baseUrl ?? feedBaseUrl;

  final String base;

  Future<String> _get(String path) async {
    final client = HttpClient()..userAgent = 'princesschess';
    try {
      final req = await client.getUrl(Uri.parse('$base$path')).timeout(const Duration(seconds: 10));
      final res = await req.close().timeout(const Duration(seconds: 15));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode != 200) throw HttpException('HTTP ${res.statusCode}', uri: Uri.parse('$base$path'));
      return body;
    } finally {
      client.close();
    }
  }

  Future<String> liveJson() => _get('/v1/live.json');

  Future<String> roundPgn(String tournamentId, String roundId) => _get('/v1/t/$tournamentId/$roundId.pgn');
}
