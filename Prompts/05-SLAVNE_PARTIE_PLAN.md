# SLAVNE_PARTIE_PLAN.md — slavné partie, přehrávač a živé turnaje (handoff pro Opus)

Doplněk k `00-PRINCESSCHESS_PLAN.md`. Přidává do appky **knihovnu skutečných partií** (mistři světa, zápasy o titul, kandidáti, velké turnaje), **přehrávač**, který je odehraje armádami s bitvami, a **živý kanál** pro právě probíhající turnaj.

Stav k 21. 11. 2026: v repu z toho není nic. Není načítání PGN, není obrazovka volné partie, není síťová vrstva. Existuje `Rules.parseSan` / `Rules.san` a plná pravidla (`RuleSet.full`, ověřeno perftem).

## Rozhodnuto (Olin, 21. 11. 2026)

1. **„64 partií" znamená obojí:** Zlatá šachovnice (64 celkem, s příběhem a hlasem) jako první, potom 64 na každého šampiona.
2. **Zápas o mistra světa 2026 je pilot živého přehrávání.** Pořadí prací je proto G1 → G2 → G3.
3. **Relay běží na Cloudflare** (Worker s cronem), ne na NAS.

## 0. Princip

1. **Partie jsou data, ne kód.** Jeden formát (PGN, jen hlavičky a tahy) pro přibalené partie, živý kanál i import od rodiče. Všechno hlídá lint v CI, stejně jako lekce.
2. **Dvě vrstvy nad stejnými daty.**
   - *Pohádka* (dítě, neumí číst): partie běží sama jako film, bitvy jen ve vybraných momentech, vypravěč, velká tlačítka, žádný text.
   - *Kronika* (rodič): notace, seznam tahů, krokování, hlavičky, tabulka turnaje.
3. **Jádro čisté a deterministické**: `lib/core/games/` bez Flutteru; laditelné konstanty (rychlosti, strop bitev) v jediném `replay_config.dart`.
4. **Nejdřív pilot, pak objem.** Tři vzorové partie a živý zápas na telefonu, test s dcerou (po G2), teprve potom tisíce partií.

## 1. Co dítě a rodič uvidí

Nové místo na mapě: **Síň slávy** (hrad s korunami). Uvnitř police:

| Police | Obsah | Dítě vidí |
|---|---|---|
| Zlatá šachovnice | 64 nejslavnějších partií napříč všemi šampiony, s příběhem a hlasem | šachovnice 8×8, každé pole = jedna pohádka |
| Šampioni a šampionky | každý mistr a mistryně světa má vlastní šachovnici 64 partií | koruna s pořadovým číslem a původní emblém |
| Zápasy o korunu | všechny zápasy o titul mistra světa od 1886 | časová osa, dvě koruny proti sobě |
| Cesta vyzyvatelů | turnaje a zápasy kandidátů od 1950 | žebřík k trůnu |
| Velké turnaje | výběr slavných turnajů | stany/hrady podle místa |
| Právě se hraje | probíhající turnaj ze živého kanálu | stan s praporkem, jen když něco běží |

Pole 8×8 jako jednotka: přehraná partie = nálepka na poli; plná šachovnice = odměna (kostým, napojit na odměny z M4). Pole jsou řazená chronologicky od a1 po h8, takže šachovnice šampiona je zároveň jeho kariéra.

**Pozor na věk:** většina mistrovských partií končí vzdáním nebo remízou, ne matem. Pětileté dítě nepochopí, proč je konec. Proto:
- tag `ends_in_mate` a v Pohádce řadit takové partie dopředu, stejně jako miniatury do 25 tahů;
- konec vzdáním = král se ukloní a podá korunu, remíza = podání rukou (krátká animace + hláška);
- tlačítko **Dohraj to**: z konečné pozice hraje dítě za vítěze proti nejlehčímu botovi.

## 2. Obsah a rozsah

„64 partií" má dvě podoby a dělají se obě, Tier A jako první:

