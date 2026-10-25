# Lesson schema (`assets/lessons/`)

Lessons are data (PLAN §5). Code: `lib/core/lessons/lesson.dart` (parse),
`lesson_engine.dart` (play), `solver.dart` (BFS), `lint.dart` + `tool/lesson_lint.dart` (CI).

## Files

```
assets/lessons/index.yaml          # map: modules (islands) → ordered lesson ids
assets/lessons/m01/m01_l03.yaml    # one lesson = 1..n tasks
```

New lesson folder → add it to `flutter: assets:` in `pubspec.yaml`.

## Lesson

```yaml
id: m02_l03                 # = file name; module prefix decides the folder
module: 2
title: {cs: "Láva!", en: "Lava!"}
story: {cs: "…", en: "…"}   # shown (later voiced) before the first task
skills: [rook_move, danger_squares]   # parent heatmap counters
reward: {stars: 3, unlock: rook}      # optional; unlock = character/costume id
# Any of these at lesson level are defaults for every task:
rules: piece_only           # full | piece_only (default piece_only)
prompt: {cs: "…", en: "…"}
hints:
  - {after_fails: 1, highlight: legal_moves}
  - {after_fails: 2, highlight: solution_first_move}
tasks:
  - goal: avoid_lava
    fen: "8/8/8/8/8/8/R7/8 w - - 0 1"   # side to move = the child
    stars: [d5]
    lava: [a5, b2, c3]                    # or: lava: attacked
    max_moves: 3
```

A lesson with a single task may put the task keys at top level and omit `tasks`.

## Task keys

| key | used by | meaning |
|---|---|---|
| `goal` | all | see table below |
| `rules` | move goals | `piece_only`: pattern moves only, no check, no castling, no en passant — works without kings. `full`: real chess |
| `fen` | all | position; only the placement field is required. Kingless FENs are fine |
| `prompt` | all | one line for the child (voiced later) |
| `stars` | reach/collect/avoid/promote/capture, yes_no | star squares; a piece collects every star **on its path**, not only where it lands |
| `lava` | any move goal | squares you may neither stop on nor drive through (knights jump over). `attacked` = every square the opponent attacks, recomputed each move |
| `max_moves` | solvable goals | par for 3 stars — never a hard limit |
| `hints` | all | `{after_fails: n, highlight: legal_moves \| solution_first_move \| targets}`; strongest unlocked wins; any hint caps the task at 2 stars |
| `targets` | tap goals | `tap_square`: sequence of `e` (street = file), `4` (house = rank) or `e4`; `tap_all`: set of squares |
| `target_fen` | setup_pieces | finished board; tray = target minus `fen` |
| `answer` | yes_no | `true` / `false` |
| `verify` | yes_no | `reachable`: lint checks `answer` = can a player piece reach the single star |
| `bot` | pawn_war | `baby` \| `puppy` \| `knightess` \| `dragoness` |

## Goals

| goal | win when | opponent |
|---|---|---|
| `tap_square` | every target tapped in order | — |
| `tap_all` | all targets tapped (any order) | — |
| `setup_pieces` | board equals `target_fen` | — |
| `reach_square` / `collect_stars` / `avoid_lava` | no stars left | passive |
| `capture_all` | no opponent pieces (+ stars) | passive (never kings) |
| `promote` | a pawn promoted (always to the Princess/queen) | passive |
| `pawn_war` | own pawn on last rank or opponent has no pawns; lose = reset, no penalty beyond a fail | bot |
| `yes_no` | right answer | — |

Not yet implemented (needed from module 4+): `escape_check`, `mate_in_1`,
`mate_in_2`, `mini_game`, `choose_move`, `spot_the_threat`. Add them to
`GoalType`, `TaskSession`, `Solver.isWon` (if solvable) and `lint.dart`.

## Stars

Per task: 3 = no mistake, no hint, within `max_moves`; 2 = ≤ 2 mistakes;
1 = finished. Lesson = rounded average. Best result is kept.

## Lint (mandatory in CI)

`dart run tool/lesson_lint.dart [--verbose]` — parses every lesson, checks
index ↔ files, stars/lava not under pieces, hints fit the goal, kings never in
`capture_all`, pawn wars pawns-only, setup tray non-empty, yes/no answers
(`verify: reachable`), and runs a BFS (opponent passive, ≤ 14 moves) so every
solvable task is solvable and `max_moves` is exactly reachable
(error if impossible, warning if lax).
