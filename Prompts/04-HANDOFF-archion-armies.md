# 04 — HANDOFF: dvanáct dětských armád z Archionu

Předávka z repa OrbitronTactics (hra Archion). Olin rozhodl, že dětské skin packy figurek patří sem, ne do Archionu. Archion si nechává epické páry.

## Co je k dispozici

Dvanáct armád po šesti figurkách. Vznikly jako šest párů „dobro × zlo“, ale každá armáda stojí sama za sebe. Jde tedy kombinovat libovolně, jak chce `00-PRINCESSCHESS_PLAN.md` §3.

| Armáda (`id`) | Česky | Původní pár | Strana |
|---|---|---|---|
| `kingdom` | Království | Pohádkové království × Čerti | dobro |
| `devils` | Čerti | Pohádkové království × Čerti | zlo |
| `fairies` | Víly | Víly × Čarodějnice | dobro |
| `witches` | Čarodějnice | Víly × Čarodějnice | zlo |
| `bees` | Včely | Včely × Sršni | dobro |
| `hornets` | Sršni | Včely × Sršni | zlo |
| `dinos` | Dinosauři | Dinosauři × Doba ledová | dobro |
| `iceage` | Doba ledová | Dinosauři × Doba ledová | zlo |
| `cats` | Kočky | Kočky × Psi | dobro |
| `dogs` | Psi | Kočky × Psi | zlo |
| `fruit` | Ovoce | Ovoce × Zelenina | dobro |
| `veggies` | Zelenina | Ovoce × Zelenina | zlo |

`fairies` a `witches` se jménem kryjí s armádami, které už tu jsou (M2). Archionské jsou jiné postavy, ve stylu vinylových hraček. Je potřeba rozhodnout: nahradit, přidat jako kostým (`fairies_toy`), nebo vynechat.

## Kde to leží

Na Macu v `art_drafts/archion_armies/<id>/`. Složka `art_drafts/` je v `.gitignore`, do repa se kopíruje až výsledek.

- `board/<figurka>.png`: 512 × 512 RGBA, figurka i s nízkým podstavcem, pro šachovnici.
- `battle/<figurka>.png`: totéž s automaticky uříznutým podstavcem, pro arénu. U širokých plášťů může řez selhat, zkontroluj to.
- `info.json`: české jméno, protivník z původního páru, DNA palety, popis (subject) každé figurky a vybraný kandidát.

Vlastnosti obrázků:

- Obrys v nich **není zapečený**. Barevnou obrubu armády kreslí appka (plán §3 „liší se barvou obruby/podstavce“).
- Výška podle typu: král 1,00, královna 0,92, střelec 0,84, jezdec 0,78, věž 0,72, pěšec 0,58 výšky plátna. Zarovnání dolů.
- Pohled ve třech čtvrtinách zepředu, natočení mírně doprava. To odpovídá §0 v `03-BATTLES_PLAN.md`: útok míří doprava a obránce se zrcadlí.

## Jak vznikly

Qwen-Image (Apache 2.0, komerčně použitelné) v ComfyUI na L40S, výřez RMBG-2.0. Styl KIDS: „Cute chibi collectible vinyl toy figurine…“. Věže mají vlastní styl bez „big head and a small body“, jinak k nim Qwen kreslil postavičku. Nástroje a přesné prompty: OrbitronTactics, `tools/faction_art/` (větev `claude/faction-art`), soubory `styles.yaml` a `factions.yaml`.

Akceptační test (obrys, šedotón, deuteranopie, protanopie) prošel u všech párů, ale s obrysem zapečeným podle strany. Tady se rozlišení stran opírá o obrubu armády.

## Známé slabiny

- Včely, Ovoce a část Dinosaurů: figurky jsou často stejná postavička v kostýmu a liší se hlavně výškou. Pro dítě, které se učí figurky poznávat, je to slabé místo. Doporučuju doplnit rozlišovací rekvizitu nebo přegenerovat SUBJECT (ne STYLE).
- Ve věžích Koček a Psů sedí zvíře (kočka ve škrabadle, pes v boudě). Je to záměr, k budově patří.
- Chybí to, co tady armáda potřebuje navíc: jména postav s mottem a hláškami (`manifest.json`), aréna, bitevní pózy `attack` / `hit` / `victory` (cesta A v `03-BATTLES_PLAN.md`) a voice-over.

## Navržený postup

1. Prohlédni `art_drafts/archion_armies/` a vyber, které armády jdou do appky (návrh: všech deset nových, `fairies` a `witches` podle rozhodnutí výše).
2. Pro každou vybranou armádu založ `assets/armies/<id>/` podle `fairies`: `sprites/<figurka>.png` z `board/`, `manifest.json` s originálními jmény, mottem a hláškami (cs + en). Bez cizích značek (§0 plánu).
3. Arény a bitevní pózy vyrob stejnou cestou jako u M2. Jako referenci postavy použij `battle/<figurka>.png`.
4. Doplň výběr armád a test, který hlídá, že každá armáda v `assets/armies/` má šest spritů a platný manifest.
5. Monetizace podle §6 plánu: dvě armády zdarma, ostatní jako packy. Rozhoduje Olin.

GPU: L40S přes hub session „L40S“ (domluv okno), nebo SPARK přes `sparkctl`.
