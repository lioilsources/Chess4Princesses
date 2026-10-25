import 'package:flutter/material.dart';

import '../../core/armies/army.dart';
import '../../core/chess/types.dart';
import 'piece_glyph.dart';

/// One piece on the board: the army's character standing on a base plate.
/// The plate tells "mine" (gold) from "theirs" (dark) even when both armies
/// look alike (PLAN §3). Without art, an army-coloured disc with the glyph.
class PieceToken extends StatelessWidget {
  const PieceToken({super.key, required this.piece, required this.army, required this.mine, required this.size});

  final Piece piece;
  final Army army;
  final bool mine;
  final double size;

  @override
  Widget build(BuildContext context) {
    final plate = mine ? const Color(0xFFFFC94D) : const Color(0xFF4A3B5C);
    final sprite = army.spriteAsset(piece.type);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: size * .04,
            child: Container(
              width: size * .78,
              height: size * .2,
              decoration: BoxDecoration(color: plate, borderRadius: BorderRadius.circular(size)),
            ),
          ),
          if (sprite != null)
            Positioned(
              left: size * .02,
              right: size * .02,
              top: 0,
              bottom: size * .07,
              child: Transform.flip(
                // Rival characters face the other way, towards "my" side.
                flipX: !mine,
                child: Image.asset(
                  sprite,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, _, _) => _disc(),
                ),
              ),
            )
          else
            _disc(),
        ],
      ),
    );
  }

  Widget _disc() => Container(
    width: size * .78,
    height: size * .78,
    margin: EdgeInsets.only(bottom: size * .1),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color(army.primary),
      border: Border.all(color: Color(army.accent), width: size * .06),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .18), blurRadius: size * .06, offset: Offset(0, size * .04))],
    ),
    alignment: Alignment.center,
    child: Text(
      pieceGlyph(piece.type),
      style: TextStyle(fontSize: size * .6, height: 1.0, color: Color(army.dark)),
    ),
  );
}
