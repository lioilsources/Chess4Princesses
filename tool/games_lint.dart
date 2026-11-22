// Lints every bundled game in assets/games/**.pgn (SLAVNE_PARTIE_PLAN §3).
// Usage: dart run tool/games_lint.dart
// Exit code 1 on any error (runs in CI next to lesson_lint).
import 'dart:io';

import 'package:princesschess/core/games/games_lint.dart';

void main() {
  final root = Directory('assets/games');
  if (!root.existsSync()) {
    stderr.writeln('Run from the repo root (assets/games not found).');
    exit(2);
  }
  final files = root.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.pgn')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final seen = <String, String>{};
  final issues = [for (final f in files) ...lintPgnFile(f.path, f.readAsStringSync(), seen)];
  for (final i in issues) {
    stdout.writeln(i);
  }
  stdout.writeln('games_lint: ${seen.length} games in ${files.length} files, ${issues.length} errors');
  if (issues.isNotEmpty) exit(1);
}
