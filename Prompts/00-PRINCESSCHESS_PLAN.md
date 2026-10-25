# PRINCESSCHESS_PLAN.md — handoff pro Opus (Claude Code)

Pracovní název: **PrincessChess** (CZ kandidáti na název do storu: *Královnička*, *Šachové království*, *Princezna na šachovnici* — rozhodnout v M0).
Repo: `lioilsources/PrincessChess`, bundle ID `com.ol1n.princesschess` (potvrdit).
Cíl: mobilní appka (Flutter, iOS + Android), která naučí pětileté dítě šachy přes příběhové lekce, mini‑hry a **bitvové animace** při braní figur. Figury nejsou bílé/černé, ale **armády postav** (víly vs čarodějky, hrdinové vs padouši, příšerky…), libovolně kombinovatelné proti sobě.

Kurikulum lekcí je v samostatném souboru `PRINCESSCHESS_LESSONS.md` — ten je zdroj pravdy pro obsah; tento soubor řeší architekturu, artwork a milníky.

---

## 0. Kontext a omezení

- Autor: Ol1n (Go + Flutter, vlastní ComfyUI stack na `comfyui.ol1n.com`, DGX Spark). Pracuje přes Director session + sub‑sessions na agent hubu.
- Primární uživatel: dcera 5 let, čeština. Appka musí fungovat **bez čtení** — vše má voice‑over + ikonky. Texty jen pro rodiče.
- Cílovka storu: rodiče dětí 4–8 let. CZ první, EN hned za tím (lokalizace od začátku, ARB).
- Znovupoužít: `cute_kid_fonts` (typografie), fairy‑tale/voice pipeline z Hajánku (TTS/voice‑clone pro voice‑over), ComfyUI pipeline z FineTune (konzistentní postavy přes LoRA / IP‑adapter).
- **IP / armády:** Winx, Trix, DC, Marvel, Pokémon jsou licencovaná díla — do publikované appky ani do assetů je použít nelze (store rejekce + právní riziko). Design proto používá **archetypy**: „víly vs čarodějky“, „hrdinové vs padouši“, „kapesní příšerky“, „princezny vs draci“ — s **vlastními originálními postavami** a jmény. Systém armád je ale datový (manifest), takže kdyby někdy vznikla licence, přidá se pack bez změny kódu. Nikde v kódu, assetech ani store listingu nesmí být odkaz na cizí značky.
- Žádné reklamy, žádné trackery, COPPA/GDPR‑K friendly, offline‑first. Rodičovská zóna za „parent gate“ (matematický příklad).

## 1. Produkt — co dítě vidí

1. **Mapa království** — cesta s moduly (0–12) jako ostrovy; odemykání postupně, hotové svítí.
2. **Lekce** — obrazovka: příběhová bublina (voice‑over) → mini‑hra na šachovnici → hvězdičky.
3. **Bitva** — při každém braní krátká (1,5–3 s) animace souboje útočník vs obránce, přeskočitelná klepnutím po 0,5 s. Vítěz zůstává na poli, poražený „odchází do hradu“.
4. **Armáda** — výběr armády pro sebe a pro soupeře, galerie postav s kostýmy, odměny z turnajů.
5. **Hraní** — partie proti botovi (4 úrovně) nebo pass‑and‑play s rodičem.
6. **Rodičovská zóna** — pokrok (skill heatmapa: tahy figur, šach, mat, openings), tipy na reálnou šachovnici, nastavení (délka sezení, voice, jazyk).

## 2. Architektura (Flutter)

```
lib/
  app/            router (go_router), theme, lokalizace
  core/
    chess/        pravidla, FEN/SAN, legal moves — balíček `chess` (dart) + vlastní wrapper
    engine/       bot: vlastní minimax (hloubka 1–3 + náhoda) pro úrovně 1–3; úroveň 4 volitelně `stockfish` (pub) se skill level 0–3
    lessons/      LessonEngine: načte YAML/JSON lekci, vyhodnocuje cíl (goal types z LESSONS.md), hinty, hvězdy
    progress/     lokální DB (drift/isar) — skill heatmapa, odemčené moduly/postavy
    audio/        voice‑over (předgenerované soubory per lokalizace), SFX, hudba (audioplayers / flame_audio)
  features/
    map/          mapa království
    lesson/       obrazovka lekce
    board/        šachovnice (widget), drag&drop, zvýraznění legálních polí, „láva“
    battle/       BattleScene (Flame): sprite‑sheet animace útočník/obránce
    army/         výběr a galerie armád
    play/         partie vs bot / pass‑and‑play
    parent/       rodičovská zóna
  data/
    armies/<id>/manifest.json + assets
    lessons/<module>/<lesson>.yaml
```

