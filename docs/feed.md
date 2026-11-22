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
| `/v1/t/<id>/<roundId>.pgn` | partie kola: jen hlavičky `Event Date Round White Black Result ECO WhiteElo BlackElo FEN SetUp` a tahy hlavní varianty | 60 s, skončené kolo 1 h |

- `Event` se přepisuje na neutrální název z kurátorského seznamu, bez sponzora.
- Komentáře s hodinami a hodnocením, varianty a URL se zahazují.
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
Bez `FEED_BASE_URL` appka živou polici vůbec neukáže a na síť nesahá.

Nasazení dělá Olin se svým přihlášením (`npx wrangler login`, pak `npm run deploy`).
Výsledná adresa (`*.workers.dev` nebo vlastní subdoména) jde do buildu přes
`--dart-define=FEED_BASE_URL=…`, v CI jako proměnná release workflow.

## Před vydáním appky s kanálem

- Popis ve storech říká „offline" (`fastlane/metadata`, všechny jazyky): přepsat na
  „funguje offline, živé turnaje volitelně z internetu".
- Doplnit `docs/privacy.html` (zatím v repu chybí): žádné účty ani sledování, co loguje Worker.
- Ověřit pravidla dětské kategorie obou storů pro síťový provoz.
- Přečíst podmínky API zdroje a jeho limity.
