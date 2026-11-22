/// Tuning for the game player — the single source (rules/games.md).
library;

/// Pause between two ordinary plies in story mode.
const replayPlyDelay = Duration(milliseconds: 900);

/// Extra pause after a moment (check, castle, promotion, sacrifice) so the
/// narrator can speak.
const replayMomentDelay = Duration(milliseconds: 1800);

/// Pause before the very first move and before the end card.
const replayEdgeDelay = Duration(milliseconds: 1200);

/// Full-screen battles per game in story mode; other captures just "poof".
const replayMaxBattles = 4;

/// A move is a sacrifice when the mover is this many "apples" down two
/// plies later and stays down for [sacrificeWindow] plies.
const sacrificeMaterial = 2;
const sacrificeWindow = 4;

/// Piece slide duration on the board.
const replaySlide = Duration(milliseconds: 380);