Rozhodnutí:
- **Šachovnice jako běžné Flutter widgety**, bitvy a mapa ve **Flame** (vložený `GameWidget`). Nedělat celou appku ve Flame — UI lekcí je formulářové.
- **Pravidla:** `chess` (pub, port chess.js) — ověřit, že umí FEN s neúplnými sadami (lekce mají často jen pár figur a někdy bez krále → v lekcích používat vlastní „lesson rules“ režim: legální tahy figury bez kontroly šachu, když na šachovnici chybí král). To je klíčový bod — LessonEngine musí mít přepínač `rules: full | piece_only`.
- **Bot úrovně:** 1 Miminko = náhodný legální tah; 2 Štěně = bere zadarmo, jinak náhoda; 3 Rytířka = minimax hloubka 2 + materiál; 4 Dračice = minimax hloubka 3 nebo Stockfish skill 1. Vždy bez „zlomyslnosti“ (neodkládat dětský mat jako past).
- **Stav:** Riverpod. Žádný backend v MVP. Volitelně později Go backend pro sync a packy (Ol1nSuperApp pattern).

## 3. Datový model armád (jádro „ne‑černobílých“ šachů)

`data/armies/<army_id>/manifest.json`:

```json
{
  "id": "fairies",
  "name": {"cs": "Víly", "en": "Fairies"},
  "palette": {"primary": "#F7A8D8", "accent": "#FFE29A"},
  "pieces": {
    "king":   {"name": {"cs": "Král tatínek"}, "sprite": "king.png", "idle": "king_idle", "attack": "king_attack", "defeat": "king_defeat", "voice": "king_hello"},
    "queen":  {...}, "rook": {...}, "bishop": {...}, "knight": {...}, "pawn": {...}
  },
  "battle_overrides": {
    "queen>knight": "queen_vs_knight_special"
  },
  "board_skin": "fairies_board.png"
}
```

- Každá postava má **4 animace**: `idle`, `attack`, `defeat`, `victory`. Bitva = kompozice: útočník `attack` + obránce `defeat` + útočník `victory`. To dává 6×6 kombinací mezi libovolnými dvěma armádami **bez** kreslení 36 videí; `battle_overrides` pro pár speciálních dvojic (Princezna vs Dračice…), kde se vyplatí unikátní scénka.
- Figury se na šachovnici liší barvou obruby/podstavce armády, aby dítě poznalo „moje vs soupeřovy“ i při dvou podobných armádách.
- Armády jsou nezávislé na straně (bílý/černý jen vnitřně pro pravidla).

Startovní armády (MVP 2, pak packy):
1. **Víly** (fairies) — pastel, křídla, hůlky. Archetyp: dobré víly.
2. **Čarodějky** (witches) — tmavě fialová, bouřka. Archetyp: zlé čarodějnice (ale roztomilé).
3. **Hrdinové / Padouši** (heroes/villains) — pláště, masky, komiksový styl (pack 1).
4. **Kapesní příšerky** (critters) — kulaté příšerky s živly (pack 2).
5. **Princezny / Draci** (princesses/dragons) — pohádkový (pack 3).

Lore: každá armáda má 6 pojmenovaných postav s jednou větou charakteru (voice‑over „Ahoj, já jsem…“ při prvním zobrazení).

## 4. Artwork pipeline (ComfyUI, Spark)

Cíl: konzistentní postavy v jednom stylu, 2D, čitelné na 48×48 px na šachovnici i ve full‑screen bitvě.

1. **Style reference**: zvolit jeden styl (návrh: chibi / „cute chunky“, silná obrysová linka, pastel, ladí s `cute_kid_fonts`). Vygenerovat 5–10 referencí a zafixovat prompt + seed strategii.
2. **Character sheet per postava**: front / 3/4 / bok, neutrální póza, bílé pozadí → rembg. Konzistence přes **IP‑adapter / Reference** nebo krátký **LoRA per armáda** (FineTune pipeline; stejný postup jako realeyes LoRA).
3. **Board sprite**: ze sheetu 1 ikona 256×256 (ořez na hlavu/tělo, výrazná silueta — test: rozpozná dítě figuru na 48 px?).
4. **Animace** — 3 cesty, zvolit v M2 po testu:
   - a) **Sprite‑sheet** z generovaných klíčových póz (idle 2 framy, attack 4, defeat 4, victory 3) + tween ve Flame. Nejlevnější, stačí.
   - b) **Rive** rigging jedné kresby (bone rig, 4 state machine stavy) — plynulé, ale ruční práce per postava.
   - c) **Video** z jeho video‑služby (image‑to‑video, 2 s klipy) → přehrávat jako video. Nejhezčí, ale velikost appky a nekontrolovatelná konzistence. Ponechat jen pro `battle_overrides`.
