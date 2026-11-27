# Google Play Console — podklady k prvnímu vydání

Odpovědi do formulářů v Play Console pro `com.ol1n.princesschess`. Grafika a texty
jsou v `fastlane/metadata/android/` (formát `fastlane supply`), build je AAB z GitHub
Release tagu (`release-android.yml`). Postup podpisu a tagů je v `docs/release.md`.

## 1. Vytvoření appky
- Název: `Chess Kingdom` (cs: `Šachové království`), výchozí jazyk **en-US**
- Typ: **Game**, zdarma (z „zdarma“ už nejde přepnout na placenou)
- Prohlášení: Developer Program Policies, US export laws → ano

## 2. App content (Policy → App content)
| Formulář | Odpověď |
|---|---|
| Privacy policy | `https://lioilsources.github.io/Chess4Princesses/privacy.html` |
| App access | All functionality is available without special access (žádný účet) |
| Ads | No, my app does not contain ads |
| Content rating (IARC) | Kategorie *Game*. Násilí: jen kreslené figurky, které se „strčí“, bez krve a bez realistické podoby → *cartoon/fantasy, mild*. Strach, sex, vulgarity, drogy, hazard: ne. Interakce uživatelů, sdílení polohy, nákupy: ne. Neomezený přístup na internet: **ne** (appka čte jen vlastní feed partií, žádný prohlížeč) |
| Target audience | viz §3 |
| News app | No |
| COVID-19 apps | No (není to aplikace kolem COVID) |
| Data safety | viz §4 |
| Government apps | No |
| Financial features | My app doesn't provide any financial features |
| Health | No health features |
| Advertising ID | No (manifest nemá `AD_ID`, žádné SDK ho nepoužívá) |

## 3. Target audience — pozor
Play se ptá na věkové skupiny cílového publika a odpověď musí odpovídat skutečnosti.
Popis appky říká „pro děti zhruba 4 až 8 let“ a listing ukazuje princezny a pohádkové
armády. Když se vybere jen 13+, recenze to typicky vrátí jako *appeals to children* a
appku stejně posune pod Families policy, jen s odkladem.

Doporučení: zaškrtnout **5 and under** a **6–8** (případně i 9–12). Tím appka spadá pod
Families policy. To ale **není** program „Designed for Families“ / „Teacher Approved“
(ten je dobrovolný a nehlásíme se do něj). Požadavky Families policy appka už splňuje:
- žádné reklamy, žádná analytická ani jiná SDK třetích stran;
- žádný sběr osobních údajů, žádná poloha, žádné identifikátory zařízení;
- privacy policy existuje a popisuje feed;
- obsah je vhodný pro děti, žádné nákupy;
- internet (feed partií) je volitelný a defaultně vypnutý.

Formulář se ještě zeptá, jestli listing neláká děti nechtěně („unintentionally appeal“).
Pokud se zvolí dětské skupiny, tahle otázka odpadá.

## 4. Data safety
- Does your app collect or share any of the required user data types? **No**
- (vyplní se tím) Data encrypted in transit: Yes (feed jen přes HTTPS)
- Account deletion: n/a (bez účtů)

Odůvodnění: postup a nastavení zůstávají v `shared_preferences` na zařízení. Jediná síťová
komunikace je volitelný feed `feed.ol1n.com`, který nedostává žádný identifikátor, cookie
ani údaje o dítěti (viz `docs/privacy.html`, `docs/feed.md`).

## 5. Store listing (Grow → Store presence → Main store listing)
- Texty: `fastlane/metadata/android/<locale>/{title,short_description,full_description}.txt`
  (46 jazyků, délky ověřené: 30 / 80 / 4000)
- Ikona 512×512 a feature graphic 1024×500: `fastlane/metadata/android/{en-US,cs-CZ}/images/`
  (ostatní jazyky přebírají en-US)
- Screenshoty: `images/phoneScreenshots/` (1320×2640) a `images/tenInchScreenshots/`
  (2064×2752), oboje cs-CZ a en-US. **Play bere nejvýš 8 na typ zařízení**, ale scén je 10:
  při nahrávání vynechat dvě (např. `08` mistr a vyzyvatel, `07` zlatá tabule).
- Kategorie: **Educational** (Game), tagy: Chess, Board, Educational, Kids
- Kontakt: e-mail z privacy policy, web `https://lioilsources.github.io/Chess4Princesses/`

Nahrát ručně, nebo najednou všechny jazyky přes fastlane (potřebuje service account
s přístupem k appce, JSON klíč nikdy do repa):
```sh
fastlane supply --package_name com.ol1n.princesschess --json_key <klíč.json> \
  --metadata_path fastlane/metadata/android --skip_upload_apk --skip_upload_aab
```

## 6. Vydání
1. **Play App Signing**: při prvním AAB nechat Google spravovat app signing key. Náš
   keystore z `Distribution/Android/Chess4Princesses/` je *upload key*.
2. První AAB nahrát ručně (stáhnout z GitHub Release posledního tagu `vX.Y.Z`).
   Play vyžaduje rostoucí `versionCode`, workflow bere číslo běhu, takže každý nový tag stačí.
3. **Osobní vývojářský účet založený po 13. 11. 2023:** produkce se odemkne až po
   uzavřeném testu (Closed testing) s **alespoň 12 testery, kteří jsou přihlášení 14 dní
   v kuse**. Účet organizace tuhle podmínku nemá.
   - Closed testing → Create track → nahrát AAB → seznam testerů (Google účty / Google Group)
     → poslat jim opt-in odkaz.
   - Po 14 dnech: Dashboard → *Apply for production* (dotazník o průběhu testu).
4. Produkce: Production → Create release → AAB → Countries (všechny) → Review.
