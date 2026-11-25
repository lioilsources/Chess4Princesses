# ZIVY_PRENOS_PLAN.md — režim Živě: nové tahy bez restartu, hodiny, rádce, analýza (handoff pro Opus)

Doplněk k `05-SLAVNE_PARTIE_PLAN.md` (§6 Živý turnaj). Živá partie dnes běží stejným přehrávačem jako slavné partie: přehraje se do posledního staženého tahu a skončí kartou „Tahle bitva se ještě hraje". Nový tah se objeví až po restartu appky. Tento plán přidává **samostatný režim Živě**.

Stav k 24. 11. 2026: `main` na `4824610` (po merge #17). Relay běží na `https://feed.ol1n.com`, první partie zápasu 2026 je dohraná (remíza, 38 tahů). Otevřené PR #16 (web F1) a #18 (store listing) s tímhle plánem nesouvisí.

## Rozhodnuto (Olin, 24. 11. 2026)

1. **Živý přenos má vlastní režim**, jiný než přehrávání slavných partií. Nový tah se ukáže sám, bez restartu.
2. **Po otevření** rozehrané partie se dosavadní tahy **rychle přehrají** a pak se čeká na další.
3. **Při čekání** si divák může zkoušet vlastní pokračování (**Analýza**) nebo si pustit **návrhy komentátora**.
4. **Časomíra**: je vidět, kolik času komu zbývá a kdo je v časové tísni.
5. **Je to pro děti i rodiče.** Bitvy se přehrávají. Kronika v živém režimu zůstává.
6. **Nastavení**: bitvy jdou vypnout a figurky jdou přepnout na klasické šachové.
7. **Konec partie**: karta s výsledkem a samolepka za dosledovanou partii.
8. **Síť jen při otevřené obrazovce.** Žádné dotazy na pozadí.

Bod 1 ruší větu z `05-SLAVNE_PARTIE_PLAN.md` §6 „Pro dítě: živé sledování tah po tahu ne". Zapsat do `docs/DECISIONS.md` (nový bod 21) a do §6 přidat odkaz sem.

## 0. Princip

1. **Jeden formát zůstává.** Kolo je dál PGN. Hodiny a hodnocení jsou v PGN komentářích (`[%clk]`, `[%eval]`), které starý parser přeskakuje, takže vydané verze appky fungují dál.
2. **Jádro čisté a deterministické.** Vše, co jde testovat bez Flutteru, patří do `lib/core/games/` a `lib/core/net/`. Čas, časovač a síťový klient se do tříd vkládají, aby testy běžely s falešnými hodinami.
3. **Laditelné konstanty na jednom místě:** nový `lib/core/games/live_config.dart` (vedle `replay_config.dart`).
4. **Živou partii nikdy nepřetáčet pod rukama.** Když si divák zkouší vlastní tahy nebo prochází historii, nový tah jen ohlásí banner. Zpět do partie se vrací sám.
5. **Dítě nečte.** Každý nový stav musí být čitelný z obrázku a zvuku: pulzující „živě", přesýpací hodiny, šipka návrhu. Text je navíc, hlavně pro Kroniku.
6. **Žádné cizí značky.** Komentátor je původní postava „Rádce", v dětské vrstvě se neobjeví název zdroje ani enginu. Zdroj patří do `docs/CREDITS.md`.

## 1. Proč je dnes nutný restart

| Místo | Chování |
|---|---|
| `lib/features/games/live_providers.dart`, `roundGamesProvider` | `FutureProvider.family` bez `autoDispose`: kolo se stáhne jednou a drží se do konce běhu appky |
| `lib/features/games/live_screen.dart`, tlačítko obnovit | invaliduje jen `liveTournamentsProvider` (seznam kol), ne tahy |
| `lib/features/games/replay_controller.dart` | `record` je neměnný `GameRecord`; u nedohrané partie skončí hláškou `endUnfinished` |
| `feed/src/index.ts` | rozehrané kolo drží v edge cache 60 s; zdroj přitom dovoluje 10 s |
| `feed/src/clean.ts` | zahazuje hodiny i hodnocení, appka je nemá odkud vzít |
| router `/live/:t/:r` | kolo bere z `extra`; bez něj (odkaz, obnova) spadne na seznam kol |

## 2. Ověřená fakta o zdroji (24. 11. 2026, 1. partie)

- `GET /api/broadcast/round/{roundId}.pgn`: `Cache-Control: public, max-age=10`, `Last-Modified`. Každý tah nese komentář `{ [%eval 0.18] [%clk 1:59:50] }`. Hlavička `TimeControl` je volný text (`120'/40m + 30'/end, 30/move from move 41`), nedá se spolehlivě parsovat.
- **Lidský komentář ve zdroji není**: v PGN není jediná varianta ani textový komentář, studie není zapisovatelná. Chat přes API nejde a do dětské appky nepatří.
- `GET /api/broadcast/-/-/{roundId}` (JSON kola): `games[]` s `fen`, `lastMove`, `status`, `players[].clock` (setiny sekundy). **Neověřeno:** pole `thinkTime` (sekundy od posledního tahu) u běžící partie. Ověřit naživo při 2. partii.
- `GET /api/cloud-eval?fen=…&multiPv=3`: pro pozice z partie vrací hloubku 40–55 a tři varianty po deseti půltazích. Tahy jsou v UCI, **rošáda jako král bere věž** (`e1h1`). Neznámá pozice dá 404. **Neověřeno:** jak rychle se objeví nová pozice během živé partie a zda je `cp` vždy z pohledu bílého.
- `[%eval]` je v dohrané partii u každého tahu. **Neověřeno:** s jakým zpožděním přichází naživo.
- Podmínky a limity API zdroje přečíst před L3 (bod z `docs/feed.md` je stále otevřený). Pravidlo zůstává: jeden dotaz naráz, při 429 minutu počkat.

## 3. Co divák uvidí

Stavy obrazovky živé partie:

| Stav | Kdy | Co je vidět |
|---|---|---|
| **Dohánění** | po otevření rozehrané partie | tahy běží rychle za sebou, bez bitev a bez vypravěče; ťuknutí na šachovnici nebo tlačítko „přeskočit" skočí na aktuální pozici |
| **Živě: čekání** | appka je na posledním tahu | odznak „živě", hodiny hráče na tahu běží, dvě velká tlačítka: **Zkusím to sám** a **Rádce** |
| **Živě: nový tah** | přišel tah a divák je v partii | figura přejede, braní spustí bitvu, vypravěč řekne hlášku |
| **Mimo partii** | vlastní analýza, návrh rádce, listování v Kronice | rámeček šachovnice má jinou barvu; velké tlačítko **Zpět k partii**; nový tah ohlásí banner se zvukem |
| **Konec** | výsledek je v PGN | poslední tah, karta s výsledkem (`_EndCard`), samolepka |

Dohraná živá partie (kolo ve stavu `finished`) se otevírá jako dnes: Pohádka od začátku, strop čtyř bitev. Navíc má v Kronice hodiny a rádce.

Rozložení Pohádky v živém režimu: nahoře hodiny soupeře, šachovnice, dole hodiny „mé" armády (bílý hraje mou armádou, PLAN §4). Pod šachovnicí pruh **Kdo vede** a tlačítka. Kronika (rodič) má navíc notaci s časy u tahů, číselné hodnocení a varianty rádce v notaci.

## 4. Relay (`feed/`)

Vše zpětně kompatibilní, takže se relay dá nasadit dřív, než vyjde appka. Před psaním načíst skilly `cloudflare:workers-best-practices` a `cloudflare:wrangler`.

1. **Hodiny a hodnocení v PGN.** `cleanPgn` nově ponechá z komentářů jen příkazy `[%clk …]` a `[%eval …]`, zapíše je za tah jako `{[%clk 1:59:50][%eval 0.18]}`. Veškerý ostatní text komentářů, varianty a NAGy dál zahazuje.
2. **Časová kontrola z kurátorského seznamu.** Do `feed/src/tournaments.json` přidat strukturované `tc` (pro zápas 2026: 40 tahů za 7200 s, pak 1800 s + 30 s na tah). Worker z něj píše standardní hlavičku `[TimeControl "40/7200:1800+30"]`. Volný text ze zdroje nepoužívat.
3. **Čas posledního tahu.** U nedohrané partie hlavička `[LastMoveAt "<unix sekundy UTC>"]` = okamžik stažení ze zdroje minus `thinkTime`. Čas stažení uložit ke kopii v edge cache, jinak hodnota po cestě zestárne. Když `thinkTime` neexistuje: u kola s jedinou partií vzít `Last-Modified` PGN, jinak hlavičku vynechat.
4. **Rozehrané kolo v cache 10 s** místo 60 s (konstanta). `live.json` zůstává 60 s.
5. **`ETag` a `304`.** Worker spočítá slabý ETag z těla, na `If-None-Match` vrací `304` bez těla.
6. **Rádce (L3):** `GET /v1/advice?fen=<FEN>`. FEN ověřit regulárním výrazem a délkou. Dotaz na zdroj jde přes `cachedSource`: nalezeno 10 min, nenalezeno 60 s. Odpověď `{"v":1,"depth":40,"lines":[{"cp":19,"moves":["e1h1","f6e4"]},{"mate":3,"moves":[…]}]}`, nejvýš 3 varianty po 10 půltazích, prázdné `lines` při 404. Při 429 ze zdroje vrátit 503 s `retry-after: 60` a minutu se neptat.
7. **Testy** (`node --test`): hodiny zůstanou a text zmizí, `TimeControl` a `LastMoveAt`, ETag, validace FEN, mapování odpovědi rádce. Sdílený zlatý soubor viz §9.
8. `docs/feed.md` přepsat podle nového chování. `docs/privacy.html` (cs i en): appka nově posílá i pozici na šachovnici, kvůli rádci.

Nasazení (`npm run deploy`) je krok ven: jen na Olinův pokyn.

## 5. Appka: jádro

- **`lib/core/games/pgn.dart`:** `PgnGame` dostane anotace k půltahům: `clocks` (`List<Duration?>`) a `evals` (setiny pěšce, mat jako zvláštní hodnota). Varianty se dál přeskakují. Stávající testy parseru musí projít beze změny.
- **`lib/core/games/game_record.dart`:** anotace nést dál (stejná délka jako `moves`).
- **`lib/core/games/time_control.dart`:** parser standardní hlavičky `TimeControl`, počet tahů do kontroly, pravidlo časové tísně (§6).
- **`lib/core/games/uci_reader.dart`:** `readUci(Position, String)` vedle `san_reader.dart`. Rošádu přijmout v obou zápisech (`e1g1` i `e1h1`). Variantu rádce uříznout u prvního nelegálního tahu.
- **`lib/core/games/analysis.dart`:** `AnalysisLine`: výchozí pozice, zásobník tahů, zpět o tah, od začátku. Jen legální tahy (`Rules.legalMoves`).
- **`lib/core/net/feed_client.dart`:** podmíněný GET (`If-None-Match`), výsledek nese tělo nebo „beze změny", ETag a čas serveru z hlavičky `Date` (pro posun hodin zařízení). Nová metoda `advice(fen)`.
- **Rozdíl dvou snímků partie.** Nový snímek buď prodlužuje starý (přibylo N půltahů), nebo ho přepisuje (**zdroj opravil tah**, u přenosů z elektronických šachovnic se to stává). Při opravě se vrátit na společný začátek a zbytek rychle přehrát.

## 6. Hodiny

- **Zdroj:** `[%clk]` u tahu = zbývající čas hráče po jeho tahu. Hráč na tahu: jeho poslední hodnota minus čas od `LastMoveAt`, s opravou o posun hodin zařízení proti času serveru. Před prvním tahem základ z `TimeControl`.
- **Bez `LastMoveAt`** tikat od chvíle, kdy appka tah poprvé uviděla, a čas označit jako přibližný.
- **Při dohánění a listování** hodiny ukazují stav v daném tahu a netikají.
- **Časová tíseň** (konstanty v `live_config.dart`):
  - před kontrolou počtu tahů: zbývá méně než 60 s na tah do kontroly;
  - po poslední kontrole: méně než 2 min;
  - bez `TimeControl`: méně než 5 min.
- **Vzhled:** číslice (rodič) a vedle nich ubývající přesýpací pruh (dítě): podíl zbývajícího času k základu do příští kontroly. V tísni zčervená a pulzuje, vypravěč řekne jednou za partii a stranu „Dochází čas!".

## 7. Appka: živý režim

- **Dotazování:** nový zdroj snímků kola (`autoDispose`, klíč turnaj + kolo) nahrazuje `roundGamesProvider` pro rozehraná kola. Ptá se každých 10 s, jen když je obrazovka otevřená a appka v popředí (`AppLifecycleListener`). Chyba: prodlužovat interval až na 60 s a ukázat poznámku „bez internetu". Konec: všechny partie kola mají výsledek. Dohrané kolo se uloží a dál čte z úložiště jako dnes (test „finished round is fetched once" musí platit dál).
- **Řadič:** `LiveController` (`ChangeNotifier`, stejný styl jako `ReplayController`: čistý stav a vložený časovač). Doporučení: `ReplayController` zobecnit jen minimálně (vyměnitelný záznam, rychlost tahu, vypnutí bitev a hlášek) a živou logiku držet v novém řadiči. Stavy podle §3.
- **Dohánění:** 120 ms na půltah, celé nejdéle 12 s (delší partii zrychlit), bez bitev, bez hlášek, tichý zvuk.
- **Nový tah naživo:** každé braní dostane celoobrazovkovou bitvu (tahy chodí po minutách, strop čtyř bitev tu neplatí). Přijde-li naráz víc než 4 půltahy, přehrát je rychle bez bitev.
- **Momenty:** oběť se pozná až o několik půltahů později (`sacrificeWindow`), naživo ji tedy nehlásit. Šach, rošáda, proměna a mat jdou hned.
- **Konec:** `progressProvider.watchGame(record.id)`, když je partie dohraná a divák došel na konec. `id` je hash včetně tahů, takže platí až pro dohranou partii. Během partie se partie určuje turnajem, kolem a pořadím.
- **Router:** `/live/:t/:r` najde kolo podle id v `liveTournamentsProvider`, `extra` zůstává jen jako zkratka. Pro kola s více partiemi `/live/:t/:r/:g`.
- **Kolo s více partiemi** (budoucí turnaje): `LiveRoundScreen` ukáže seznam s hráčem na tahu a časy, jedno stažení obslouží všechny partie.
- **Nezhasínat displej** ve stavu Živě (viz otázka 2).
- **Dlaždice budoucího kola:** k datu přidat hodinu začátku.

