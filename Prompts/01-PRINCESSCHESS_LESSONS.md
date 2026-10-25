# PrincessChess — kurikulum lekcí (5 let)

Cíl: naučit pětiletou holčičku šachy hravou formou — od tahů figur přes základní matování po první openings. Každá lekce = krátký příběh + mini‑hra na šachovnici + odměna (hvězdičky / nový kostým / nová postava do armády).

## Zásady pro věk 5 let

- **10 minut max** na sezení, jedna lekce = 1–3 sezení. Lekce se dají opakovat bez trestu.
- **Jedna figura naráz.** Nová figura přibývá až když je předchozí „kamarádka“ (dítě ji umí posunout bez nápovědy 5× po sobě).
- **Hraje se s málo figurami.** Celá partie až v modulu 12. Do té doby mini‑hry na 3–8 figur (metoda „pěšcová válka“ a „Step method“).
- **Vždy příběh, nikdy pravidlo.** Ne „věž se pohybuje po řádcích a sloupcích“, ale „Věžka jezdí jen rovně, protože má kolečka jako vláček“.
- **Žádný tlak na prohru.** Bitvy jsou show, ne trauma: poražená postava „odchází do hradu odpočinout“ a vrátí se v další hře.
- **Okamžitá odezva.** Správný tah = jiskřičky + zvuk; špatný tah = figurka zavrtí hlavou a ukáže kam smí (zvýrazněné pole).
- **Rodičovský režim**: rodič vidí, co dítě umí (heatmapa dovedností), a dostane tip, co s ní zkusit na skutečné šachovnici.

## Mechaniky mini‑her (znovupoužitelné v enginu lekcí)

| Typ úkolu | Popis | Použití |
|---|---|---|
| `reach_square` | dojdi figurou na cílové pole (hvězda) | učení tahů |
| `collect_stars` | seber všechny hvězdy na šachovnici na co nejméně tahů | plánování tahů |
| `capture_all` | vezmi všechny soupeřovy figury (soupeř netahá) | braní + bitvy |
| `avoid_lava` | některá pole jsou „láva“ (ohrožená) — dojdi bezpečně | ohrožení, pojem „šach“ |
| `escape_check` | král je v šachu, najdi únik | šach |
| `mate_in_1` / `mate_in_2` | dej mat | matování |
| `pawn_war` | pěšcová válka: dostaň pěšce na konec dřív než soupeř | první „partie“ |
| `mini_game` | partie s omezenou sadou figur (král+věž vs král, …) | koncovky |
| `choose_move` | ze 3 nabídek vyber správný tah | openings, principy |
| `spot_the_threat` | klepni na figuru, která je v nebezpečí | taktika |

Každá lekce v appce je JSON/YAML: `fen`, `goal`, `allowed_pieces`, `max_moves`, `hint_text`, `story_text`, `reward`. Opus postaví generický engine, lekce jsou data.

---

## Modul 0 — Království (šachovnice)

**Příběh:** Šachovnice je království rozdělené na 64 komnat. Každá komnata má jméno (písmeno ulice + číslo domu). Bílá komnata musí být vpravo dole („bílá vpravo, jinak se princezna zlobí“).

Lekce:
1. **Kde bydlí princezna?** — klepni na komnatu, kterou appka pojmenuje (e4, a1…). Nejdřív jen písmena (ulice), pak čísla, pak obojí.
2. **Barevné komnaty** — klepni na všechna bílá pole v jedné řadě; úhlopříčka „má stejnou barvu“ (příprava na střelce).
3. **Postav království** — přetáhni figury na správná místa (jen 1. řada, „dáma na svou barvu“).

Odměna: první postava armády (Princezna = dáma).

## Modul 1 — Pěšci („Malé družičky“)

**Příběh:** Družičky jdou vždy dopředu, nikdy zpátky. První krok mohou skočit dva. Bojují šikmo (pošťouchnou toho, kdo jim stojí šikmo v cestě). Když dojdou až na konec, promění se v princeznu!

Lekce:
1. `reach_square` — doveď družičku na hvězdu (rovně, bez překážek).
2. `reach_square` — stojí ti v cestě kámen (figura) — nemůžeš skrz; najdi, která družička projde.
3. `capture_all` — bitva šikmo: vezmi 3 soupeřovy pěšce.
4. **Proměna** — doveď družičku na poslední řadu → animace proměny v princeznu.
5. `pawn_war` — pěšcová válka 4 vs 4 proti robotovi (nejlehčí bot). **První „partie“ v životě.**

Dovednost: tah pěšce, dvojkrok, braní šikmo, proměna. (Braní mimochodem až v modulu 9.)

