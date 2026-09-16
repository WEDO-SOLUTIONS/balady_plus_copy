"""Two views of the hit effects.

  fx_sheet.png   each effect on its own, on the deck's own dark
  fx_hit.png     a hit landing on the runway, with everything composited the
                 way the game would draw it

The effects are stored for additive drawing -- chroma in RGB, intensity in
alpha -- so compositing here uses the same rule canvas does for
globalCompositeOperation = 'lighter': dst += src.rgb * src.a * globalAlpha.
Anything that judges these has to add them, not alpha-blend them, or the
answer is wrong.
"""
from PIL import Image, ImageDraw, ImageFont
import numpy as np
import os, math

HERE = os.path.dirname(os.path.abspath(__file__))
HD = os.path.join(HERE, '..', 'assets', 'hd')
OUT = os.path.join(HERE, 'out')

W, H, SCALE = 440, 956, 2
key_y = H - max(44, H * 0.065)
judge_y = key_y - max(52, H * 0.075)
vp_y = round(H * 0.48) - 62
C = judge_y - vp_y
half_near = min(W * 0.46, 300)


def font(sz):
    p = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
    return ImageFont.truetype(p, sz) if os.path.exists(p) else ImageFont.load_default()


def load(name):
    return Image.open(os.path.join(HD, name + '_hd.png')).convert('RGBA')


def add(dst, src, cx, cy, scale=1.0, alpha=1.0, rot=0.0):
    """Additive draw, centred on (cx, cy). dst is a float array HxWx3."""
    im = src
    if rot:
        im = im.rotate(rot, resample=Image.BICUBIC, expand=True)
    if scale != 1.0:
        im = im.resize((max(1, int(im.width * scale)), max(1, int(im.height * scale))),
                       Image.LANCZOS)
    a = np.asarray(im).astype(np.float32) / 255.0
    x0, y0 = int(cx - im.width / 2), int(cy - im.height / 2)
    x1, y1 = x0 + im.width, y0 + im.height
    sx0, sy0 = max(0, -x0), max(0, -y0)
    x0, y0 = max(0, x0), max(0, y0)
    x1, y1 = min(dst.shape[1], x1), min(dst.shape[0], y1)
    if x1 <= x0 or y1 <= y0:
        return
    patch = a[sy0:sy0 + (y1 - y0), sx0:sx0 + (x1 - x0)]
    dst[y0:y1, x0:x1] += patch[..., :3] * patch[..., 3:4] * alpha


def over(dst, src, cx, cy, scale=1.0):
    """Ordinary alpha compositing, for the solid sprites."""
    im = src
    if scale != 1.0:
        im = im.resize((max(1, int(im.width * scale)), max(1, int(im.height * scale))),
                       Image.LANCZOS)
    a = np.asarray(im).astype(np.float32) / 255.0
    x0, y0 = int(cx - im.width / 2), int(cy - im.height / 2)
    x1, y1 = x0 + im.width, y0 + im.height
    sx0, sy0 = max(0, -x0), max(0, -y0)
    x0, y0 = max(0, x0), max(0, y0)
    x1, y1 = min(dst.shape[1], x1), min(dst.shape[0], y1)
    if x1 <= x0 or y1 <= y0:
        return
    p = a[sy0:sy0 + (y1 - y0), sx0:sx0 + (x1 - x0)]
    al = p[..., 3:4]
    dst[y0:y1, x0:x1] = dst[y0:y1, x0:x1] * (1 - al) + p[..., :3] * al


def to_image(buf):
    return Image.fromarray((np.clip(buf, 0, 1) * 255).astype(np.uint8))


