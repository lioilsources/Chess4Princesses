import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/content_lang.dart';
import '../../app/providers.dart';
import '../../core/games/library.dart';
import '../../core/net/feed_client.dart';
import '../../l10n/app_localizations.dart';
import 'games_providers.dart';
import 'library_screens.dart';
import 'live_providers.dart';

/// Síň slávy (SLAVNE_PARTIE_PLAN §1): the shelves of the bundled library
/// and, when a parent allows it, "Právě se hraje" from the relay.
class HallScreen extends ConsumerWidget {
  const HallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final watched = ref.watch(progressProvider).value?.gamesWatched ?? const <String>{};
    final golden = ref.watch(shelfProvider('golden')).value?.firstOrNull?.entries ?? const <LibraryEntry>[];
    final challengeYear = ref.watch(shelfProvider('challenge')).value?.firstOrNull?.year;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            HallHeader(
              title: l10n.hallTitle,
              trailing: IconButton(iconSize: 32, tooltip: l10n.settingsTitle, icon: const Icon(Icons.settings_rounded), onPressed: () => context.push('/settings')),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  if (feedConfigured) const _LiveShelf(),
                  _ShelfCard(
                    icon: Icons.grid_on_rounded,
                    title: l10n.hallGolden,
                    hint: l10n.hallGoldenHint,
                    palette: KidPalette.peach,
                    route: '/hall/golden',
                    trailing: golden.isEmpty ? null : StickerCount(done: golden.where((e) => watched.contains(e.id)).length, total: golden.length),
                  ),
                  _ShelfCard(
                    icon: Icons.workspace_premium_rounded,
                    title: l10n.hallMatches,
                    hint: l10n.hallMatchesHint,
                    palette: KidPalette.lavender,
                    route: '/hall/matches',
                  ),
                  _ShelfCard(icon: Icons.auto_awesome_rounded, title: l10n.hallWomen, hint: l10n.hallWomenHint, palette: KidPalette.mint, route: '/hall/women'),
                  if (challengeYear != null)
                    _ShelfCard(
                      icon: Icons.emoji_events_rounded,
                      title: l10n.hallChallenge,
                      hint: l10n.hallChallengeHint('$challengeYear'),
                      palette: KidPalette.sky,
                      route: '/hall/challenge',
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

class _ShelfCard extends StatelessWidget {
  const _ShelfCard({required this.icon, required this.title, required this.hint, required this.palette, required this.route, this.trailing});

  final IconData icon;
  final String title;
  final String hint;
  final KidPalette palette;
  final String route;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 64, color: const Color(0xFFFFB300)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BubbleText(title, role: KidRole.title, size: 22, palette: palette),
                    const SizedBox(height: 4),
                    Text(hint, style: const TextStyle(color: Color(0xFF8D6E63))),
                    if (trailing != null) ...[const SizedBox(height: 6), trailing!],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Live tournaments, behind the parent switch (off by default).
class _LiveShelf extends ConsumerWidget {
  const _LiveShelf();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = context.contentLang;
    final on = ref.watch(liveEnabledProvider).value ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            value: on,
            onChanged: (v) => ref.read(liveEnabledProvider.notifier).set(v),
            title: Text(l10n.liveSwitch),
            subtitle: on ? null : Text(l10n.liveSwitchHint),
            secondary: const Icon(Icons.wifi_rounded),
          ),
          if (on)
            switch (ref.watch(liveTournamentsProvider)) {
              AsyncData(:final value) when value.value.isEmpty => Text(l10n.liveNothing, textAlign: TextAlign.center),
              AsyncData(:final value) => Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final t in value.value)
                    ActionChip(
                      avatar: const Icon(Icons.flash_on_rounded, color: Color(0xFFE53935)),
                      label: Text(t.nameIn(lang)),
                      onPressed: () => context.push('/live/${t.id}'),
                    ),
                ],
              ),
              AsyncError() => Text(l10n.liveError, textAlign: TextAlign.center),
              _ => const Center(child: CircularProgressIndicator()),
            },
        ],
      ),
    );
  }
}
