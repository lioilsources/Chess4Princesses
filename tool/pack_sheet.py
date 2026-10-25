#!/usr/bin/env python3
"""PNG frame sequence -> sprite sheet + JSON atlas for one battle clip.

BATTLES_PLAN §2. Every production path (A key poses, B image-to-video,
C 3D renders) ends here, so the app never cares how frames were made.

  pack:   tool/pack_sheet.py pack FRAMES_DIR OUT_DIR --clip attack --fps 8 \
              --hit-frame 2 --fx sparkle --sfx whoosh_02
  check:  tool/pack_sheet.py check assets/armies        # CI: validate all atlases

Frames are trimmed to their *common* bounding box (so the feet anchor does not
jump between frames), scaled to fit SIZE x SIZE with the character ~220 px
tall, and laid out left to right.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from PIL import Image

SIZE = 256
CHAR_HEIGHT = 220
MIN_FRAMES = {"idle": 2, "attack": 4, "defeat": 4, "victory": 3}
FX = {"sparkle", "bonk", "zap", "splash"}
EXITS = {"fly_left", "poof", "sink"}
PIECES = {"king", "queen", "rook", "bishop", "knight", "pawn"}


def load_frames(src: Path) -> list[Image.Image]:
    files = sorted(p for p in src.iterdir() if p.suffix.lower() in {".png", ".webp"})
    if not files:
        sys.exit(f"no frames in {src}")
    frames = []
    for f in files:
        im = Image.open(f)
        if im.mode != "RGBA":
            sys.exit(f"{f}: needs an alpha channel (got {im.mode}) — run rembg/BiRefNet first")
        frames.append(im)
    if len({im.size for im in frames}) != 1:
        sys.exit(f"{src}: frames differ in size")
    return frames


def common_bbox(frames: list[Image.Image]) -> tuple[int, int, int, int]:
    boxes = [im.getchannel("A").getbbox() for im in frames]
    if any(b is None for b in boxes):
        empty = [i for i, b in enumerate(boxes) if b is None]
        # An empty last defeat frame ("prázdno") is fine; others are mistakes.
        boxes = [b for b in boxes if b is not None]
        if not boxes:
            sys.exit("all frames are fully transparent")
        print(f"note: transparent frames {empty}")
    return (min(b[0] for b in boxes), min(b[1] for b in boxes), max(b[2] for b in boxes), max(b[3] for b in boxes))


def pack(args: argparse.Namespace) -> None:
    clip = args.clip
    frames = load_frames(Path(args.frames))
    if len(frames) < MIN_FRAMES[clip]:
        sys.exit(f"{clip} needs at least {MIN_FRAMES[clip]} frames, got {len(frames)}")
    if clip == "attack" and args.hit_frame is None:
        sys.exit("attack needs --hit-frame")
    if args.hit_frame is not None and not 0 <= args.hit_frame < len(frames):
        sys.exit("--hit-frame out of range")

    x0, y0, x1, y1 = common_bbox(frames)
    w, h = x1 - x0, y1 - y0
    scale = min(CHAR_HEIGHT / h, (SIZE - 8) / w)
    tw, th = max(1, round(w * scale)), max(1, round(h * scale))
    # Feet at the bottom centre, a few px above the edge.
    ox, oy = (SIZE - tw) // 2, SIZE - 8 - th

    sheet = Image.new("RGBA", (SIZE * len(frames), SIZE), (0, 0, 0, 0))
    out_frames = []
    duration = round(1000 / args.fps)
    for i, im in enumerate(frames):
        cell = im.crop((x0, y0, x1, y1)).resize((tw, th), Image.LANCZOS)
        sheet.paste(cell, (i * SIZE + ox, oy), cell)
        out_frames.append({"frame": {"x": i * SIZE, "y": 0, "w": SIZE, "h": SIZE}, "duration": duration})

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    sheet.save(out / f"{clip}.png", optimize=True)
    meta = {"clip": clip, "image": f"{clip}.png", "size": [SIZE, SIZE], "anchor": [0.5, (SIZE - 8) / SIZE]}
    if args.hit_frame is not None:
        meta["hit_frame"] = args.hit_frame
    for key in ("fx", "sfx", "exit"):
        if getattr(args, key):
            meta[key] = getattr(args, key)
    (out / f"{clip}.json").write_text(json.dumps({"frames": out_frames, "meta": meta}, indent=1))
    print(f"{out / clip}.png: {len(frames)} frames, {len(frames) * duration} ms")


def check_atlas(path: Path) -> list[str]:
    errs = []
    try:
        data = json.loads(path.read_text())
        meta, frames = data["meta"], data["frames"]
    except (KeyError, ValueError) as e:
        return [f"{path}: bad JSON ({e})"]
    clip = meta.get("clip")
    if clip not in MIN_FRAMES:
        errs.append(f"{path}: unknown clip {clip!r}")
        return errs
    if len(frames) < MIN_FRAMES[clip]:
        errs.append(f"{path}: {len(frames)} frames < {MIN_FRAMES[clip]}")
    if clip == "attack" and not 0 <= meta.get("hit_frame", -1) < len(frames):
        errs.append(f"{path}: attack needs hit_frame inside the clip")
    if meta.get("fx") and meta["fx"] not in FX:
        errs.append(f"{path}: fx {meta['fx']!r} not in {sorted(FX)}")
    if meta.get("exit") and meta["exit"] not in EXITS:
        errs.append(f"{path}: exit {meta['exit']!r} not in {sorted(EXITS)}")
    img = path.with_name(meta.get("image", ""))
    if not img.is_file():
        errs.append(f"{path}: image {img.name} missing")
    else:
        im = Image.open(img)
        if im.mode != "RGBA":
            errs.append(f"{img}: no alpha")
        for f in frames:
            r = f["frame"]
            if r["x"] + r["w"] > im.width or r["y"] + r["h"] > im.height:
                errs.append(f"{path}: frame outside sheet")
                break
    return errs


def check(args: argparse.Namespace) -> None:
    root = Path(args.root)
    errs: list[str] = []
    atlases = list(root.glob("*/battle/*/*.json"))
    for piece_dir in {p.parent for p in atlases}:
        if piece_dir.name not in PIECES:
            errs.append(f"{piece_dir}: unknown piece folder")
        missing = [c for c in MIN_FRAMES if not (piece_dir / f"{c}.json").is_file()]
        if missing:
            errs.append(f"{piece_dir}: missing clips {missing}")
    for a in atlases:
        errs += check_atlas(a)
    for e in errs:
        print("ERROR", e)
    print(f"pack_sheet check: {len(atlases)} atlases, {len(errs)} errors")
    sys.exit(1 if errs else 0)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("pack", help="pack one clip")
    p.add_argument("frames")
    p.add_argument("out")
    p.add_argument("--clip", required=True, choices=sorted(MIN_FRAMES))
    p.add_argument("--fps", type=float, default=8)
    p.add_argument("--hit-frame", type=int)
    p.add_argument("--fx", choices=sorted(FX))
    p.add_argument("--sfx")
    p.add_argument("--exit", choices=sorted(EXITS))
    p.set_defaults(func=pack)
    c = sub.add_parser("check", help="validate every atlas under ROOT (CI)")
    c.add_argument("root", nargs="?", default="assets/armies")
    c.set_defaults(func=check)
    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
