# BATTLES_PLAN.md — bitvové animace pro PrincessChess (handoff pro Opus)

Doplněk k `PRINCESSCHESS_PLAN.md` (sekce 3–4). Řeší, jak vyrobit a přehrát animaci souboje při braní figury tak, aby **libovolná postava z libovolné armády** mohla bojovat s libovolnou jinou, bez kreslení scény pro každou dvojici.

## 0. Princip: skládání, ne dvojice

Bitva = **útočník** + **obránce** v jedné aréně. Každá postava má 4 samostatné klipy, nezávislé na soupeři:

| Klip | Délka | Co se děje |
|---|---|---|
| `idle` | smyčka 1 s | dýchá, mrká, houpe se |
| `attack` | 1,0–1,5 s | nápřah → úder/kouzlo směrem doprava (vždy doprava, obránce se zrcadlí) |
| `defeat` | 1,0 s | zásah → odlet/zmizení (puf, jiskry, „ouvej“) |
| `victory` | 1,0 s | radost, zamávání |

Choreografie v enginu: `idle` obou → útočník `attack` → při „hit framu“ obránce `defeat` + efekt zásahu → útočník `victory` → zpět na šachovnici. Celkem ≤ 3 s, od 0,5 s přeskočitelné klepnutím.

Počet assetů: **4 klipy × 6 figur = 24 na armádu**, kombinace zdarma. Unikátní duely (`battle_overrides`) jen pro ~5 hvězdných dvojic.

## 1. Výroba: tři cesty, jeden výstup

Všechny cesty končí stejně: **sekvence PNG/WebP framů s alfou → sprite‑sheet (JSON atlas) → Flame `SpriteAnimation`**. Díky tomu se dá cesta vyměnit bez zásahu do kódu appky.

### Cesta A — sprite‑sheet z klíčových póz (MVP, M2)

1. **Character sheet** (viz PRINCESSCHESS_PLAN §4): 1 obrázek postavy, front/3‑4, bílé pozadí, zafixovaný styl.
2. **Pózy** přes ComfyUI (SDXL nebo Flux + IP‑Adapter / krátký LoRA per postava):
   - idle: 2 pózy (neutrál, lehce nakloněná)
   - attack: 4 pózy (nápřah, výpad, úder, návrat)
   - defeat: 4 pózy (zásah, záklon, pád/odlet, prázdno)
   - victory: 3 pózy (ruce nahoru, skok, mrknutí)
   - Prompt: `<styl>, <postava>, <póza>, full body, white background, same character, same outfit`; stejný seed, ControlNet OpenPose s připravenými kostrami póz (jedna sada koster pro všechny postavy → konzistentní timing).
3. **Pozadí pryč**: BiRefNet / rembg node → PNG s alfou.
4. **In‑between** dělá Flame: tween pozice (nájezd 200 ms), scale „squash & stretch“, rotace ±8°, shake kamery při zásahu, částice (hvězdičky, srdíčka, bleskíky) z jedné sdílené sady. Výsledek vypadá jako animace i s 4 framy.
5. Volitelně **AI interpolace** (RIFE / FILM node) mezi pózami → 8–12 framů na klip, pokud bude trhané.

Rozpočet: 13 póz × 6 figur = ~80 obrázků na armádu; na Sparku pár minut generování, většina času je výběr dobrých framů.

### Cesta B — image‑to‑video (krásnější, M3+)

1. Vstup: stejný character sheet.
2. **I2V model** z jeho video služby (Wan 2.x I2V / jiné, co má v Tsumiki kartách), 2 s @ 16–24 fps, prompt per klip:
   - attack: „character winds up and casts a sparkle spell to the right, white background, 2D animation style“
   - defeat: „character gets bonked, spins and flies off to the left, cartoon, white background“
   - victory: „character jumps and cheers, white background“
   - idle: „character breathes and blinks, subtle motion, white background“
3. **Video matting**: RobustVideoMatting / BiRefNet‑video node → alfa per frame. Bílé pozadí ve vstupu matting hodně usnadní.
4. `ffmpeg` → PNG sekvence → downsample na 12 fps a 256 px → `tool/pack_sheet.py` → atlas.
5. Výběr: generovat 3–4 varianty, ručně vybrat. Kontrola konzistence: postava nesmí měnit barvu/outfit mezi klipy; pokud model „odjíždí“, přidat první frame jako reference i do posledního (start+end frame I2V) a zkrátit na 1,5 s.

Riziko: nekonzistence mezi klipy, halucinace končetin. Mitigace: krátké klipy, bílé pozadí, LoRA postavy, variantování. Velikost: 4 klipy × 24 framů × 256 px WebP ≈ 1,5–3 MB na postavu → ~15 MB na armádu; ok pro base 2 armády, packy stahovat on‑demand (asset bundle / Play Asset Delivery, ODR na iOS).

### Cesta C — 3D přes FantasyCharacter pipeline (škálování, později)

1. 2D sheet → 3D model (existující FantasyCharacter pipeline).
2. Rig + Mixamo‑style klipy: `Idle`, `Standing Melee Attack` / `Spell Cast`, `Falling Back Death` (zjemnit, žádná „smrt“, spíš „odfouknutí“), `Victory`.
3. Render z fixní 3/4 kamery do PNG sekvence (Blender headless, toon shader + outline, ať to sedí ke 2D stylu) → atlas.
4. Nová armáda = 6 modelů, animace se recyklují → nejlevnější od 3. packu dál.

