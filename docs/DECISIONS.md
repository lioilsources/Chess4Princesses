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
- Kid test: can she tell the pieces apart at board size (fairy pawn vs queen are both pink)?
- SFX/music.