## Modul 2 — Věž („Věžka na kolečkách“)

**Příběh:** Věžka má kolečka a jezdí jen rovně — dopředu, dozadu, doleva, doprava — jak daleko chce, dokud nenarazí.

Lekce:
1. `reach_square` — 3 úkoly, hvězda rovně.
2. `collect_stars` — seber 4 hvězdy na nejméně tahů (plánování rohu).
3. `avoid_lava` — některá pole hoří, dojeď k hvězdě bezpečně.
4. `capture_all` — Věžka vs 4 pěšci.

## Modul 3 — Střelec („Motýlek“)

**Příběh:** Motýlek létá jen šikmo a celý život zůstává na své barvě komnat. Jeden motýlek má rád bílé komnaty, druhý černé.

Lekce:
1. `reach_square` — šikmo k hvězdě.
2. **Hádanka barev** — „dostane se Motýlek na tuhle hvězdu?“ (ano/ne — hvězda na jiné barvě).
3. `collect_stars` — šikmá cesta.
4. `capture_all` — Motýlek vs pěšci.

## Modul 4 — Dáma („Princezna“)

**Příběh:** Princezna umí všechno, co Věžka i Motýlek dohromady. Je nejsilnější, proto ji musíme chránit a nehnat do bitvy hned.

Lekce:
1. `reach_square` — rovně i šikmo.
2. `collect_stars` — 5 hvězd, max 5 tahů.
3. `capture_all` — Princezna vs 6 figur („velká bitva“, hodně animací).
4. `spot_the_threat` — která figura ohrožuje Princeznu? (základ ochrany dámy)

## Modul 5 — Jezdec („Koník“)

**Příběh:** Koník jako jediný umí skákat přes ostatní. Skáče ve tvaru písmene L: dva kroky rovně, jeden do strany (nebo naopak). Pokaždé přistane na jiné barvě.

Nejtěžší figura — plánovat **dvojnásobek lekcí** a vracet se k ní.

