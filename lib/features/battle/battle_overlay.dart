import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battle_scene.dart';

/// Hosts one [BattleGame] above the board; a new request = a new game.
class BattleOverlay extends StatefulWidget {
  const BattleOverlay({super.key, required this.request, required this.onFinished});

  final BattleRequest request;
  final VoidCallback onFinished;

  @override
  State<BattleOverlay> createState() => _BattleOverlayState();
}

class _BattleOverlayState extends State<BattleOverlay> {
  late final game = BattleGame(widget.request, onFinished: widget.onFinished);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 180),
    builder: (context, t, child) => Opacity(opacity: t, child: child),
    child: GameWidget(game: game),
  );
}
