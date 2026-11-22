import 'game_record.dart';
import 'pgn.dart';

/// Words that must not appear in bundled game headers: sponsors and brands
/// (CLAUDE.md "no third-party brands"). Events are named by place and year.
const bannedHeaderWords = [
  'salesforce', 'tata steel', 'norway chess', 'sinquefield', 'grand chess tour', 'freestyle', 'chess.com', 'lichess',
  'champions chess tour', 'meltwater', 'altibox', 'esports', 'red bull', 'total chess',
  'corus', 'hoogovens', 'gibtelecom', 'grenke', 'aeroflot', 'lindores', 'braingames', 'sportaccord', 'ordix', 'avro',
];

/// Headers kept in bundled PGN (PLAN §6: no URLs, no clocks).
const bundledHeaders = {'Event', 'Site', 'Date', 'Round', 'White', 'Black', 'Result', 'ECO', 'WhiteElo', 'BlackElo', 'FEN', 'SetUp'};

class GamesLintIssue {
  GamesLintIssue(this.file, this.message);
  final String file;
  final String message;
  @override
  String toString() => '$file: $message';
}

/// Lints one bundled PGN file: every game replays legally, results agree
/// with the final position, no annotations, no brands, no duplicates
/// (across all files via [seenIds]).
List<GamesLintIssue> lintPgnFile(String file, String text, Map<String, String> seenIds) {
  final out = <GamesLintIssue>[];
  void err(String m) => out.add(GamesLintIssue(file, m));

  final movetext = text.split('\n').where((l) => !l.trimLeft().startsWith('[')).join('\n');
  if (RegExp(r'[{};()$]').hasMatch(movetext)) err('bundled PGN must not contain comments, variations or NAGs');

  final List<PgnGame> games;
  try {
    games = parsePgn(text);
  } on PgnFormatException catch (e) {
    return [...out, GamesLintIssue(file, e.message)];
  }
  if (games.isEmpty) err('no games');
  for (final (i, g) in games.indexed) {
    final who = '#${i + 1} ${g.header('White')} – ${g.header('Black')}';
    for (final k in g.headers.keys) {
      if (!bundledHeaders.contains(k)) err('$who: header "$k" not allowed in bundled PGN');
    }
    for (final v in g.headers.values) {
      final low = v.toLowerCase();
      for (final w in bannedHeaderWords) {
        if (low.contains(w)) err('$who: brand "$w" in headers — name events by place and year');
      }
    }
    if (g.headers['Result'] != null && g.headers['Result'] != g.result) {
      err('$who: Result header ${g.headers['Result']} differs from movetext ${g.result}');
    }
    try {
      final r = GameRecord.fromPgn(g);
      for (final p in r.problems()) {
        err('$who: $p');
      }
      final prev = seenIds[r.id];
      if (prev != null) err('$who: duplicate of $prev (id ${r.id})');
      seenIds[r.id] = '$file $who';
    } on GameFormatException catch (e) {
      err(e.message);
    } on FormatException catch (e) {
      err('$who: ${e.message}');
    }
  }
  return out;
}

/// Lints the shelves against the packs (PLAN §3): every entry points at an
/// existing game whose id matches, the golden board has exactly 64 squares,
/// and every packed game sits on at least one shelf. [packs] maps a pack id
/// to its parsed records; [collections] maps a shelf file to its JSON.
List<GamesLintIssue> lintLibrary(Map<String, List<GameRecord>> packs, Map<String, Map<String, dynamic>> collections) {
  final out = <GamesLintIssue>[];
  final used = <String>{};
  for (final MapEntry(key: file, value: json) in collections.entries) {
    final groups = (json['groups'] as List).cast<Map<String, dynamic>>();
    for (final g in groups) {
      final items = (g['items'] as List).cast<Map<String, dynamic>>();
      if (file.endsWith('golden.json') && items.length != 64) out.add(GamesLintIssue(file, 'golden board has ${items.length} games, needs 64'));
      if (items.isEmpty) out.add(GamesLintIssue(file, 'group ${g['id']} is empty'));
      for (final it in items) {
        final pack = packs[it['p']];
        final i = it['i'] as int;
        if (pack == null || i >= pack.length) {
          out.add(GamesLintIssue(file, '${it['id']}: no game ${it['p']}#$i'));
          continue;
        }
        if (pack[i].id != it['id']) out.add(GamesLintIssue(file, '${it['id']}: ${it['p']}#$i is ${pack[i].id}'));
        used.add('${it['p']}#$i');
      }
    }
  }
  for (final MapEntry(key: p, value: games) in packs.entries) {
    for (var i = 0; i < games.length; i++) {
      if (!used.contains('$p#$i')) out.add(GamesLintIssue('p/$p.pgn', 'game #${i + 1} is on no shelf'));
    }
  }
  return out;
}
