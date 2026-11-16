import 'dart:convert';

import '../chess/types.dart';
import '../lessons/lesson.dart';

/// `assets/armies/<id>/manifest.json` (PLAN §3). Armies are data: a new pack
/// is a new folder, no code change.
class Army {
  const Army({required this.id, required this.name, required this.primary, required this.accent, required this.dark, required this.pieces, this.arena, this.battleOverrides = const {}});

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
      arena: j['arena'] as String?,
      battleOverrides: Map<String, String>.from(j['battle_overrides'] as Map? ?? const {}),
    );
  }

  factory Army.parse(String source) => Army.fromJson(jsonDecode(source) as Map<String, dynamic>);

  /// Army ids shipped in the app, in picker order (packs/IAP later, PLAN §6).
  /// The `*_toy` armies and the ten after them come from Archion
  /// (Prompts/04-HANDOFF-archion-armies.md); test/armies_test.dart keeps
  /// this list in sync with `assets/armies/`.
  static const baseIds = [
    'fairies', 'witches', 'kingdom', 'devils', 'fairies_toy', 'witches_toy', 'bees', 'hornets', //
    'dinos', 'iceage', 'cats', 'dogs', 'fruit', 'veggies',
  ];

  static String manifestAsset(String id) => 'assets/armies/$id/manifest.json';

  final String id;
  final LocalizedText name;

  /// ARGB colours.
  final int primary;
  final int accent;
  final int dark;
  final Map<PieceType, ArmyPiece> pieces;

  /// Battle background relative to the army folder (portrait); null → gradient.
  final String? arena;

  String? get arenaAsset => arena == null ? null : 'assets/armies/$id/$arena';

  /// `"queen>knight": "<clip>"` — unique duel instead of the composed battle.
  final Map<String, String> battleOverrides;

  ArmyPiece operator [](PieceType t) => pieces[t]!;

  /// Battle key pose of [t] (`tool/art/pose_gen.py`); may not exist yet.
  String poseAsset(PieceType t, String pose) => 'assets/armies/$id/battle/${t.name}/$pose.png';

  /// Standing art for the arena without the board base: the sprite file
  /// under `stand/` instead of `sprites/` (optional; the battle falls back
  /// to [spriteAsset]).
  String? standAsset(PieceType t) => switch (pieces[t]!.sprite) {
    final s? when s.startsWith('sprites/') => 'assets/armies/$id/stand/${s.substring(8)}',
    _ => null,
  };

  /// Character art for [t] (`assets/armies/<id>/<sprite>`), null → placeholder.
  String? spriteAsset(PieceType t) => switch (pieces[t]!.sprite) {
    final s? => 'assets/armies/$id/$s',
    null => null,
  };

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

  /// Character art relative to the army folder (512×512, feet at the bottom);
  /// null → placeholder disc.
  final String? sprite;
}
