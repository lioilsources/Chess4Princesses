import 'dart:convert';

import '../chess/types.dart';
import '../lessons/lesson.dart';

/// `assets/armies/<id>/manifest.json` (PLAN §3). Armies are data: a new pack
/// is a new folder, no code change.
class Army {
  const Army({required this.id, required this.name, required this.primary, required this.accent, required this.dark, required this.pieces, this.battleOverrides = const {}});

  factory Army.fromJson(Map<String, dynamic> j) {
    final pal = j['palette'] as Map<String, dynamic>;
    final pieces = j['pieces'] as Map<String, dynamic>;
    return Army(
      id: j['id'] as String,
      name: LocalizedText.parse(j['name']),
      primary: _hex(pal['primary'] as String),
      accent: _hex(pal['accent'] as String),
      dark: _hex(pal['dark'] as String? ?? '#333333'),
      pieces: {
        for (final t in PieceType.values)
          t: ArmyPiece.fromJson(pieces[_pieceKey(t)] as Map<String, dynamic>? ?? const {}),
      },
      battleOverrides: Map<String, String>.from(j['battle_overrides'] as Map? ?? const {}),
    );
  }

  factory Army.parse(String source) => Army.fromJson(jsonDecode(source) as Map<String, dynamic>);

  /// Army ids shipped in the base app (packs come later, PLAN §3).
  static const baseIds = ['fairies', 'witches'];

  static String manifestAsset(String id) => 'assets/armies/$id/manifest.json';

  final String id;
  final LocalizedText name;

  /// ARGB colours.
  final int primary;
  final int accent;
  final int dark;
  final Map<PieceType, ArmyPiece> pieces;

  /// `"queen>knight": "<clip>"` — unique duel instead of the composed battle.
  final Map<String, String> battleOverrides;

  ArmyPiece operator [](PieceType t) => pieces[t]!;

  static String _pieceKey(PieceType t) => t.name;

  static int _hex(String s) => 0xFF000000 | int.parse(s.replaceFirst('#', ''), radix: 16);
}

class ArmyPiece {
  const ArmyPiece({this.name = const LocalizedText({}), this.motto = const LocalizedText({}), this.lines = const {}, this.sprite});

  factory ArmyPiece.fromJson(Map<String, dynamic> j) => ArmyPiece(
    name: LocalizedText.parse(j['name']),
    motto: LocalizedText.parse(j['motto']),
    lines: {for (final e in (j['lines'] as Map? ?? const {}).entries) '${e.key}': LocalizedText.parse(e.value)},
    sprite: j['sprite'] as String?,
  );

  final LocalizedText name;

  /// One sentence of character ("Ahoj, já jsem…").
  final LocalizedText motto;

  /// Battle one-liners: `attack`, `defeat`, `victory` (BATTLES §4).
  final Map<String, LocalizedText> lines;

  /// Board sprite (256×256) once artwork exists; null → placeholder.
  final String? sprite;
}