# ------------------------------- the sheet ---------------------------------
def sheet():
    items = [('fx_flare', 'flare', 1.0), ('fx_ring', 'shockwave', 1.0),
             ('fx_glow', 'lane glow', 1.0), ('fx_spark', 'ember', 1.6)]
    cell = 360
    buf = np.zeros((cell + 70, cell * len(items), 3), np.float32)
    buf[:] = 0.055
    for i, (name, _, sc) in enumerate(items):
        add(buf, load(name), cell * i + cell / 2, cell / 2 + 10, scale=sc * cell / 384)
    # the shards get their own row, drawn normally
    img = to_image(buf)
    d = ImageDraw.Draw(img)
    for i, (_, label, _) in enumerate(items):
        d.text((cell * i + cell // 2, cell + 22), label, font=font(26),
               fill=(232, 228, 220), anchor='ma')

    shards = [load('fx_shard_%d' % i) for i in range(6)]
    row = np.zeros((190, img.width, 3), np.float32)
    row[:] = 0.055
    for i, sh in enumerate(shards):
        over(row, sh, (i + 0.5) * img.width / 6, 80, scale=0.85)
    rimg = to_image(row)
    d2 = ImageDraw.Draw(rimg)
    d2.text((img.width // 2, 152), 'gold shards  (traced geometry, 6 fragments)',
            font=font(26), fill=(255, 205, 130), anchor='ma')
    out = Image.new('RGB', (img.width, img.height + rimg.height))
    out.paste(img, (0, 0)); out.paste(rimg, (0, img.height))
    out.save(os.path.join(OUT, 'fx_sheet.png'))
    print('fx_sheet.png', out.size)


# ------------------------------ the hit shot -------------------------------
def hit():
    base = Image.open(os.path.join(OUT, 'runway_preview.png')).convert('RGB')
    buf = np.asarray(base).astype(np.float32) / 255.0

    cx = base.width / 2
    jy = judge_y * SCALE
    lane_dx = (half_near * 2 / 3) * SCALE

    # Notes coming down the lanes, sized the way _gem does: dw = halfNear *
    # 0.34 * (1/z) * 2.15, scaled to this preview.
    def note_at(sprite, lane, z):
        x = cx + (lane - 1) * lane_dx / z
        y = (vp_y + C / z) * SCALE
        dw = half_near * 0.34 * (1 / z) * 2.15 * SCALE
        over(buf, sprite, x, y, scale=dw / sprite.width)

    note_at(load('note_tabl'), 0, 1.95)
    note_at(load('note_swords'), 1, 3.10)
    note_at(load('note_tar'), 2, 1.42)
    note_at(load('note_swords'), 1, 4.30)

    # Keycaps, sized by height the way _keycaps does: ch = 45 pt.
    for lane, name in enumerate(['key_tabl', 'key_swords', 'key_tar']):
        sp = load(name)
        over(buf, sp, cx + (lane - 1) * lane_dx, key_y * SCALE,
             scale=(45 * SCALE) / sp.height)

    # The hit itself, on the middle lane.
    hx, hy = cx, jy
    add(buf, load('fx_glow'), hx, hy, scale=2.6, alpha=0.55)
    add(buf, load('fx_ring'), hx, hy, scale=1.15, alpha=0.75)
    add(buf, load('fx_flare'), hx, hy, scale=1.5, alpha=1.0)

    rng = np.random.default_rng(7)
    for i in range(46):
        a = rng.uniform(0, 2 * math.pi)
        d = rng.uniform(18, 210) * SCALE / 2
        s = rng.uniform(0.18, 0.5)
        add(buf, load('fx_spark'), hx + math.cos(a) * d, hy + math.sin(a) * d * 0.55,
            scale=s, alpha=rng.uniform(0.35, 1.0))
    for i in range(9):
        a = rng.uniform(0, 2 * math.pi)
        d = rng.uniform(40, 170) * SCALE / 2
        sp = load('fx_shard_%d' % (i % 6))
        over(buf, sp, hx + math.cos(a) * d, hy + math.sin(a) * d * 0.55,
             scale=rng.uniform(0.22, 0.42))

    to_image(buf).save(os.path.join(OUT, 'fx_hit.png'))
    print('fx_hit.png', base.size)


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    sheet()
    hit()
