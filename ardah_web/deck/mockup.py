"""Wrap a captured frame in an iPhone-style device shell.

Everything is drawn: rounded screen, titanium-ish bezel, the Dynamic Island,
a soft contact shadow. Output is RGBA so slides can sit it on any background.
"""
import sys, os
from PIL import Image, ImageDraw, ImageFilter

SCREEN_RATIO = 440 / 956          # iPhone 17 Pro Max logical points


def rounded_mask(size, radius, supersample=4):
    w, h = size
    m = Image.new('L', (w * supersample, h * supersample), 0)
    ImageDraw.Draw(m).rounded_rectangle(
        [0, 0, w * supersample - 1, h * supersample - 1],
        radius=radius * supersample, fill=255)
    return m.resize((w, h), Image.LANCZOS)


def device(frame_path, height=1400, bezel=None, shadow=True, cutout='island'):
    """`cutout` is 'island' (iPhone-style pill) or 'punch' (a centred hole, the
    Galaxy shape). The game keeps its HUD below the reported safe-area inset, so
    either shell clears the meters — the shape is only a styling choice."""
    shot = Image.open(frame_path).convert('RGB')
    sw = int(round(height * SCREEN_RATIO))
    shot = shot.resize((sw, height), Image.LANCZOS)

    b = bezel if bezel is not None else max(6, int(height * 0.011))
    radius = int(height * 0.062)
    body_w, body_h = sw + b * 2, height + b * 2

    pad = int(height * 0.06) if shadow else 0
    canvas = Image.new('RGBA', (body_w + pad * 2, body_h + pad * 2), (0, 0, 0, 0))

    if shadow:
        sh = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
        ImageDraw.Draw(sh).rounded_rectangle(
            [pad, pad + int(height * 0.012), pad + body_w, pad + body_h + int(height * 0.012)],
            radius=radius + b, fill=(0, 0, 0, 150))
        canvas.alpha_composite(sh.filter(ImageFilter.GaussianBlur(pad * 0.45)))

    # Bezel: a dark body with a bright rim, which is all the eye needs.
    body = Image.new('RGBA', (body_w, body_h), (0, 0, 0, 0))
    bd = ImageDraw.Draw(body)
    bd.rounded_rectangle([0, 0, body_w - 1, body_h - 1], radius=radius + b, fill=(26, 24, 28, 255))
    bd.rounded_rectangle([0, 0, body_w - 1, body_h - 1], radius=radius + b,
                         outline=(168, 158, 142, 255), width=max(2, b // 3))
    canvas.alpha_composite(body, (pad, pad))

    screen = Image.new('RGBA', (sw, height))
    screen.paste(shot, (0, 0))
    screen.putalpha(rounded_mask((sw, height), radius))
    canvas.alpha_composite(screen, (pad + b, pad + b))

    # Camera cutout, drawn to the proportions the device actually reports.
    if cutout == 'punch':
        d = int(height * 0.026)
        cx = pad + b + sw // 2 - d // 2
        cy = pad + b + int(height * 0.014)
        hole = Image.new('RGBA', (d, d), (0, 0, 0, 0))
        ImageDraw.Draw(hole).ellipse([0, 0, d - 1, d - 1], fill=(8, 8, 10, 255))
        canvas.alpha_composite(hole, (cx, cy))
    elif cutout == 'island':
        iw, ih = int(sw * 0.30), int(height * 0.037)
        ix, iy = pad + b + (sw - iw) // 2, pad + b + int(height * 0.0115)
        island = Image.new('RGBA', (iw, ih), (0, 0, 0, 0))
        ImageDraw.Draw(island).rounded_rectangle([0, 0, iw - 1, ih - 1], radius=ih // 2, fill=(8, 8, 10, 255))
        canvas.alpha_composite(island, (ix, iy))

    return canvas


if __name__ == '__main__':
    src, dst = sys.argv[1], sys.argv[2]
    h = int(sys.argv[3]) if len(sys.argv) > 3 else 1400
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    device(src, h).save(dst)
    print(dst)
