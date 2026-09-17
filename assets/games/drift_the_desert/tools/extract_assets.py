#!/usr/bin/env python3
"""Cut the game's art out of the Arabic_drift mockup sheet.

The sheet is a 4x2 grid of phone mockups (1312x1199). This script slices the
individual screens out of it and derives every image the game ships in
`img/`: the hero car cut-out, the desert plate, the results strip, the UI
marks and the reward icons.

It is kept in the repo so the art can be re-derived (or re-tuned) from the
source sheet instead of being an opaque blob of binaries.

    pip install pillow rembg[cpu]
    python3 tools/extract_assets.py path/to/Arabic_drift.png

`rembg` is only needed for the two cut-outs; everything else is plain Pillow.
"""

import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageStat

OUT = Path(__file__).resolve().parent.parent / 'img'

# Screen boxes inside the sheet, measured from the phone bezels.
COLS = [(7, 317), (332, 648), (663, 977), (991, 1308)]
ROWS = [(2, 583), (593, 1175)]
INSET = 9
NAMES = ['splash', 'howto', 'ready', 'play', 'play2', 'danger', 'results', 'rewards']


def screens(sheet):
    out, i = {}, 0
    for (y0, y1) in ROWS:
        for (x0, x1) in COLS:
            out[NAMES[i]] = sheet.crop((x0 + INSET, y0 + INSET, x1 - INSET + 1, y1 - INSET + 1))
            i += 1
    return out


# --------------------------------------------------------------------------- #
# helpers                                                                      #
# --------------------------------------------------------------------------- #

def feather_mask(size, radius):
    """White rectangle with `radius` px of soft edge, for seamless patching."""
    w, h = size
    m = Image.new('L', (w, h), 0)
    ImageDraw.Draw(m).rectangle([radius, radius, w - radius - 1, h - radius - 1], fill=255)
    return m.filter(ImageFilter.GaussianBlur(radius * 0.6))


def mirror_tile(im, width, soften=1.0):
    """Widen a clean strip of scenery by mirroring it end to end.

    The mockup has no unobstructed full-width sky — the hero car or a panel is
    always in the middle — but it does have clean columns down each side. Those
    tile seamlessly when every other copy is flipped.
    """
    out = Image.new('RGB', (width, im.height))
    x, flip = 0, False
    while x < width:
        out.paste(im.transpose(Image.FLIP_LEFT_RIGHT) if flip else im, (x, 0))
        x += im.width
        flip = not flip
    return out.filter(ImageFilter.GaussianBlur(soften)) if soften else out


def luma_key(im, floor, ceil, tint=None):
    """Alpha from luminance — pulls light marks (logo, lettering) off a dark
    background without a matting model."""
    g = im.convert('L')
    a = g.point(lambda v: 0 if v <= floor else (255 if v >= ceil else int(255 * (v - floor) / (ceil - floor))))
    rgba = im.convert('RGBA')
    rgba.putalpha(a)
    if tint:
        solid = Image.new('RGBA', im.size, tint + (255,))
        solid.putalpha(a)
        rgba = Image.alpha_composite(solid, rgba)
        rgba.putalpha(a)
    return rgba


def trim(im, pad=2):
    box = im.split()[3].getbbox()
    if not box:
        return im
    x0, y0, x1, y1 = box
    return im.crop((max(0, x0 - pad), max(0, y0 - pad),
                    min(im.width, x1 + pad), min(im.height, y1 + pad)))


def upscale(im, factor, resample=Image.LANCZOS):
    return im.resize((int(im.width * factor), int(im.height * factor)), resample)


def save_png(im, name):
    p = OUT / name
    im.save(p, optimize=True)
    print(f'  {name:22} {im.size[0]}x{im.size[1]}  {p.stat().st_size / 1024:6.1f} KB')


def save_jpg(im, name, q=84):
    p = OUT / name
    im.convert('RGB').save(p, quality=q, optimize=True, progressive=True)
    print(f'  {name:22} {im.size[0]}x{im.size[1]}  {p.stat().st_size / 1024:6.1f} KB')


# --------------------------------------------------------------------------- #
# cut-outs                                                                     #
# --------------------------------------------------------------------------- #

