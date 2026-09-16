#!/usr/bin/env python3
"""
Cut the three image assets out of the supplied Baloot mock-up.

    python3 tools/extract-assets.py "Baloot final.png"

Writes room.webp, crest.webp and corner.webp next to index.html. All the
coordinates below are pixel offsets into the 937x1679 mock-up, measured once
by hand; if the source art changes they have to be measured again.

Requires Pillow.
"""
import sys, statistics
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

SRC = Path(sys.argv[1] if len(sys.argv) > 1 else "Baloot final.png")
OUT = Path(__file__).resolve().parent.parent
src = Image.open(SRC).convert("RGB")


def row_heal(img, off, x0, x1, y0, y1, sl, sr, width=10):
    """Erase baked-in text: refill each row from clean pixels either side of it."""
    px = img.load()
    for y in range(y0 - off[1], y1 - off[1]):
        both = ([px[x, y] for x in range(sl - off[0], sl - off[0] + width)] +
                [px[x, y] for x in range(sr - off[0] - width, sr - off[0])])
        c = tuple(int(statistics.median([p[i] for p in both])) for i in range(3))
        for x in range(x0 - off[0], x1 - off[0]):
            px[x, y] = c


def key_background(rgb, seeds, thresh=58):
    """Flood the backdrop away from the given seeds and make it transparent."""
    KEY = (255, 0, 255)
    work = rgb.copy()
    for seed in seeds:
        try:
            ImageDraw.floodfill(work, seed, KEY, thresh=thresh)
        except Exception:
            pass
    out = rgb.convert("RGBA")
    po, pw = out.load(), work.load()
    for y in range(out.height):
        for x in range(out.width):
            if pw[x, y] == KEY:
                r, g, b, _ = po[x, y]
                po[x, y] = (r, g, b, 0)
    return out


def luma_alpha(rgba, floor, span):
    """Gold on dark cloth: derive alpha from brightness so it floats anywhere."""
    px = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, _ = px[x, y]
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            a = 0 if lum < floor else min(255, int((lum - floor) * 255 / span))
            px[x, y] = (r, g, b, a)
    return rgba


# ---------- 1. the room: walls, lanterns, players and the table ----------
BOX = (35, 322, 900, 866)          # below the baked score, above the WINNING pill
room = src.crop(BOX).convert("RGBA")
px = room.load()


def felt(x0, y0, x1, y1):
    vals = [px[x, y] for y in range(y0 - BOX[1], y1 - BOX[1])
                     for x in range(x0 - BOX[0], x1 - BOX[0])]
    return tuple(int(statistics.median([v[i] for v in vals])) for i in range(3))


# repaint the two cards lying on the cloth, so live ones can be dealt there
top, bot = felt(432, 726, 520, 744), felt(432, 846, 520, 862)
X0, Y0, X1, Y1 = 378, 748, 574, 840
w, h = X1 - X0, Y1 - Y0
patch = Image.new("RGB", (w, h))
pp = patch.load()
import random
random.seed(7)
for y in range(h):
    t = y / max(h - 1, 1)
    base = tuple(int(top[i] + (bot[i] - top[i]) * t) for i in range(3))
    for x in range(w):
        n = random.randint(-3, 3)
        pp[x, y] = tuple(max(0, min(255, base[i] + n)) for i in range(3))
patch = patch.filter(ImageFilter.GaussianBlur(0.6))
mask = Image.new("L", (w, h), 0)
ImageDraw.Draw(mask).rectangle((8, 8, w - 8, h - 8), fill=255)
room.paste(patch, (X0 - BOX[0], Y0 - BOX[1]), mask.filter(ImageFilter.GaussianBlur(5)))

# fade the bottom so the scene dissolves into the cloth below it
W, H = room.size
fade = Image.new("L", (W, H), 255)
d = ImageDraw.Draw(fade)
for i in range(80):
    d.line([(0, H - 1 - i), (W, H - 1 - i)], fill=int(255 * (i / 80) ** 1.25))
room.putalpha(fade)
room.resize((880, int(880 * H / W)), Image.LANCZOS).save(
    OUT / "room.webp", quality=84, method=6)

# ---------- 2. the crest: scroll, shield and plaque, emptied of text ----------
P = (258, 80, 682, 218)
crest = src.crop(P).copy()
row_heal(crest, P, 310, 628, 143, 197, 306, 634)             # the title
row_heal(crest, P, 461, 476, 95, 120, 457, 480, width=4)     # the deal number
crest = crest.filter(ImageFilter.GaussianBlur(0.4))
w, h = crest.size
crest = key_background(crest, [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1),
                               (3, 3), (w - 4, 3), (3, h - 4), (w - 4, h - 4),
                               (w // 2, 1), (w // 2, h - 2)])
crest.save(OUT / "crest.webp", quality=92, method=6)

# ---------- 3. the arabesque from the bottom bar ----------
corner = luma_alpha(src.crop((34, 1488, 140, 1606)).convert("RGBA"), 46, 58)
corner.save(OUT / "corner.webp", quality=92, method=6)

for n in ("room.webp", "crest.webp", "corner.webp"):
    print(n, Image.open(OUT / n).size, (OUT / n).stat().st_size // 1024, "KB")
