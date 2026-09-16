"""Render a .pptx to preview images by reading the slide XML directly.

LibreOffice cannot load any file in this sandbox, so QA renders from the
package itself: shapes, text runs and images are read out of ppt/slides/*.xml
and drawn with Pillow. Fonts differ from PowerPoint's, so text is measured with
a metric-similar substitute and deliberately ERRS WIDE — if a box looks tight
here it has slack in the real deck, and anything that overflows here is worth a
second look.
"""
import zipfile, sys, os, re, io
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw, ImageFont

NS = {
    'a': 'http://schemas.openxmlformats.org/drawingml/2006/main',
    'p': 'http://schemas.openxmlformats.org/presentationml/2006/main',
    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
}
EMU_IN = 914400
DPI = 110

FONT_DIRS = ['/usr/share/fonts', '/usr/local/share/fonts']

def find_font(bold=False, italic=False):
    want = ('DejaVuSans-Bold.ttf' if bold else 'DejaVuSans.ttf')
    for root in FONT_DIRS:
        for dirpath, _, files in os.walk(root):
            if want in files:
                return os.path.join(dirpath, want)
    return None

FONT_REG, FONT_BOLD = find_font(False), find_font(True)

def font(size_pt, bold):
    px = max(6, int(size_pt * DPI / 72))
    path = FONT_BOLD if bold else FONT_REG
    try:
        return ImageFont.truetype(path, px)
    except Exception:
        return ImageFont.load_default()

def emu(v):
    return int(int(v) / EMU_IN * DPI)

def solid_color(node):
    if node is None:
        return None
    srgb = node.find('.//a:srgbClr', NS)
    return '#' + srgb.get('val') if srgb is not None else None

def render(pptx_path, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    z = zipfile.ZipFile(pptx_path)
    pres = ET.fromstring(z.read('ppt/presentation.xml'))
    sz = pres.find('p:sldSz', NS)
    W, H = emu(sz.get('cx')), emu(sz.get('cy'))

    slides = sorted([n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)],
                    key=lambda n: int(re.search(r'(\d+)', n.split('/')[-1]).group(1)))
    report = []
    for idx, name in enumerate(slides, 1):
        rels_name = f'ppt/slides/_rels/{os.path.basename(name)}.rels'
        rels = {}
        if rels_name in z.namelist():
            for rel in ET.fromstring(z.read(rels_name)):
                rels[rel.get('Id')] = rel.get('Target').replace('../', 'ppt/')

        root = ET.fromstring(z.read(name))
        bg = solid_color(root.find('.//p:bg', NS)) or '#FFFFFF'
        img = Image.new('RGB', (W, H), bg)
        d = ImageDraw.Draw(img, 'RGBA')
        issues = []

        for sp in root.iter():
            tag = sp.tag.split('}')[1]
            if tag not in ('sp', 'pic'):
                continue
            xfrm = sp.find('.//a:xfrm', NS)
            if xfrm is None:
                continue
            off, ext = xfrm.find('a:off', NS), xfrm.find('a:ext', NS)
            x, y = emu(off.get('x')), emu(off.get('y'))
            w, h = emu(ext.get('cx')), emu(ext.get('cy'))

            if x < -2 or y < -2 or x + w > W + 2 or y + h > H + 2:
                issues.append(f'shape out of bounds at {x},{y} {w}x{h}')

            if tag == 'pic':
                blip = sp.find('.//a:blip', NS)
                rid = blip.get('{%s}embed' % NS['r']) if blip is not None else None
                target = rels.get(rid)
                if target and target in z.namelist():
                    pic = Image.open(io.BytesIO(z.read(target))).convert('RGBA')
                    pic = pic.resize((max(1, w), max(1, h)), Image.LANCZOS)
                    img.paste(pic, (x, y), pic)
                else:
                    d.rectangle([x, y, x + w, y + h], outline='#FF00FF', width=2)
                continue

            fill = solid_color(sp.find('.//p:spPr/a:solidFill', NS))
            prst = sp.find('.//a:prstGeom', NS)
            kind = prst.get('prst') if prst is not None else 'rect'
            if fill:
                if kind == 'ellipse':
                    d.ellipse([x, y, x + w, y + h], fill=fill)
                else:
                    d.rounded_rectangle([x, y, x + w, y + h], radius=int(min(w, h) * 0.12), fill=fill)

            tx = sp.find('.//p:txBody', NS)
            if tx is None:
                continue
            cy = y + 4
            for para in tx.findall('a:p', NS):
                runs = para.findall('a:r', NS)
                if not runs:
                    cy += 6
                    continue
                text = ''.join((r.find('a:t', NS).text or '') for r in runs)
                rPr = runs[0].find('a:rPr', NS)
                size = int(rPr.get('sz', '1800')) / 100 if rPr is not None else 18
                bold = (rPr is not None and rPr.get('b') == '1')
                col = solid_color(rPr) if rPr is not None else None
                f = font(size, bold)
                align = (para.find('a:pPr', NS).get('algn') if para.find('a:pPr', NS) is not None else None)

                # naive wrap
                words, line, lines = text.split(' '), '', []
                for wd in words:
                    trial = (line + ' ' + wd).strip()
                    if d.textlength(trial, font=f) > w and line:
                        lines.append(line); line = wd
                    else:
                        line = trial
                lines.append(line)
                for ln in lines:
                    lw = d.textlength(ln, font=f)
                    lx = x + (w - lw) / 2 if align == 'ctr' else x
                    d.text((lx, cy), ln, font=f, fill=col or '#FFFFFF')
                    cy += size * DPI / 72 * 1.25
                if cy > y + h + 6:
                    issues.append(f'text may overflow: "{text[:38]}"')

        img.save(f'{out_dir}/slide-{idx:02d}.png')
        report.append((idx, issues))
    return report


if __name__ == '__main__':
    rep = render(sys.argv[1], sys.argv[2])
    for idx, issues in rep:
        print(f'slide {idx:02d}: ' + ('OK' if not issues else '; '.join(issues)))
