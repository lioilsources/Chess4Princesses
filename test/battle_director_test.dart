import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/features/battle/battle_director.dart';
import 'package:princesschess/features/battle/clip_atlas.dart';

void main() {
  test('runs all phases within 3 s and hits once', () {
    final d = BattleDirector();
    expect(d.totalTime, lessThanOrEqualTo(3.0));
    final phases = <BattlePhase>[];
    var hits = 0;
    while (d.phase != BattlePhase.done) {
      for (final e in d.update(1 / 60)) {
        if (e == BattleEvent.hit) hits++;
        if (e == BattleEvent.phase) phases.add(d.phase);
      }
    }
    expect(hits, 1);
    expect(phases, [BattlePhase.idle, BattlePhase.attack, BattlePhase.victory, BattlePhase.exit, BattlePhase.done]);
    expect(d.elapsed, closeTo(d.totalTime, 1 / 30));
  });

  test('hit happens before the attack phase ends', () {
    final d = BattleDirector();
    d.update(BattleDirector.enterTime + BattleDirector.idleTime + 0.01);
    expect(d.phase, BattlePhase.attack);
    expect(d.update(ClipTiming.placeholder.hitAt), contains(BattleEvent.hit));
  });

  test('skip only after 0.5 s, then jumps to exit', () {
    final d = BattleDirector();
    d.update(0.4);
    expect(d.skip(), isFalse);
    d.update(0.2);
    expect(d.skip(), isTrue);
    expect(d.phase, BattlePhase.exit);
    d.update(BattleDirector.exitTime + 0.01);
    expect(d.phase, BattlePhase.done);
  });

  test('a big dt still emits every event in order', () {
    final d = BattleDirector();
    final events = d.update(10);
    expect(events.where((e) => e == BattleEvent.hit).length, 1);
    expect(d.phase, BattlePhase.done);
  });

  test('parses pack_sheet.py atlas', () {
    final a = ClipAtlas.parse(File('test/fixtures/attack.json').readAsStringSync());
    expect(a.clip, 'attack');
    expect(a.frames.length, 4);
    expect(a.hitFrame, 2);
    expect(a.fx, 'sparkle');
    expect(a.seconds, closeTo(0.5, 0.01));
    expect(a.hitSeconds, closeTo(0.25, 0.01));
  });
}
