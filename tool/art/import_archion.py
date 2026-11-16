#!/usr/bin/env python3
"""Copy the Archion kids armies into the app (Prompts/04-HANDOFF-archion-armies.md).

Source: art_drafts/archion_armies/<src>/board/<piece>.png (512×512 RGBA,
figurine with its low base, no baked outline, height by piece type).
Writes assets/armies/<id>/sprites/<piece>.png unchanged in size, only
re-encoded as WebP q90 (5× smaller than PNG, no visible loss on the
vinyl renders, where 256-colour PNG dithers the faces), and the base-less battle/<piece>.png as
assets/armies/<id>/stand/<piece>.png (standing art in the arena). Archion's fairies/witches become costumes fairies_toy and
witches_toy next to the M2 armies of the same name.

  python3 tool/art/import_archion.py
"""
import os

from PIL import Image

SRC = "art_drafts/archion_armies"
IDS = {
    "kingdom": "kingdom", "devils": "devils", "fairies": "fairies_toy", "witches": "witches_toy",
    "bees": "bees", "hornets": "hornets", "dinos": "dinos", "iceage": "iceage",
    "cats": "cats", "dogs": "dogs", "fruit": "fruit", "veggies": "veggies",
}
WEBP = {"quality": 90, "alpha_quality": 90, "method": 6}
PIECES = ["king", "queen", "rook", "bishop", "knight", "pawn"]


def main():
    for src, dst in IDS.items():
        for p in PIECES:
            im = Image.open(f"{SRC}/{src}/board/{p}.png").convert("RGBA")
            assert im.size == (512, 512), (src, p, im.size)
            out = f"assets/armies/{dst}/sprites/{p}.webp"
            os.makedirs(os.path.dirname(out), exist_ok=True)
            im.save(out, **WEBP)
            stand = Image.open(f"{SRC}/{src}/battle/{p}.png").convert("RGBA")
            out = f"assets/armies/{dst}/stand/{p}.webp"
            os.makedirs(os.path.dirname(out), exist_ok=True)
            stand.save(out, **WEBP)
        print(dst)


if __name__ == "__main__":
    main()
