// Builds the bundled games library (SLAVNE_PARTIE_PLAN §2, §3) from
// downloaded PGN Mentor files and data/games/*.yaml.
//
//   dart run tool/games/build.dart <src>                 write assets/games/**
//   dart run tool/games/build.dart <src> --find "Tal~Smyslov~1959"
//
// <src> holds events/*.pgn and players/*.pgn (see docs/games_schema.md).
// Output: assets/games/p/<pack>.pgn (clean PGN), assets/games/c/<shelf>.json
// (shelf entries pointing into packs) and assets/games/index.json.
import 'dart:convert';
import 'dart:io';

import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/games_lint.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:yaml/yaml.dart';

const _out = 'assets/games';
final _fast = RegExp(
  r"rapid|blitz|bullet|online|simul|blind|exhib|armageddon|960|random|playoff|tie-?break|\btb\b|25'|g/\d|speed|titled|arena|tuesday|banter|lichess|chess\.com|bundesliga",
  caseSensitive: false,
);

class Player {
  Player(this.id, this.name, this.short, this.match);
  final String id;
  final String name;
  final String short;
  final RegExp? match;
}

late final Map<String, Player> _players;

/// "Carlsen,M" → "Magnus Carlsen"; unknown "Last, First" → "First Last".
String canon(String raw) {
  final s = raw.trim();
  for (final p in _players.values) {
    if (p.match != null && p.match!.hasMatch(s)) return p.name;
  }
  final m = RegExp(r'^([^,]+),\s*(.+)$').firstMatch(s);
  if (m == null) return s;
  var first = m[2]!.replaceAll(RegExp(r'\d+$'), '').trim();
  final last = m[1]!.trim();
  if (first.isEmpty) return last;
  // "Vladimir B" → "Vladimir": a bare middle initial only adds noise.
  first = first.replaceAll(RegExp(r'\s+[A-Z]\.?$'), '');
  return first.length <= 2 && !first.endsWith('.') ? '$first. $last' : '$first $last';
}

Player? playerByName(String name) => _players.values.where((p) => p.name == name).firstOrNull;

/// Surname shown on a match card ("Steinitz – Zukertort").
String short(String name) => playerByName(name)?.short ?? name.split(' ').last;

class Raw {
  Raw(this.file, this.g);
  final String file;
  final PgnGame g;
  late final Src? src = clean(file, g);
}

class Src {
  Src(this.file, this.raw, this.record);
  final String file;
  final PgnGame raw;
  final GameRecord record;
  String get id => record.id;
  String get white => record.white;
  String get black => record.black;
  int? get year => record.year;
}

List<PgnGame> readPgn(File f) {
  final bytes = f.readAsBytesSync();
  String text;
  try {
    text = utf8.decode(bytes);
  } on FormatException {
    text = latin1.decode(bytes);
  }
  return parsePgn(text.replaceAll('\r', ''));
}

/// Clean headers: canonical names, neutral event, nothing outside
/// [bundledHeaders]. Moves are rewritten from the replayed record.
Src? clean(String file, PgnGame g, {String? event}) {
  if (g.result == '*') return null;
  final h = <String, String>{};
  for (final k in ['Event', 'Site', 'Date', 'Round', 'White', 'Black', 'Result', 'ECO', 'WhiteElo', 'BlackElo', 'SetUp', 'FEN']) {
    final v = g.headers[k];
    if (v == null || v.isEmpty || v == '?' || (k.endsWith('Elo') && (int.tryParse(v) ?? 0) == 0)) continue;
    h[k] = v;
  }
  h['White'] = canon(h['White'] ?? '?');
  h['Black'] = canon(h['Black'] ?? '?');
  h['Result'] = g.result;
  // Events are named by place and year (PLAN §7): player-file events are
  // full of sponsors, so they are rebuilt from Site and Date.
  final site = h['Site']?.replaceAll(RegExp(r'\s+[A-Z]{3}$'), '').trim();
  final year = (h['Date'] ?? '').split('.').first;
  h['Event'] = event ?? [?site, if (int.tryParse(year) != null) year].join(' ');
  if (h['Event']!.isEmpty) h.remove('Event');
  for (final k in ['Event', 'Site']) {
    final v = h[k];
    if (v != null && bannedHeaderWords.any(v.toLowerCase().contains)) h.remove(k);
  }
  try {
    final r = GameRecord.fromPgn(PgnGame(headers: h, sans: g.sans, result: g.result));
    final pg = PgnGame(headers: h, sans: r.sans, result: g.result);
    return Src(file, pg, r);
  } on Object {
    return null;
  }
}

