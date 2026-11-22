import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/games/game_record.dart';
import '../../l10n/app_localizations.dart';
import 'games_providers.dart';

/// Síň slávy (SLAVNE_PARTIE_PLAN §1): shelves of famous games. G1 has one
/// shelf with the bundled samples; live games and the library join later.
class HallScreen extends ConsumerWidget {
  const HallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final games = ref.watch(sampleGamesProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), tooltip: l10n.back, onPressed: () => context.pop()),
                  Expanded(child: BubbleText(l10n.hallTitle, role: KidRole.title, size: 30, palette: KidPalette.peach)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(alignment: AlignmentDirectional.centerStart, child: BubbleText(l10n.hallFamous, role: KidRole.title, size: 22, palette: KidPalette.lavender)),
            ),
            Expanded(
              child: switch (games) {
                AsyncData(value: final list) => GridView.extent(
                  padding: const EdgeInsets.all(16),
                  maxCrossAxisExtent: 220,
                  childAspectRatio: .75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [for (final g in list) _GameTile(game: g)],
                ),
                AsyncError(:final error) => Center(child: Text('$error')),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.game});
  final GameRecord game;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 2,
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.push('/game/${game.id}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(game.endsInMate ? Icons.emoji_events_rounded : Icons.auto_stories_rounded, size: 56, color: const Color(0xFFFFB300)),
            const SizedBox(height: 8),
            // Player names are facts in Latin script in every language (PLAN §5).
            Text(game.white, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Text('–'),
            Text(game.black, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            if (game.year case final y?) Text('$y', style: const TextStyle(color: Color(0xFF8D6E63))),
          ],
        ),
      ),
    ),
  );
}
