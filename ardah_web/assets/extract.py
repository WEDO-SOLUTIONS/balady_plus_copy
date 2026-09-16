"""Slice the Ardah concept art into game assets.

Two techniques, both cheap and both honest about their limits:

  * plates  — straight rectangular crops (the stage backdrop);
  * sprites — crop, then key out the near-uniform background behind the object
              by distance-from-background, and UNMULTIPLY the remaining colour
              so edges do not keep a dark halo. Works because every object we
              want sits on a dark, nearly flat deck or on smooth night sky.

Anything with a busy background behind it (the performers against the fort)
cannot be cut this way — that needs a real segmentation pass or the artwork
delivered in layers, which is what docs/ardah-art-brief.md asks for.
"""
import numpy as np
from PIL import Image, ImageFilter
import os, json

SRC = 'ardah_ref/Ardah final.png'
OUT = 'assets_out'
os.makedirs(OUT, exist_ok=True)
im = Image.open(SRC).convert('RGB')
A = np.asarray(im).astype(np.float64)


def largest_blob(mask):
    """Keep only the connected component the crop is centred on — drops the
    neighbouring note, a stray spark, a corner of the rail."""
    h, w = mask.shape
    seen = np.zeros_like(mask, dtype=bool)
    best = None
    from collections import deque
    cy, cx = h // 2, w // 2
    starts = [(cy, cx)] + [(cy + dy, cx + dx) for dy in (-4, 0, 4) for dx in (-4, 0, 4)]
    for sy, sx in starts:
        if not (0 <= sy < h and 0 <= sx < w) or not mask[sy, sx] or seen[sy, sx]:
            continue
        comp = np.zeros_like(mask, dtype=bool)
        q = deque([(sy, sx)]); seen[sy, sx] = True; comp[sy, sx] = True
        while q:
            y, x = q.popleft()
            for ny, nx in ((y-1,x),(y+1,x),(y,x-1),(y,x+1)):
                if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                    seen[ny, nx] = True; comp[ny, nx] = True; q.append((ny, nx))
        if best is None or comp.sum() > best.sum():
            best = comp
    return best if best is not None else mask


def sprite(name, box, pad=6, thresh=70.0, feather=1.2, bg=None, floor=0.34, shape=None,
           radius=0.18, shrink=1.0):
    """Cut `box` and key it against its own border colour."""
    x0, y0, x1, y1 = box
    crop = A[y0 - pad:y1 + pad, x0 - pad:x1 + pad].copy()
    h, w, _ = crop.shape

    if bg is None:
        ring = np.concatenate([
            crop[:3].reshape(-1, 3), crop[-3:].reshape(-1, 3),
            crop[:, :3].reshape(-1, 3), crop[:, -3:].reshape(-1, 3)])
        bg = np.median(ring, axis=0)

    dist = np.sqrt(((crop - bg) ** 2).sum(axis=2))
    alpha = np.clip(dist / thresh, 0, 1)

    # A soft ramp alone leaves the whole rectangle faintly visible, because the
    # deck under the object is not perfectly flat. Hard-floor the weak pixels,
    # then keep only the blob in the middle of the crop.
    alpha[alpha < floor] = 0
    alpha = np.clip((alpha - floor) / (1 - floor), 0, 1)
    alpha *= largest_blob(alpha > 0.12)

    # A shape mask finishes the job where the object touches its neighbour (the
    # coins are stacked) or sits under a spray of sparks.
    if shape:
        yy, xx = np.mgrid[0:h, 0:w]
        cy, cx = (h - 1) / 2, (w - 1) / 2
        if shape == 'ellipse':
            m = ((xx - cx) / (w / 2 * shrink - 1)) ** 2 + ((yy - cy) / (h / 2 * shrink - 1)) ** 2 <= 1.0
        else:                      # rounded rect
            r = min(w, h) * radius
            dx = np.maximum(np.abs(xx - cx) - (w / 2 - 1 - r), 0)
            dy = np.maximum(np.abs(yy - cy) - (h / 2 - 1 - r), 0)
            m = (dx ** 2 + dy ** 2) <= r ** 2
        alpha *= m

    # Unmultiply: recover the object's own colour from  px = a*obj + (1-a)*bg
    a3 = alpha[..., None]
    obj = np.where(a3 > 0.02, (crop - bg * (1 - a3)) / np.maximum(a3, 0.02), crop)
    obj = np.clip(obj, 0, 255)

    rgba = np.dstack([obj, alpha * 255]).astype(np.uint8)
    out = Image.fromarray(rgba, 'RGBA')
    if feather:
        a = out.getchannel('A').filter(ImageFilter.GaussianBlur(feather))
        out.putalpha(a)
    out.save(f'{OUT}/{name}.png')
    return out.size


