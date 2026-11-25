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

/// A conditional GET: [body] is null when the server said "not modified".
class FeedFetch {
  const FeedFetch({this.body, this.etag, this.serverTime});
  final String? body;
  final String? etag;

  /// The server's clock (`Date` header), to correct the device clock.
  final DateTime? serverTime;

  bool get notModified => body == null;
}

/// One adviser line: UCI moves and the evaluation (White's view).
class AdviceLine {
  const AdviceLine({required this.moves, this.cp, this.mate});

  factory AdviceLine.fromJson(Map<String, dynamic> j) =>
      AdviceLine(moves: [for (final m in j['moves'] as List) m as String], cp: j['cp'] as int?, mate: j['mate'] as int?);

  final List<String> moves;
  final int? cp;
  final int? mate;
}

class Advice {
  const Advice({required this.depth, required this.lines});

  /// Parses `/v1/advice`.
  factory Advice.parse(String body) {
    final j = jsonDecode(body) as Map<String, dynamic>;
    if (j['v'] != 1) throw const FormatException('Unknown advice version');
    return Advice(
      depth: j['depth'] as int? ?? 0,
      lines: [for (final l in j['lines'] as List) AdviceLine.fromJson(l as Map<String, dynamic>)],
    );
  }

  final int depth;
  final List<AdviceLine> lines;
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

  /// GET with `If-None-Match`; a 304 gives a [FeedFetch] without body.
  Future<FeedFetch> _getIfChanged(String path, String? etag) async {
    final client = HttpClient()..userAgent = 'princesschess';
    try {
      final req = await client.getUrl(Uri.parse('$base$path')).timeout(const Duration(seconds: 10));
      if (etag != null) req.headers.set(HttpHeaders.ifNoneMatchHeader, etag);
      final res = await req.close().timeout(const Duration(seconds: 15));
      final body = await res.transform(utf8.decoder).join();
      DateTime? date;
      try {
        final d = res.headers.value(HttpHeaders.dateHeader);
        if (d != null) date = HttpDate.parse(d);
      } on FormatException {
        date = null;
      }
      final tag = res.headers.value(HttpHeaders.etagHeader);
      if (res.statusCode == 304) return FeedFetch(etag: tag ?? etag, serverTime: date);
      if (res.statusCode != 200) throw HttpException('HTTP ${res.statusCode}', uri: Uri.parse('$base$path'));
      return FeedFetch(body: body, etag: tag, serverTime: date);
    } finally {
      client.close();
    }
  }

  Future<String> liveJson() => _get('/v1/live.json');

  /// A running round, asked again and again while the live screen is open.
  Future<FeedFetch> roundIfChanged(String tournamentId, String roundId, {String? etag}) =>
      _getIfChanged('/v1/t/$tournamentId/$roundId.pgn', etag);

  /// Up to three adviser lines for a position of the game.
  Future<Advice> advice(String fen) async => Advice.parse(await _get('/v1/advice?fen=${Uri.encodeQueryComponent(fen)}'));

  Future<String> roundPgn(String tournamentId, String roundId) => _get('/v1/t/$tournamentId/$roundId.pgn');
}