- **Tier A — Zlatá šachovnice:** 64 partií celkem, ruční výběr, příběh cs+en, hlas, překlad do katalogu.
- **Tier B — šachovnice šampionů:** 64 partií na každého. Klasická linie má 18 mistrů (Steinitz, Lasker, Capablanca, Aljechin, Euwe, Botvinnik, Smyslov, Tal, Petrosjan, Spasskij, Fischer, Karpov, Kasparov, Kramnik, Anand, Carlsen, Ting Li-žen, Gukesh), tedy 1 152 partií. Počet nesmí být v kódu natvrdo: zápas 2026 může přidat devatenáctého.
- **Šampionky:** mistryně světa od Věry Menčíkové po současnost (v době psaní 17, ověřit) a Judit Polgárová. Pro appku jménem PrincessChess to má být první třída, ne dodatek. Menčíková reprezentovala Československo.
- **Zápasy o titul:** 1886–2024 kompletně (řádově 1 000 partií; jen Karpov–Kasparov 1984 jich má 48), plus turnaje o titul 1948, 2005, 2007 a rozdělené období 1993–2006 jako samostatná větev. Tiebreaky značit `tc: rapid`.
- **Kandidáti:** turnaje a zápasy od Budapešti 1950. Mezipásmové turnaje až později.
- **Velké turnaje (první vlna):** Londýn 1851, Hastings 1895, Petrohrad 1914, New York 1924, Nottingham 1936, AVRO 1938, Curych 1953 a z novější doby Linares, Wijk aan Zee, Dortmund. Česká stopa: Karlovy Vary 1907, 1911, 1923, 1929.

Jedna partie patří do více polic (např. zápas o titul i šachovnice šampiona). Proto **globální sklad partií se stabilním ID** = hash normalizovaných (bílý, černý, datum, tahy), stejný princip jako klíč hlasových klipů. Police na ID jen odkazují.

Velikost: PGN bez komentářů má kolem 1 kB na partii, 5 000 partií jsou jednotky MB a v balíčku se zkomprimují. Historie se tedy **přibalí celá** a zůstane offline; síť je jen pro živý kanál.

### Výběr 64 partií šampiona
Skript navrhne, člověk vybere. `tool/games/rank.dart` ohodnotí všechny dostupné partie hráče: výhra, síla soupeře, váha akce (zápas o titul > kandidáti > superturnaj), bonus za krátkost a za mat na šachovnici. Výstup je seznam 100 kandidátů → ruční výběr 64 do `data/games/collections/champions/<id>.yaml`. Výběr nepřebírat z jedné knihy ani jednoho webu (viz §7).

## 3. Datová vrstva

```
data/games/pgn/<zdroj>/…          zdrojová PGN po očištění (nebalí se do appky)
data/games/players.yaml           kanonická jména, aliasy, emblém, pořadí šampiona
data/games/collections/**.yaml    police: typ, název (cs/en), seznam ID nebo pravidlo (celá akce)
data/games/stories/<id>.yaml      Tier A: úvod, momenty (ply → text cs/en), závěr
assets/games/index.json           seznam polic pro UI (bez parsování PGN)
assets/games/c/<police>.json      položky: id, hráči, rok, výsledek, počet tahů, tagy, tier
assets/games/p/<balík>.pgn        partie; index drží (balík, offset)
```

`assets/games/**` generuje `dart run tool/games/pack.dart` z `data/games/**`; ručně se needituje.

**Jádro `lib/core/games/`** (čistý Dart):
- `pgn.dart` — hlavičky, tahy, přeskočit komentáře `{}`, varianty `()`, NAG `$n`; `0-0` i `O-O`; hlavička `FEN`/`SetUp` pro partie s výhodou.
- `san_reader.dart` — rychlé rozlišení SAN podle typu figury, cíle a rozlišovače. Stávající `Rules.parseSan` generuje SAN pro každý legální tah a na lint tisíců partií je pomalý; nechat ho jako referenci v testu (oba musí dát stejný tah).
- `game_record.dart` — neměnná partie: hlavičky, `List<Move>`, pozice po každém půltahu.
- `moments.dart` — momenty bez enginu: braní, šach, mat, rošáda, proměna, oběť (materiálový skok, který se nevrátí do N půltahů).
- `library.dart` — načtení indexu, dohledání partie podle ID.

