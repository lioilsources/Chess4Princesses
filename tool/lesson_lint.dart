// Lints every lesson in assets/lessons: parses, solvable, par reachable.
// Usage: dart run tool/lesson_lint.dart [--verbose]
// Exit code 1 on any error (PLAN §5: mandatory in CI).
import 'dart:io';

import 'package:princesschess/core/lessons/curriculum.dart';
import 'package:princesschess/core/lessons/lint.dart';

void main(List<String> args) {
  final verbose = args.contains('--verbose');
  final root = Directory('assets/lessons');
  final index = File('${root.path}/index.yaml');
  if (!index.existsSync()) {
    stderr.writeln('Run from the repo root (assets/lessons/index.yaml not found).');
    exit(2);
  }
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .where((n) => n.endsWith('.yaml') && n != 'index.yaml')
      .map((n) => n.substring(0, n.length - 5));

  final report = lintCurriculum(index.readAsStringSync(), (id) {
    final f = File(Curriculum.lessonAsset(id));
    return f.existsSync() ? f.readAsStringSync() : null;
  }, lessonFiles: files);

  for (final i in report.issues) {
    if (i.isError || verbose) stdout.writeln(i);
  }
  if (verbose) {
    for (final e in report.solutions.entries) {
      stdout.writeln('  ${e.key.padRight(14)} solved in ${e.value}');
    }
  }
  final errors = report.issues.where((i) => i.isError).length;
  final warnings = report.issues.length - errors;
  stdout.writeln('lesson_lint: ${report.solutions.length} puzzles solved, $errors errors, $warnings warnings');
  exit(report.ok ? 0 : 1);
}
