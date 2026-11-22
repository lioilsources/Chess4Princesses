import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/games/game_record.dart';
import 'package:princesschess/core/games/pgn.dart';
import 'package:princesschess/features/games/replay_controller.dart';

/// Timer stand-in: callbacks run only when the test fires them.
class FakeTimers {
  final pending = <(Duration, void Function())>[];
  Timer call(Duration d, void Function() f) {
    final entry = (d, f);
    pending.add(entry);
    return _FakeTimer(() => pending.remove(entry));
  }

  /// Fires the next pending callback; false when nothing is scheduled.
  bool fire() {
    if (pending.isEmpty) return false;
    pending.removeAt(0).$2();
    return true;
  }
}

class _FakeTimer implements Timer {
  _FakeTimer(this._cancel);
  final void Function() _cancel;
  bool _active = true;
  @override
  void cancel() {
    _active = false;
    _cancel();
  }

  @override
  bool get isActive => _active;
  @override
  int get tick => 0;
}

void main() {
  final games = [for (final g in parsePgn(File('assets/games/samples.pgn').readAsStringSync())) GameRecord.fromPgn(g)];
  final opera = games.first;

  test('story mode plays to the end, stops for battles, ends with mate', () {
    final timers = FakeTimers();
    final c = ReplayController(opera, timer: timers.call)..play();
    var battles = 0;
    var guard = 0;
    while (!c.ended && guard++ < 500) {
      if (c.battle != null) {
        battles++;
        expect(timers.pending, isEmpty, reason: 'no move while a battle runs');
        c.battleFinished();
        continue;
      }
      expect(timers.fire(), isTrue);
    }
    expect(c.ply, opera.length);
    expect(battles, c.battles.length);
    expect(battles, lessThanOrEqualTo(4));
    expect(c.line, ReplayLine.endMate);
  });

  test('chronicle steps without battles and back', () {
    final c = ReplayController(opera, timer: FakeTimers().call)..setChronicle(true);
    for (var i = 0; i < opera.length; i++) {
      c.stepForward();
      expect(c.battle, isNull);
    }
    expect(c.atEnd, isTrue);
    c.stepBack();
    expect(c.ply, opera.length - 1);
    expect(c.position.fen, opera.positions[opera.length - 1].fen);
    c.jumpTo(5);
    expect(c.position.fen, opera.positions[5].fen);
  });

  test('skip to battle lands on the next battle', () {
    final c = ReplayController(games[1], timer: FakeTimers().call);
    final first = c.nextBattlePly!;
    c.skipToBattle();
    expect(c.ply, first + 1);
    expect(c.battle, isNotNull);
  });

  test('resigned game ends with the bow, not mate', () {
    final timers = FakeTimers();
    final c = ReplayController(games[2], timer: timers.call)..play();
    var guard = 0;
    while (!c.ended && guard++ < 500) {
      if (c.battle != null) {
        c.battleFinished();
      } else {
        timers.fire();
      }
    }
    expect(c.line, ReplayLine.endResign);
  });
}
