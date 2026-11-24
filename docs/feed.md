# Živý kanál partií (`feed/`)

Malý Cloudflare Worker, přes který appka přehrává právě probíhající turnaje
(`Prompts/05-SLAVNE_PARTIE_PLAN.md` §6). Appka nikdy nemluví se zdrojem napřímo.

```
Lichess Broadcast API → Worker (edge cache) → appka (cache v telefonu)
```

## Co Worker vrací

| Cesta | Obsah | Cache |
|---|---|---|
| `/v1/live.json` | `{v: 1, tournaments: [{id, name: {cs, en}, emblem, rounds: [{id, n, startsAt, state}]}]}` | 60 s |
| `/v1/t/<id>/<roundId>.pgn` | partie kola: hlavičky `Event Date Round White Black Result ECO WhiteElo BlackElo FEN SetUp`, `TimeControl` (z kurátorského seznamu, pole `tc`), u rozehrané partie `LastMoveAt` (unix sekundy posledního tahu); tahy hlavní varianty s komentářem `{[%clk …][%eval …]}` | rozehrané kolo 10 s, skončené 1 h |
| `/v1/advice?fen=<FEN>` | rádce: `{v: 1, depth, lines: [{cp \| mate, moves: [uci…]}]}`, nejvýš 3 varianty po 10 půltazích, prázdné `lines` když zdroj pozici nezná | 10 min, neznámá pozice 60 s |

Všechny odpovědi mají slabý `ETag`; na `If-None-Match` vrací Worker `304` bez těla.
Appka se během otevřené živé partie ptá každých 10 s (`lib/core/games/live_config.dart`).

- `Event` se přepisuje na neutrální název z kurátorského seznamu, bez sponzora.
- Z komentářů zůstávají jen příkazy `[%clk]` a `[%eval]`; text komentářů, varianty, NAGy a URL se zahazují.
- `LastMoveAt` = čas stažení ze zdroje minus `thinkTime` z JSON kola (`/api/broadcast/-/-/<roundId>`). Když ho zdroj nemá, hlavička chybí a appka tiká od chvíle, kdy tah uviděla.
- Při `429` od zdroje rádce minutu odpovídá `503` s `retry-after: 60`.
- Do appky jdou jen turnaje z `feed/src/tournaments.json` a jen v jejich termínu (± 1 den).

## Proč edge cache a ne cron + KV

Plán počítal s cronem a zápisem do KV. Stačí méně: Worker se na zdroj ptá jen při
dotazu appky a odpověď drží v edge cache (`caches.default`). Zdroj tak vidí řádově jeden
dotaz za minutu na lokalitu. Odpadá KV namespace i denní limit zápisů a nasazení je jeden
příkaz. Cron + KV má smysl až ve chvíli, kdy by kanál měl běžet nezávisle na dotazech
(např. upozornění, že začalo kolo).

## Soukromí

Appka posílá jen holý GET bez cookies, účtů a identifikátorů. Worker neloguje IP adresy
ani hlavičky, jen chyby s cestou. Logy a trasy mají vzorkování 10 %.

## Přidání turnaje

1. Najít ID vysílání: `curl -s https://lichess.org/api/broadcast/top` (pole `tour.id`).
2. Přidat záznam do `feed/src/tournaments.json`: vlastní `id` (krátké, bez sponzora),
   `source` (ID vysílání), `name.cs` / `name.en` podle místa a roku, `emblem`, `from` / `to`.
3. PR, pak nasazení.

## Vývoj a nasazení

```
cd feed
npm install
npm test            # čisté funkce (node --test)
npx wrangler types  # vygeneruje worker-configuration.d.ts
npm run check       # tsc
npx wrangler dev    # lokálně proti skutečnému zdroji: http://localhost:8787/v1/live.json
```

Appka proti lokálnímu Workeru: `flutter run --dart-define=FEED_BASE_URL=http://<adresa Macu>:8787`.

Simulátor bez sítě (`tool/fake_feed.dart`) pouští 1. partii zápasu po tazích se stejnými cestami:
`dart run tool/fake_feed.dart --every 5 --start-ply 30 [--burst 3] [--correct-at 40]`, pak
`flutter run --dart-define=FEED_BASE_URL=http://localhost:8787 --dart-define=ROUTE=/live/wch2026/Sim00001`.
Zlatý soubor `feed/test/fixtures/wch2026_r1_feed.pgn` (kopie v `test/fixtures/`) drží kontrakt mezi Workerem a appkou.
Bez `FEED_BASE_URL` appka živou polici vůbec neukáže a na síť nesahá.

Nasazení: `npm run deploy` (Wrangler přihlášený přes `npx wrangler login`). Worker běží
na vlastní doméně `https://feed.ol1n.com` (`routes` v `wrangler.jsonc`, DNS záznam založí
Wrangler sám). Release workflowy ji předávají appce jako
`--dart-define=FEED_BASE_URL=${{ vars.FEED_BASE_URL }}` (proměnná repa, ne secret).
Prázdná proměnná = build bez živé police.

## Před vydáním appky s kanálem

- Popis ve storech říká „offline" (`fastlane/metadata`, všechny jazyky): přepsat na
  „funguje offline, živé turnaje volitelně z internetu".
- Doplnit `docs/privacy.html` (zatím v repu chybí): žádné účty ani sledování, co loguje Worker.
- Ověřit pravidla dětské kategorie obou storů pro síťový provoz.
- Přečíst podmínky API zdroje a jeho limity.