def plate(name, box, patches=()):
    """Straight crop. `patches` paint sky over anything we do not want baked in
    (the title plaque), sampling the columns either side of the patch and then
    blurring the result — a per-row fill alone leaves visible banding."""
    x0, y0, x1, y1 = box
    crop = A[y0:y1, x0:x1].copy()
    for (px0, py0, px1, py1) in patches:
        px0, py0, px1, py1 = px0 - x0, py0 - y0, px1 - x0, py1 - y0
        pad = 26
        ay0, ay1 = max(0, py0 - pad), min(crop.shape[0], py1 + pad)
        ax0, ax1 = max(0, px0 - pad), min(crop.shape[1], px1 + pad)

        left = np.median(crop[py0:py1, max(0, px0 - 40):px0 - 8], axis=1)
        right = np.median(crop[py0:py1, px1 + 8:px1 + 40], axis=1)
        ramp = np.linspace(0, 1, px1 - px0)[None, :, None]
        crop[py0:py1, px0:px1] = left[:, None, :] * (1 - ramp) + right[:, None, :] * ramp

        # Blur the whole neighbourhood, then feather it back in: the sky is a
        # smooth gradient, so a blurred patch is indistinguishable from it.
        region = Image.fromarray(crop[ay0:ay1, ax0:ax1].astype(np.uint8), 'RGB')
        blurred = np.asarray(region.filter(ImageFilter.GaussianBlur(9))).astype(np.float64)
        mask = np.zeros(blurred.shape[:2])
        mask[py0 - ay0:py1 - ay0, px0 - ax0:px1 - ax0] = 1
        mask = np.asarray(Image.fromarray((mask * 255).astype(np.uint8))
                          .filter(ImageFilter.GaussianBlur(14))).astype(np.float64) / 255
        crop[ay0:ay1, ax0:ax1] = crop[ay0:ay1, ax0:ax1] * (1 - mask[..., None]) + blurred * mask[..., None]

    img = Image.fromarray(np.clip(crop, 0, 255).astype(np.uint8), 'RGB')
    img.save(f'{OUT}/{name}.png')
    return img.size


def sprite_plain(name, box, radius=14, feather=1.0):
    """Crop with a rounded-rect mask and no colour keying at all.

    The keycaps defeated the keyer: they are layered objects (coloured top,
    metal base, bevel) sitting under a spray of sparks, and every threshold that
    removed the deck also ate a bevel or a corner. A plain mask keeps the whole
    object intact. The few dark pixels it keeps in the corners are the deck —
    and the caps are drawn back onto that same dark deck, so nothing shows.
    """
    x0, y0, x1, y1 = box
    crop = A[y0:y1, x0:x1]
    h, w, _ = crop.shape
    yy, xx = np.mgrid[0:h, 0:w]
    r = radius
    dx = np.maximum(np.abs(xx - (w - 1) / 2) - (w / 2 - r), 0)
    dy = np.maximum(np.abs(yy - (h - 1) / 2) - (h / 2 - r), 0)
    alpha = ((dx ** 2 + dy ** 2) <= r ** 2).astype(float) * 255

    out = Image.fromarray(np.dstack([crop, alpha]).astype(np.uint8), 'RGBA')
    if feather:
        out.putalpha(out.getchannel('A').filter(ImageFilter.GaussianBlur(feather)))
    out.save(f'{OUT}/{name}.png')
    return out.size


manifest = {}
# The stage: sky, fort, palms, banners, the rows, the musicians, the floor.
# The title plaque is painted out — it is UI, not scenery.
manifest['bg_stage'] = plate('bg_stage', (88, 128, 852, 945),
                             patches=[(248, 184, 702, 342)])
# A variant WITH the plaque baked in is deliberately not produced: the menu
# draws its own plaque so the title can be localised.

manifest['note_tabl']   = sprite('note_tabl',   (250, 1118, 318, 1170), thresh=64)
manifest['note_swords'] = sprite('note_swords', (440, 1046, 496, 1098), thresh=64, shape='ellipse', pad=2)
manifest['note_tar']    = sprite('note_tar',    (630, 1157, 698, 1211), thresh=64, shape='ellipse',
                                pad=2, shrink=0.94)

# Keycaps: the box has to take the whole thing — the coloured top AND the metal
# base plate under it — and stop above the deck's reflection. The mask keeps a
# soft radius so the base plate's corners survive; earlier boxes clipped the
# base and the mask ate the corners, which is what made the caps look gnawed.
manifest['key_tabl']   = sprite_plain('key_tabl',   (170, 1352, 266, 1440), radius=15)
manifest['key_swords'] = sprite_plain('key_swords', (420, 1363, 518, 1440), radius=13)
manifest['key_tar']    = sprite_plain('key_tar',    (678, 1352, 774, 1440), radius=15)

manifest['ui_plaque'] = sprite('ui_plaque', (255, 190, 692, 336), thresh=52, feather=0.8)

json.dump({k: {'w': v[0], 'h': v[1]} for k, v in manifest.items()},
          open(f'{OUT}/manifest.json', 'w'), indent=2)
for k, v in manifest.items():
    kb = os.path.getsize(f'{OUT}/{k}.png') / 1024
    print(f'{k:14s} {v[0]:5d}x{v[1]:<5d} {kb:8.0f} KB')
