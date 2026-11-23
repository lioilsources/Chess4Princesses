# Šachové království → Babylon.js: mapa portu

Webový klient Šachového království (Chess4Princesses) v TypeScriptu nad Babylon.js. Zdroj pravdy je
Flutter appka v kořeni repa (pravidla v `lib/core/`). Plán: `DevConventions/Prompts/06-PLAN-babylon-web.md`,
šablona `DevConventions/templates/babylon`, vzor `ChrestysSkatepark/babylon`.
Stav: **F0 (audit a spike)**. Hostování: GitHub Pages repa, hra pod `/play/`, `docs/` (landing, privacy, support) dál v kořeni.

## Úrovně parity

- **P0**: diskrétní pravidla, shoda bit po bitu přes zlaté vektory z Dartu (`tool/dump_vectors.dart` → `test/golden/`).
  Šachy jsou celé diskrétní: pravidla, lekce, solver, bot, PGN, knihovna.
- **P1**: časování animací (posun figurky 380 ms, bitva): ±5 %.
- **P2**: vzhled: šachovnice shora, figurky jako sprity armád na podstavci (zlatý = moje, tmavý = soupeř), barvy z `chess_board.dart`.

## Vrstvy

| Složka | Obsah | Hlídá |
|---|---|---|
| `src/rules/` | šachy, lekce, bot, PGN, port Dart souboru po souboru | ESLint: bez Babylonu, DOM, `game/`, `ui/` |
| `src/game/` | Babylon scéna (šachovnice, figurky, bitva), smyčka, obrazovky | — |
| `src/ui/` | DOM: HUD, mapa, menu, síň slávy, karty | ESLint: bez Babylonu a `game/` |

## Mapa Dart → TS po souborech

`lib/core/` má 2 836 řádků čistého Dartu. UI importují jen `audio/sounds.dart` a `voice/narrator.dart`
(přehrávání), ty jdou do `ui/`. Fáze = kdy se soubor portuje.

| Dart | ř. | TS | Parita | Fáze |
|---|---|---|---|---|
| `core/chess/types.dart` | 114 | `rules/types.ts` | P0 | **F0 hotovo** |
| `core/chess/position.dart` | 166 | `rules/position.ts` | P0 | **F0 hotovo** |
| `core/chess/rules.dart` | 289 | `rules/rules.ts` | P0 | **F0** bez `san`/`parseSan`/`attackers`/`path`, zbytek F1 |
| `core/engine/bot.dart` | 138 | `rules/bot.ts` | P0 (se seedem) | F1 |
| `core/lessons/lesson.dart` | 283 | `rules/lesson.ts` | P0 | F1 |
| `core/lessons/lesson_engine.dart` | 306 | `rules/lesson-engine.ts` | P0 | F1 |
| `core/lessons/solver.dart` | 105 | `rules/solver.ts` | P0 | F1 |
| `core/lessons/curriculum.dart`, `content_catalog.dart` | 77 | `rules/curriculum.ts` | P0 | F1 |
| `core/lessons/lint.dart` | 199 | — (zůstává v Dartu, CI) | — | vypouští se |
| `core/progress/progress.dart` | 109 | `rules/progress.ts` (localStorage v `ui/`) | P0 | F3 |
| `core/armies/army.dart` | 104 | `rules/army.ts` (dnes `ui/armies.ts`, jen sprity) | P0 | F3 |
| `core/games/pgn.dart`, `san_reader.dart`, `game_record.dart` | 288 | `rules/pgn.ts` … | P0 | F3 |
| `core/games/library.dart`, `moments.dart`, `replay_config.dart` | 257 | `rules/library.ts` … | P0 | F3 |
| `core/games/games_lint.dart` | 102 | — (Dart, CI) | — | vypouští se |
| `core/net/feed_client.dart` | 80 | `ui/feed.ts` (fetch) | P2 | F3 |
| `core/voice/voice_lines.dart` | 94 | `rules/voice-lines.ts` (klíč klipu = hash textu) | P0 | F3 |
| `core/voice/narrator.dart`, `core/audio/sounds.dart` | 125 | `ui/audio.ts` (Web Audio, odemčení prvním dotykem) | P2 | F3 |
| `features/board/*` | 426 | `game/board-scene.ts` | P2 | **F0 základ**, značky (hvězdy, láva, nápověda) F2 |
| `features/lesson/*` | 797 | `game/lesson.ts` + `ui/lesson-hud.ts` | P1/P2 | F2 |
| `features/map/*` | 334 | `ui/map.ts` | P2 | F3 |
| `features/army/*` | 154 | `ui/army-picker.ts` | P2 | F3 |
| `features/battle/*` | 661 | `game/battle.ts` (atlasy klipů, režisér) | P1 | F3 |
| `features/games/*` | 1 502 | `ui/hall.ts`, `game/replay.ts` | P2 | F3 |
| `app/*` | 173 | `game/main.ts` (obrazovky místo go_router) | — | F2 |

## Zlaté vektory (F1)

| Soubor | Co pokrývá | Přesně (CI diff) |
|---|---|---|
| `moves.json` | legální tahy, `san`, `status` na sadě FEN (vč. lekcí bez králů, `piece_only`) | ano |
| `lessons.json` | každá lekce: start, sekvence tahů → stav cílů, hvězdy, par ze solveru | ano |
| `bot.json` | tahy botů všech úrovní se seedovaným Lcg | ano (bot dostane injektovaný generátor) |
| `pgn.json` | PGN → UCI tahy, momenty, id partie (sha1) | ano |

F0 hlídá pravidla perftem (standardní počty uzlů, `test/rules.test.ts`).

## Funkce

Jedna řádka na funkci = jedno video (plán 06, kap. 5a). Id funkce = `?demo=<id>`. W = web, F = Flutter.