## 8. Analýza a rádce

**Zkusím to sám** (L2)
- Začíná z aktuální pozice, v Kronice z libovolného tahu. Divák táhne za obě strany, ťuk-ťuk i tažením jako v lekcích (`ChessBoard`: `onTap`, `onDragStart`, `onDrop`, `BoardMarks.dots`).
- Proměna: dáma. Braní: jen „puf" (viz otázka 4).
- Ovládání: zpět o tah, od začátku, **Zpět k partii**.
- Nový tah během analýzy: banner se zvukem, šachovnice se nehýbe. Po návratu se zameškané tahy přehrají (braní s bitvou, víc než 4 půltahy rychle).

**Rádce** (L3)
- **Kdo vede:** pruh mezi oběma armádami z `[%eval]` posledního tahu, pět stupňů (prahy v `live_config.dart`). Bez dalšího dotazu na síť.
- **Návrhy:** až tři varianty pro pozici, na kterou se divák dívá. Dotaz jde až po otevření rádce nebo v Kronice, a **jen pro pozice hlavní linie** (stejné pro všechny diváky, takže je pokryje edge cache).
- **Dítě:** tři bubliny, první tah každé varianty jako šipka na šachovnici (`BoardMarks.hintMove`). Ťuknutí variantu přehraje tempem `replayPlyDelay`, braní jen „puf".
- **Rodič (Kronika):** varianty v notaci (`Rules.san`), hodnocení číslem, hloubka.
- **Po přehrání:** „Zkusím pokračovat sám" předá koncovou pozici do vlastní analýzy.
- **Rádce mlčí** (404, chyba, limit): „Rádce ještě přemýšlí", zkusit znovu s dalším tahem.
- **Formát je připravený na další komentátory**: odpověď může později nést `by` a `text` (`cs`, `en`). Text z internetu jen do Kroniky a jen to, co propustí relay.

