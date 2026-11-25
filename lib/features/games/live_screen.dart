import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/content_lang.dart';
import '../../core/games/game_record.dart';
import '../../core/net/feed_client.dart';
import '../../l10n/app_localizations.dart';
import 'live_game_screen.dart';
import 'live_providers.dart';
import 'replay_screen.dart';

/// "Právě se hraje" (PLAN §6): rounds of one live tournament from the relay.
class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key, required this.tournamentId});
  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = context.contentLang;
    final live = ref.watch(liveTournamentsProvider);
    FeedTournament? t;
    if (live case AsyncData(:final value)) {
      for (final x in value.value) {
        if (x.id == tournamentId) t = x;
      }
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            _Bar(title: t?.nameIn(lang) ?? l10n.liveTitle, l10n: l10n, onRefresh: () => ref.invalidate(liveTournamentsProvider)),
            if (live case AsyncData(value: Cached(offline: true))) _OfflineNote(l10n: l10n),
            Expanded(
              child: switch (live) {
                AsyncData() when t == null => Center(child: Text(l10n.liveNothing)),
                AsyncData() => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [for (final r in t!.rounds) _RoundTile(tournament: t, round: r, l10n: l10n)],
                ),
                AsyncError() => Center(child: Text(l10n.liveError)),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.title, required this.l10n, this.onRefresh});
  final String title;
  final AppLocalizations l10n;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 8, 0),
    child: Row(
      children: [
        IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), tooltip: l10n.back, onPressed: () => context.pop()),
        Expanded(child: BubbleText(title, role: KidRole.title, size: 24, palette: KidPalette.peach)),
        if (onRefresh != null) IconButton(iconSize: 32, icon: const Icon(Icons.refresh_rounded), onPressed: onRefresh),
      ],
    ),
  );
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [const Icon(Icons.cloud_off_rounded, size: 18), const SizedBox(width: 6), Expanded(child: Text(l10n.liveOffline))]),
  );
}

class _RoundTile extends StatelessWidget {
  const _RoundTile({required this.tournament, required this.round, required this.l10n});
  final FeedTournament tournament;
  final FeedRound round;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (round.state) {
      RoundState.finished => (Icons.emoji_events_rounded, const Color(0xFFFFB300)),
      RoundState.ongoing => (Icons.flash_on_rounded, const Color(0xFFE53935)),
      RoundState.upcoming => (Icons.schedule_rounded, const Color(0xFFB0A3BF)),
    };
    final start = round.startsAt?.toLocal();
    final day = start == null ? null : MaterialLocalizations.of(context).formatMediumDate(start);
    final time = start == null ? null : TimeOfDay.fromDateTime(start).format(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(l10n.liveGame(round.n), style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: start == null ? null : Text(round.state == RoundState.upcoming ? '$day · ${l10n.liveStartsAt(time!)}' : day!),
        enabled: round.state != RoundState.upcoming,
        onTap: () => context.push('/live/${tournament.id}/${round.id}', extra: round),
      ),
    );
  }
}

/// `/live/:t/:r` without the round object (a link, a restored route):
/// find it in the tournament list.
class LiveRoundLoader extends ConsumerWidget {
  const LiveRoundLoader({super.key, required this.tournamentId, required this.roundId});
  final String tournamentId;
  final String roundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = ref.watch(liveTournamentsProvider);
    if (live case AsyncData(:final value)) {
      for (final t in value.value) {
        if (t.id != tournamentId) continue;
        for (final r in t.rounds) {
          if (r.id == roundId) return LiveRoundScreen(tournamentId: tournamentId, round: r);
        }
      }
      return LiveScreen(tournamentId: tournamentId);
    }
    if (live is AsyncError) return LiveScreen(tournamentId: tournamentId);
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// One round. Finished: a single game opens as a story, several are listed.
/// Running: the live mode (live_game_screen.dart) for each game.
class LiveRoundScreen extends ConsumerWidget {
  const LiveRoundScreen({super.key, required this.tournamentId, required this.round});
  final String tournamentId;
  final FeedRound round;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Every game of the feed opens in the live screen: a finished one catches up
    // to its end card, then offers the adviser and own tries like a running one.
    final live = round.state != RoundState.upcoming;
    final games = ref.watch(roundGamesProvider((tournamentId, round)));
    return switch (games) {
      AsyncData(value: Cached(value: [_])) when live => LiveGameScreen(tournamentId: tournamentId, roundId: round.id),
      AsyncData(value: Cached(value: [final only])) => ReplayScreen(gameId: only.id, game: only),
      AsyncData(value: Cached(value: final list)) => Scaffold(
        backgroundColor: const Color(0xFFFFF4D6),
        body: SafeArea(
          child: Column(
            children: [
              _Bar(title: l10n.liveGame(round.n), l10n: l10n),
              Expanded(
                child: list.isEmpty
                    ? Center(child: Text(l10n.liveNothing))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final (i, g) in list.indexed)
                            _GameRow(game: g, onTap: live ? () => context.push('/live/$tournamentId/${round.id}/$i') : null),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      AsyncError() => Scaffold(body: SafeArea(child: Column(children: [_Bar(title: l10n.liveGame(round.n), l10n: l10n), Expanded(child: Center(child: Text(l10n.liveError)))]))),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow({required this.game, this.onTap});
  final GameRecord game;

  /// Live game; null = a finished one, opened as a story.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text('${game.white} – ${game.black}'),
      subtitle: Text(game.result.pgn),
      trailing: onTap == null ? null : const Icon(Icons.flash_on_rounded, color: Color(0xFFE53935)),
      onTap: onTap ?? () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ReplayScreen(gameId: game.id, game: game))),
    ),
  );
}
