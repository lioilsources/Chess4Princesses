# PrincessChess (Šachové království)

Flutter app (iOS + Android) that teaches a 5-year-old chess through story
lessons, mini-games and battle animations between character armies.
Plans: `Prompts/00-PRINCESSCHESS_PLAN.md`, `01-PRINCESSCHESS_LESSONS.md`, `03-BATTLES_PLAN.md`.

## Status

- **M0** ✅ scaffold (go_router, Riverpod, cs/en ARB, `cute_kid_fonts`), board widget (tap or drag, legal squares glow), own rules engine with `full | piece_only`, placeholder pieces.
- **M1** ✅ (mostly) LessonEngine + YAML schema + lint; modules 0–3 as data (16 lessons, 37 tasks); static kingdom map; stars + progress.
- **Voice-over** ✅ every story, prompt, tap target, feedback and battle line is read aloud (pre-generated clips, cs + en). Tap the prompt bubble to hear it again.
- **B1** ✅ battle overlay in Flame: `BattleDirector` state machine, placeholder fighters, fx, camera shake, tap to skip; `tool/pack_sheet.py` + atlas format.
- Bonus: bot levels 1–4 (used by the pawn war), army manifests for Fairies + Witches and an army picker.

See `docs/DECISIONS.md` for decisions, open questions and what's next.

## Run

```sh
flutter pub get
flutter run                         # map → island → lesson
dart run tool/lesson_lint.dart      # every lesson solvable, par reachable (CI)
flutter test
python3 tool/pack_sheet.py check    # battle atlases (needs Pillow)
```

### Voice-over

Clips live in `assets/voice/<lang>/<key>.mp3`; the key is a hash of the text,
so editing a lesson text just leaves its clip missing (the app stays silent
for that line, and `flutter test` fails until it is generated):

```sh
dart run tool/voice_lines.dart      # list every spoken line → assets/voice/lines.json
sparkctl exec chess4princesses tts 30 20 "hlas lekcí" -- python3 tool/voice_gen.py
```

`voice_gen.py` only generates what is missing. Voices and licences: `docs/CREDITS.md`.

The 🗲 button on the map opens a test battle (any piece vs any piece).

## Layout

```
lib/
  app/            router, providers, app shell
  core/chess/     Position (FEN, kingless ok), Rules (movegen, SAN, attacks)
  core/engine/    Bot levels baby / puppy / knightess / dragoness
  core/lessons/   Lesson model, TaskSession/LessonSession, Solver (BFS), lint
  core/progress/  stars, skills, unlocked characters (shared_preferences)
  core/armies/    army manifest model
  core/voice/     voice line keys + Narrator (audioplayers)
  features/       map, lesson, board, battle (Flame), army
assets/lessons/   index.yaml + mNN/mNN_lMM.yaml   → docs/lesson_schema.md
assets/armies/    <army>/manifest.json (+ battle/<piece>/<clip>.png|json later)
tool/             lesson_lint.dart, pack_sheet.py, voice_lines.dart, voice_gen.py
assets/voice/     <lang>/<text-hash>.mp3 + lines.json
```

No ads, no trackers, offline. No third-party brands anywhere: armies are
original archetypes (PLAN §0).
