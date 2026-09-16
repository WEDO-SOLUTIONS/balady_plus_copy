"""Rebuild the sheets used to judge the traced sprites.

  notes_hd.png       the three 512 px note masters on a checkerboard
  notes_compare.png  cut vs traced at the three sizes the runway uses
  caps_compare.png   the keycaps, cut vs traced, at the size render.js draws

Sizes come from the perspective in render.js: a note is ~38 pt at the far end,
~67 pt mid-runway and ~115 pt at the judgment line, drawn here at 3x so the
comparison is at device pixels rather than points.
"""
from PIL import Image, ImageDraw, ImageFont
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(HERE, '..', 'assets')
OUT = os.path.join(HERE, 'out')
LANES = [('tabl', 'note_tabl'), ('swords', 'note_swords'), ('tar', 'note_tar')]
SIZES = [('far  ~38 pt', 38 * 3), ('mid  ~67 pt', 67 * 3), ('line ~115 pt', 115 * 3)]


def font(sz):
    p = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
    return ImageFont.truetype(p, sz) if os.path.exists(p) else ImageFont.load_default()


def checker(w, h, s=16):
    im = Image.new('RGB', (w, h), (44, 44, 48))
    d = ImageDraw.Draw(im)
    for y in range(0, h, s):
        for x in range(0, w, s):
            if (x // s + y // s) % 2 == 0:
                d.rectangle([x, y, x + s - 1, y + s - 1], fill=(58, 58, 63))
    return im


def masters():
    cell, pad = 512, 40
    sheet = checker(cell * 3 + pad * 4, cell + pad * 2 + 70)
    d = ImageDraw.Draw(sheet)
    for i, (lane, base) in enumerate(LANES):
        im = Image.open(os.path.join(ASSETS, 'hd', base + '_hd.png')).convert('RGBA')
        x = pad + i * (cell + pad)
        # The masters are trimmed to their content now, so centre them in the
        # cell rather than assuming they fill it.
        sheet.paste(im, (x + (cell - im.width) // 2, pad + (cell - im.height) // 2), im)
        d.text((x + cell // 2, pad + cell + 18), f'{lane}  512 px',
               font=font(30), fill=(235, 232, 226), anchor='ma')
    sheet.save(os.path.join(OUT, 'notes_hd.png'))


def compare():
    colw = max(s for _, s in SIZES) + 70
    rowh = max(s for _, s in SIZES) + 40
    sheet = checker(210 + colw * len(SIZES), 64 + len(LANES) * 2 * rowh)
    d = ImageDraw.Draw(sheet)
    for j, (label, _) in enumerate(SIZES):
        d.text((210 + j * colw + colw // 2, 22), label, font=font(26),
               fill=(235, 232, 226), anchor='ma')
    y = 64
    for lane, base in LANES:
        for tag, path in (('cut', os.path.join(ASSETS, base + '.webp')),
                          ('redraw', os.path.join(ASSETS, 'hd', base + '_hd.png'))):
            im = Image.open(path).convert('RGBA')
            d.text((24, y + rowh // 2), f'{lane}\n{tag}', font=font(24),
                   fill=(255, 205, 130) if tag == 'redraw' else (196, 196, 202), anchor='lm')
            for j, (_, px) in enumerate(SIZES):
                sc = px / max(im.size)
                r = im.resize((max(1, round(im.width * sc)), max(1, round(im.height * sc))),
                              Image.LANCZOS)
                sheet.paste(r, (210 + j * colw + colw // 2 - r.width // 2,
                                y + rowh // 2 - r.height // 2), r)
            y += rowh
    sheet.save(os.path.join(OUT, 'notes_compare.png'))


def caps():
    # js/render.js sizes a keycap by HEIGHT (ch = h * 1.5 = 45 pt, width
    # follows the aspect), the opposite of a note -- so the row below scales
    # each sprite to a fixed height, which is what the game will do.
    LANES = [('tabl', 'key_tabl'), ('swords', 'key_swords'), ('tar', 'key_tar')]
    SIZES = [('as drawn  45 pt', 45 * 3), ('2x', 90 * 3)]
    colw = max(s for _, s in SIZES) * 2 + 80
    rowh = max(s for _, s in SIZES) + 46
    sheet = checker(230 + colw * len(SIZES), 64 + len(LANES) * 2 * rowh)
    d = ImageDraw.Draw(sheet)
    for j, (label, _) in enumerate(SIZES):
        d.text((230 + j * colw + colw // 2, 22), label, font=font(26),
               fill=(235, 232, 226), anchor='ma')
    y = 64
    for lane, base in LANES:
        for tag, path in (('cut', os.path.join(ASSETS, base + '.webp')),
                          ('traced', os.path.join(ASSETS, 'hd', base + '_hd.png'))):
            im = Image.open(path).convert('RGBA')
            d.text((24, y + rowh // 2), f'{lane}\n{tag}', font=font(24),
                   fill=(255, 205, 130) if tag == 'traced' else (196, 196, 202), anchor='lm')
            for j, (_, px) in enumerate(SIZES):
                sc = px / im.height
                r = im.resize((max(1, round(im.width * sc)), max(1, round(im.height * sc))),
                              Image.LANCZOS)
                sheet.paste(r, (230 + j * colw + colw // 2 - r.width // 2,
                                y + rowh // 2 - r.height // 2), r)
            y += rowh
    sheet.save(os.path.join(OUT, 'caps_compare.png'))


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    masters()
    compare()
    caps()
    print('notes_hd.png, notes_compare.png, caps_compare.png ->', OUT)
