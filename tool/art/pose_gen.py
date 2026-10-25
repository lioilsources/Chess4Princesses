#!/usr/bin/env python3
"""Battle poses for the picked characters (BATTLES_PLAN path A, B2).

Licence-clean consistency without IP-Adapter / Kontext / LoRA: flux-schnell
(Apache-2.0) in-context inpainting. The canvas is two 1024 panels: the left
one holds the picked board sprite, the right one is masked and generated
from a "two-panel character sheet, the exact same character …" prompt, so
the model copies face, outfit and colours from the left panel. Only core
ComfyUI nodes + BEN2 (MIT) for the cut-out.

Writes art_drafts/poses/<army>/<piece>_<pose>_s<seed>.png (alpha) and a
contact sheet art_drafts/poses/sheet.png. Picks go to picks.json "poses",
make_sprites.py turns them into assets/armies/<army>/battle/<piece>/<pose>.png.

  python3 tool/art/pose_gen.py                         # 12 characters × 3 poses × 4 seeds
  python3 tool/art/pose_gen.py --only fairies.queen --poses attack --seeds 5 6
  python3 tool/art/pose_gen.py --dump tool/art/pose_workflow.json   # workflow for the ComfyUI UI
"""
import argparse
import io
import json
import os
import time
import urllib.request
import uuid

from PIL import Image

from comfy_gen import COMFY, OUT, contact_sheet, run_wf

PANEL = 1024


def workflow(prompt, seed, prefix, ref_name, denoise=1.0, steps=4):
    return {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux1-schnell.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "DualCLIPLoader", "inputs": {"clip_name1": "clip_l.safetensors", "clip_name2": "t5xxl_fp16.safetensors", "type": "flux", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "ae.safetensors"}},
        "4": {"class_type": "CLIPTextEncode", "inputs": {"text": prompt, "clip": ["2", 0]}},
        "5": {"class_type": "CLIPTextEncode", "inputs": {"text": "", "clip": ["2", 0]}},
        # Transparent right half → LoadImage mask 1 there = the part to paint.
        "6": {"class_type": "LoadImage", "inputs": {"image": ref_name}},
        "7": {"class_type": "VAEEncode", "inputs": {"pixels": ["6", 0], "vae": ["3", 0]}},
        "12": {"class_type": "SetLatentNoiseMask", "inputs": {"samples": ["7", 0], "mask": ["6", 1]}},
        "8": {"class_type": "KSampler", "inputs": {
            "seed": seed, "steps": steps, "cfg": 1, "sampler_name": "euler", "scheduler": "simple", "denoise": denoise,
            "model": ["1", 0], "positive": ["4", 0], "negative": ["5", 0], "latent_image": ["12", 0]}},
        "9": {"class_type": "VAEDecode", "inputs": {"samples": ["8", 0], "vae": ["3", 0]}},
        "13": {"class_type": "ImageCrop", "inputs": {"image": ["9", 0], "width": PANEL, "height": PANEL, "x": PANEL, "y": 0}},
        "10": {"class_type": "RMBG", "inputs": {"image": ["13", 0], "model": "BEN2", "sensitivity": 1.0, "process_res": 1024, "mask_blur": 0, "mask_offset": 0, "invert_output": False, "refine_foreground": False, "background": "Alpha", "background_color": "#FFFFFF"}},
        "11": {"class_type": "SaveImage", "inputs": {"filename_prefix": f"chess4p/poses/{prefix}", "images": ["10", 0]}},
    }


