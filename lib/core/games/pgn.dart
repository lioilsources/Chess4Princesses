/// Minimal PGN reader/writer for famous and live games (SLAVNE_PARTIE_PLAN §3).
/// Pure Dart. Keeps headers and main-line SAN; drops comments `{}` / `;`,
/// variations `()`, NAGs `$n` and move numbers.
library;

const pgnResults = {'1-0', '0-1', '1/2-1/2', '*'};

class PgnGame {
  const PgnGame({required this.headers, required this.sans, required this.result});

  final Map<String, String> headers;
  final List<String> sans;

  /// From the movetext terminator, falling back to the `Result` header.
  final String result;

  String header(String key) => headers[key] ?? '?';
}

class PgnFormatException implements Exception {
  PgnFormatException(this.message);
  final String message;
  @override
  String toString() => 'PgnFormatException: $message';
}

final _header = RegExp(r'^\[(\w+)\s+"((?:[^"\\]|\\.)*)"\]\s*$');
final _moveNumber = RegExp(r'^\d+\.+');

/// Parses every game in [text].
List<PgnGame> parsePgn(String text) {
  final games = <PgnGame>[];
  var headers = <String, String>{};
  final movetext = StringBuffer();
  var inMoves = false;

  void flush() {
    if (headers.isEmpty && movetext.toString().trim().isEmpty) return;
    games.add(_game(headers, movetext.toString()));
    headers = {};
    movetext.clear();
    inMoves = false;
  }

  for (final raw in text.replaceAll('\r\n', '\n').split('\n')) {
    final line = raw.trimRight();
    if (line.startsWith('%')) continue; // escape line
    final h = _header.firstMatch(line.trim());
    if (h != null && !_insideBraces(movetext.toString())) {
      if (inMoves) flush();
      headers[h.group(1)!] = h.group(2)!.replaceAll(r'\"', '"').replaceAll(r'\\', r'\');
      continue;
    }
    if (line.trim().isEmpty) continue;
    inMoves = true;
    movetext.writeln(line);
  }
  flush();
  return games;
}

bool _insideBraces(String s) => s.lastIndexOf('{') > s.lastIndexOf('}');

PgnGame _game(Map<String, String> headers, String movetext) {
  final sans = <String>[];
  String? result;
  var depth = 0; // variation nesting
  var i = 0;
  final t = movetext;
  while (i < t.length) {
    final c = t[i];
    if (c == '{') {
      final end = t.indexOf('}', i);
      if (end < 0) throw PgnFormatException('Unclosed comment in "${headers['Event'] ?? '?'}"');
      i = end + 1;
    } else if (c == ';') {
      final end = t.indexOf('\n', i);
      i = end < 0 ? t.length : end + 1;
    } else if (c == '(') {
      depth++;
      i++;
    } else if (c == ')') {
      depth--;
      if (depth < 0) throw PgnFormatException('Unbalanced ")" in "${headers['Event'] ?? '?'}"');
      i++;
    } else if (c.trim().isEmpty) {
      i++;
    } else {
      var j = i;
      while (j < t.length && !' \t\n{}();'.contains(t[j])) {
        j++;
      }
      var tok = t.substring(i, j);
      i = j;
      if (depth > 0 || tok.startsWith(r'$')) continue;
      if (pgnResults.contains(tok)) {
        result = tok;
        continue;
      }
      tok = tok.replaceFirst(_moveNumber, '').replaceFirst(RegExp(r'[!?]+$'), '');
      if (tok.isEmpty) continue;
      sans.add(tok);
    }
  }
  if (depth != 0) throw PgnFormatException('Unclosed variation in "${headers['Event'] ?? '?'}"');
  return PgnGame(headers: Map.unmodifiable(headers), sans: List.unmodifiable(sans), result: result ?? headers['Result'] ?? '*');
}

/// Seven Tag Roster first, then the rest in the given order.
const _roster = ['Event', 'Site', 'Date', 'Round', 'White', 'Black', 'Result'];

/// Writes a clean game: headers (only [keep] when given) and bare SAN moves,
/// wrapped at 80 columns.
String writePgn(PgnGame g, {Set<String>? keep, String? result}) {
  final res = result ?? g.result;
  final b = StringBuffer();
  final keys = [
    ..._roster.where(g.headers.containsKey),
    ...g.headers.keys.where((k) => !_roster.contains(k)),
  ].where((k) => keep == null || keep.contains(k));
  for (final k in keys) {
    final v = k == 'Result' ? res : g.headers[k]!;
    b.writeln('[$k "${v.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"]');
  }
  b.writeln();
  final tokens = <String>[];
  for (var i = 0; i < g.sans.length; i++) {
    tokens.add(i.isEven ? '${i ~/ 2 + 1}. ${g.sans[i]}' : g.sans[i]);
  }
  tokens.add(res);
  var line = '';
  for (final tok in tokens) {
    if (line.isNotEmpty && line.length + 1 + tok.length > 80) {
      b.writeln(line);
      line = tok;
    } else {
      line = line.isEmpty ? tok : '$line $tok';
    }
  }
  if (line.isNotEmpty) b.writeln(line);
  return b.toString();
}
