#!/usr/bin/env bash
# App Store screenshots (cs + en-US), repeatable.
#
#   tool/store_screenshots.sh                # both devices
#   tool/store_screenshots.sh ios-tablet     # one device
#
# Devices:
#   ios-phone   iPhone 6.9" (1320×2868)  simulator iPhone 17/18 Pro Max
#   ios-tablet  iPad 13"   (2064×2752)   simulator iPad Pro 13-inch (M5/M4)
#
# Output: fastlane/metadata/ios/<cs|en-US>/screenshots/<iphone69|ipad13>_<NN>_<scene>.png
# Scenes and languages: integration_test/store_screenshots_test.dart.
# Upload (replaces the sets, never submits): tool/upload_store_screenshots.py
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
META="$ROOT/fastlane/metadata"
RAW="$ROOT/build/store_screenshots"
DEVICES=("$@"); [ ${#DEVICES[@]} -eq 0 ] && DEVICES=(ios-phone ios-tablet)
export FLUTTER_XCODE_COMPILATION_CACHE_ENABLE_CACHING=NO

sim_udid() { # first available simulator from the names
  for name in "$@"; do
    local id
    id=$(xcrun simctl list devices available | grep -F "    $name (" | head -1 | grep -oE '[0-9A-F-]{36}' || true)
    [ -n "$id" ] && { echo "$id"; return; }
  done
  echo "missing simulator: $*" >&2; exit 1
}

ios() { # ios <kind> <prefix> <simulators…>
  local kind=$1 prefix=$2; shift 2
  local udid booted_here=0; udid=$(sim_udid "$@")
  if ! xcrun simctl list devices | grep -F "$udid" | grep -q Booted; then
    xcrun simctl boot "$udid"; booted_here=1
  fi
  xcrun simctl bootstatus "$udid" -b >/dev/null
  xcrun simctl status_bar "$udid" override --time 9:41 --dataNetwork wifi --wifiBars 3 \
    --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
  rm -rf "${RAW:?}/$kind"; mkdir -p "$RAW/$kind"
  local rc=0
  (cd "$ROOT" && SCREENSHOT_DIR="$RAW/$kind" flutter drive \
    --driver=test_driver/screenshot_driver.dart \
    --target=integration_test/store_screenshots_test.dart -d "$udid") || rc=$?
  xcrun simctl status_bar "$udid" clear
  [ $booted_here = 1 ] && xcrun simctl shutdown "$udid"
  # audioplayers can throw while the app is torn down after the last shot;
  # that fails the drive but the PNGs are complete.
  local n; n=$(ls "$RAW/$kind"/*.png 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -ge 18 ] || { echo "flutter drive failed (rc=$rc, $n shots)" >&2; exit 1; }
  for loc in cs:cs en:en-US; do
    local out="$META/ios/${loc#*:}/screenshots"; mkdir -p "$out"; rm -f "$out/${prefix}"_*.png
    for f in "$RAW/$kind/${loc%%:*}"_*.png; do
      cp "$f" "$out/${prefix}_$(basename "$f" | cut -d_ -f2-)"
    done
  done
  return 0
}

for d in "${DEVICES[@]}"; do
  echo "== $d"
  case $d in
    ios-phone)  ios ios-phone iphone69 "iPhone 17 Pro Max" "iPhone 18 Pro Max" "iPhone 16 Pro Max" ;;
    ios-tablet) ios ios-tablet ipad13 "iPad Pro 13-inch (M5)" "iPad Pro 13-inch (M4)" ;;
    *) echo "unknown device: $d" >&2; exit 1 ;;
  esac
done
for f in "$META"/ios/*/screenshots/*.png; do
  sips -g pixelWidth -g pixelHeight "$f" | awk -v f="${f#"$ROOT"/}" '/pixelWidth/{w=$2} /pixelHeight/{print f, w "x" $2}'
done
echo "done: $META/ios/*/screenshots"
