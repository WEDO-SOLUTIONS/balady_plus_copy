# Penalty 3D Sprite Sources

The active character and ball visuals use pre-rendered PNG sprites generated with
the built-in image generation tool, then processed locally with chroma-key
background removal.

## Files

- `goalkeeper_idle.png` - goalkeeper ready stance.
- `goalkeeper_dive_left.png` - goalkeeper mid-height diving left.
- `goalkeeper_dive_low_left.png` - goalkeeper low diving left.
- `goalkeeper_dive_high_left.png` - goalkeeper high diving left. The game
  mirrors left-dive sprites for right-side dives.
- `goalkeeper_motion/` - generated goalkeeper movement sprite sheets based on
  the goalkeeper movement reference: ready stance, sidestep, low/mid/high dives,
  save recovery, and missed-goal reaction.
- `soccer_ball.png` - realistic soccer ball sprite.
- `striker_ready.png` - striker idle/aiming stance from one consistent sprite
  sheet.
- `striker_windup.png` - striker wind-up frame from the same sheet.
- `striker_kick.png` - striker follow-through frame from the same sheet.

## Runtime Approach

The game keeps Flame for input, physics, scoring, and scene rendering. Human and
ball visuals now use high-resolution transparent sprites instead of the previous
manual GLB triangle renderer, because Canvas-only GLB rendering cannot provide
proper materials, textures, lighting, skinning, or animation quality.

## Regenerating Motion Sheets

Run:

```bash
rtk /Users/ve/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 tool/generate_goalkeeper_motion_sprites.py
```

The script composes the movement sheets from the transparent goalkeeper base
sprites and writes `assets/sprites/goalkeeper_motion/metadata.json`.
