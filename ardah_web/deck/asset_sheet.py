"""Contact sheet of every image file the game loads, on a checkerboard so the
transparency is visible, with the real pixel size and weight under each one."""
import os, glob
from PIL import Image, ImageDraw, ImageFont

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets')
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sheets')
BG = (16, 18, 26)
INK = (243, 237, 226)
GOLD = (231, 180, 76)
MUTED = (150, 162, 180)


def font(sz, bold=False):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''),):
        if os.path.exists(p):
            return ImageFont.truetype(p, sz)
    return ImageFont.load_default()


def checker(size, step=12):
    im = Image.new('RGB', size, (52, 54, 62))
    d = ImageDraw.Draw(im)
    for y in range(0, size[1], step):
        for x in range(0, size[0], step):
            if (x // step + y // step) % 2 == 0:
                d.rectangle([x, y, x + step - 1, y + step - 1], fill=(38, 40, 48))
    return im


def tile(path, box_w, box_h, scale_to=None):
    im = Image.open(path).convert('RGBA')
    w, h = im.size
    target = scale_to or min(box_w / w, box_h / h)
    im = im.resize((max(1, int(w * target)), max(1, int(h * target))), Image.NEAREST if target > 1 else Image.LANCZOS)
    cell = checker((box_w, box_h))
    cell.paste(im, ((box_w - im.width) // 2, (box_h - im.height) // 2), im)
    return cell, (w, h)


def sheet(files, title, cols, box, scale, out_name, note=None):
    f_title, f_name, f_meta = font(30, True), font(17, True), font(14)
    pad, cap = 26, 52
    bw, bh = box
    rows = (len(files) + cols - 1) // cols
    W = pad + cols * (bw + pad)
    # The heading must not be clipped by a narrow grid.
    probe = ImageDraw.Draw(Image.new('RGB', (10, 10)))
    W = max(W, int(probe.textlength(title, font=f_title)) + pad * 2)
    if note:
        W = max(W, int(probe.textlength(note, font=f_meta)) + pad * 2)
    H = 120 + rows * (bh + cap + pad) + (40 if note else 0)
    sh = Image.new('RGB', (W, H), BG)
    d = ImageDraw.Draw(sh)
    d.text((pad, 34), title, font=f_title, fill=INK)

    for i, f in enumerate(files):
        cell, real = tile(f, bw, bh, scale)
        x = pad + (i % cols) * (bw + pad)
        y = 110 + (i // cols) * (bh + cap + pad)
        sh.paste(cell, (x, y))
        d.rectangle([x, y, x + bw - 1, y + bh - 1], outline=(70, 74, 86))
        name = os.path.basename(f)
        d.text((x, y + bh + 8), name, font=f_name, fill=GOLD)
        kb = os.path.getsize(f) / 1024
        d.text((x, y + bh + 30), f'{real[0]}x{real[1]} px · {kb:.1f} KB', font=f_meta, fill=MUTED)

    if note:
        d.text((pad, H - 34), note, font=f_meta, fill=MUTED)
    sh.save(f'{OUT}/{out_name}')
    print(out_name, sh.size)


def g(*names):
    return [f'{SRC}/{n}.webp' for n in names]


sheet(g('note_tabl', 'note_tabl_b', 'note_tabl_c',
        'note_swords', 'note_swords_b', 'note_swords_c',
        'note_tar', 'note_tar_b'),
      'Note sprites — the objects that travel down the lanes', 3, (250, 200), 2.4,
      'assets_notes.png',
      'One shape per lane, several colours within it — the lane stays readable by position '
      'and silhouette. Ray traced, not drawn: the stones are dielectrics, so their colour is '
      'an absorption coefficient rather than a fill.')

sheet(g('key_tabl', 'key_swords', 'key_tar', 'glyph_a', 'glyph_s', 'glyph_d'),
      'Lane keycaps and their key glyphs', 3, (250, 220), 2.4,
      'assets_keys.png',
      'Each pad is rendered from the angle the camera really has to it. The letters are '
      'SEPARATE sprites, not pixels on the pad: that is what keeps them localisable into '
      'Arabic, and lets a touch player get a dot instead of a key name.')

sheet(g('fx_flare', 'fx_ring', 'fx_glow', 'fx_spark'),
      'Hit effects — light, not surfaces', 4, (240, 240), 1.6,
      'assets_fx.png',
      'These carry INTENSITY IN THE ALPHA CHANNEL and chroma in RGB, because the game adds '
      'them rather than blending them. On this sheet they are shown blended, so they read '
      'darker here than in the game.')

sheet(g('fx_chip_a0', 'fx_chip_a1', 'fx_chip_b0', 'fx_chip_b1',
        'fx_chip_c0', 'fx_chip_c1', 'fx_shard_0', 'fx_shard_2',
        'fx_flake_0', 'fx_flake_1'),
      'Debris — a broken note throws pieces of itself', 5, (180, 180), 2.0,
      'assets_debris.png',
      'Crystal chips in the note\'s own colour, gold shards, silver flakes. A gem throws '
      'nothing: a cut stone that breaks should flash, not leave rubble.')

sheet(g('runway'),
      'The runway deck — dark glass with a gold Najdi lattice', 1, (900, 660), None,
      'assets_runway.png',
      'Stored in RUNWAY SPACE, not screen space: across by world x, along by depth z, with '
      'rows spaced uniformly in 1/z. The game warps it into whatever layout the handset has, '
      'once per resize.')

sheet([f'{SRC}/bg_stage.webp'], 'Stage backdrop — one plate behind the runway', 1, (760, 820), None,
      'assets_stage.png',
      'Cut from the concept art. Performers, musicians and fires are baked in, so this layer does not animate.')

sheet([f'{SRC}/ui_plaque.webp'], 'Title plaque — extracted but NOT used', 1, (700, 260), None,
      'assets_unused.png',
      'Its title is baked in as English pixels, so it cannot localise. The menu draws its own plaque instead.')
