#!/usr/bin/env python3
"""Generate missing voice-over clips from assets/voice/lines.json.

Run `dart run tool/voice_lines.dart` first. Every line whose clip
assets/voice/<lang>/<key>.mp3 does not exist yet goes to the SPARK audio
service (/v1/audio/tts), comes back as WAV and is converted to small mono MP3
with ffmpeg. Existing clips are never touched, so reruns are cheap.

The TTS service is on SPARK, so run it through the broker:
  sparkctl exec chess4princesses tts 30 20 "hlas lekcí" -- python3 tool/voice_gen.py

Voices (commercially clean, see docs/CREDITS.md):
  cs  piper:cs_CZ-kasandra-medium  (CC BY 4.0, attribution required)
  en  kokoro:af_heart              (Apache-2.0)
"""
import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor

BASE = os.environ.get("AUDIO_URL", "http://spark:8093")
VOICES = {"cs": "piper:cs_CZ-kasandra-medium", "en": "kokoro:af_heart"}
# A touch slower than adult speech: the listener is five.
SPEED = {"cs": 0.9, "en": 0.9}


def http(method, path, body=None, timeout=60):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method, headers={"content-type": "application/json"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def synth(line, out_path):
    lang = line["lang"]
    job = json.loads(http("POST", "/v1/audio/tts", {
        "text": line["say"], "language": lang, "voice": VOICES[lang],
        "speed": SPEED[lang], "format": "wav", "seed": 7,
    }))
    job_id = job["job_id"]
    deadline = time.time() + 180
    while True:
        st = json.loads(http("GET", f"/v1/audio/jobs/{job_id}"))
        if st["status"] == "done":
            break
        if st["status"] == "error":
            raise RuntimeError(st.get("error") or "tts error")
        if time.time() > deadline:
            raise TimeoutError(f"job {job_id} still {st['status']}")
        time.sleep(0.5)
    wav = http("GET", st["outputs"][0]["url"], timeout=120)
    with tempfile.NamedTemporaryFile(suffix=".wav") as tmp:
        tmp.write(wav)
        tmp.flush()
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        part = out_path + ".part.mp3"
        subprocess.run(
            ["ffmpeg", "-loglevel", "error", "-y", "-i", tmp.name,
             # 150 ms of air at the end so the last syllable is not clipped.
             "-af", "apad=pad_dur=0.15", "-ac", "1", "-ar", "44100", "-b:a", "64k", part],
            check=True,
        )
        os.replace(part, out_path)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lines", default="assets/voice/lines.json")
    ap.add_argument("--lang", choices=sorted(VOICES), help="only this language")
    ap.add_argument("--limit", type=int, help="at most N clips (try-out)")
    ap.add_argument("--workers", type=int, default=4)
    args = ap.parse_args()

    lines = json.load(open(args.lines, encoding="utf-8"))
    todo = [l for l in lines
            if (not args.lang or l["lang"] == args.lang)
            and not os.path.exists(f"assets/voice/{l['lang']}/{l['key']}.mp3")]
    if args.limit:
        todo = todo[: args.limit]
    print(f"voice_gen: {len(todo)} clips to generate via {BASE}", flush=True)

    ok, failed = 0, 0

    def one(line):
        path = f"assets/voice/{line['lang']}/{line['key']}.mp3"
        for attempt in range(3):
            try:
                synth(line, path)
                return True, line, None
            except (urllib.error.URLError, RuntimeError, TimeoutError, subprocess.CalledProcessError) as e:
                err = e
                time.sleep(2 * (attempt + 1))
        return False, line, err

    with ThreadPoolExecutor(args.workers) as pool:
        for done, line, err in pool.map(one, todo):
            if done:
                ok += 1
                print(f"  ok   {line['lang']}/{line['key']}  {line['say']}", flush=True)
            else:
                failed += 1
                print(f"  FAIL {line['lang']}/{line['key']}  {line['source']}: {err}", file=sys.stderr, flush=True)

    # Last line = metrics for the SPARK broker summary.
    print(json.dumps({"voice_clips": {"ok": ok, "failed": failed}}))
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