Map<String, Object?> item(Src s, String pack, int i, {bool tb = false}) => {
  'id': s.id,
  'p': pack,
  'i': i,
  'w': s.white,
  'b': s.black,
  if (s.year != null) 'y': s.year,
  'r': s.raw.result,
  'n': (s.record.length + 1) ~/ 2,
  if (s.record.endsInMate) 'm': 1,
  if ((s.raw.headers['Round'] ?? '').isNotEmpty) 'rd': s.raw.headers['Round'],
  if (tb) 'tb': 1,
};

void writePack(String pack, List<Src> games) {
  File('$_out/p/$pack.pgn').writeAsStringSync(games.map((g) => writePgn(g.raw)).join('\n'));
}

void writeJson(String path, Object data) {
  File(path).writeAsStringSync('${const JsonEncoder.withIndent(' ').convert(data)}\n');
}

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run tool/games/build.dart <src> [--find "W~B~year"]');
    exit(2);
  }
  final src = args.first;
  final py = loadYaml(File('data/games/players.yaml').readAsStringSync()) as YamlMap;
  _players = {};
  for (final p in [...py['champions'] as YamlList, ...py['others'] as YamlList]) {
    final m = p as YamlMap;
    final id = m['id'] as String;
    if (_players.containsKey(id)) continue; // second reign line of the same person
    final name = m['name'] as String;
    _players[id] = Player(
      id,
      name,
      m['short'] as String? ?? name.split(' ').last,
      m['match'] == null ? null : RegExp(m['match'] as String, caseSensitive: false),
    );
  }

  final cfg = loadYaml(File('data/games/sources.yaml').readAsStringSync()) as YamlMap;
  // Raw games; replaying all ~150k is slow, so only candidates get cleaned.
  final pool = <Raw>[];
  final byFile = <String, List<Raw>>{};
  for (final dir in ['events', 'players']) {
    for (final f in Directory('$src/$dir').listSync().whereType<File>().where((f) => f.path.endsWith('.pgn'))) {
      final name = f.uri.pathSegments.last;
      final list = [for (final g in readPgn(f)) Raw(name, g)];
      byFile[name] = list;
      pool.addAll(list);
    }
  }
  final extras = [for (final g in readPgn(File('data/games/pgn/extra.pgn'))) Raw('extra.pgn', g)];
  pool.addAll(extras);

  if (args.length >= 3 && args[1] == '--find') {
    for (final spec in args.skip(2)) {
      stdout.writeln('== $spec');
      for (final s in find(pool, spec)) {
        stdout.writeln(
          '${s.id}  ${s.white} – ${s.black}  ${s.raw.headers['Date']}  ${s.raw.headers['Event']}  r${s.raw.headers['Round'] ?? '?'}  ${s.raw.result}  ${(s.record.length + 1) ~/ 2} moves${s.record.endsInMate ? ' mate' : ''}  [${s.file}]',
        );
      }
    }
    return;
  }

  Directory('$_out/p').createSync(recursive: true);
  Directory('$_out/c').createSync(recursive: true);
  final where = <String, Map<String, Object?>>{}; // id → item already packed

  // --- Zápasy o korunu ---
  final groups = <Map<String, Object?>>[];
  for (final m in (cfg['matches'] as YamlList).cast<YamlMap>()) {
    final year = m['year'] as int;
    final line = m['line'] as String;
    final pack = m['id'] as String? ?? '${line == 'fide' ? 'fide' : 'wch'}-$year';
    final only = (m['only'] as YamlList?)?.cast<String>();
    final event = line == 'fide' ? 'FIDE World Championship $year' : 'World Championship $year';
    final raw = readPgn(File('$src/events/${m['file']}'));
    final games = <Src>[];
    final tbs = <bool>[];
    final seen = <String>{};
    for (final g in raw) {
      final s = clean(m['file'] as String, g, event: event);
      if (s == null || !seen.add(s.id)) continue;
      if (only != null && !only.every((o) => '${s.white} ${s.black}'.toLowerCase().contains(o))) continue;
      games.add(s);
      tbs.add(_fast.hasMatch('${g.headers['Event']} ${g.headers['Round']}'));
    }
    if (games.isEmpty) throw StateError('$pack: no games');
    writePack(pack, games);
    final items = [for (final (i, s) in games.indexed) item(s, pack, i, tb: tbs[i])];
    for (final it in items) {
      where.putIfAbsent(it['id']! as String, () => it);
    }
    final kind = m['kind'] as String? ?? 'match';
    final score = <String, double>{};
    for (final (i, s) in games.indexed) {
      if (tbs[i]) continue;
      final (w, b) = switch (s.raw.result) {
        '1-0' => (1.0, 0.0),
        '0-1' => (0.0, 1.0),
        _ => (.5, .5),
      };
      score[s.white] = (score[s.white] ?? 0) + w;
      score[s.black] = (score[s.black] ?? 0) + b;
    }
    // Who holds the title after the match goes first (ties and tie-breaks:
    // Schlechter–Lasker 1910 is still "Lasker – Schlechter").
    final holder = titleHolder(py, line, year);
    final ranked = score.entries.toList()
      ..sort((a, b) {
        if (a.key == holder) return -1;
        if (b.key == holder) return 1;
        return b.value.compareTo(a.value);
      });
    groups.add({
      'id': pack,
      'line': line,
      'kind': kind,
      'year': year,
      'title': kind == 'tournament' ? '${m['place']} $year' : '${short(ranked[0].key)} – ${short(ranked[1].key)}',
      if (kind == 'match')
        'score': [
          for (final e in ranked.take(2)) {'name': e.key, 'pts': e.value},
        ],
      'items': items,
    });
  }
  writeJson('$_out/c/matches.json', {'v': 1, 'groups': groups});

  // --- Šampionky ---
  final women = cfg['women'] as YamlMap;
  final per = women['perChampion'] as int;
  final womenGroups = <Map<String, Object?>>[];
  final womenGames = <Src>[];
  final champs = [
    for (final p in (py['champions'] as YamlList).cast<YamlMap>())
      if (p['line'] == 'women') p,
  ];
  for (final c in champs) {
    final p = _players[c['id']]!;
    final from = [...extras, for (final f in (women['files'] as YamlList).cast<String>()) ...byFile[f] ?? <Raw>[]];
    final cands = <String, Src>{};
    for (final r in from) {
      final g = r.g;
      if (g.result != '1-0' && g.result != '0-1') continue;
      if (canon(g.header(g.result == '1-0' ? 'White' : 'Black')) != p.name) continue;
      if (_fast.hasMatch('${g.headers['Event']} ${g.headers['Site']}')) continue;
      final s = r.src;
      if (s == null) continue;
      final won = (s.white == p.name && s.raw.result == '1-0') || (s.black == p.name && s.raw.result == '0-1');
      if (!won || s.raw.headers['FEN'] != null || s.record.length < 40) continue;
      final opp = int.tryParse(s.raw.headers[s.white == p.name ? 'BlackElo' : 'WhiteElo'] ?? '');
      if (opp != null && opp < 2350) continue;
      if (_fast.hasMatch('${s.raw.headers['Event']} ${s.raw.headers['Site']}')) continue;
      cands[s.id] = s;
    }
    if (cands.isEmpty) continue;
    double score(Src s) {
      final opp = int.tryParse(s.raw.headers[s.white == p.name ? 'BlackElo' : 'WhiteElo'] ?? '') ?? 2200;
      final y = s.year ?? 0;
      final reign = (c['reigns'] as YamlList).cast<YamlList>().any((r) => y >= (r[0] as int) - 2 && y <= ((r[1] as int?) ?? 9999));
      return (s.record.endsInMate ? 150 : 0) + (reign ? 150 : 0) + opp / 4 - s.record.length;
    }

    final pick = (cands.values.toList()..sort((a, b) => score(b).compareTo(score(a)))).take(per).toList()
      ..sort((a, b) => (a.raw.headers['Date'] ?? '').compareTo(b.raw.headers['Date'] ?? ''));
    final items = <Map<String, Object?>>[];
    for (final s in pick) {
      final had = where[s.id];
      if (had != null) {
        items.add(had);
        continue;
      }
      final it = item(s, 'women', womenGames.length);
      womenGames.add(s);
      where[s.id] = it;
      items.add(it);
    }
    final reigns = [for (final r in (c['reigns'] as YamlList).cast<YamlList>()) '${r[0]}–${r[1] ?? ''}'];
    womenGroups.add({'id': p.id, 'title': p.name, 'n': c['n'], 'reigns': reigns, 'items': items});
  }
  writePack('women', womenGames);
  writeJson('$_out/c/women.json', {'v': 1, 'groups': womenGroups});

  // --- Zlatá šachovnice ---
  final goldenGames = <Src>[];
  final golden = <Map<String, Object?>>[];
  for (final spec in (cfg['golden'] as YamlList).cast<String>()) {
    final hits = find(pool, spec);
    if (hits.length != 1) throw StateError('golden "$spec": ${hits.length} games match');
    final s = hits.first;
    final had = where[s.id];
    if (had != null) {
      golden.add(had);
      continue;
    }
    final it = item(s, 'golden', goldenGames.length);
    goldenGames.add(s);
    where[s.id] = it;
    golden.add(it);
  }
  writePack('golden', goldenGames);
  writeJson('$_out/c/golden.json', {
    'v': 1,
    'groups': [
      {'id': 'golden', 'items': golden},
    ],
  });

  writeJson('$_out/index.json', {
    'v': 1,
    'shelves': [
      {'id': 'golden', 'kind': 'board', 'file': 'c/golden.json'},
      {'id': 'matches', 'kind': 'timeline', 'file': 'c/matches.json'},
      {'id': 'women', 'kind': 'people', 'file': 'c/women.json'},
    ],
  });
  final total = where.length;
  stdout.writeln('games: ${groups.length} matches, ${womenGroups.length} women champions, ${golden.length} golden, $total unique games');
}

