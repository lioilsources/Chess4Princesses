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
}
