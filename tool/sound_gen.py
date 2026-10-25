#!/usr/bin/env python3
"""Generate SFX and music loops from tool/sounds.json on the SPARK audio service.

Each sound gets VARIATIONS takes in art_drafts/sounds/ (to listen and pick);
variant 1 (or the one named in "pick") goes to assets/sounds/<name>.mp3.
Existing assets are kept; --force regenerates.

Needs the audio-sfx / audio-music addons, so run through the broker:
  sparkctl exec chess4princesses comfyui,audio-sfx,audio-music 40 20 "zvuky" -- python3 tool/sound_gen.py
"""
import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.request

BASE = os.environ.get("AUDIO_URL", "http://spark:8093")
VARIATIONS = 3


def http(method, path, body=None, timeout=60):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method, headers={"content-type": "application/json"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def job(path, body, wait_s):
    jid = json.loads(http("POST", path, body))["job_id"]
    deadline = time.time() + wait_s
    while time.time() < deadline:
        st = json.loads(http("GET", f"/v1/audio/jobs/{jid}"))
        if st["status"] == "done":
            return st["outputs"]
        if st["status"] == "error":
            raise RuntimeError(st.get("error") or "error")
        time.sleep(1)
    raise TimeoutError(jid)


def to_mp3(data, dest, mono, bitrate):
    with tempfile.NamedTemporaryFile(suffix=".wav") as tmp:
        tmp.write(data)
        tmp.flush()
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", tmp.name, "-ac", "1" if mono else "2",
                        "-ar", "44100", "-b:a", bitrate, dest], check=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()
    spec = json.load(open("tool/sounds.json"))
    ok = failed = 0
    for kind, items in (("sfx", spec["sfx"]), ("music", spec["music"])):
        for name, s in items.items():
            dest = f"assets/sounds/{name}.mp3"
            if (args.only and name not in args.only) or (os.path.exists(dest) and not args.force):
                continue
            body = {"prompt": s["prompt"], "duration_s": s["duration_s"], "seed": 7, "variations": VARIATIONS, "format": "wav"}
            if kind == "music":
                body |= {"instrumental": True, "loop": True, "bpm": s.get("bpm")}
            pick = f"art_drafts/sounds/{name}_v{s.get('pick', 1)}.mp3"
            try:
                # Takes already on disk are reused; --force asks the model again.
                if args.force or not os.path.exists(pick):
                    outs = job(f"/v1/audio/{kind}", body, 900 if kind == "music" else 300)
                    for i, o in enumerate(outs, 1):
                        to_mp3(http("GET", o["url"], timeout=300), f"art_drafts/sounds/{name}_v{i}.mp3",
                               mono=kind == "sfx", bitrate="64k" if kind == "sfx" else "96k")
                os.makedirs(os.path.dirname(dest), exist_ok=True)
                shutil.copy(pick, dest)
                ok += 1
                print(f"ok   {dest}", flush=True)
            except Exception as e:
                failed += 1
                print(f"FAIL {name}: {e}", file=sys.stderr, flush=True)
    print(json.dumps({"sounds": {"ok": ok, "failed": failed}}))
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
