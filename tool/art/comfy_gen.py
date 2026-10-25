#!/usr/bin/env python3
"""Draft character art on SPARK ComfyUI (PLAN §4 step 1–2).

flux-schnell txt2img (Apache-2.0, safe for the store) + BEN2 background
removal (MIT). Writes art_drafts/<army>/<piece>_s<seed>.png (cut-out, alpha)
and a contact sheet art_drafts/sheet.png to pick from.

Needs a ComfyUI window on SPARK (sparkctl, profile comfy).
  python3 tool/art/comfy_gen.py                      # all 12 characters × 4 seeds
  python3 tool/art/comfy_gen.py --only fairies.queen --seeds 11 12
"""
import argparse
import json
import os
import time
import urllib.parse
import urllib.request
import uuid

COMFY = os.environ.get("COMFY_URL", "http://192.168.88.66:8188")
OUT = "art_drafts"


def workflow(prompt, seed, prefix, width=1024, height=1024, cut=True):
    wf = {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux1-schnell.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "DualCLIPLoader", "inputs": {"clip_name1": "clip_l.safetensors", "clip_name2": "t5xxl_fp16.safetensors", "type": "flux", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "ae.safetensors"}},
        "4": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": ["2", 0]}},
        "5": {"class_type": "CLIPTextEncode", "inputs": {"text": "", "clip": ["2", 0]}},
        "6": {"class_type": "EmptySD3LatentImage", "inputs": {"width": width, "height": height, "batch_size": 1}},
        "8": {"class_type": "KSampler", "inputs": {
            "seed": seed, "steps": 4, "cfg": 1, "sampler_name": "euler", "scheduler": "simple", "denoise": 1,
            "model": ["1", 0], "positive": ["4", 0], "negative": ["5", 0], "latent_image": ["6", 0]}},
        "9": {"class_type": "VAEDecode", "inputs": {"samples": ["8", 0], "vae": ["3", 0]}},
        "10": {"class_type": "RMBG", "inputs": {"image": ["9", 0], "model": "BEN2", "sensitivity": 1.0, "process_res": 1024, "mask_blur": 0, "mask_offset": 0, "invert_output": False, "refine_foreground": False, "background": "Alpha", "background_color": "#FFFFFF"}},
        "11": {"class_type": "SaveImage", "inputs": {"filename_prefix": f"chess4p/{prefix}", "images": ["10" if cut else "9", 0]}},
    }
    if not cut:
        del wf["10"]
    return wf


def call(path, body=None):
    req = urllib.request.Request(COMFY + path, data=json.dumps(body).encode() if body else None,
                                 headers={"content-type": "application/json"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read()


def run(prompt, seed, prefix, dest, **kw):
    pid = json.loads(call("/prompt", {"prompt": workflow(prompt, seed, prefix, **kw), "client_id": str(uuid.uuid4())}))["prompt_id"]
    deadline = time.time() + 600
    while time.time() < deadline:
        h = json.loads(call(f"/history/{pid}")).get(pid)
        if h and h.get("status", {}).get("completed"):
            img = h["outputs"]["11"]["images"][0]
            q = urllib.parse.urlencode({"filename": img["filename"], "subfolder": img["subfolder"], "type": img["type"]})
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            with open(dest, "wb") as f:
                f.write(call(f"/view?{q}"))
            return
        if h and h.get("status", {}).get("status_str") == "error":
            raise RuntimeError(json.dumps(h["status"].get("messages", []))[:500])
        time.sleep(1)
    raise TimeoutError(pid)


def contact_sheet(paths, out):
    from PIL import Image, ImageDraw
    rows = {}
    for p in paths:
        rows.setdefault(os.path.dirname(p) + "/" + os.path.basename(p).split("_s")[0], []).append(p)
    cell = 256
    cols = max(len(v) for v in rows.values())
    sheet = Image.new("RGB", (cell * cols + 160, cell * len(rows)), "#FFF1F7")
    d = ImageDraw.Draw(sheet)
    for r, (name, ps) in enumerate(sorted(rows.items())):
        d.text((8, r * cell + cell // 2), name.replace(OUT + "/", ""), fill="#4A3B5C")
        for c, p in enumerate(sorted(ps)):
            im = Image.open(p).convert("RGBA")
            im.thumbnail((cell, cell))
            sheet.paste(im, (160 + c * cell, r * cell), im)
            d.text((160 + c * cell + 4, r * cell + 4), os.path.basename(p).split("_")[-1][:-4], fill="#8A2F6B")
    sheet.save(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec", default="tool/art/characters.json")
    ap.add_argument("--only", nargs="*", help="army.piece, e.g. fairies.queen")
    ap.add_argument("--seeds", nargs="*", type=int, default=[1, 2, 3, 4])
    ap.add_argument("--props", help="tool/art/props.json: icons (cut-out) + backgrounds (portrait, no cut)")
    args = ap.parse_args()

    if args.props:
        return props(args)
    spec = json.load(open(args.spec))
    jobs = []
    for army, a in spec["armies"].items():
        for piece, desc in a["pieces"].items():
            if args.only and f"{army}.{piece}" not in args.only:
                continue
            prompt = f"{desc}. {a['theme']}. {spec['style']}"
            for seed in args.seeds:
                jobs.append((prompt, seed, f"{army}_{piece}_s{seed}", f"{OUT}/{army}/{piece}_s{seed}.png"))

    done = []
    for i, (prompt, seed, prefix, dest) in enumerate(jobs, 1):
        t = time.time()
        try:
            run(prompt, seed, prefix, dest)
            done.append(dest)
            print(f"[{i}/{len(jobs)}] {dest}  {time.time() - t:.1f}s", flush=True)
        except Exception as e:  # keep going, report at the end
            print(f"[{i}/{len(jobs)}] FAIL {dest}: {e}", flush=True)
    all_drafts = sorted(os.path.join(dp, f) for dp, _, fs in os.walk(OUT) for f in fs if f.endswith(".png") and "_s" in f)
    if all_drafts:
        contact_sheet(all_drafts, f"{OUT}/sheet.png")
    print(json.dumps({"images": {"ok": len(done), "failed": len(jobs) - len(done)}}))


def props(args):
    spec = json.load(open(args.props))
    jobs = [(f"{d}. {spec['style']}", name, {}) for name, d in spec["items"].items()]
    jobs += [(d, name, {"width": 768, "height": 1344, "cut": False}) for name, d in spec["backgrounds"].items()]
    ok = failed = 0
    for prompt, name, kw in jobs:
        if args.only and name not in args.only:
            continue
        for seed in args.seeds:
            dest = f"{OUT}/{name}_s{seed}.png"
            try:
                run(prompt, seed, name.replace("/", "_") + f"_s{seed}", dest, **kw)
                ok += 1
                print(dest, flush=True)
            except Exception as e:
                failed += 1
                print(f"FAIL {dest}: {e}", flush=True)
    print(json.dumps({"images": {"ok": ok, "failed": failed}}))


if __name__ == "__main__":
    main()
