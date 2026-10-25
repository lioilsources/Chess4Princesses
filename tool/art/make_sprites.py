#!/usr/bin/env python3
"""Turn picked drafts into app sprites (PLAN §4 step 3).

For each pick in tool/art/picks.json:
  - drop stray bits the background remover left (sparkles, flowers, smoke):
    keep only the big connected blobs of the alpha mask,
  - crop to the character, fit into a square with a little air,
    feet on a common baseline (same scale feel across armies),
  - write assets/armies/<army>/sprites/<piece>.png at 512 px
    (board shows it at ~48–90 pt, the battle at ~200 pt → 512 covers @3x),
    module icons assets/ui/modules/<name>.png at 256 px and
    arena backgrounds assets/armies/<army>/arena.jpg.

  python3 tool/art/make_sprites.py
"""
import json
import os
from collections import deque

from PIL import Image, ImageChops, ImageFilter

SIZE = 512
MARGIN = 0.04  # of SIZE, on top and sides
BASELINE = 0.97  # feet at 97 % of the height


def keep_main_blobs(im, scale=256, alpha_min=40, keep_ratio=0.12):
    """Alpha mask of components at least keep_ratio × the largest one."""
    a = im.getchannel("A").resize((scale, scale), Image.BILINEAR)
    px = a.load()
    seen = [[False] * scale for _ in range(scale)]
    comps = []
    for y in range(scale):
        for x in range(scale):
            if seen[y][x] or px[x, y] < alpha_min:
                continue
            q, pts = deque([(x, y)]), []
            seen[y][x] = True
            while q:
                cx, cy = q.popleft()
                pts.append((cx, cy))
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        nx, ny = cx + dx, cy + dy
                        if 0 <= nx < scale and 0 <= ny < scale and not seen[ny][nx] and px[nx, ny] >= alpha_min:
                            seen[ny][nx] = True
                            q.append((nx, ny))
            comps.append(pts)
    biggest = max(len(c) for c in comps)
    keep = Image.new("L", (scale, scale), 0)
    kp = keep.load()
    for c in comps:
        if len(c) >= biggest * keep_ratio:
            for x, y in c:
                kp[x, y] = 255
    # Grow a little so the upscaled mask does not nibble the outline.
    keep = keep.filter(ImageFilter.MaxFilter(5)).resize(im.size, Image.BILINEAR)
    return keep


def solid_inside(a, scale=256, alpha_min=24):
    """Opaque mask of everything enclosed by the outline.

    White parts on the white generation background (a white pony) come out
    half transparent from the background remover; the thick outline makes
    the silhouette closed, so whatever the outside flood fill cannot reach
    belongs to the character.
    """
    small = a.resize((scale, scale), Image.BILINEAR).load()
    outside = [[False] * scale for _ in range(scale)]
    q = deque((x, y) for x in range(scale) for y in (0, scale - 1)) + deque((x, y) for y in range(scale) for x in (0, scale - 1))
    for x, y in q:
        outside[y][x] = True
    while q:
        x, y = q.popleft()
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < scale and 0 <= ny < scale and not outside[ny][nx] and small[nx, ny] < alpha_min:
                outside[ny][nx] = True
                q.append((nx, ny))
    inside = Image.new("L", (scale, scale), 0)
    ip = inside.load()
    for y in range(scale):
        for x in range(scale):
            if not outside[y][x]:
                ip[x, y] = 255
    # Shrink so the anti-aliased outline keeps its soft edge.
    return inside.filter(ImageFilter.MinFilter(5)).resize(a.size, Image.BILINEAR)


def process(src, dest, size=SIZE):
    im = Image.open(src).convert("RGBA")
    mask = keep_main_blobs(im)
    r, g, b, a = im.split()
    a = Image.composite(a, Image.new("L", im.size, 0), mask)
    a = ImageChops.lighter(a, solid_inside(a))
    im = Image.merge("RGBA", (r, g, b, a))
    im = im.crop(a.point(lambda v: 255 if v > 16 else 0).getbbox())

    room = size * (1 - 2 * MARGIN)
    height_room = size * (BASELINE - MARGIN)
    s = min(room / im.width, height_room / im.height)
    im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(im, ((size - im.width) // 2, round(size * BASELINE) - im.height), im)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    out.save(dest, optimize=True)


def main():
    picks = json.load(open("tool/art/picks.json"))
    out = []
    for army, pieces in picks["armies"].items():
        for piece, seed in pieces.items():
            out.append(f"assets/armies/{army}/sprites/{piece}.png")
            process(f"art_drafts/{army}/{piece}_s{seed}.png", out[-1])
    # Kingdom map islands for modules without a character (castle, apple, …).
    for name, seed in picks["icons"].items():
        out.append(f"assets/ui/modules/{name}.png")
        process(f"art_drafts/icons/{name}_s{seed}.png", out[-1], size=256)
    # Battle backgrounds: portrait, no alpha → JPEG.
    for army, seed in picks["arenas"].items():
        out.append(f"assets/armies/{army}/arena.jpg")
        Image.open(f"art_drafts/arenas/{army}_s{seed}.png").convert("RGB").save(out[-1], quality=85, optimize=True)
    for p in out:
        print(f"{p}  ({os.path.getsize(p) // 1024} kB)")


if __name__ == "__main__":
    main()
