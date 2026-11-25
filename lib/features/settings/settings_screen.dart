import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/settings/settings.dart';
import '../../l10n/app_localizations.dart';
import '../board/piece_token.dart';
import '../games/library_screens.dart';
import '../../core/chess/types.dart';

/// Parent settings: battles and classic pieces (Prompts/06-ZIVY_PRENOS_PLAN.md §10).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider).value ?? const Settings();
    final notifier = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            HallHeader(title: l10n.settingsTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: SwitchListTile(
                      key: const ValueKey('settings.battles'),
                      value: s.battles,
                      onChanged: s.classicPieces ? null : (v) => notifier.change((x) => x.copyWith(battles: v)),
                      secondary: const Icon(Icons.flash_on_rounded, size: 36, color: Color(0xFFFFA000)),
                      title: Text(l10n.settingsBattles),
                      subtitle: Text(l10n.settingsBattlesHint),
                    ),
                  ),
                  Card(
                    child: SwitchListTile(
                      key: const ValueKey('settings.classic'),
                      value: s.classicPieces,
                      onChanged: (v) => notifier.change((x) => x.copyWith(classicPieces: v)),
                      secondary: const SizedBox.square(dimension: 40, child: ClassicPiece(piece: Piece(Side.white, PieceType.knight), size: 40)),
                      title: Text(l10n.settingsClassic),
                      subtitle: Text(l10n.settingsClassicHint),
                    ),
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
