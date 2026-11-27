import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:princesschess/core/armies/army.dart';
import 'package:princesschess/core/chess/types.dart';
import 'package:princesschess/features/battle/battle_overlay.dart';
import 'package:princesschess/features/battle/battle_scene.dart';

void main() {
  testWidgets('battle plays to the end and calls back', (t) async {
    final fairies = Army.parse(await rootBundle.loadString(Army.manifestAsset('fairies')));
    final witches = Army.parse(await rootBundle.loadString(Army.manifestAsset('witches')));
    var done = 0;
    await t.pumpWidget(MaterialApp(
      home: BattleOverlay(
        request: BattleRequest(attackerArmy: fairies, attacker: PieceType.queen, defenderArmy: witches, defender: PieceType.knight),
        onFinished: () => done++,
      ),
    ));
    for (var i = 0; i < 240 && done == 0; i++) {
      // Arena and sprites decode on real I/O, which fake time never waits for.
      if (i < 20) await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await t.pump(const Duration(milliseconds: 16));
    }
    expect(done, 1);
  });

  // Regression: the battle clock ran while the fighters' art was still
  // loading, so on a slow phone the duel was over before anyone appeared.
  for (final pair in const [
    ['fairies', 'witches'],
    ['cats', 'dogs'],
    ['kingdom', 'devils'],
  ]) {
    testWidgets('battle clock waits for the fighters (${pair.join(' vs ')})', (t) async {
      var done = 0;
      await _pumpBattle(t, pair[0], pair[1], () => done++);
      // Fake time only: art that is not cached yet stays unloaded here.
      var waited = 0;
      for (var i = 0; i < 60; i++) {
        await t.pump(const Duration(milliseconds: 16));
        final fighters = _gameOf(t).world.children.whereType<PlaceholderFighter>();
        if (fighters.length < 2 || fighters.any((f) => !f.isLoaded)) {
          waited++;
          expect(_gameOf(t).director.elapsed, 0, reason: 'battle clock ran before the fighters were drawn');
        }
      }
      if (pair[0] != 'fairies') expect(waited, greaterThan(0), reason: 'fresh art should still be loading');
      for (var i = 0; i < 400 && done == 0; i++) {
        if (i < 20) await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
        await t.pump(const Duration(milliseconds: 16));
      }
      expect(done, 1);
    });
  }

  testWidgets('a stalled frame does not skip the battle', (t) async {
    var done = 0;
    await _pumpBattle(t, 'cats', 'dogs', () => done++);
    for (var i = 0; i < 20; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await t.pump(const Duration(milliseconds: 16));
    }
    final before = _gameOf(t).director.elapsed;
    await t.pump(const Duration(seconds: 5));
    expect(_gameOf(t).director.elapsed - before, lessThanOrEqualTo(BattleGame.maxStep + 1e-9));
    expect(done, 0);
  });

  testWidgets('battle still plays when the art never loads', (t) async {
    var done = 0;
    // Armies no earlier test drew, so their art is not cached and never loads in fake time.
    await _pumpBattle(t, 'dinos', 'iceage', () => done++);
    for (var i = 0; i < 400 && done == 0; i++) {
      await t.pump(const Duration(milliseconds: 16));
    }
    expect(done, 1);
  });
}

BattleGame _gameOf(WidgetTester t) => (t.state(find.byType(BattleOverlay)) as dynamic).game as BattleGame;

Future<void> _pumpBattle(WidgetTester t, String attacker, String defender, void Function() onDone) async {
  // Real I/O: a manifest cached by an earlier test never resolves in fake time.
  final a = Army.parse((await t.runAsync(() => rootBundle.loadString(Army.manifestAsset(attacker), cache: false)))!);
  final d = Army.parse((await t.runAsync(() => rootBundle.loadString(Army.manifestAsset(defender), cache: false)))!);
  await t.pumpWidget(
    MaterialApp(
      home: BattleOverlay(
        request: BattleRequest(attackerArmy: a, attacker: PieceType.queen, defenderArmy: d, defender: PieceType.knight),
        onFinished: onDone,
      ),
    ),
  );
}