### Kdy co

| | A sprite‑sheet | B video | C 3D |
|---|---|---|---|
| Čas na 1. armádu | 1–2 dny | 2–4 dny | 1–2 týdny setup |
| Čas na další armádu | 1 den | 2 dny | 2–3 dny |
| Konzistence | vysoká | střední | vysoká |
| Vzhled | „chunky 2D“, s efekty dobré | nejplynulejší | plynulé, ale „3D feel“ |
| Velikost / armáda | ~3 MB | ~15 MB | ~5 MB |

Doporučení: **A pro M2 a base armády**, B pro `battle_overrides` a pro 2. pack jako experiment, C až když bude 4+ packů.

## 2. Formát assetů (společný)

```
assets/armies/<army>/battle/<piece>/
  idle.png + idle.json      # TexturePacker‑style atlas (frames, size, duration)
  attack.png + attack.json  # meta: hit_frame (index, kdy zásah), anchor (x,y nohy)
  defeat.png + defeat.json
  victory.png + victory.json
```

`attack.json` navíc: `hit_frame`, `fx: "sparkle" | "bonk" | "zap" | "splash"`, `sfx: "whoosh_02"`. `defeat.json`: `exit: "fly_left" | "poof" | "sink"`. Všechny postavy stejné měřítko (kotva u nohou, výška ~220 px z 256), ať se nesmíchají velikosti mezi armádami.

`tool/pack_sheet.py`: PNG sekvence → trim + pad → atlas + JSON; validuje počet framů, alfa, rozměr. Běží v CI nad každou armádou.

## 3. Přehrávání ve Flame

```
BattleScene (FlameGame, overlay přes board)
  ├─ ArenaBackground (per armáda útočníka, parallax 2 vrstvy)
  ├─ Fighter(attacker, side: left)   # SpriteAnimationGroupComponent {idle, attack, victory}
  ├─ Fighter(defender, side: right, flipped)  # {idle, defeat}
  ├─ FxLayer (ParticleSystemComponent, sdílené efekty)
  └─ BattleDirector  # stavový automat
```

`BattleDirector` stavy: `enter` (oba nájezd 300 ms) → `idle` (400 ms, bublina s hláškou postavy) → `attack` → na `hit_frame`: `defeat` + fx + camera shake + sfx → `victory` → `exit` (300 ms) → callback do board → figura zmizí z pole, útočník na něj doskočí. Skip po 500 ms: přeskočí rovnou na `exit`.

Výkon: předehřát atlasy obou armád při startu partie (`Flame.images.loadAll`), ne při první bitvě. Cíl 60 fps na 5 let starém Androidu.

## 4. Hlášky a zvuk

- Každá postava: 3 krátké hlášky (attack / defeat / victory), voice‑over z TTS pipeline (Hajánek), dětsky laskavé („Hopla!“, „Jdu si odpočinout do hradu…“, „Jupí!“). Nikdy „umřel“, „zabil“.
- SFX sdílené: 6 whoosh, 4 hit (bonk/sparkle/zap/splash), 2 fanfáry. Vlastní nebo CC0.
- Hudba v bitvě: krátký sting přes hudbu z šachovnice, ne celá skladba.

## 5. Speciální duely (`battle_overrides`)

Jen pro dvojice, které dítě uvidí často nebo jsou „hvězdné“: Princezna vs Princezna, Princezna vs Král, Koník vs Koník, + 2 dle armád. Výroba cestou B jako **jeden klip s oběma postavami** (ovládaný start‑frame = obě postavy ve scéně vygenerované cestou A). Formát stejný (atlas), jen flag `pair: true` → BattleDirector přehraje jediný klip místo kompozice.

## 6. Milníky

| M | Výstup |
|---|---|
| **B1** | `pack_sheet.py`, formát JSON, BattleScene s placeholder postavami (barevné tvary), stavový automat, skip, fx a shake — hotovo bez jediného assetu |
| **B2** | ComfyUI workflow cesty A (uložit `.json` workflow do `tools/comfy/`), 1 postava (Víla‑Princezna) kompletní 4 klipy → první skutečná bitva na telefonu → **test s dcerou** |
| **B3** | Zbytek armád Víly + Čarodějky cestou A, hlášky, sfx |
| **B4** | Experiment cesty B na 1 postavě; rozhodnout, zda packy pojedou B |
| **B5** | 5 speciálních duelů; on‑demand stahování packů |

## 7. Otázky pro Ol1na

1. Který I2V model teď běží na video službě a jaká je délka/rozlišení, co dá za rozumný čas? (Rozhodne, zda B připadá v úvahu už pro base armády.)
2. Chce „zásah“ jako komiksový bonk, nebo spíš magické kouzlo bez kontaktu (jemnější pro 5 let)?
3. Může bitva běžet jako fullscreen overlay, nebo má zůstat „na šachovnici“ v malém (menší wow, ale rychlejší tempo partie)? Návrh: fullscreen v lekcích, malá verze v partiích vs bot (nastavitelné v rodičovské zóně).