**Lint `tool/games_lint.dart`** (do CI vedle `lesson_lint`):
- každá partie se přehraje legálně od začátku do konce; výsledek v hlavičce nesmí odporovat konečné pozici;
- žádné duplicitní ID, každý odkaz z police existuje, šachovnice šampiona má přesně 64 polí;
- přibalené PGN nemá komentáře ani varianty;
- jména jen z `players.yaml`; názvy akcí neprojdou seznamem zakázaných značek (§7);
- Tier A má příběh cs+en a hlasové klipy.

## 4. Přehrávač

`lib/features/replay/`: `ReplayController` (Riverpod: půltah, hraje/stojí, rychlost, režim, politika bitev) a `ReplayScreen`. Nové cesty v routeru: `/hall`, `/hall/:shelf`, `/game/:id`, `/live/:tournament`.

Společné:
- Figura se musí po šachovnici **posunout**. `ChessBoard` dnes animuje jen pulzy; přidat animovaný přesun mezi pozicemi, jinak tahy problikávají. Poslední tah zvýraznit přes `BoardMarks.hintMove`/`glow`.
- Armády: výchozí moje vs. soupeřova z `Progress`; bílý hráč = moje armáda, pokud dítě neřekne jinak. Volitelně „fandím" jedné straně.

Pohádka (dítě):
- Autoplay. Mezi momenty tahy rychle (kolem 0,4 s), u momentu zpomalit a nechat mluvit vypravěče.
- **Strop bitev:** celoobrazovková bitva nejvýš 3–4× za partii (první braní, klíčové momenty, konec), ostatní braní jen malý „puf" na šachovnici. Malá bitva v šachovnici je v plánu M3 (DECISIONS §11) a tady se použije.
- Ovládání bez textu: velké ▶/⏸, „skoč na další bitvu", „znovu". Časová osa s puntíky momentů.
- **Hádej tah:** u 1–3 momentů se film zastaví a dítě vybírá ze tří tahů (typ `choose_move` z modulu 10) → hvězdy.

