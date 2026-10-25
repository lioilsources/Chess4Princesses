import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/chess/types.dart';
import '../../l10n/app_localizations.dart';
import '../board/piece_token.dart';
import 'battle_overlay.dart';
import 'battle_scene.dart';

/// Pick any attacker and defender and watch the battle (BATTLES B1 check,
/// and the "chce ji vidět znovu?" kid test).
class BattleDemoScreen extends ConsumerStatefulWidget {
  const BattleDemoScreen({super.key});

  @override
  ConsumerState<BattleDemoScreen> createState() => _BattleDemoScreenState();
}

class _BattleDemoScreenState extends ConsumerState<BattleDemoScreen> {
  PieceType attacker = PieceType.queen;
  PieceType defender = PieceType.knight;
  int _run = 0;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final armies = ref.watch(boardArmiesProvider).value;
    if (armies == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final (mine, rival) = armies;

    Widget picker(Side side, PieceType value, ValueChanged<PieceType> onPick) => Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (final t in PieceType.values.reversed)
          GestureDetector(
            onTap: () => setState(() => onPick(t)),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: t == value ? const Color(0x55FFC107) : null,
              ),
              child: PieceToken(piece: Piece(side, t), army: side == Side.white ? mine : rival, mine: side == Side.white, size: 52),
            ),
          ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F7),
      appBar: AppBar(title: Text(l10n.battleDemo), leading: BackButton(onPressed: () => context.pop())),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.myArmy, style: Theme.of(context).textTheme.titleLarge),
              picker(Side.white, attacker, (t) => attacker = t),
              const SizedBox(height: 16),
              Text(l10n.rivalArmy, style: Theme.of(context).textTheme.titleLarge),
              picker(Side.black, defender, (t) => defender = t),
              const SizedBox(height: 32),
              Center(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(200, 64)),
                  onPressed: () => setState(() {
                    _run++;
                    _playing = true;
                  }),
                  icon: const Icon(Icons.bolt_rounded, size: 32),
                  label: Text(l10n.start),
                ),
              ),
            ],
          ),
          if (_playing)
            Positioned.fill(
              child: BattleOverlay(
                key: ValueKey(_run),
                request: BattleRequest(attackerArmy: mine, attacker: attacker, defenderArmy: rival, defender: defender, lang: lang),
                onFinished: () => setState(() => _playing = false),
              ),
            ),
        ],
      ),
    );
  }
}
