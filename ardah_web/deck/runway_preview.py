"""Map the runway texture through js/render.js's own projection.

The texture is in runway space, so this is the check that it lands correctly on
screen. Layout constants are read straight out of Renderer.resize for a
440x956 phone; everything is scaled by SCALE for viewing.

    keyY   = h - max(44, h * 0.065)
    judgeY = keyY - max(52, h * 0.075)
    vpY    = round(h * 0.48) - 62
    C      = judgeY - vpY
    halfNear = min(w * 0.46, 300)
"""
from PIL import Image
import os

HERE = os.path.dirname(os.path.abspath(__file__))
TEX = os.path.join(HERE, '..', 'assets', 'hd', 'runway_hd.png')
OUT = os.path.join(HERE, 'out', 'runway_preview.png')

W, H, SCALE = 440, 956, 2
Z_LIP, Z_FAR, X_MAX = 0.86, 5.0, 1.165

key_y = H - max(44, H * 0.065)
judge_y = key_y - max(52, H * 0.075)
vp_y = round(H * 0.48) - 62
C = judge_y - vp_y
half_near = min(W * 0.46, 300)

tex = Image.open(TEX).convert('RGBA')
out = Image.new('RGB', (W * SCALE, H * SCALE), (14, 12, 18))

inv_far, inv_lip = 1 / Z_FAR, 1 / Z_LIP
y_top = vp_y + C / Z_FAR
y_bot = vp_y + C / Z_LIP

for py in range(int(y_top * SCALE), int(y_bot * SCALE) + 1):
    y = py / SCALE
    z = C / (y - vp_y)
    if not (Z_LIP <= z <= Z_FAR):
        continue
    v = (1 / z - inv_far) / (inv_lip - inv_far)
    row = min(tex.height - 1, max(0, int(v * tex.height)))
    width = max(1, int(2 * (half_near / z) * X_MAX * SCALE))
    strip = tex.crop((0, row, tex.width, row + 1)).resize((width, 1), Image.LANCZOS)
    out.paste(strip, ((out.width - width) // 2, py), strip)

# The judgment line, so the near end is readable in context.
d = Image.new('RGBA', out.size, (0, 0, 0, 0))
from PIL import ImageDraw
dr = ImageDraw.Draw(d)
hn = half_near * SCALE
dr.rectangle([out.width // 2 - hn, judge_y * SCALE - 2,
              out.width // 2 + hn, judge_y * SCALE + 2], fill=(255, 226, 150, 220))
out = Image.alpha_composite(out.convert('RGBA'), d).convert('RGB')

os.makedirs(os.path.dirname(OUT), exist_ok=True)
out.save(OUT)
print('runway_preview.png', out.size, '->', OUT)
