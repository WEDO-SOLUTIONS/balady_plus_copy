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

from PIL import Image, ImageChops, ImageDraw, ImageEnhance, ImageFilter, ImageStat

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


def fade_bottom(im, frac=0.26):
    """Dissolve the bottom of a sprite instead of ending it on a straight cut.

    The driver is cropped at the waist, and no amount of seating him deeper
    hides that edge without burying his torso as well. Fading it lets him read
    as continuing down into the cabin.
    """
    h = im.height
    start = int(h * (1 - frac))
    ramp = Image.new('L', (1, h), 255)
    rp = ramp.load()
    for y in range(start, h):
        rp[0, y] = int(255 * (1 - (y - start) / max(1, h - start)) ** 1.4)
    out = im.copy()
    out.putalpha(ImageChops.multiply(im.split()[3], ramp.resize(im.size)))
    return out


def erode_alpha(im, size=5):
    """Shave the outermost ring of a matte.

    Partially transparent edge pixels still carry the background's colour, so
    over a dark surface they read as a pale outline. Cutting them is simpler
    than un-mixing them and, at this scale, indistinguishable.
    """
    a = im.split()[3].filter(ImageFilter.MinFilter(size)).filter(ImageFilter.GaussianBlur(1))
    out = im.copy()
    out.putalpha(a)
    return out


def solidify(im, gamma=0.62, floor=58):
    """Push a soft matte towards opaque.

    A white sleeve against a bright sky comes back half-transparent, which
    reads as a ghost limb once the sprite is composited. Bending the alpha
    curve fills it in; anything below `floor` is dropped so the fringe does not
    come with it.
    """
    a = im.split()[3].point(
        lambda v: 0 if v < floor else min(255, int(255 * (v / 255.0) ** gamma)))
    out = im.copy()
    out.putalpha(a)
    return out


def largest_blob(im, thresh=40):
    """Keep only the biggest connected run of opaque pixels.

    A loose matte picks up specks — a corner of the countdown panel, a fleck of
    debris — that read as dirt once the sprite is drawn large. Flood-filling
    from the heaviest component and dropping the rest is enough to clear them.
    """
    a = im.split()[3]
    w, h = a.size
    small = a.resize((max(1, w // 4), max(1, h // 4)), Image.BILINEAR)
    sw, sh = small.size
    px = small.load()

    seen = bytearray(sw * sh)
    best, best_size = None, 0
    for sy in range(sh):
        for sx in range(sw):
            if seen[sy * sw + sx] or px[sx, sy] < thresh:
                continue
            stack, cells = [(sx, sy)], []
            seen[sy * sw + sx] = 1
            while stack:
                x, y = stack.pop()
                cells.append((x, y))
                for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                    if 0 <= nx < sw and 0 <= ny < sh and not seen[ny * sw + nx] \
                            and px[nx, ny] >= thresh:
                        seen[ny * sw + nx] = 1
                        stack.append((nx, ny))
            if len(cells) > best_size:
                best, best_size = cells, len(cells)

    if not best:
        return im

    keep = Image.new('L', (sw, sh), 0)
    kp = keep.load()
    for x, y in best:
        kp[x, y] = 255
    keep = keep.resize((w, h), Image.BILINEAR).filter(ImageFilter.MaxFilter(5))

    out = im.copy()
    out.putalpha(ImageChops.multiply(a, keep))
    return out


def trim(im, pad=2):
    box = im.split()[3].getbbox()
    if not box:
        return im
    x0, y0, x1, y1 = box
    return im.crop((max(0, x0 - pad), max(0, y0 - pad),
                    min(im.width, x1 + pad), min(im.height, y1 + pad)))


def upscale(im, factor, resample=Image.LANCZOS):
    return im.resize((int(im.width * factor), int(im.height * factor)), resample)


def sharpen(im, radius=1.6, percent=105, threshold=2):
    """The sheet's crops are small and the game draws them large; an unsharp
    pass buys back the edge the upscale eats. It is applied to the colour only,
    so the matte's soft edge is left alone."""
    rgb = im.convert('RGB').filter(
        ImageFilter.UnsharpMask(radius=radius, percent=percent, threshold=threshold))
    out = rgb.convert('RGBA')
    out.putalpha(im.split()[3])
    return out


def compose_hero(car, driver, seat=0.545, lift=0.42, scale=0.47):
    """Seat the driver in the car's sunroof.

    `seat` is where along the car's width he sits, `lift` how far his hips sit
    below the roof line, and `scale` his height relative to the car's.
    """
    # The matte keeps a wedge of sand under the wheels; fading it out stops it
    # reading as a cardboard base once the sprite sits on the track.
    car = car.copy()
    a = car.split()[3]
    ramp = Image.linear_gradient('L').resize((1, car.height)).resize(car.size)
    ramp = ramp.point(lambda v: 255 if v < 216 else max(0, 255 - (v - 216) * 7))
    car.putalpha(ImageChops.multiply(a, ramp))

    dh = int(car.height * scale)
    dw = max(1, int(driver.width * dh / driver.height))
    d = driver.resize((dw, dh), Image.LANCZOS)

    pad = dh
    out = Image.new('RGBA', (max(car.width, dw) + pad, car.height + pad), (0, 0, 0, 0))
    ox = (out.width - car.width) // 2
    oy = out.height - car.height
    out.alpha_composite(car, (ox, oy))

    dx = int(ox + car.width * seat - dw / 2)
    dy = int(oy - dh + dh * lift)
    out.alpha_composite(d, (max(0, dx), max(0, dy)))
    return trim(out)


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

def cutout(im, scale=4, matting=True):
    """Alpha-matte a subject off the desert. Upscaling first gives the model a
    workable input — the source crops are only ~200 px wide.

    `matting` is True for the default thresholds, False to skip matting, or a
    (foreground, background, erode) triple. The defaults give the car a clean
    rim but eat thin low-contrast limbs: on the driver they cropped both of his
    raised arms, which are white sleeves against a bright sky.
    """
    from rembg import remove, new_session
    global _SESSION
    try:
        _SESSION
    except NameError:
        _SESSION = new_session('u2net')
    big = upscale(im, scale)
    if matting is False:
        return remove(big, session=_SESSION)
    fg, bg, erode = (250, 15, 8) if matting is True else matting
    return remove(big, session=_SESSION, alpha_matting=True,
                  alpha_matting_foreground_threshold=fg,
                  alpha_matting_background_threshold=bg,
                  alpha_matting_erode_size=erode)


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

    # --- hero car: the rear three-quarter, so the camera follows the car ----
    # The results screen is the only rear shot on the sheet and it is small,
    # so it is matted at 8x and kept larger than the crop deserves.
    rear = trim(cutout(s['results'].crop((96, 286, 186, 374)), scale=8))

    # Its driver faces away. The countdown screen's driver is turned towards
    # the camera, which is the pose the game wants, so he is matted separately
    # and seated in the rear car's sunroof.
    # Cropped above the countdown car's roof line: any lower and the matte
    # drags that car's bonnet along with him.
    # Gentle matting thresholds: the default pair is tuned for the car's hard
    # rim and eats his sleeves, but matting off leaves a halo of sky that shows
    # as a box once he is composited over the dark rear window.
    driver = erode_alpha(trim(largest_blob(
        cutout(s['ready'].crop((134, 219, 258, 298)), scale=8, matting=(200, 45, 3)))))

    hero = compose_hero(sharpen(rear, radius=2.2, percent=155),
                        fade_bottom(sharpen(driver)))
    save_png(upscale(hero, 520.0 / hero.width), 'car.png')


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