def canvas(ref_path, init=False):
    """Reference on white in the left panel, transparent right panel.

    init: the right panel keeps the reference in RGB (alpha 0 still marks it
    as the part to paint), so with denoise < 1 the pose is repainted from
    the character itself and keeps its shape, colours and outline.
    """
    ref = Image.open(ref_path).convert("RGBA")
    ref.thumbnail((PANEL, PANEL))
    im = Image.new("RGBA", (2 * PANEL, PANEL), (255, 255, 255, 0))
    left = Image.new("RGBA", (PANEL, PANEL), (255, 255, 255, 255))
    left.alpha_composite(ref, ((PANEL - ref.width) // 2, PANEL - ref.height))
    im.paste(left, (0, 0))
    if init:
        right = left.copy()
        right.putalpha(0)
        im.paste(right, (PANEL, 0))
    buf = io.BytesIO()
    im.save(buf, "PNG")
    return buf.getvalue()


def upload(name, data):
    boundary = uuid.uuid4().hex
    body = (f"--{boundary}\r\nContent-Disposition: form-data; name=\"image\"; filename=\"{name}\"\r\n"
            f"Content-Type: image/png\r\n\r\n").encode() + data + \
           (f"\r\n--{boundary}\r\nContent-Disposition: form-data; name=\"subfolder\"\r\n\r\nchess4p\r\n"
            f"--{boundary}\r\nContent-Disposition: form-data; name=\"overwrite\"\r\n\r\ntrue\r\n--{boundary}--\r\n").encode()
    req = urllib.request.Request(COMFY + "/upload/image", data=body,
                                 headers={"content-type": f"multipart/form-data; boundary={boundary}"})
    with urllib.request.urlopen(req, timeout=60) as r:
        res = json.loads(r.read())
    return f"{res['subfolder']}/{res['name']}" if res.get("subfolder") else res["name"]


def prompt_for(desc, theme, pose, style):
    return (f"A two-panel character sheet of one and the same character on a plain pure white background. "
            f"Left panel: {desc}, standing. Right panel: the exact same character with the same face, "
            f"same outfit, same colours and same proportions, {pose}. {theme}. {style}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", help="army.piece, e.g. fairies.queen")
    ap.add_argument("--poses", nargs="*", help="attack hit victory")
    ap.add_argument("--seeds", nargs="*", type=int, default=[1, 2, 3, 4])
    ap.add_argument("--denoise", type=float, default=1.0, help="< 1 starts the pose from a copy of the character")
    # ComfyUI runs int(steps / denoise) steps and skips the first ones, so with
    # 4 steps denoise 0.85 is still a full repaint and 0.7 already a copy;
    # more steps give a finer scale.
    ap.add_argument("--steps", type=int, default=4)
    ap.add_argument("--tag", default="", help="subfolder under art_drafts/poses/ (compare settings)")
    ap.add_argument("--dump", help="write one example workflow (API format) and exit")
    args = ap.parse_args()

    chars = json.load(open("tool/art/characters.json"))
    spec = json.load(open("tool/art/poses.json"))
    picks = json.load(open("tool/art/picks.json"))["armies"]

    jobs = []
    for army, a in chars["armies"].items():
        for piece, desc in a["pieces"].items():
            if args.only and f"{army}.{piece}" not in args.only:
                continue
            ref = f"{OUT}/{army}/{piece}_s{picks[army][piece]}.png"
            for pose, text in spec["poses"].items():
                if args.poses and pose not in args.poses:
                    continue
                text = spec["overrides"].get(piece, {}).get(pose, text)
                jobs.append((army, piece, ref, pose, prompt_for(desc, a["theme"], text, spec["style"])))

    if args.dump:
        army, piece, ref, pose, prompt = jobs[0]
        json.dump(workflow(prompt, 1, f"{army}_{piece}_{pose}", f"chess4p/ref_{army}_{piece}.png"), open(args.dump, "w"), indent=1)
        return print(args.dump)

    total, done, uploaded = len(jobs) * len(args.seeds), [], {}
    i = 0
    for army, piece, ref, pose, prompt in jobs:
        if ref not in uploaded:
            init = args.denoise < 1
            uploaded[ref] = upload(f"ref_{army}_{piece}{'_init' if init else ''}.png", canvas(ref, init))
        for seed in args.seeds:
            i += 1
            dest = f"{OUT}/poses/{args.tag + '/' if args.tag else ''}{army}/{piece}_{pose}_s{seed}.png"
            t = time.time()
            try:
                run_wf(workflow(prompt, seed, f"{army}_{piece}_{pose}_s{seed}", uploaded[ref], args.denoise, args.steps), dest)
                done.append(dest)
                print(f"[{i}/{total}] {dest}  {time.time() - t:.1f}s", flush=True)
            except Exception as e:  # keep going, report at the end
                print(f"[{i}/{total}] FAIL {dest}: {e}", flush=True)
    drafts = sorted(os.path.join(dp, f) for dp, _, fs in os.walk(f"{OUT}/poses") for f in fs
                    if f.endswith(".png") and "_s" in f)
    if drafts:
        contact_sheet(drafts, f"{OUT}/poses/sheet.png")
    print(json.dumps({"images": {"ok": len(done), "failed": total - len(done)}}))


if __name__ == "__main__":
    main()
