import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/armies/army.dart';
import '../../core/chess/position.dart';
import '../../core/chess/types.dart';
import 'piece_token.dart';

/// What is being dragged onto a square.
sealed class BoardDrag {
  const BoardDrag();
}

class DragFromSquare extends BoardDrag {
  const DragFromSquare(this.from);
  final Square from;
}

class DragFromTray extends BoardDrag {
  const DragFromTray(this.piece);
  final Piece piece;
}

/// Everything the board draws besides the pieces.
class BoardMarks {
  const BoardMarks({
    this.selected,
    this.dots = const {},
    this.stars = const {},
    this.lava = const {},
    this.glow = const {},
    this.done = const {},
    this.hintMove,
  });

  final Square? selected;

  /// Where the selected piece may go.
  final Set<Square> dots;
  final Set<Square> stars;
  final Set<Square> lava;

  /// Hint glow (targets, movable pieces).
  final Set<Square> glow;

  /// Already-tapped targets.
  final Set<Square> done;
  final (Square, Square)? hintMove;
}

/// A one-shot animation on a square; [tick] changes to replay it.
class SquarePulse {
  const SquarePulse(this.square, this.tick);
  final Square? square;
  final int tick;
}

/// Kid chessboard: plain Flutter widgets (PLAN §2), tap-tap or drag & drop.
class ChessBoard extends StatelessWidget {
  const ChessBoard({
    super.key,
    required this.position,
    required this.armyOf,
    required this.mySide,
    this.marks = const BoardMarks(),
    this.shake = const SquarePulse(null, 0),
    this.burst = const SquarePulse(null, 0),
    this.canDrag,
    this.onTap,
    this.onDragStart,
    this.onDrop,
    this.showCoordinates = true,
  });

  final Position position;
  final Army Function(Side) armyOf;

  /// The player's side, drawn at the bottom.
  final Side mySide;
  final BoardMarks marks;
  final SquarePulse shake;
  final SquarePulse burst;
  final bool Function(Square)? canDrag;
  final void Function(Square)? onTap;
  final void Function(Square)? onDragStart;
  final void Function(BoardDrag, Square)? onDrop;
  final bool showCoordinates;

  static const light = Color(0xFFFFFAF0);
  static const dark = Color(0xFFC9A3E0);
  static const frame = Color(0xFF7B4FA0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final side = min(c.maxWidth, c.maxHeight);
        final label = showCoordinates ? side * .055 : 0.0;
        final cell = (side - label - 8) / 8;
        final files = List.generate(8, (i) => mySide == Side.white ? i : 7 - i);
        final ranks = List.generate(8, (i) => mySide == Side.white ? 7 - i : i);
        final coordStyle = TextStyle(fontSize: label * .7, fontWeight: FontWeight.w700, color: frame);

        return SizedBox(
          width: side,
          height: side,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCoordinates)
                    Column(children: [for (final r in ranks) SizedBox(width: label, height: cell, child: Center(child: Text('${r + 1}', style: coordStyle)))]),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: frame, borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        children: [
                          for (final r in ranks)
                            Row(children: [for (final f in files) _cell(Square.at(f, r), cell)]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (showCoordinates)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: label + 4),
                    for (final f in files) SizedBox(width: cell, height: label, child: Center(child: Text(String.fromCharCode(0x61 + f), style: coordStyle))),
                    const SizedBox(width: 4),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _cell(Square s, double size) {
    final piece = position[s];
    final m = marks;
    final isHintFrom = m.hintMove?.$1 == s, isHintTo = m.hintMove?.$2 == s;

    Widget? pieceWidget;
    if (piece != null) {
      final token = PieceToken(piece: piece, army: armyOf(piece.side), mine: piece.side == mySide, size: size);
      Widget w = token;
      if (shake.square == s) w = _Shake(key: ValueKey('shake${shake.tick}'), child: w);
      if (canDrag?.call(s) ?? false) {
        w = Draggable<BoardDrag>(
          data: DragFromSquare(s),
          onDragStarted: () => onDragStart?.call(s),
          feedback: Transform.scale(scale: 1.25, child: token),
          childWhenDragging: Opacity(opacity: .3, child: token),
          child: w,
        );
      }
      pieceWidget = w;
    }

    return DragTarget<BoardDrag>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (d) => onDrop?.call(d.data, s),
      builder: (context, candidate, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(s),
        child: Container(
          width: size,
          height: size,
          color: s.isLight ? light : dark,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (m.lava.contains(s)) _Lava(size: size),
              if (m.done.contains(s)) Container(color: const Color(0x8869D49A)),
              if (m.selected == s) Container(color: const Color(0x99FFD54F)),
              if (candidate.isNotEmpty) Container(color: const Color(0x55FFFFFF)),
              if (m.glow.contains(s) || isHintFrom || isHintTo) const _Glow(),
              if (m.stars.contains(s)) Icon(Icons.star_rounded, size: size * .8, color: const Color(0xFFFFC107), shadows: const [Shadow(color: Color(0xFFB8860B), blurRadius: 2, offset: Offset(0, 2))]),
              ?pieceWidget,
              if (m.dots.contains(s))
                Container(
                  width: size * (piece == null ? .28 : .9),
                  height: size * (piece == null ? .28 : .9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: piece == null ? const Color(0xAA4CAF50) : null,
                    border: piece == null ? null : Border.all(color: const Color(0xCC4CAF50), width: size * .07),
                  ),
                ),
              if (burst.square == s) _Burst(key: ValueKey('burst${burst.tick}'), size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lava extends StatelessWidget {
  const _Lava({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: RadialGradient(colors: [Color(0xFFFFD54F), Color(0xFFFF7043), Color(0xFFD84315)]),
    ),
    alignment: Alignment.center,
    child: Icon(Icons.local_fire_department_rounded, size: size * .6, color: const Color(0xFFFFF3E0)),
  );
}

/// Pulsing hint ring.
class _Glow extends StatefulWidget {
  const _Glow();

  @override
  State<_Glow> createState() => _GlowState();
}

class _GlowState extends State<_Glow> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: .35, end: 1.0).animate(_c),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF29B6F6), width: 5), color: const Color(0x3329B6F6)),
    ),
  );
}

/// "Figurka zavrtí hlavou" — wrong move feedback.
class _Shake extends StatelessWidget {
  const _Shake({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 450),
    builder: (context, t, child) => Transform.rotate(angle: sin(t * pi * 5) * (1 - t) * .35, child: child),
    child: child,
  );
}

/// Sparkle ring for a good move / collected star.
class _Burst extends StatelessWidget {
  const _Burst({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, t, _) => Opacity(
        opacity: 1 - t,
        child: Transform.scale(
          scale: .5 + t * 1.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFD54F), width: 4)),
              ),
              for (var i = 0; i < 6; i++)
                Transform.translate(
                  offset: Offset(cos(i * pi / 3), sin(i * pi / 3)) * size * .45,
                  child: Icon(Icons.auto_awesome, size: size * .25, color: const Color(0xFFFFC107)),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
