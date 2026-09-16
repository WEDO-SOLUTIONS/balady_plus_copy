"""Rebuild the two sheets used to judge the note sprites.

  notes_hd.png       the three 512 px masters on a checkerboard
  notes_compare.png  cut vs redraw at the three sizes the runway uses

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
        sheet.paste(im, (x, pad), im)
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


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    masters()
    compare()
    print('notes_hd.png, notes_compare.png ->', OUT)