| Id | Funkce | W | F | Video |
|---|---|---|---|---|
| `play-bot` | partie proti botovi (4 úrovně) s armádami | F0 spike | ano | `01-play-bot` |
| `lesson-tap` | lekce: ťukání na políčka, ulice a domečky | — | ano | `02-lesson-tap` |
| `lesson-stars` | sbírání hvězd na par | — | ano | `03-lesson-stars` |
| `lesson-lava` | láva: kam král nesmí | — | ano | `04-lesson-lava` |
| `lesson-capture` | sebrat všechno, soupeř stojí | — | ano | `05-lesson-capture` |
| `setup` | stavění figurek ze zásobníku | — | ano | `06-setup` |
| `battle` | bitevní animace při braní | — | ano | `07-battle` |
| `army` | výběr armády (14 armád) | — | ano | `08-army` |
| `map` | mapa království, odemykání ostrovů | — | ano | `09-map` |
| `golden-board` | Zlatá šachovnice, 64 slavných partií | — | ano | `10-golden-board` |
| `replay` | přehrávání partie s vyprávěním a hlasem | — | ano | `11-replay` |
| `live` | živé partie (feed) | — | ano | `12-live` |

## Co se na webu vypouští

- `core/lessons/lint.dart`, `core/games/games_lint.dart`, `tool/`: kontrola obsahu běží v Dartu v CI, web ji nepotřebuje.
- Generování hlasu a zvuků (`tool/voice_gen.py`, `sound_gen.py`): web bere hotové klipy.
- IAP appka nemá; nic se nevypouští kvůli placení.

## Assety

Kopírují se při buildu (`scripts/copy-assets.ts`) z `../assets/`, v gitu jen Flutter kopie.

| Složka | Velikost | Na webu |
|---|---|---|
| `armies/*/sprites` + `manifest.json` | 14 armád; fairies a witches 1,0 MB PNG každá, ostatní ~0,2 MB WebP | F0 (všechny, načítají se jen zvolené) |
| `armies/*/battle`, `arena.jpg` | ~6 MB | F3, dotahuje se až při bitvě |
| `voice/{cs,en}` | 22 MB (11 + 11) | F3, klip po klipu na vyžádání, nikdy předem |
| `sounds` | 1,1 MB | F3 |
| `lessons` | 0,26 MB YAML → JSON při buildu | F1 |
| `games` | 1,4 MB (index + police + PGN balíky) | F3, balík až při otevření |
| `i18n` + `lib/l10n/*.arb` | 2,4 MB + ARB, 45 jazyků | F3, jen zvolený jazyk |
| `ui/modules` | 0,4 MB | F3 |

**Nález:** výchozí armády (víly a čarodějnice) mají sprity jako PNG 512×512 po ~170 kB. Ostatní armády už mají WebP
po ~30 kB. Po převodu na WebP (cwebp q85) mají obě sady 0,38 MB místo 2 MB a první obrazovka webu klesne
z 2,6 na 0,7 MB (viz měření). Převod patří do Flutter assetů (zmenší i appku). Je to samostatný PR mimo `babylon/`
a schvaluje ho Olin.

## Měření F0

Lokálně 23. 11. 2026: MacBook (Apple Silicon), headless Chromium 1254 přes Playwright, okno 430×932 @3x (telefon na výšku),
obě verze servírované přes `serve` s gzipem, bez cache. Mediány ze 3 běhů. „Škrcení“ = 4 Mbit/s, RTT 100 ms, CPU ×4.
Na referenčním telefonu měří Olin.

| | Flutter web (`flutter build web --release`, 3.50.1, CanvasKit) | Babylon spike | Babylon spike, sprity WebP |
|---|---|---|---|
| Build na disku | 77 MB (36 MB `canvaskit/`, 38 MB assety vč. hlasu) | 6,0 MB `dist/` (4,3 MB sprity 14 armád) | 4,0 MB |
| Build trval | 53 s | 1,5 s | — |
| Přeneseno do prvního snímku | 4,0–4,6 MB | 2,63 MB (JS 805 kB raw / 189 kB gzip, sprity 2 MB) | **0,70 MB** |
| První snímek, rychlá síť | ~1,2 s (`flutter-first-frame`) | ~0,16 s | ~0,15 s |
| První snímek, škrcení | ~9,5 s | ~5,9 s | **~2,1 s** |
| FPS (desktop, `?debug`) | — | 120 (vsync) | — |

Cíle plánu (první obrazovka do 3 MB, první snímek do 3 s) splní spike jen se sprity ve WebP. Bez převodu se dá
cíl splnit i tím, že se sprity načtou až po prvním snímku, ale první snímek by pak byl prázdná šachovnice.

Flutter se měřil na dočasné kopii projektu (`flutter create --platforms=web` mimo repo), nic z buildu není v repu.

## Odchylky

- **Hlavní objekt spiku je celá partie proti botovi**, ne lekce. Lekce stojí na `lesson_engine.dart` (F1). Bot ve spiku
  je úroveň „baby“ (náhodný legální tah). Proměna je vždy na dámu (Flutter ukazuje výběr, F2).
- **Workflow zatím nemá job `golden`.** Vektory vznikají v F1, pak se job doplní ze šablony.
- **Barvy šachovnice jsou v F0 opsané** (`ui/palette.ts`). V F1 je nahradí generátor, který je čte z `chess_board.dart`.
- **Texty:** spike nemá žádné. Ovládá se obrázky (král na tahu, ↻, 🎉/🌟/🤝). Texty z ARB přijdou v F3.
- **`node.md` (Astro/SvelteKit, Paraglide)** neplatí: stack je zafixovaný plánem 06 (Vite + TS + Babylon, texty z ARB).