## 9. Simulátor a testy

Zápas se hraje jen v 15:00 našeho času v hrací dny, vývoj na to čekat nemůže.

- **`tool/fake_feed.dart`:** místní server se stejnými cestami jako relay. Ze zlatého souboru pouští partii po půltazích (`--every 5`, `--start-ply 30`, dávka tahů naráz, oprava tahu), umí ETag i `LastMoveAt` a vrací připravené odpovědi rádce. Appka: `flutter run --dart-define=FEED_BASE_URL=http://localhost:8787` (iOS simulátor; na Androidu `adb reverse`).
- **Zlatý soubor:** zdrojové PGN 1. partie (`curl https://lichess.org/api/broadcast/round/xLgOJ6cb.pgn`) do `feed/test/fixtures/`, vedle něj očekávaný výstup relay. Stejný výstup čtou testy v Dartu, takže obě implementace drží jeden kontrakt.
- **Testy jádra:** parser anotací, `TimeControl` a tíseň, `readUci` včetně obou rošád, `AnalysisLine`, rozdíl snímků (prodloužení, oprava).
- **Testy řadiče** s falešným časovačem a klientem: dohánění, čekání, nový tah s bitvou, dávka tahů, banner mimo partii a návrat, konec se samolepkou, pauza dotazů na pozadí, prodlužování intervalu po chybě.
- **Widget test:** živá obrazovka nad falešným klientem (vzor `test/core/net/feed_test.dart`, `FakeFeed`).
- **Brána před každým push:** `flutter analyze --no-fatal-infos && flutter test && dart run tool/lesson_lint.dart && dart run tool/games_lint.dart`, pro relay `cd feed && npm test && npm run check`.

