# Decisions & open questions

## Made during M0/M1/B1

1. **Own move generator instead of the `chess` pub package.** `chess` 0.8.1
   rejects any FEN without exactly one king per side ("wrong kings counts"),
   and most lessons have no kings. `lib/core/chess/` is pure Dart (~400 lines),
   verified by perft (start position to depth 3, kiwipete, positions 3 and 4,
   which cover en passant, pins, castling and promotion).
   - `RuleSet.full` = real chess; a side without a king just has nothing to protect.
   - `RuleSet.pieceOnly` = pattern moves only: no check, no castling, **no en passant**
     (taught in module 9, so pawn wars don't surprise the child with it).
2. **Stars are collected along the path**, not only on landing (a rook driving
   through a star takes it). For a 5-year-old that is what "collect" means;
   it also makes the "plan the corner" lesson work (`collect_stars`).
3. **Lava blocks sliding through** (knights jump over it), so the rook lava
   lesson is not trivial and module 5 "přeskoč lávu" works as written.
4. **`max_moves` is par, not a limit.** The child is never cut off; it only
   decides 3 vs 2 stars. Lint fails if par is impossible.
5. **Promotion is always to the Princess (queen)** in lessons and for the bot.
   Underpromotion is module 9.
6. **Extra goal types for modules 0 and 3:** `tap_square` (street/house/room),
   `tap_all`, `setup_pieces`, `yes_no` (with `verify: reachable` for lint).
7. **Lessons hold several tasks** (LESSONS often says "3 úkoly"); lesson-level keys are task defaults.
8. **Progress in `shared_preferences` JSON** behind `ProgressStore`, not drift/isar yet.
   No codegen and enough for stars + skill counters; swap when the parent
   heatmap needs queries (M4).
9. **Assets live in `assets/`** (`assets/lessons`, `assets/armies`), matching
   BATTLES_PLAN's `assets/armies/<army>/battle/<piece>/` layout.
10. **Battle timing** (placeholder): enter 0.3 + idle 0.3 + attack/defeat 1.3 + victory 0.7 + exit 0.3 = 2.9 s, skippable from 0.5 s.
    `BattleDirector` is a pure state machine; Flame only renders its events, so sprite
    atlases (B2) replace `PlaceholderFighter` without touching choreography.
11. **Battles are fullscreen in lessons** (BATTLES Q3 proposal); a small in-board variant for bot games comes with M3.
12. Working app title "Šachové království" / "Chess Kingdom" (ARB `appTitle`) until the name is chosen.
13. **Voice-over is pre-generated, keyed by a hash of the text.** No on-device TTS:
    offline, same voice on every phone, and no clip↔text mapping file to maintain.
    Czech = Piper Kasandra (the only commercially clean Czech voice on SPARK, CC BY →
    `docs/CREDITS.md`), English = Kokoro `af_heart`; both at 0.9 speed. Squares are
    spelled for the narrator ("komnatu é čtyři"). A parent voice-clone can replace
    the clip set later without code changes.
14. **Art = flux-schnell + BEN2 cut-out, chibi style** (recommendation Q2 taken). Only
    licence-clean models (`docs/CREDITS.md`); flux-dev/Kontext are non-commercial.
    Pipeline: `tool/art/characters.json` / `props.json` (prompts) → `comfy_gen.py`
    (4 seeds each → `art_drafts/`, gitignored, with a contact sheet) → pick in
    `picks.json` → `make_sprites.py` (drops stray sparkles, fills the inside of the
    outline opaque, 512 px, common baseline). Same seed = same image, so a pick is
    reproducible. `refine_foreground` stays off: it turns white fur black.
15. **Board piece = character on a plate**: gold plate mine, dark plate theirs; rival
    characters are mirrored to face my side. Battles use the same sprites over the
    defender's arena (drawn under the game so it fills any screen shape).
    Map islands 1–6 show my army's character, the rest a sticker icon.
16. **Twelve more armies from Archion** (`Prompts/04-HANDOFF-archion-armies.md`):
    kingdom, devils, bees, hornets, dinos, iceage, cats, dogs, fruit, veggies, plus
    Archion's fairies/witches as costumes `fairies_toy` / `witches_toy` next to the
    M2 armies (Olin's choice). Qwen-Image vinyl-toy renders, no baked outline, height
    by piece type (king 1.00 … pawn 0.58). `tool/art/import_archion.py` copies them:
    `sprites/` (with the low base, board) and `stand/` (base cut off, arena; the
    battle prefers it when bundled). **WebP q90** instead of PNG: 5× smaller and no
    visible loss; 256-colour PNG dithers the faces. Arenas: soft 3D toy dioramas
    (`tool/art/arenas_archion.json`) to match the renders. Names, mottos and battle
    lines are original (cs + en); `test/armies_test.dart` checks every folder.
    The picker shows one list with a "mine / rival" switch (14 armies).
17. **Famous games player (G1, `Prompts/05-SLAVNE_PARTIE_PLAN.md`).** Own PGN reader in
    `lib/core/games/` (comments, variations and NAGs dropped) and a fast SAN reader that filters
    legal moves instead of writing SAN for each (`Rules.parseSan` stays as the reference in tests).
    Story mode plays the game like a film with at most 4 full-screen battles (mate, sacrifices,
    first capture, queen captures — `battlePlies`), other captures just poof; chronicle mode is
    the parent's notation and stepping, no battles. White always plays with my army. Moments come
    from the moves alone (no engine); a sacrifice = the mover stays 2+ apples down for 4 plies and
    wins. Generic event lines (check, castle, sacrifice, end by mate / resignation / draw) are ARB
    strings, not yet voiced. Bundled PGN is linted in CI (`tool/games_lint.dart`): legal replay,
    result vs final position, no comments, no URLs, no sponsor names.
18. **Live games relay = Cloudflare Worker with edge cache** (`feed/`, `docs/feed.md`), not
    cron + KV as the plan said: the Worker asks the source only when the app asks and keeps the
    answer in `caches.default` (60 s, finished rounds 1 h), so there is no KV namespace and no
    write limit. It serves only curated tournaments under neutral names and strips clocks,
    comments and URLs. The app reaches it only when built with `FEED_BASE_URL` and a parent
    turns on "Partie z internetu" (off by default); fetched rounds are kept in
    `shared_preferences` and replay offline.
19. **Games library is free (G3, Olin 22. 11. 2026).** The whole library ships in the base app,
    no IAP shelves: a children's app without accounts or ads, and in-app purchases in the kids
    category would need a parent gate and stricter store rules. Paid voice for the champion
    boards stays possible later.
20. **Library data (G3, `docs/games_schema.md`).** Packs are generated straight into
    `assets/games/p/` by `tool/games/build.dart` from PGN Mentor downloads and
    `data/games/{players,sources}.yaml`; there is no committed copy under `data/games/pgn/`
    (only `extra.pgn`, hand-checked games missing from the sources). Title matches 1886–2024
    (PCA 1993, 1995 in the classical line; FIDE 1993–2006 as its own branch: matches, knock-out
    finals, San Luis 2005). The golden board is a hand-made list of 64 specs; women champions
    get 8 games each by a scoring rule (wins, mates, reign years, strong opponents, no rapid,
    blitz or online) until G5 brings the per-champion boards. Events from player files are
    renamed to place + year (sponsors). Opponents not in `players.yaml` are only reordered to
    "First Last"; champions and frequent opponents are canonical. A sticker = the game was
    played to the end (`Progress.gamesWatched`).

21. **Live mode (Prompts/06-ZIVY_PRENOS_PLAN.md, 24. 11. 2026).** A running game is no longer
    a replay that stops at the last downloaded move: the live screen polls the relay every 10 s
    while open and in front, catches up quickly, then plays each new move (battles on captures,
    a burst of more than four plies quickly). Clocks and engine evaluations travel in the PGN as
    `[%clk]` / `[%eval]` comments, so older app versions keep working. The adviser is the
    source's cloud evaluation behind `/v1/advice` (no human commentary exists in the feed).
    This overrides SLAVNE_PARTIE_PLAN §6 "no move-by-move live watching for the child".
    Parent settings: battles on/off, classic pieces in games (replay and live).

## Open questions for Ol1n (PLAN §8 + BATTLES §7) — with recommendations

| # | Question | Recommendation |
|---|---|---|
| 1 | Name + bundle ID | **Šachové království** (CZ) / *Chess Kingdom* (EN). Descriptive, searchable, avoids the "princess" gender lock-in for the store. Bundle `com.ol1n.princesschess` is set now; changing it before the first TestFlight upload costs nothing |
| 2 | Art style | **Chibi "cute chunky"** with thick outlines. Reads at 48 px, matches `cute_kid_fonts`, and LoRA training is simpler than for a comic style |
| 3 | Battles: sprite-sheet (A) or video (C/B)? | **A for the base armies** (planned for M2); B only for `battle_overrides` and as an experiment on 1 character (B4). The atlas format is shared, so switching costs nothing |
| 4 | Flame vs Lottie/Rive | **Flame** — already wired (B1 runs), particles + camera shake for free, and matches IMMUNORUN/Kiran experience |
| 5 | Voice: TTS narrator or parent voice-clone? | **TTS child narrator by default** + optional "record mum/dad" voice-clone pack later. The app must work without reading, so voice-over is the next big gap (M3) |
| 6 | Share characters with Storyteller/Hajánek? | Yes for **style/LoRA and pipeline**, no for the characters themselves at first: chess armies need 6 roles × 2 sides with a clear silhouette per piece type |
| B1 | Which I2V model runs on the video service, length/resolution? | Needed before B4 |
| B2 | Hit as comic bonk or contactless magic? | **Magic (sparkle/zap) by default**, bonk reserved for comic packs (heroes/villains) |
| B3 | Battle fullscreen or small in-board? | Fullscreen in lessons (done), small in bot games, parent toggle |

## Not done yet (next steps)

- Voice: listen through on a device and re-tune `say` spellings where the narrator stumbles; parent toggle for voice.
- Goal types for modules 4–12 (see `docs/lesson_schema.md`).
- Play vs bot / pass-and-play screen (bot levels 1–4 already exist in `core/engine/bot.dart`).
- Parent zone + parent gate, settings (battles on/off, language).
- Module tournaments + diploma.
- Battle poses (B2): attack / defeat / victory frames per character; consistency needs a reference method that is licence-clean (IP-Adapter on SDXL base, or a LoRA) — flux Kontext is non-commercial.
- Archion armies: battle poses (attack / hit / victory) — `pose_gen.py` prompts are for the flat sticker style, the vinyl renders need their own style line.
- Archion armies: bees, fruit and part of dinos are the same little figure in costumes, told apart mainly by height — kid test, maybe re-generate SUBJECT with a prop.
- Monetisation (PLAN §6: two armies free, the rest as packs): all 14 armies are open for now, no IAP yet — Olin decides.
- Kid test: can she tell the pieces apart at board size (fairy pawn vs queen are both pink)?
- SFX/music.
- Famous games: voice clips for the replay event lines (SPARK), library and shelves (G3); deploy the feed Worker and set `FEED_BASE_URL` in release builds.