5. **Pozadí**: mapa království, arény pro bitvy (per armáda 1 aréna), board skin.
6. **Export**: PNG s alfou, @2x/@3x, sprite‑sheety přes TexturePacker‑kompatibilní JSON. Rozpočet: ≤ 60 MB base appka.

Zvuk: voice‑over CZ+EN z TTS pipeline (Hajánek), SFX (cinky, lusknutí, „šach!“ fanfára), 2 hudební smyčky. Dětský hlas vypravěčky.

## 5. Lekce jako data

`data/lessons/<module>/<n>.yaml`:

```yaml
id: m02_l03
module: 2
title: {cs: "Láva!"}
story: {cs: "Pozor, některé komnaty hoří. Věžka musí k hvězdě bezpečně."}
rules: piece_only
fen: "8/8/8/3*4/8/8/R7/8"     # * = hvězda, vlastní rozšíření FEN; nebo zvlášť `stars:`
stars: [d5]
lava: [a5, b2, c3]
goal: reach_square
max_moves: 3
hints:
  - {after_fails: 1, highlight: legal_moves}
  - {after_fails: 2, highlight: solution_first_move}
reward: {stars: 3}
```

LessonEngine validuje cíl po každém tahu, počítá hvězdy (3 = bez nápovědy a do `max_moves`), loguje skill events do progress DB. Nástroj `tool/lesson_lint.dart` ověří, že každá lekce je řešitelná (BFS nad legálními tahy) — povinné v CI.

## 6. Milníky

| M | Obsah | Výstup |
|---|---|---|
| **M0** | Scaffold, go_router, Riverpod, lokalizace, cute_kid_fonts, board widget, pravidla + `piece_only` režim, placeholder figury (barevné kruhy s písmenem) | Dá se táhnout figurou, legální pole svítí |
| **M1** | LessonEngine + YAML formát + lint; moduly 0–3 z LESSONS.md jako data; mapa království (statická); hvězdy a progress DB | Hratelné lekce bez grafiky |
| **M2** | Armády: manifest, 2 armády (Víly, Čarodějky) kompletní sheet + board sprite; BattleScene ve Flame (sprite‑sheet varianta); výběr armád | První bitva na telefonu — **test s dcerou** |
| **M3** | Moduly 4–9; bot úrovně 1–3; pass‑and‑play; voice‑over CZ | Celá cesta po mat |
| **M4** | Moduly 10–12 (openings, taktika, partie); turnaje + odměny (kostýmy); rodičovská zóna; EN voice | Feature complete |
| **M5** | Polish: animace mapy, hudba, onboarding, parent gate, ikonka, screenshoty; TestFlight + Play internal; store listing CZ/EN | Beta |
| **M6** | Pack 1 (Hrdinové/Padouši) jako IAP; bot úroveň 4; sdílitelný diplom | 1.0 |

Monetizace: base zdarma (2 armády, moduly 0–8), **jednorázový nákup** „Celé království“ (zbytek modulů + 1 pack), další packy armád jednotlivě. Žádné předplatné pro děti.

## 7. Test s dítětem (povinný po M2 a M4)

Sledovat: pozná figuru na šachovnici? Chápe zvýrazněná pole? Chce bitvu přeskočit, nebo ji chce vidět znovu (pokud znovu → přidat „replay“ tlačítko)? Kde se zasekne (koník). Délka pozornosti. Zapisovat do `docs/kid_tests.md`.

## 8. Otevřené otázky pro Ol1na

1. Název + bundle ID.
2. Styl artworku — chibi vs. „komiksový“ (ovlivní všechny packy, rozhodnout před M2).
3. Bitvy: sprite‑sheet (a) stačí, nebo chce rovnou video klipy z vlastní video služby (c)?
4. Flame pro bitvy vs čistý Flutter (Lottie/Rive) — preferuje Flame kvůli IMMUNORUN/Kiran zkušenosti?
5. Voice: dětská vypravěčka z TTS, nebo jeho/rodičovský hlas přes voice‑clone (Hajánek)?
6. Má smysl sdílet fairy‑tale/character assety se Storyteller / Hajánek (stejné postavy napříč appkami)?

## 9. První kroky pro Opus

1. Přečíst `PRINCESSCHESS_LESSONS.md`.
2. Založit repo, M0 scaffold, ověřit balíček `chess` na neúplných FEN; pokud nevyhovuje, napsat vlastní movegen (6 figur, není to velké) — rozhodnout do 1 hodiny práce.
3. Navrhnout YAML schéma lekcí + lint, převést modul 0–1 do dat.
4. Vrátit Ol1novi: screenshot board widgetu, schéma lekce, seznam otázek z bodu 8 s doporučením.
