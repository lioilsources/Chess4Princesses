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
/// even itself — the base plate keeps the sides apart. With 14 armies the
/// two lists would be very long, so one list and a "mine / rival" switch.
class ArmyScreen extends ConsumerStatefulWidget {
  const ArmyScreen({super.key});

  @override
  ConsumerState<ArmyScreen> createState() => _ArmyScreenState();
}

class _ArmyScreenState extends ConsumerState<ArmyScreen> {
  bool _mine = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final armies = ref.watch(armiesProvider).value;
    final progress = ref.watch(progressProvider).value ?? const Progress();
    final notifier = ref.read(progressProvider.notifier);
    final current = _mine ? progress.myArmy : progress.rivalArmy;

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: armies == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                        BubbleText(l10n.armies, role: KidRole.title, size: 32, palette: KidPalette.lavender),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Expanded(child: _SideTab(label: l10n.myArmy, palette: KidPalette.lemon, selected: _mine, onTap: () => setState(() => _mine = true))),
                        const SizedBox(width: 12),
                        Expanded(child: _SideTab(label: l10n.rivalArmy, palette: KidPalette.sky, selected: !_mine, onTap: () => setState(() => _mine = false))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (final a in armies.values)
                          _ArmyCard(
                            army: a,
                            mine: _mine,
                            lang: lang,
                            selected: current == a.id,
                            onTap: () => _mine ? notifier.chooseArmies(mine: a.id) : notifier.chooseArmies(rival: a.id),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SideTab extends StatelessWidget {
  const _SideTab({required this.label, required this.palette, required this.selected, required this.onTap});

  final String label;
  final KidPalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: selected ? 1 : .45,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1 : .9,
        child: Center(child: BubbleText(label, role: KidRole.title, size: 22, palette: palette)),
      ),
    ),
  );
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