## 10. Nastavení: bitvy a klasické figurky

Nastavení v appce zatím není (jen přepínač živých partií v Síni slávy a parametr `LessonController.battles`).

- **Úložiště:** `lib/core/settings/` nad `shared_preferences`, `settingsProvider` v `lib/app/providers.dart`. Dvě volby: `battles` (výchozí zapnuto), `classicPieces` (výchozí vypnuto).
- **Obrazovka `/settings`**, vstup ozubeným kolem z mapy a ze Síně slávy. Rodičovská brána přijde s rodičovskou zónou, tady ne.
- **Bitvy vypnuté:** lekce, přehrávač i živý režim dělají při braní jen „puf".
- **Klasické figurky:** `PieceToken` kreslí šachové figury místo postav. Bitvy se řídí jen svým přepínačem; s klasickými figurkami bitva ukáže postavy armád (Olin 26. 11. 2026). Rozsah viz otázka 3.
- **Kresba figur:** glyfy z `piece_glyph.dart` se na Androidu a iOS kreslí různě. Přibalit písmo s šachovými znaky pod licencí OFL (např. podmnožinu Noto Sans Symbols 2) nebo nakreslit vlastní tvary. Zapsat do `docs/CREDITS.md`.

## 11. Texty a hlas

- Nové texty jdou do všech 46 ARB (jako v #17), vygenerované `app_localizations_*.dart` se commitují.
- **Hlas:** hlášky přehrávače dnes klipy nemají a vypravěč chybějící klip tiše přeskočí. Nové hlášky živého režimu se chovají stejně. Do `spokenArbKeys` je přidat **až v L5 spolu s klipy**, jinak spadne `flutter test`. Klipy se generují na SPARKu (`sparkctl exec … -- python3 tool/voice_gen.py`), to je krok ven.
- Text komentátora z internetu se nedá předem namluvit. Proto je první rádce beze slov: šipky a tahy.

## 12. Milníky

Každý milník je vlastní větev a PR (název česky, commity anglicky). PR nemergovat, rozhoduje Olin.

| M | Výstup | Hotovo, když |
|---|---|---|
| **L1** | Relay: hodiny, `TimeControl`, `LastMoveAt`, cache 10 s, ETag. Appka: anotace v PGN, dotazování, `LiveController`, dohánění, nový tah s bitvou, hodiny a tíseň, konec se samolepkou, router. Simulátor a zlatý soubor. `DECISIONS` bod 21, odkazy v `05` §6 a v `CLAUDE.md` | v simulátoru přibývají tahy bez restartu, hodiny tikají a po návratu z pozadí appka dožene zameškané tahy; totéž ověřeno na jedné skutečné partii zápasu |
| **L2** | Zkusím to sám: `AnalysisLine`, tahy na šachovnici, banner nového tahu, návrat do partie; v Kronice analýza z libovolného tahu | během čekání jde zahrát vlastní variantu a vrátit se; nový tah analýzu nepřeruší |
| **L3** | Rádce: `/v1/advice`, `readUci`, pruh Kdo vede, tři návrhy, přehrání varianty, předání do vlastní analýzy; Kronika s notací variant. `CREDITS`, `privacy.html`, podmínky API | u pozice z partie jdou přehrát tři návrhy; neznámá pozice appku nerozbije |
| **L4** | Nastavení: bitvy, klasické figurky, obrazovka `/settings`, zapojení do lekcí, přehrávače a živého režimu | obě volby přežijí restart a platí všude, kde mají |
| **L5** | Vydání: hlasové klipy (cs, en), kontrola textů ve storech, scéna „živě" do screenshotů, test s dcerou do `docs/kid_tests.md` | Olin má build k otestování na telefonu |

Pořadí L1 → L2 → L3 kvůli kalendáři. L4 na ostatních nezávisí a jde zařadit kdykoli po L1.

**Kalendář zápasu** (vždy 15:00 našeho času): 25., 26., 28., 29., 30. 11., 2., 3., 4., 6., 7., 8., 10., 11. 12. Tiebreak v seznamu kol zatím není.

## 13. Mimo rozsah

- Chat diváků, účty, upozornění ze serveru, dotazy na pozadí.
- Šachový engine přímo v appce (licence, velikost).
- Lidský nebo LLM textový komentář (formát je připravený, zdroj není, viz otázka 1).
- Webová verze (`babylon/`).
- „Dohraj to" proti botovi z pozice partie (`05` G4).

## 14. Pracovní pravidla

- Kroky ven jen na Olinův pokyn: nasazení relay, tag vydání, generování hlasu na SPARKu, cokoli ve storech.
- Když build sáhne do `ios/Podfile`, `Podfile.lock`, `project.pbxproj` nebo `pubspec.lock`, vrátit to; do PR nepatří.
- Nová závislost jen po odsouhlasení (otázka 2).
- Rizika hlídat průběžně:
  - **Limit požadavků Workeru:** dotaz každých 10 s je asi 1 800 požadavků na diváka a partii. Ověřit denní limit tarifu; při desítkách současných diváků prodloužit interval nebo změnit tarif.
  - **Rádce u malých turnajů:** zdroj zná hlavně pozice sledovaných partií, jinde může mlčet.
  - **Zpoždění přenosu:** pořadatel může tahy pouštět se zpožděním, hodiny pak ukazují stav ze zdroje, ne ze sálu.

## 15. Otázky pro Olina

Nic z toho neblokuje L1. Bez odpovědi platí doporučení.

1. **Kdo je komentátor?** Přenos nemá lidský komentář ani varianty. První rádce proto čte návrhy enginu. Chcete časem i slovní komentář (psaný ručně, nebo generovaný LLM z faktů o pozici)? Do odpovědi: jen rádce z enginu.
2. **Nezhasínat displej** při sledování: nová závislost `wakelock_plus`. Do odpovědi: ano.
3. **Klasické figurky** jen v partiích (přehrávač a živý režim), nebo i v lekcích? Do odpovědi: jen v partiích.
4. **Bitvy ve vlastní analýze?** Do odpovědi: ne, jen „puf".
5. **Rádce i pro vlastní analýzu** (dotazy na libovolné pozice, víc provozu na zdroj)? Do odpovědi: ne.
6. **Připomenutí začátku partie** místní notifikací z času kola? Do odpovědi: ne.
7. **Vydání:** relay nasadit hned po merge L1 a appku pustit do TestFlightu po L1, nebo až po L3? Do odpovědi: po L1, ať se dá testovat na skutečných partiích.
