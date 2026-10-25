#!/usr/bin/env python3
"""App icon from tool/art/appicon_1024.png (square, no frame: the OS rounds it).

Overwrites every size in the iOS AppIcon set and the Android launcher mipmaps.
  python3 tool/art/make_icons.py
"""
import json
import os

from PIL import Image

SRC = "tool/art/appicon_1024.png"
IOS = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
ANDROID = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}


def main():
    master = Image.open(SRC).convert("RGB")  # App Store rejects alpha
    for img in json.load(open(f"{IOS}/Contents.json"))["images"]:
        if "filename" not in img:
            continue
        pt = float(img["size"].split("x")[0])
        px = round(pt * int(img["scale"].rstrip("x")))
        master.resize((px, px), Image.LANCZOS).save(f"{IOS}/{img['filename']}")
    for density, px in ANDROID.items():
        path = f"android/app/src/main/res/mipmap-{density}/ic_launcher.png"
        os.makedirs(os.path.dirname(path), exist_ok=True)
        master.resize((px, px), Image.LANCZOS).save(path)
    print("icons written")


if __name__ == "__main__":
    main()
