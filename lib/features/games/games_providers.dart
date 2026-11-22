import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/games/game_record.dart';
import '../../core/games/pgn.dart';

/// Bundled sample games (G1). The full library with shelves comes in G3.
const sampleGamesAsset = 'assets/games/samples.pgn';

final sampleGamesProvider = FutureProvider<List<GameRecord>>((ref) async {
  final text = await rootBundle.loadString(sampleGamesAsset);
  return [for (final g in parsePgn(text)) GameRecord.fromPgn(g)];
});

/// A game by its stable id, from every source the app knows.
final gameByIdProvider = FutureProvider.family<GameRecord?, String>((ref, id) async {
  final games = await ref.watch(sampleGamesProvider.future);
  for (final g in games) {
    if (g.id == id) return g;
  }
  return null;
});