def cutout(im, scale=4):
    """Alpha-matte a subject off the desert. Upscaling first gives the model a
    workable input — the source crops are only ~200 px wide."""
    from rembg import remove, new_session
    global _SESSION
    try:
        _SESSION
    except NameError:
        _SESSION = new_session('u2net')
    big = upscale(im, scale)
    return remove(big, session=_SESSION, alpha_matting=True,
                  alpha_matting_foreground_threshold=250,
                  alpha_matting_background_threshold=15,
                  alpha_matting_erode_size=8)


# --------------------------------------------------------------------------- #

def main():
    sheet_path = Path(sys.argv[1]) if len(sys.argv) > 1 else None
    if not sheet_path or not sheet_path.is_file():
        sys.exit('usage: extract_assets.py <Arabic_drift.png>')

    sheet = Image.open(sheet_path).convert('RGB')
    if sheet.size != (1312, 1199):
        print(f'warning: expected a 1312x1199 sheet, got {sheet.size}')
    s = screens(sheet)
    OUT.mkdir(parents=True, exist_ok=True)
    print(f'writing to {OUT}')

    # --- hero car + driver, the sprite the whole game hangs on --------------
    # Matted at 4x, kept at 2x: enough for a retina phone, half the bytes.
    car_full = cutout(s['ready'].crop((48, 196, 272, 444)))
    car = trim(car_full)
    save_png(upscale(car, 0.5), 'car.png')

    # The car driving away and the script lettering both already live inside
    # results-art.jpg, so they are not cut out separately.

    # --- one of the floating coins -----------------------------------------
    coin = trim(cutout(s['play2'].crop((228, 312, 276, 360)), scale=8))
    save_png(upscale(coin, 160.0 / coin.width), 'coin.png')

    # --- scenery strips -----------------------------------------------------
    # Clean columns from the splash art, widened by mirroring: the canvas
    # scrolls these behind the procedural dunes and track.
    save_jpg(mirror_tile(s['splash'].crop((8, 12, 92, 186)), 360), 'sky.jpg', 84)
    # Stop above the shaded mid-ground: the strip has to meet the canvas's own
    # sand, so both of its edges fade out.
    ridge = mirror_tile(s['splash'].crop((8, 182, 74, 227)), 360, soften=0.6).convert('RGBA')
    ramp = Image.linear_gradient('L').resize((1, ridge.height)).resize(ridge.size)
    ridge.putalpha(ImageChops.multiply(
        ramp.point(lambda v: min(255, int(v * 3.2))),
        ramp.transpose(Image.FLIP_TOP_BOTTOM).point(lambda v: min(255, int(v * 5.0)))
    ))
    save_png(ridge, 'ridge.png')

    # --- results strip: sunset, the car driving off and the script line -----
    save_jpg(s['results'].crop((4, 230, 293, 420)), 'results-art.jpg', 86)

    # --- sand for the scrolling road texture --------------------------------
    save_jpg(s['ready'].crop((18, 470, 282, 550)), 'sand.jpg', 84)

    # --- marks and icons ----------------------------------------------------
    save_png(trim(luma_key(s['rewards'].crop((112, 20, 192, 80)), 40, 170)), 'logo.png')
    save_png(trim(luma_key(s['splash'].crop((28, 310, 268, 452)), 118, 225)), 'title.png')

    save_png(trim(luma_key(s['rewards'].crop((22, 150, 84, 212)), 40, 150)), 'tokens.png')
    save_png(trim(luma_key(s['rewards'].crop((116, 148, 184, 216)), 40, 150)), 'badge.png')
    save_jpg(s['rewards'].crop((206, 158, 282, 208)), 'skin.jpg', 86)

    for name, box in [('icon-crown', (20, 124, 56, 160)),
                      ('icon-clock', (160, 124, 196, 160)),
                      ('icon-flame', (20, 178, 56, 216)),
                      ('icon-coin', (160, 178, 196, 216))]:
        save_png(trim(luma_key(s['results'].crop(box), 45, 150)), name + '.png')

    print('done')


if __name__ == '__main__':
    main()
