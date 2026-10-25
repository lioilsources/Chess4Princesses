# Credits & licences of bundled assets

Must also be shown in the app (parent zone → "O aplikaci") before release.

## Voice-over (`assets/voice/`)

| lang | voice | licence | attribution |
|---|---|---|---|
| cs | Piper `cs_CZ-kasandra-medium` | CC BY 4.0 | **Hlas Kasandra © Ondřej Šimek, CC BY 4.0 (rhasspy/piper-voices)** |
| en | Kokoro-82M `af_heart` | Apache-2.0 | — |

Generated on SPARK by the audio service (`tool/voice_gen.py`); only engines
the service marks as commercially clean are used (`commercial_only=true`).

## Sound effects & music (`assets/sounds/`)

Generated on SPARK by the audio service (`tool/sound_gen.py`, prompts in
`tool/sounds.json`, 3 takes each in `art_drafts/sounds/`, take 1 shipped):
SFX **MOSS-SoundEffect v2** (Apache-2.0), music **ACE-Step 1.5** (MIT) —
the service's commercially clean defaults.

## Art (`assets/armies/*/sprites`, `arena.jpg`, `assets/ui/modules`)

Generated on SPARK ComfyUI (`tool/art/comfy_gen.py`, picks in `tool/art/picks.json`):

- images: **FLUX.1 [schnell]** — Apache-2.0, commercial use allowed;
- background removal: **BEN2** — MIT (RMBG-2.0 is CC BY-NC, deliberately not used).
- app icon: same flux-schnell pipeline (`tool/art/appicon_1024.png` → `make_icons.py`).

No third-party characters or brands; prompts describe original archetypes only.

## Fonts

`cute_kid_fonts` — see that package for the font licences.