/// Champion of [line] right after a title event held in [year].
String? titleHolder(YamlMap py, String line, int year) {
  for (final c in (py['champions'] as YamlList).cast<YamlMap>()) {
    if (c['line'] != line) continue;
    for (final r in (c['reigns'] as YamlList).cast<YamlList>()) {
      final from = r[0] as int, to = r[1] as int?;
      if (from <= year && (to == null || to > year)) return _players[c['id']]!.name;
    }
  }
  return null;
}

/// "White~Black~year[~result][~r=round][~n=moves][~ev=event]" by name substring.
List<Src> find(List<Raw> pool, String spec) {
  final f = spec.split('~').map((s) => s.trim()).toList();
  final w = f[0].toLowerCase(), b = f[1].toLowerCase();
  final y = int.tryParse(f.length > 2 ? f[2] : '');
  // Further fields: a result, r=<round>, n=<moves>, ev=<event substring>.
  final more = f.skip(3);
  final res = more.where(pgnResults.contains).firstOrNull;
  String? opt(String k) => more.where((x) => x.startsWith('$k=')).map((x) => x.substring(k.length + 1)).firstOrNull;
  final rd = opt('r'), n = int.tryParse(opt('n') ?? ''), ev = opt('ev')?.toLowerCase();
  // The same game can sit in a match file and a player file with a slightly
  // different date; moves decide. A match file copy wins, so the golden
  // board shares the match id.
  final out = <String, Src>{};
  bool fromEvent(Src s) => RegExp(r'^(World|Fide|PCA)').hasMatch(s.file);
  for (final r in pool) {
    final g = r.g;
    if (y != null && !(g.headers['Date'] ?? '').startsWith('$y')) continue;
    if (!canon(g.header('White')).toLowerCase().contains(w) || !canon(g.header('Black')).toLowerCase().contains(b)) continue;
    final s = r.src;
    if (s == null) continue;
    if (!s.white.toLowerCase().contains(w) || !s.black.toLowerCase().contains(b)) continue;
    if (y != null && s.year != y) continue;
    if (res != null && s.raw.result != res) continue;
    if (rd != null && s.raw.headers['Round'] != rd) continue;
    if (n != null && (s.record.length + 1) ~/ 2 != n) continue;
    if (ev != null && !'${r.g.headers['Event']}'.toLowerCase().contains(ev)) continue;
    final key = s.record.moves.map((m) => m.uci).join(' ');
    final prev = out[key];
    if (prev == null || (!fromEvent(prev) && fromEvent(s))) out[key] = s;
  }
  return out.values.toList();
}
