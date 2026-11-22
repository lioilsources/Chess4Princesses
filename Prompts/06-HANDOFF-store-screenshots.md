# 06 — HANDOFF: screenshoty pro App Store a Google Play

Předávka na MacBook (víc paměti na simulátory). Build v1.0.2 je v TestFlightu a ve Firebase. Do review chybí screenshoty, privacy a support stránky a metadata. Tenhle handoff řeší **jen screenshoty**.

## Výstup

PNG soubory do `docs/screenshots/store/<platforma>/<jazyk>/NN_<obrazovka>.png`, commit jmenovitě do větve `docs/store-screenshots` a PR (merge rozhoduje Olin).

| Platforma | Zařízení (simulátor / emulátor) | Rozlišení | Počet |
|---|---|---|---|
| `ios-6.9` | iPhone 16 Pro Max (nebo novější 6,9″) | 1320 × 2868 (1290 × 2796 také projde) | 5–8 |
| `ios-ipad-13` | iPad Pro 13″ (M4) | 2064 × 2752 (2048 × 2732 také projde) | 5–8 |
| `android-phone` | Pixel 8/9, portrait | 1080 × 2400 nebo podobné, poměr nejvýš 2:1 | 4–8 |

Appka má `TARGETED_DEVICE_FAMILY = "1,2"`, takže iPad screenshoty jsou povinné. Android tablet není povinný.

Jazyky: `cs` a `en`. Další locale až na pokyn.

## Které obrazovky

Pořadí podle toho, co má prodávat (první dvě vidí lidi ve výsledcích hledání):

1. `01_map`: mapa království (`/`), ideálně s několika odemčenými moduly.
2. `02_lesson`: lekce uprostřed úkolu, s bublinou příběhu (např. lávová lekce `m02_l03`, viz `docs/screenshots/m02_l03_lava.png`).
3. `03_battle`: bitevní animace (`/battle`), zachytit chvíli zásahu, ne klid.
4. `04_army`: výběr armády (`/army`) s několika armádami z Archionu.
5. `05_hall`: síň slavných partií (`/hall`).
6. `06_replay`: přehrávání slavné partie (`/game/:id`).
7. volitelně `07_live`: živý turnaj (`/live/:t`), jen když relay právě něco vrací.

Progress pro mapu a armády: odemknout přes hraní, nebo dočasně v debug buildu. Debug úpravy necommitovat.

## Postup (iOS)

```sh
flutter pub get
open -a Simulator
xcrun simctl boot "iPhone 16 Pro Max"
xcrun simctl status_bar booted override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
flutter run --release -d "iPhone 16 Pro Max"
# navigovat na obrazovku, pak:
xcrun simctl io booted screenshot docs/screenshots/store/ios-6.9/cs/01_map.png
```

Jazyk simulátoru přepínat v Settings, nebo `xcrun simctl spawn booted defaults write -g AppleLanguages '(en)'` a restartovat appku. Totéž pro iPad.

Kontrola rozměrů: `sips -g pixelWidth -g pixelHeight <soubor>`.

## Postup (Android)

```sh
flutter emulators --launch <pixel_avd>
adb shell settings put global sysui_demo_allowed 1
adb shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0941
flutter run --release
adb exec-out screencap -p > docs/screenshots/store/android-phone/cs/01_map.png
```

Navíc pro Play: **feature graphic** 1024 × 500 (PNG/JPG bez alfy) do `docs/screenshots/store/android-feature.png`. Stačí ikona a název na pozadí z barev appky.

## Pravidla

- Žádné reálné osobní údaje, e-maily ani cizí značky v záběru.
- Bez rámečků a popisků. Screenshot musí ukazovat skutečnou appku.
- Na reálná zařízení neinstalovat bez dotazu.
- Repo je PUBLIC: do commitu ani PR nepatří domovské cesty, Team ID ani e-maily.

## Poznámka pro review (mimo tenhle handoff)

V `lib/` není rodičovská brána. Pro Kids kategorii ji Apple vyžaduje u odkazů ven a u nastavení. Rozhodnutí o Kids kategorii zatím chybí.
