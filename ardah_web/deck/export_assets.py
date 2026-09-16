"""Export the traced masters in assets/hd/ to the webp the game loads.

Target sizes come from what js/render.js can ask for at most. Note that
Renderer.resize caps dpr at 2, so the ceiling is twice the point size, not
three times:

    note      dw = halfNear * 0.731 / z, worst case z = Z_LIP -> ~172 pt
    keycap    ch = 45 pt
    runway    2 * halfNear * 1.165 at the near lip -> ~471 pt
    effects   scaled by the game, a couple of hundred points at most

Masters are kept at or a little above those ceilings and no further: past the
point where a sprite is drawn 1:1 the extra pixels are only file size, and the
brief's budget is 4 MB for the whole set.
"""
from PIL import Image
import os

HERE = os.path.dirname(os.path.abspath(__file__))
HD = os.path.join(HERE, '..', 'assets', 'hd')
OUT = os.path.join(HERE, '..', 'assets')

# name -> (longest side in px, quality); None keeps the master's size
JOBS = {
    'note_tabl': (None, 92), 'note_swords': (None, 92), 'note_tar': (None, 92),
    'key_tabl': (200, 92), 'key_swords': (200, 92), 'key_tar': (200, 92),
    'runway': (1280, 90),
    'fx_spark': (64, 92), 'fx_flare': (None, 92),
    'fx_ring': (None, 92), 'fx_glow': (None, 92),
}
for i in range(6):
    JOBS['fx_shard_%d' % i] = (80, 92)

total = 0
for name, (longest, q) in sorted(JOBS.items()):
    src = os.path.join(HD, name + '_hd.png')
    if not os.path.exists(src):
        print('  missing', src)
        continue
    im = Image.open(src).convert('RGBA')
    if longest and max(im.size) > longest:
        s = longest / max(im.size)
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))),
                       Image.LANCZOS)
    dst = os.path.join(OUT, name + '.webp')
    # exact=True keeps the colour under transparent pixels, which matters for
    # the effects: they carry intensity in alpha and chroma in RGB, so a codec
    # that "optimises" RGB where alpha is low would eat the ember gradient.
    im.save(dst, 'WEBP', quality=q, method=6, exact=True)
    kb = os.path.getsize(dst) / 1024
    total += kb
    print(f'  {name:16s} {im.width:4d}x{im.height:<4d} {kb:7.1f} KB')

print(f'  {"total":16s} {total / 1024:.2f} MB  (brief allows 4 MB for the set)')