Kronika (rodič, za rodičovskou bránou nebo přepínačem):
- Krok vpřed/vzad, skok na tah, seznam tahů v notaci, hlavičky, bitvy vypnuté.
- U turnaje kola a tabulka; u zápasu skóre po partiích.
- Tip pro společné sledování: krátká otázka pro rodiče k momentu („Zeptej se: kterou figurku bys vzala?").

`Progress`: přidat `gamesWatched` a hvězdy z hádání. `shared_preferences` JSON zatím stačí (DECISIONS §8).

## 5. Příběhy, hlas, překlady

- **Tier A:** úvod + 2–3 momenty + závěr = kolem 5 vět na partii, 64 partií → asi 320 textů na jazyk (stejný rozsah jako armády z Archionu). Hlas cs+en: asi 640 klipů. Dnes má 482 českých klipů s anglickými dohromady 22 MB, takže počítat s dalšími zhruba 15 MB.
- **Tier B a živé partie:** žádné psané příběhy. Malá sada **obecných hlášek vázaných na událost** („Šach!", „Koník skáče přes hradbu!", „Princezna se obětovala!", „Mat! Bitva je vyhraná.") — pár desítek klipů pokryje tisíce partií. Texty jdou přes ARB/katalog, žádný text natvrdo.
- Návrhy příběhů generuje LLM na SPARKu (přes `sparkctl`, skill `spark-job`) ze strukturovaných faktů: hlavičky + momenty. **Vyprávění je o postavách armád, ne o lidech.** Žádné vymyšlené citáty ani historky o skutečných hráčích; životopisný fakt jen z `players.yaml` se zdrojem. Olin schvaluje češtinu, pak en a katalog.
- Jména hráčů ve všech jazycích latinkou (zápis FIDE). Dítě se orientuje podle emblému a čísla koruny.
- Změna textu = chybějící klip a červený `flutter test` (platný invariant), s tím počítat v pořadí prací.

Analýza enginem (G5, volitelná): Stockfish jako **nástroj na vývojovém stroji**, do appky jdou jen výsledná data (momenty „skvělý tah / chyba", u vzdaných partií případně matová varianta „jak by to dopadlo"). Stockfish je GPLv3, do appky se nelinkuje.

## 6. Živý turnaj („Právě se hraje")

```
zdroj (Lichess Broadcast API) → relay → statické soubory na vlastní doméně → appka
```

- **Zdroj:** Lichess Broadcast API. Ověřeno naživo 21. 11. 2026, bez přihlášení:
  - `GET /api/broadcast/top` — JSON `active` / `upcoming` / `past`;
  - `GET /api/broadcast/{tourId}` — turnaj a seznam kol (`id`, `name`, `startsAt`);
  - `GET /api/broadcast/round/{roundId}.pgn` — PGN celého kola, odpověď má `Last-Modified` a `Cache-Control: public, max-age=10`;
  - neověřeno: `GET /api/broadcast/{tourId}.pgn` (celý turnaj) a streamovací varianta. Relay je nepotřebuje.
  - Podmínky a limity API si přečíst na oficiální stránce před nasazením. Jeden dotaz naráz, při 429 minutu počkat, vlastní `User-Agent`. Záloha: PGN přímo od pořadatele.
- **Co ze zdroje vyhodit:** komentáře s hodinami a hodnocením (`{ [%eval …] [%clk …] }`), hlavičky `Site`, `GameURL`, `BroadcastURL`, `BroadcastName`, `Opening`. Hlavička `Event` má tvar „Round 7: Bílý - Černý", název akce se bere z kurátorského seznamu. Ponechat `White`, `Black`, `Result`, `Round`, `Date`, `ECO`, případně Elo.
- **Proč relay a ne appka přímo:** dětská appka nemá posílat nic třetí straně; jeden dotazující se server místo tisíců telefonů; kurátorství (které turnaje, pod jakým názvem); očištění názvů od sponzorů; nezávislost appky na změně cizího API.
- **Relay = Cloudflare Worker** v adresáři `feed/` tohoto repa (TypeScript, `wrangler.jsonc`; před psaním načíst skilly `cloudflare:workers-best-practices` a `cloudflare:wrangler`):
  - Cron Trigger po minutě. Pro turnaje z `feed/tournaments.json`, které právě běží, najde dnešní kolo a stáhne jeho PGN s `If-Modified-Since`.
  - Očištěné kolo uloží do KV, **jen když se změnilo** (bezplatný tarif má denní strop zápisů, ověřit aktuální limity). Jeden klíč na kolo.
  - Handler `fetch` vrací `/v1/live.json` a `/v1/t/<id>/r<kolo>.pgn` s `ETag` a krátkou cache.
  - Žádné logování IP adres, žádná analytika.
  - Veřejná adresa kanálu smí být v appce jako konstanta (`lib/core/net/feed_config.dart`), je stejně v binárce. ID účtu Cloudflare a API token jen v prostředí nebo v secrets CI, ne v repu.
  - Nasazení (`wrangler deploy`) je krok ven: dělá se na Olinův pokyn a s jeho přihlášením.
- **Formát kanálu `v1/`:** `live.json` (běžící a nedávné turnaje: id, název cs/en, emblém, data, kola a jejich stav), `t/<id>/r<kolo>.pgn` (jen hlavičky a tahy). Kurátorský seznam `feed/tournaments.json`: ID vysílání, neutrální název, emblém. Přidání turnaje = PR + nasazení.
- **Appka:** `lib/core/net/feed_client.dart` (závislosti `http`, `path_provider`), dotaz jen když je obrazovka otevřená, podmíněný `ETag`, stažené kolo se uloží a jde přehrát offline. Bez účtů, identifikátorů a analytiky. Přepínač „partie z internetu" v rodičovské zóně.
- **Pro dítě:** ~~živé sledování tah po tahu ne.~~ Změněno 24. 11. 2026: režim Živě, viz `06-ZIVY_PRENOS_PLAN.md`. Po skončení kola appka nabídne **pohádku z dnešního kola**: partii vybere pravidlo (rozhodnutý výsledek, mat na šachovnici, krátkost, počet bitev). Rodič vidí všechny partie kola i rozehrané.
- **Po turnaji:** partie se přesunou do `data/games/` a vyjdou v dalším vydání appky; kanál tedy slouží i jako doplňování obsahu mezi vydáními.

**Pilot: zápas o mistra světa 2026, Gukesh–Sindarov, Ženeva.** Údaje z Lichess API k 21. 11. 2026:
- vysílání `qfkdt8mn`, 14 kol po jedné partii, každá začíná ve 14:00 UTC (15:00 našeho času);
- 1. partie 24. 11. (kolo `xLgOJ6cb`), dále 25., 26., 28., 29., 30. 11., 2., 3., 4., 6., 7., 8., 10. a 11. 12.; ID kol brát vždy z `/api/broadcast/qfkdt8mn`;
- tiebreak v seznamu kol zatím není, relay musí snést kolo přidané během zápasu;
- název v appce: „Zápas o mistra světa 2026, Ženeva" (oficiální název nese sponzora).

Jedna partie denně s dvěma hráči je nejjednodušší možný živý turnaj. Když se první partie nestihnou, nic se neztrácí: kola zůstávají ve zdroji a zápas jde dohnat zpětně. **Na dceřin telefon se pilot dostane jen lokální instalací z Macu, nebo po opravě release pipeline** (v1.0.1 spadl na secrets), s tím počítat.

Důsledky, které nejdou přehlédnout:
- README a popis ve storech říkají „offline" (25 souborů ve `fastlane/metadata`). Po přidání kanálu platí „funguje offline, živé turnaje volitelně z internetu" → upravit texty ve všech jazycích.
- V repu zatím chybí `docs/privacy.html`; kanál do ní patří (žádné účty, žádné sledování, co loguje server).
- Ověřit pravidla dětské kategorie obou storů pro síťový provoz a odkazy ven.

## 7. Práva a značky

- **Tahy partie jsou fakta** a volně se šíří. Chráněné mohou být komentáře, anotace a u sbírek i samotný výběr a databáze jako celek. Proto: komentáře a varianty vždy odstranit, výběr dělat vlastní, nebrat podstatnou část jedné cizí databáze, Tier A ověřit ze dvou zdrojů. Zdroje zapsat do `docs/CREDITS.md`.
- Kandidáti na zdroje (u každého před stažením přečíst podmínky): archiv vysílání Lichess, PGN Mentor, The Week in Chess, Wikipedie u zápasů o titul, komunitní databáze (Caissabase, Lumbra). chessgames.com hromadně nestahovat, jen ruční kontrola.
- **Skuteční lidé:** jména a výsledky jako fakta ano; žádné portréty, karikatury ani vymyšlené výroky. Každý šampion dostane **původní emblém** (koruna s číslem + motiv, např. klobouk kouzelníka) ze stávající art pipeline, pilot na jednom kusu.
- **Vlajky vynechat** (zaniklé státy, hráči pod vlajkou FIDE, politika). Kód federace jen v Kronice.
- **Invariant „žádné cizí značky" platí i tady:** turnaje pojmenovat místem a rokem („Wijk aan Zee 2025", „Zápas o mistra světa 2026, Ženeva"), ne sponzorem. Lint drží seznam zakázaných slov. Název police se nesmí plést s názvem existující knihy.
- Šachy 960 a jiné varianty mimo rozsah.

## 8. Milníky

| M | Výstup | Hotovo, když |
|---|---|---|
| **G1** | Jádro: `pgn`, `san_reader`, `game_record`, `moments`, lint, testy; `ReplayController`; animovaný přesun figury; Kronika a základní Pohádka (autoplay, strop bitev, obecné hlášky bez hlasu). Tři přibalené partie jako vzorek i testovací data: Morphyho partie v opeře 1858 (17 tahů a mat), jedna partie šampiona, jedna šampionky | libovolné PGN se přehraje v obou režimech; lint v CI |
| **G2** | Živý kanál: Worker v `feed/`, formát `v1`, obrazovka „Právě se hraje", cache v appce; kurátorský seznam s jediným turnajem (zápas 2026) | partie zápasu jde přehrát v appce a po stažení i bez sítě; **test s dcerou** na jedné partii zápasu zapsaný v `docs/kid_tests.md` |
| **G3** | Knihovna: `data/games`, `pack.dart`, `players.yaml`, Síň slávy, police, šachovnice 8×8; obsah: zápasy o titul 1886–2024 a výběr Zlaté šachovnice | 64 + zápasy o titul v appce, nálepky se ukládají |
| **G4** | Dětská vrstva: příběhy a hlas Tier A, obecné hlášky, hádej tah, Dohraj to, konce vzdáním/remízou, odměny | Zlatá šachovnice kompletní cs+en, katalog přeložen |
| **G5** | Objem: šachovnice šampionů a šampionek, kandidáti, velké turnaje; emblémy; volitelně analýza enginem | lint zelený na celém skladu |
| **G6** | Navíc: viz §9 | podle výběru |

G2 je před G3 kvůli kalendáři: zápas končí 11. 12. (bez tiebreaku). Test s dcerou po G2 rozhoduje, jak moc investovat do G4. G1 a G2 nezávisí na modulech 7–9; „Dohraj to" potřebuje bota a obrazovku volné partie z M3.

## 9. Další nápady (seřazeno podle poměru přínos/práce)

1. **Úlohy z partií šampionů:** z celého skladu vytěžit pozice mat 1. a 2. tahem → hotové úlohy pro `LessonEngine`, řešitelnost hlídá stávající solver a lint. „Dokonči to jako Tal."
2. **Před šampiony:** Morphy, Anderssen (Nesmrtelná, Věčně zelená). Krátké, efektní, končí matem — pro dítě nejlepší materiál vůbec.
3. **Moje partie:** partie dítěte z hry proti botovi a s rodičem se ukládají a mají vlastní šachovnici vedle šampionů. Rodič může vložit PGN (např. z dětského turnaje) a přehrát ho armádami.
4. **Česká stopa:** Steinitz se narodil v Praze; Réti, Duras, Flohr, Hort, Navara; karlovarské turnaje.
5. **Roboti:** Kasparov–Deep Blue 1997 (rozhodující partie má 19 tahů), AlphaZero.
6. **Zázračné děti:** partie, které šampioni hráli jako děti. Motivace „taky byli malí".
7. **Partie dne / Dnes před lety:** jedna dlaždice na mapě, deterministicky podle data, offline.
8. **Jak začínali šampioni:** první tahy z knihovny jako podklad pro modul 10 (zahájení).
9. **Klasické figurky** jako přepínač v Kronice pro rodiče, který chce vidět partii „normálně".
10. **Sdílení klipu** partie s bitvami (video) — až na konec, za rodičovskou bránou.

## 10. Otázky pro Ol1na

Otázky k pořadí prací jsou rozhodnuté nahoře. Zbývají:

1. **Síť v dětské appce:** kanál výchozí zapnutý, nebo ho zapíná rodič? Do odpovědi: zapíná rodič.
2. **Doména kanálu:** vlastní subdoména, nebo adresa `workers.dev`? Potřeba před nasazením G2.
3. **Šampionky** jako rovnocenná police hned od G3? Do odpovědi: ano.
4. ~~**Zdarma, nebo balíčky?**~~ Rozhodnuto 22. 11. 2026: celá knihovna zdarma (DECISIONS §19).
5. **Hlas pro Tier A** přibalit (asi +15 MB), nebo stahovat na vyžádání? Potřeba před G4.
6. **Emblémy šampionů:** stačí koruna s číslem, nebo původní kreslený motiv pro každého? Potřeba před G5.

## 11. První kroky pro Opus

1. Přečíst `docs/DECISIONS.md` (§1, §8, §11, §13), `lib/core/chess/rules.dart`, `lib/features/battle/`, `lib/features/board/chess_board.dart`.
2. **G1** v jednom PR: jádro, lint v CI, přehrávač, tři vzorové partie. Gate repa před pushem.
3. **G2** ve druhém PR: `feed/` (Worker) a obrazovka „Právě se hraje". Worker nejdřív lokálně (`wrangler dev`) proti skutečnému kolu zápasu; nasazení až na Olinův pokyn a po odpovědi na otázku 2.
4. Po G2 se zastavit na testu s dcerou.
5. Rozhodnutí zapisovat do `docs/DECISIONS.md`, formát dat do `docs/games_schema.md`, kanál do `docs/feed.md`.
