/// Tuning for the live mode (Prompts/06-ZIVY_PRENOS_PLAN.md) — the single source.
library;

/// How often an open live game asks the relay (it caches a running round 10 s).
const livePollEvery = Duration(seconds: 10);

/// Longest wait between polls after repeated errors.
const livePollMax = Duration(seconds: 60);

/// Catch-up after opening a running game: per ply, and the whole run at most.
const liveCatchUpPly = Duration(milliseconds: 120);
const liveCatchUpMax = Duration(seconds: 12);

/// More new plies than this at once are played quickly, without battles.
const liveBurstMax = 4;

/// Time trouble: under a move control, less than this per move left until it.
const liveTroublePerMove = Duration(seconds: 60);

/// Time trouble after the last control.
const liveTroubleFinal = Duration(minutes: 2);

/// Time trouble when the time control is unknown.
const liveTroubleUnknown = Duration(minutes: 5);

/// "Who is ahead" bar (five steps): below the first threshold even, below
/// the second slightly ahead, above it clearly ahead. Centipawns.
const liveAheadSteps = [50, 300];

/// How long the hourglass bar of the side to move ticks between redraws.
const liveClockTick = Duration(seconds: 1);
