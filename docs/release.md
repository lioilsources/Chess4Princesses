# Release

Release = tag `vX.Y.Z` → `.github/workflows/release-ios.yml` (TestFlight) a
`release-android.yml` (Firebase App Tester + AAB). Workflowy pocházejí ze šablon
v repu Distribution (`scripts/align-project.sh`). Opravy patří tam, ne sem.

- Bundle id / applicationId: `com.ol1n.princesschess`
- Složka appky v Distribution: `Chess4Princesses` (`Apple/Chess4Princesses/`, `Android/Chess4Princesses/`)

## Jednorázové ruční kroky

### iOS
1. developer.apple.com → Identifiers: App ID `com.ol1n.princesschess` (pokud ještě není).
2. Profiles → Distribution → **App Store** → App ID `com.ol1n.princesschess`
   → stáhnout `.mobileprovision` do `Distribution/Apple/Chess4Princesses/`.
3. App Store Connect: appka s tímto bundle id (už existuje, buildy jsou v TestFlightu).

### Android
1. Upload keystore: `keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
   → `Distribution/Android/Chess4Princesses/upload-keystore.jks`, heslo a alias do Bitwardenu
   (postup a název položky viz `Distribution/README.md`).
2. Firebase konzole: přidat Android appku `com.ol1n.princesschess` (kvůli App Testeru).
3. Google Play Console: vytvořit appku, až půjde do storu.

### GitHub secrets
```sh
bw list items --pretty > ~/.bw_cache.json
<Distribution>/scripts/setup-gh-secrets.sh --repo lioilsources/Chess4Princesses
```
Script nastaví iOS certifikát, ASC API klíč, profil, Android keystore a Firebase.

## Vydání
```sh
git fetch --tags
git tag v1.0.1 && git push origin v1.0.1
gh run list -R lioilsources/Chess4Princesses --limit 5
```
Číslo buildu bere workflow z čísla běhu, verze pochází z tagu.