Lekce:
1. **Kam Koník doskočí?** — klepni na všechna pole, kam smí (zobrazí „podkovy“).
2. `reach_square` — 1 skok.
3. `reach_square` — 2 skoky (hvězda nedosažitelná na jeden).
4. **Koníkova cesta** — projdi 3×3 / 4×4 výseč (zjednodušená knight's tour).
5. `capture_all` — Koník vs pěšci.
6. `avoid_lava` — přeskoč lávu.

## Modul 6 — Král („Král tatínek“)

**Příběh:** Král je starý a opatrný: jen jeden krůček kterýmkoli směrem. Nikdy nesmí vstoupit tam, kde by ho někdo mohl vzít. Když ho někdo ohrožuje, říká se tomu **šach** — a král musí hned něco udělat.

Lekce:
1. `reach_square` — jeden krok.
2. `avoid_lava` — „kam král nesmí“ — zobraz ohrožená pole jako lávu, dojdi k hvězdě.
3. **Šach!** — soupeřova figura říká „šach“; klepni, kterou figurou ohrožuje.
4. `escape_check` — tři úniky z šachu: **uteč, zakryj, vezmi** (každý zvlášť, pak smíchané).
5. Pravidlo: „krále nikdo nebere, král se jen schovává“ — proč hra končí matem.

## Modul 7 — Bitvy a hodnota figur

**Příběh:** Každá postava má sílu v jablíčkách: družička 1, Koník 3, Motýlek 3, Věžka 5, Princezna 9. Král = celé království. Vyměnit Věžku za družičku je špatný obchod.

Lekce:
1. **Kdo je silnější?** — vyber z dvou figur tu dražší.
2. `capture_all` s výběrem — můžeš vzít jen jednu: vezmi tu nejcennější.
3. `spot_the_threat` — „co ti soupeř vezme příštím tahem?“
4. **Chráněná vs nechráněná** — vezmi jen to, co nikdo nehlídá (jinak přijde odveta — animace odvetné bitvy).
5. **Výměny** — „stojí to za to?“ (ano/ne).

## Modul 8 — Mat (základní vzory)

**Příběh:** Mat = král je v šachu a nemá kam utéct, nikdo ho nezakryje, nikdo útočníka nevezme. Království vyhrálo!

Lekce (v tomto pořadí, každý vzor nejdřív `mate_in_1`, pak s malou obměnou):
1. **Mat na poslední řadě** (back‑rank) — věž/dáma na 1./8. řadě, král zavřený pěšci.
2. **Schodový mat** (dvě věže / věž+dáma „po schodech“) — `mini_game` K+2V vs K. Nejsnazší reálná koncovka pro dítě.
3. **Mat dámou a králem** — „Princezna stojí koníkovým skokem od krále a tlačí ho do rohu, Král tatínek pomáhá“. `mini_game` K+D vs K, s nápovědou a varováním na pat.
4. **Pat** — „král nemá tah, ale není v šachu → remíza, nikdo nevyhrál“ — ukázat jako „oops“ situaci, kterou nechceme.
5. **Mat v 1 — mix** (20 pozic, různé figury, včetně Koníka).
6. **Mat věží a králem** — až ovládne 2 a 3 (náročnější, volitelné).

## Modul 9 — Speciální tahy

1. **Rošáda** — „Král se schová do hradu a Věžka ho hlídá“: podmínky (nikdo netáhl, nic mezi, ne přes šach). `choose_move`.
2. **Proměna** — opakování + „může být i Koník“ (ukázka, proč někdy).
3. **Braní mimochodem** — až poslední, jako „kouzlo družiček“ (volitelné, dle zájmu).

## Modul 10 — Openings (principy, ne memorování)

**Příběh:** Na začátku bitvy nejde o braní, ale o to, kdo má lepší místo. Tři pravidla království:
1. **Obsaď střed** — pěšci na e4/d4 (střed je „trůnní sál“, kdo ho drží, vidí všude).
2. **Vyveď rytíře** — Koníci a Motýlci ven dřív než Princezna („Princezna jde až se zbrojí“).
3. **Schovej krále** — rošáda brzy.

Lekce (`choose_move` — vždy 3 nabídky, 1 správná, se zpětnou vazbou „proč“):
1. První tah: e4 nebo d4 (ne a4/h4 — „kraj je nudný“).
2. Odpověď černého: e5 / d5.
3. Vyveď Koníka (Jf3), ne dámu.
4. **Italská hra** jako jediné „jménem“ pojmenované otevření: 1.e4 e5 2.Jf3 Jc6 3.Sc4 — ukázat jako „cestu princezny do Itálie“ s mapou. Trénink 3 tahů bílým i černým.
5. Pro černé stejný vzor zrcadlově (Jc6, Sc5).
6. Rošáda do 6. tahu — `choose_move` v pozicích z Italské.
7. **Dětský mat** (Dh5 + Sc4 → Dxf7#) — nejdřív jako „lest, kterou zkusí každý kluk na hřišti“ — naučit **obranu** (Jf6 / g6 / De7), až pak jako útok. Včetně „pozor na f7/f2 — nejslabší komnata“.
8. **Bláznivý mat** (f3 g4 → Dh4#) — jen ukázka „co se stane, když pustíš krále na vzduch“.

## Modul 11 — Taktika pro malé (volitelné, po modulu 10)

1. **Vidlička** — Koník ohrožuje dvě figury naráz („dva zajíci“).
2. **Vazba** — figura nesmí uhnout, protože za ní stojí král.
3. **Jsi v nebezpečí?** — každý tah se před potvrzením zeptat sama sebe (návyk).

## Modul 12 — Celé partie

1. Partie proti botovi úrovně „Miminko“ (náhodné tahy, nikdy nebere dámu zadarmo? → ne: bere, ale neplánuje).
2. Úrovně bota: Miminko → Štěně → Rytířka → Dračice (do ~800 Elo; dál nemá smysl).
3. **Partie s rodičem** na jednom telefonu (pass‑and‑play) — s nápovědami zapnutými pro dítě.
4. Po partii „co bylo super“: appka ukáže 1 pěkný tah dítěte a 1 moment „tady se dalo vzít zadarmo“.

---

## Pořadí a tempo (orientačně)

| Týden | Moduly |
|---|---|
| 1–2 | 0, 1 |
| 3 | 2, 3 |
| 4 | 4 |
| 5–6 | 5 (koník), opakování 1–4 |
| 7 | 6, 7 |
| 8–10 | 8 (mat), 9 |
| 11–12 | 10 (openings) |
| 13+ | 11, 12, volné hraní |

Každý modul končí **„Turnajem“**: 5 úkolů z modulu za sebou → nová postava / kostým do armády + diplom pro rodiče (sdílitelný obrázek).

## Tip pro rodiče (zobrazit v appce)

- Po každém modulu to zkusit na opravdové šachovnici — přenos je ta skutečná dovednost.
- Nikdy nehrát s dítětem „naplno“: hrát pěšcové války, K+2V vs K, odkládat dámu.
- Když se nudí koník — pauza týden, pak znova. Je to normální.
