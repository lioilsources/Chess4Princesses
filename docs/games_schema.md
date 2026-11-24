# Knihovna partií (`assets/games/`)

Formát přibalených partií pro Síň slávy (`Prompts/05-SLAVNE_PARTIE_PLAN.md` §3).
Všechno v `assets/games/` generuje `tool/games/build.dart`; ručně se needituje.

## Zdroje

| Soubor | Obsah |
|---|---|
| `data/games/players.yaml` | kanonická jména (`match` = regex přes zápis ve zdroji), krátké jméno, pořadí a roky vlády šampionů a šampionek |
| `data/games/sources.yaml` | zápasy o titul (soubor, rok, linie `classic`/`fide`, `only` pro finále K.O.), 64 polí Zlaté šachovnice, pravidlo pro šampionky a pro polici Mistr a vyzyvatel (`challenge`: rok, hráči, soubory, turnaje z Lichessu) |
| `data/games/pgn/extra.pgn` | ručně ověřené partie, které ve zdrojích chybí (Menčíková–Grafová 1937) |

Stažené PGN se do repa necommitují. Postup:

```
mkdir -p src/events src/players            # mimo repo
# z https://www.pgnmentor.com/files.html: events/WorldChamp*.pgn, FideChamp*.pgn, PCAChamp*.pgn
# a players/<Jméno>.zip (rozbalit) — seznam souborů je v sources.yaml
python3 -I tool/games/lichess_player.py Sindarov src/players/Sindarov.pgn   # hráči, které PGN Mentor nemá
dart run tool/games/build.dart src
dart run tool/games/build.dart src --find "Tal~Smyslov~1959~1-0~r=8"   # hledání partie pro šachovnici
dart run tool/games_lint.dart
```

Výběr na Zlatou šachovnici: `Bílý~Černý~rok`, dál volitelně výsledek, `r=kolo`, `n=počet tahů`,
`ev=část názvu akce`. Musí sedět právě jedna partie. Partie, která je i v zápase o titul, se
sdílí přes stejné ID.

Mistr a vyzyvatel: po každém turnaji kandidátů změň v `sources.yaml` rok, `players` a `files`,
doplň vyzyvatele do `players.yaml` a jeho turnaje do `challenge.lichess`, pak build. Partie se
vybírají stejně jako u šampionek (výhry, maty, silní soupeři, bonus za poslední dva roky), bez
rapidu, blitzu a tiebreaků (i podle hlavičky `TimeControl`).

## Výstup

```
assets/games/index.json        {v, shelves: [{id, kind: board|timeline|people, file}]}
assets/games/c/<police>.json   {v, groups: [{id, title?, line?, kind?, year?, score?, n?, reigns?, items}]}
assets/games/p/<balík>.pgn     čisté PGN: jen hlavičky z bundledHeaders a tahy hlavní varianty
```

Položka (`items`): `id` (hash hráčů, data a tahů, `GameRecord.id`), `p` balík, `i` pořadí
v balíku, `w`/`b` hráči, `y` rok, `r` výsledek, `n` počet tahů, `m: 1` končí matem,
`rd` kolo, `tb: 1` rychlá partie / tiebreak (nepočítá se do skóre).

Skupiny: zápas (`kind: match`, `score` jen z vážných partií, držitel titulu po zápase první),
turnaj o titul (`kind: tournament`, název = místo + rok), šampionka (`n` pořadí, `reigns`),
Zlatá šachovnice (jedna skupina, 64 položek, pole a1 → h8 chronologicky).

## Lint (`tool/games_lint.dart`, CI)

- každá partie v balících se legálně přehraje, výsledek sedí s matem/patem, žádné komentáře,
  varianty, cizí hlavičky ani značky sponzorů, žádné duplicitní ID;
- každá položka police míří na existující partii se stejným ID, Zlatá šachovnice má 64 polí,
  každá partie v balíku leží aspoň na jedné polici.
