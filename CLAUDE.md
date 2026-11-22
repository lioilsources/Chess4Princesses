# PrincessChess (Chess4Princesses)

<!-- Max 80 řádků. Co se nevejde, jde do docs/ a sem jeden odkaz. Veřejné repo: žádné LAN IP, domovské cesty, ID. -->

## Účel
Flutter app (iOS + Android) that teaches a 5-year-old chess through story lessons, mini-games and battle animations between character armies. Offline, no ads, no trackers.

## Build a test
```
flutter pub get
flutter analyze --no-fatal-infos && flutter test && dart run tool/lesson_lint.dart && dart run tool/games_lint.dart   # what CI runs, gate before push
python3 tool/pack_sheet.py check    # battle atlases (needs Pillow)
dart run tool/voice_lines.dart      # list spoken lines → assets/voice/lines.json
```
Voice clips are generated on SPARK through the broker (`sparkctl exec … -- python3 tool/voice_gen.py`, see README).

## Mapa
- `lib/app/` router, providers, app shell
- `lib/core/` chess rules, bots, lessons (engine, solver, lint), progress, armies, voice
- `lib/core/games/` PGN, game records, moments (famous games player) → `Prompts/05-SLAVNE_PARTIE_PLAN.md`
- `lib/features/` map, lesson, board, battle (Flame), army, games (hall + replay)
- `assets/lessons/` lesson YAML → `docs/lesson_schema.md`; `assets/armies/`, `assets/voice/`
- `tool/` lesson lint, atlas packer, voice and sound generators; `tool/art/` ComfyUI art pipeline
- `Prompts/` plans and handoffs; `docs/` decisions, credits, release

## Invarianty
- Every lesson must stay solvable with reachable par (`tool/lesson_lint.dart`, CI).
- Voice clip key is a hash of the text: editing a line leaves its clip missing and `flutter test` fails until regenerated.
- No third-party brands: armies are original archetypes.

## Kam dál
`README.md`, `docs/DECISIONS.md`, `docs/release.md`, `Prompts/`
