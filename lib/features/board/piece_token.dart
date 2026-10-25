import 'package:flutter/material.dart';

import '../../core/armies/army.dart';
import '../../core/chess/types.dart';
import 'piece_glyph.dart';

/// One piece on the board. Placeholder look (PLAN M0): army-coloured disc
/// with the glyph. The base plate tells "mine" (gold) from "theirs" (dark)
/// even when both armies look alike (PLAN §3).
class PieceToken extends StatelessWidget {
  const PieceToken({super.key, required this.piece, required this.army, required this.mine, required this.size});

  final Piece piece;
  final Army army;
  final bool mine;
  final double size;

  @override
  Widget build(BuildContext context) {
    final plate = mine ? const Color(0xFFFFC94D) : const Color(0xFF4A3B5C);
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
          Container(
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
          ),
        ],
      ),
    );
  }
}
