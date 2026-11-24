import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/games_lint.dart';
import 'package:princesschess/core/games/library.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/core/progress/progress.dart';

Map<String, dynamic> _json(String path) => jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

void main() {
  test('bundled index lists the four shelves', () {
    final shelves = parseLibraryIndex(_json('assets/games/index.json'));
    expect(shelves.map((s) => (s.id, s.kind)), [
      ('golden', ShelfKind.board),
      ('matches', ShelfKind.timeline),
      ('women', ShelfKind.people),
      ('challenge', ShelfKind.people),
    ]);
  });

  test('champion and challenger: both players with their wins, the year on every group', () {
    final groups = parseCollection(_json('assets/games/c/challenge.json'));
    expect(groups, hasLength(2));
    for (final g in groups) {
      expect(g.year, isNotNull);
      expect(g.entries, isNotEmpty);
      for (final e in g.entries) {
        final winner = e.result == '1-0' ? e.white : e.black;
        expect(winner, g.title, reason: '${e.white} – ${e.black}');
      }
    }
    // The champion keeps the crown number, the challenger has none yet.
    expect(groups.first.number, isNotNull);
    expect(groups.last.number, isNull);
  });

  test('title matches run from 1886, the title holder first', () {
    final groups = parseCollection(_json('assets/games/c/matches.json'));
    expect(groups.first.year, 1886);
    expect(groups.first.title, 'Steinitz – Zukertort');
    // Drawn 5:5, Lasker kept the title.
    final m1910 = groups.firstWhere((g) => g.id == 'wch-1910a');
    expect(m1910.score.first.name, 'Emanuel Lasker');
    expect(groups.where((g) => g.line == 'fide'), isNotEmpty);
    expect(groups.every((g) => g.entries.isNotEmpty), isTrue);
  });

  test('golden board: 64 games in time order', () {
    final golden = parseCollection(_json('assets/games/c/golden.json')).single.entries;
    expect(golden, hasLength(64));
    final years = [for (final e in golden) e.year!];
    expect(years, orderedEquals([...years]..sort()));
  });

  test('lintLibrary catches an entry pointing at the wrong game', () {
    final games = [for (final g in parsePgn(File('data/games/pgn/extra.pgn').readAsStringSync())) GameRecord.fromPgn(g)];
    final ok = {
      'c/x.json': {
        'groups': [
          {
            'id': 'x',
            'items': [
              for (final (i, g) in games.indexed) {'id': g.id, 'p': 'x', 'i': i},
            ],
          },
        ],
      },
    };
    expect(lintLibrary({'x': games}, ok), isEmpty);
    final wrong = {
      'c/x.json': {
        'groups': [
          {
            'id': 'x',
            'items': [
              {'id': games[0].id, 'p': 'x', 'i': 1},
            ],
          },
        ],
      },
    };
    final issues = lintLibrary({'x': games}, wrong).map((i) => i.message).join('\n');
    expect(issues, contains('x#1 is'));
    expect(issues, contains('is on no shelf'));
  });

  test('points read like a score sheet', () {
    expect(formatPoints(12.5), '12½');
    expect(formatPoints(.5), '½');
    expect(formatPoints(7), '7');
  });

  test('watched games survive a save', () {
    final p = const Progress().withGameWatched('abc').withArmies(mine: 'kingdom');
    final back = Progress.fromJson(jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>);
    expect(back.gamesWatched, {'abc'});
    expect(back.myArmy, 'kingdom');
  });
}
