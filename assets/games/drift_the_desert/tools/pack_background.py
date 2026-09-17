#!/usr/bin/env python3
"""Compress the baked background plates for shipping.

The baker writes full RGBA PNGs, which are far too heavy: a 1280x300 terrain
layer costs ~400 KB as PNG, and there are six of them. But those layers are
not arbitrary masks — each is simply opaque below a per-column skyline. So the
colour goes out as a JPEG and the silhouette as a height curve of a few
hundred bytes, which the game replays as a clip path. The curves are emitted as js/plates.js
rather than JSON: XHR to file:// is blocked, and the single-file build has
nothing to fetch from.

    python3 tools/pack_background.py
"""

import base64
import json
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
BG = ROOT / 'img' / 'bg'

TIMES = ['gold', 'dusk']
TERRAIN = ['far', 'near', 'dunes']
SAMPLES = 640          # height samples per layer


def skyline(alpha, samples):
    """First opaque row per column, as a 0..255 fraction of the plate height.

    The curve is sampled coarsely and replayed as a clip path, so each sample
    takes the *lowest* skyline across the columns it covers. Erring downwards
    shaves a pixel or two off a crest; erring upwards would uncover the JPEG's
    filled-in sky, which reads as a black block.

    255 means the column is empty all the way down, which the game skips.
    """
    w, h = alpha.size
    px = alpha.load()
    out = []
    for i in range(samples):
        x0 = int(i * w / samples)
        x1 = max(x0 + 1, int((i + 1) * w / samples))
        worst = 0
        for x in range(x0, min(w, x1)):
            top = h
            for y in range(h):
                if px[x, y] > 127:
                    top = y
                    break
            worst = max(worst, top)
        out.append(min(255, int(round(worst * 255.0 / h))))
    return out


def main():
    if not BG.is_dir():
        sys.exit('img/bg is missing — run tools/bake_background.js first')

    manifest = {'samples': SAMPLES, 'plates': {}}
    total = 0

    for time in TIMES:
        src = BG / f'sky-{time}.png'
        if not src.is_file():
            sys.exit(f'missing {src.name}')
        im = Image.open(src).convert('RGB')
        dst = BG / f'sky-{time}.jpg'
        im.save(dst, quality=82, optimize=True, progressive=True)
        total += dst.stat().st_size
        print(f'  {dst.name:18} {im.width}x{im.height} {dst.stat().st_size / 1024:8.1f} KB')
        manifest['plates'].setdefault('sky', {})['size'] = [im.width, im.height]

    for layer in TERRAIN:
        heights = None
        for time in TIMES:
            src = BG / f'{layer}-{time}.png'
            if not src.is_file():
                sys.exit(f'missing {src.name}')
            im = Image.open(src).convert('RGBA')

            # The silhouette is identical across the time variants — same seed,
            # same geometry — so it is measured once and shared.
            if heights is None:
                heights = skyline(im.split()[3], SAMPLES)

            # Flood the transparent area with the topmost opaque pixel of its
            # column, so JPEG ringing along the skyline has nothing to smear.
            rgb = im.convert('RGB')
            px = rgb.load()
            ap = im.split()[3].load()
            # Per-column top colour, smoothed across neighbours. Flooding with
            # each column's own colour left vertical corduroy, which showed as
            # a fringe wherever the clip path missed the skyline by a pixel.
            tops = []
            for x in range(im.width):
                c = None
                for y in range(im.height):
                    if ap[x, y] > 127:
                        c = px[x, y]
                        break
                tops.append(c)

            known = [c for c in tops if c is not None] or [(120, 100, 80)]
            fallback = tuple(sum(v[i] for v in known) // len(known) for i in range(3))
            tops = [c if c is not None else fallback for c in tops]

            span = 16
            smooth = []
            for x in range(im.width):
                a = max(0, x - span)
                b = min(im.width, x + span + 1)
                win = tops[a:b]
                smooth.append(tuple(sum(c[i] for c in win) // len(win) for i in range(3)))

            for x in range(im.width):
                fill = smooth[x]
                for y in range(im.height):
                    if ap[x, y] <= 127:
                        px[x, y] = fill
                    else:
                        break

            dst = BG / f'{layer}-{time}.jpg'
            rgb.save(dst, quality=80, optimize=True, progressive=True)
            total += dst.stat().st_size
            print(f'  {dst.name:18} {im.width}x{im.height} {dst.stat().st_size / 1024:8.1f} KB')

        manifest['plates'][layer] = {
            'size': [im.width, im.height],
            'heights': base64.b64encode(bytes(heights)).decode('ascii')
        }

    out = ROOT / 'js' / 'plates.js'
    out.write_text(
        '/* Generated by tools/pack_background.py — do not edit.\n'
        '   Sizes and skyline height curves for the baked backdrop plates. */\n'
        'window.DRIFT_PLATES = ' + json.dumps(manifest, separators=(',', ':')) + ';\n'
    )
    total += out.stat().st_size
    print(f'  {out.name:18} {"":9} {out.stat().st_size / 1024:8.1f} KB')

    for p in BG.glob('*.png'):
        p.unlink()
    print(f'total {total / 1024:.0f} KB (source PNGs removed)')


if __name__ == '__main__':
    main()
