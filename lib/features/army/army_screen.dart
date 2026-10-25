import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/armies/army.dart';
import '../../core/chess/types.dart';
import '../../core/progress/progress.dart';
import '../../l10n/app_localizations.dart';
import '../board/piece_token.dart';

/// Pick my army and the rival's (PLAN §1.4). Any army can face any other,
/// even itself — the base plate keeps the sides apart.
class ArmyScreen extends ConsumerWidget {
  const ArmyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final armies = ref.watch(armiesProvider).value;
    final progress = ref.watch(progressProvider).value ?? const Progress();
    final notifier = ref.read(progressProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: armies == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                      BubbleText(l10n.armies, role: KidRole.title, size: 32, palette: KidPalette.lavender),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BubbleText(l10n.myArmy, role: KidRole.title, size: 22, palette: KidPalette.lemon),
                  for (final a in armies.values)
                    _ArmyCard(army: a, mine: true, lang: lang, selected: progress.myArmy == a.id, onTap: () => notifier.chooseArmies(mine: a.id)),
                  const SizedBox(height: 16),
                  BubbleText(l10n.rivalArmy, role: KidRole.title, size: 22, palette: KidPalette.sky),
                  for (final a in armies.values)
                    _ArmyCard(army: a, mine: false, lang: lang, selected: progress.rivalArmy == a.id, onTap: () => notifier.chooseArmies(rival: a.id)),
                ],
              ),
      ),
    );
  }
}

class _ArmyCard extends StatelessWidget {
  const _ArmyCard({required this.army, required this.mine, required this.lang, required this.selected, required this.onTap});

  final Army army;
  final bool mine;
  final String lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: selected ? Color(army.dark) : const Color(0xFFE0D6E8), width: selected ? 5 : 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(army.name.of(lang), style: KidTheme.of(context).style(KidRole.title).copyWith(fontSize: 24, color: Color(army.dark)))),
              if (selected) Icon(Icons.check_circle_rounded, color: Color(army.dark), size: 32),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final t in PieceType.values.reversed)
                  Tooltip(
                    message: army[t].name.of(lang),
                    child: PieceToken(piece: Piece(mine ? Side.white : Side.black, t), army: army, mine: mine, size: 54),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
