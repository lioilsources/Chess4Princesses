import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/games/library.dart';
import '../../l10n/app_localizations.dart';
import 'games_providers.dart';

const _paper = Color(0xFFFFF4D6);
const _gold = Color(0xFFFFB300);
const _brown = Color(0xFF8D6E63);

/// Ids of games played to the end (stickers).
Set<String> _watched(WidgetRef ref) => ref.watch(progressProvider).value?.gamesWatched ?? const {};

/// Back button and a bubble title, the hall's common header.
class HallHeader extends StatelessWidget {
  const HallHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 0),
    child: Row(
      children: [
        IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), tooltip: AppLocalizations.of(context).back, onPressed: () => context.pop()),
        Expanded(
          child: BubbleText(title, role: KidRole.title, size: 28, palette: KidPalette.peach),
        ),
        ?trailing,
      ],
    ),
  );
}

/// "12 z 64" with a star.
class StickerCount extends StatelessWidget {
  const StickerCount({super.key, required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.star_rounded, color: _gold, size: 28),
      const SizedBox(width: 4),
      Text(AppLocalizations.of(context).hallStickers(done, total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    ],
  );
}

Widget _loading<T>(AsyncValue<T> v, Widget Function(T) data) => switch (v) {
  AsyncData(:final value) => data(value),
  AsyncError(:final error) => Center(child: Text('$error')),
  _ => const Center(child: CircularProgressIndicator()),
};

/// Zlatá šachovnice: 64 games on the squares, a1 → h8 in time order
/// (PLAN §1). A played game leaves a star sticker on its square.
class GoldenBoardScreen extends ConsumerWidget {
  const GoldenBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final watched = _watched(ref);
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: _loading(ref.watch(shelfProvider('golden')), (groups) {
          final entries = groups.first.entries;
          return Column(
            children: [
              HallHeader(
                title: l10n.hallGolden,
                trailing: StickerCount(done: entries.where((e) => watched.contains(e.id)).length, total: entries.length),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF6D4C41), width: 6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GridView.count(
                          crossAxisCount: 8,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Rank 8 on top, a1 bottom left: square i holds entry i.
                            for (var row = 7; row >= 0; row--)
                              for (var col = 0; col < 8; col++)
                                _GoldenSquare(
                                  entry: row * 8 + col < entries.length ? entries[row * 8 + col] : null,
                                  dark: (row + col).isEven,
                                  watched: watched,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _GoldenSquare extends StatelessWidget {
  const _GoldenSquare({required this.entry, required this.dark, required this.watched});

  final LibraryEntry? entry;
  final bool dark;
  final Set<String> watched;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final color = dark ? const Color(0xFFD7A86E) : const Color(0xFFFFE8B8);
    if (e == null) return ColoredBox(color: color);
    final done = watched.contains(e.id);
    return Tooltip(
      message: '${e.white} – ${e.black}${e.year == null ? '' : ', ${e.year}'}',
      child: Material(
        color: color,
        child: InkWell(
          onTap: () => context.push('/game/${e.id}'),
          child: Center(
            child: done
                ? const FittedBox(
                    child: Icon(
                      Icons.star_rounded,
                      color: _gold,
                      size: 40,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black38)],
                    ),
                  )
                : FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        '${e.year ?? ''}',
                        style: TextStyle(color: dark ? Colors.white : _brown, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Zápasy o korunu: every title match on a time line; the split FIDE
/// title (1993–2006) is its own branch (PLAN §2).
class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final watched = _watched(ref);
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: Column(
          children: [
            HallHeader(title: l10n.hallMatches),
            Expanded(
              child: _loading(ref.watch(shelfProvider('matches')), (groups) {
                final classic = groups.where((g) => g.line != 'fide').toList();
                final fide = groups.where((g) => g.line == 'fide').toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    for (final g in classic) _MatchRow(group: g, watched: watched),
                    if (fide.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                        child: BubbleText(l10n.hallFideLine, role: KidRole.title, size: 20, palette: KidPalette.lavender),
                      ),
                      for (final g in fide) _MatchRow(group: g, watched: watched),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.group, required this.watched});

  final LibraryGroup group;
  final Set<String> watched;

  @override
  Widget build(BuildContext context) {
    final g = group;
    final done = g.entries.where((e) => watched.contains(e.id)).length;
    final tournament = g.kind == 'tournament';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/hall/group/${g.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    '${g.year ?? ''}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _brown),
                  ),
                ),
                Icon(tournament ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded, color: _gold, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      if (g.score.length == 2)
                        Text('${formatPoints(g.score[0].points)} : ${formatPoints(g.score[1].points)}', style: const TextStyle(color: _brown)),
                    ],
                  ),
                ),
                if (done > 0) StickerCount(done: done, total: g.entries.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A shelf of people, each with their own games: Šampionky (women's world
/// champions) and Mistr a vyzyvatel (both players of the coming title match).
class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key, required this.shelfId, required this.title});

  final String shelfId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watched = _watched(ref);
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: Column(
          children: [
            HallHeader(title: title),
            Expanded(
              child: _loading(
                ref.watch(shelfProvider(shelfId)),
                (groups) => GridView.extent(
                  padding: const EdgeInsets.all(16),
                  maxCrossAxisExtent: 240,
                  childAspectRatio: .9,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [for (final g in groups) _ChampionCard(group: g, watched: watched)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChampionCard extends StatelessWidget {
  const _ChampionCard({required this.group, required this.watched});

  final LibraryGroup group;
  final Set<String> watched;

  @override
  Widget build(BuildContext context) {
    final g = group;
    final done = g.entries.where((e) => watched.contains(e.id)).length;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/hall/group/${g.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CrownBadge(number: g.number),
              const SizedBox(height: 8),
              Text(
                g.title ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Text(
                g.reigns.join(', '),
                textAlign: TextAlign.center,
                style: const TextStyle(color: _brown),
              ),
              const SizedBox(height: 6),
              StickerCount(done: done, total: g.entries.length),
            ],
          ),
        ),
      ),
    );
  }
}

/// Crown with the champion's number (PLAN §7: no portraits, no flags).
class CrownBadge extends StatelessWidget {
  const CrownBadge({super.key, this.number});

  final int? number;

  @override
  Widget build(BuildContext context) => Container(
    width: 64,
    height: 64,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: _gold,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2))],
    ),
    child: number == null
        ? const Icon(Icons.star_rounded, color: Colors.white, size: 40)
        : Text(
            '$number',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Colors.white),
          ),
  );
}

/// One match, tournament or champion: its games as tiles.
class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watched = _watched(ref);
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: _loading(ref.watch(groupProvider(groupId)), (g) {
          if (g == null)
            return Center(
              child: IconButton(iconSize: 48, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
            );
          final isMatch = g.kind != null;
          return Column(
            children: [
              HallHeader(title: [g.title ?? '', if (g.kind == 'match' && g.year != null) '${g.year}'].join(' ')),
              if (g.score.length == 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${g.score[0].name}  ${formatPoints(g.score[0].points)} : ${formatPoints(g.score[1].points)}  ${g.score[1].name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: _brown),
                  ),
                ),
              Expanded(
                child: GridView.extent(
                  padding: const EdgeInsets.all(16),
                  maxCrossAxisExtent: 200,
                  childAspectRatio: .78,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [for (final e in g.entries) LibraryGameTile(entry: e, watched: watched.contains(e.id), showRound: isMatch)],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// A game card: players, year or game number, result, sticker.
class LibraryGameTile extends StatelessWidget {
  const LibraryGameTile({super.key, required this.entry, required this.watched, this.showRound = false});

  final LibraryEntry entry;
  final bool watched;
  final bool showRound;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final e = entry;
    final n = e.roundNumber;
    final label = showRound && n != null ? l10n.liveGame(n) : '${e.year ?? ''}';
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/game/${e.id}'),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(e.mate ? Icons.emoji_events_rounded : Icons.auto_stories_rounded, size: 44, color: _gold),
                  const SizedBox(height: 4),
                  // Player names are facts in Latin script in every language (PLAN §5).
                  Text(
                    e.white,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(_resultMark(e.result), style: const TextStyle(color: _brown)),
                  Text(
                    e.black,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(label, style: const TextStyle(color: _brown)),
                  if (e.tiebreak) Text(l10n.hallTiebreak, style: const TextStyle(color: _brown, fontSize: 12)),
                ],
              ),
            ),
            if (watched) const PositionedDirectional(top: 6, end: 6, child: Icon(Icons.star_rounded, color: _gold, size: 30)),
          ],
        ),
      ),
    );
  }
}

String _resultMark(String r) => switch (r) {
  '1-0' => '1 – 0',
  '0-1' => '0 – 1',
  '1/2-1/2' => '½ – ½',
  _ => '–',
};
