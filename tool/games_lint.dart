// Lints the bundled games library (SLAVNE_PARTIE_PLAN §3): every PGN pack in
// assets/games/p replays legally, and the shelves in assets/games/c point at
// the right games. Usage: dart run tool/games_lint.dart
// Exit code 1 on any error (runs in CI next to lesson_lint).
import 'dart:convert';
import 'dart:io';

import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/games_lint.dart';
import 'package:princesschess/core/games/pgn.dart';

void main() {
  final root = Directory('assets/games');
  if (!root.existsSync()) {
    stderr.writeln('Run from the repo root (assets/games not found).');
    exit(2);
  }
  final files = Directory('assets/games/p').listSync().whereType<File>().where((f) => f.path.endsWith('.pgn')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final seen = <String, String>{};
  final issues = <GamesLintIssue>[];
  final packs = <String, List<GameRecord>>{};
  for (final f in files) {
    final text = f.readAsStringSync();
    final found = lintPgnFile(f.path, text, seen);
    issues.addAll(found);
    if (found.isEmpty) {
      packs[f.uri.pathSegments.last.replaceAll('.pgn', '')] = [for (final g in parsePgn(text)) GameRecord.fromPgn(g)];
    }
  }
  final collections = {
    for (final f in Directory('assets/games/c').listSync().whereType<File>().where((f) => f.path.endsWith('.json')))
      f.path: jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  };
  if (issues.isEmpty) issues.addAll(lintLibrary(packs, collections));
  for (final i in issues) {
    stdout.writeln(i);
  }
  stdout.writeln('games_lint: ${seen.length} games in ${files.length} packs, ${collections.length} shelves, ${issues.length} errors');
  if (issues.isNotEmpty) exit(1);
}
