/// Minimal PGN reader/writer for famous and live games (SLAVNE_PARTIE_PLAN §3).
/// Pure Dart. Keeps headers and main-line SAN; drops comments `{}` / `;`,
/// variations `()`, NAGs `$n` and move numbers.
library;

const pgnResults = {'1-0', '0-1', '1/2-1/2', '*'};

/// Engine evaluation of a position, from White's point of view.
class Eval {
  const Eval.cp(int this.cp) : mate = null;
  const Eval.mate(int this.mate) : cp = null;

  /// Centipawns; positive = White is better.
  final int? cp;

  /// Moves to mate; positive = White mates.
  final int? mate;

  /// `[%eval 0.18]` → cp 18, `[%eval #-3]` → mate -3.
  static Eval? parse(String s) {
    if (s.startsWith('#')) {
      final n = int.tryParse(s.substring(1));
      return n == null ? null : Eval.mate(n);
    }
    final v = double.tryParse(s);
    return v == null ? null : Eval.cp((v * 100).round());
  }

  @override
  bool operator ==(Object other) => other is Eval && other.cp == cp && other.mate == mate;
  @override
  int get hashCode => Object.hash(cp, mate);
  @override
  String toString() => mate != null ? '#$mate' : '${cp! / 100}';
}

/// `1:59:50` / `0:05` → duration, or null.
Duration? parseClock(String s) {
  final parts = s.split(':');
  if (parts.isEmpty || parts.length > 3) return null;
  var seconds = 0.0;
  for (final p in parts) {
    final v = double.tryParse(p);
    if (v == null) return null;
    seconds = seconds * 60 + v;
  }
  return Duration(milliseconds: (seconds * 1000).round());
}

/// `1:59:50` style for a duration.
String formatClock(Duration d) {
  final s = d.isNegative ? 0 : d.inSeconds;
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(sec)}' : '${two(m)}:${two(sec)}';
}

final _command = RegExp(r'\[%(clk|eval)\s+([^\]\s]+)\]');

class PgnGame {
  const PgnGame({required this.headers, required this.sans, required this.result, this.clocks = const [], this.evals = const []});

  final Map<String, String> headers;
  final List<String> sans;

  /// Clock of the mover after each ply (`[%clk]`), same length as [sans] or empty.
  final List<Duration?> clocks;

  /// Evaluation after each ply (`[%eval]`), same length as [sans] or empty.
  final List<Eval?> evals;

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
  final clocks = <Duration?>[];
  final evals = <Eval?>[];
  var annotated = false;
  String? result;
  var depth = 0; // variation nesting
  var i = 0;
  final t = movetext;
  while (i < t.length) {
    final c = t[i];
    if (c == '{') {
      final end = t.indexOf('}', i);
      if (end < 0) throw PgnFormatException('Unclosed comment in "${headers['Event'] ?? '?'}"');
      if (depth == 0 && sans.isNotEmpty) {
        for (final m in _command.allMatches(t.substring(i + 1, end))) {
          annotated = true;
          if (m.group(1) == 'clk') clocks[sans.length - 1] = parseClock(m.group(2)!);
          if (m.group(1) == 'eval') evals[sans.length - 1] = Eval.parse(m.group(2)!);
        }
      }
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
      clocks.add(null);
      evals.add(null);
    }
  }
  if (depth != 0) throw PgnFormatException('Unclosed variation in "${headers['Event'] ?? '?'}"');
  return PgnGame(
    headers: Map.unmodifiable(headers),
    sans: List.unmodifiable(sans),
    result: result ?? headers['Result'] ?? '*',
    clocks: annotated ? List.unmodifiable(clocks) : const [],
    evals: annotated ? List.unmodifiable(evals) : const [],
  );
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
