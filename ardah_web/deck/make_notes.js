/* Forge high-resolution note sprites.

   The sprites in assets/ are cut from the concept image, where the coin is 72
   pixels across. The game draws it at ~120 pt near the judgment line, which on
   a 3x screen is 360 device pixels — a five-fold upscale of a lossy crop. No
   amount of filtering puts detail back; the only way up is to draw the object
   at the size it will actually be used.

   These are drawn on a canvas at 4x and downsampled, which is what gives the
   clean edges: bevels, a specular sweep, a rim light from the moon side, and a
   contact shadow, all in the palette the lanes already use. */
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const path = require('path');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const SIZE = 512;
const SS = 4;                       // supersampling factor

const DRAW = (S) => {
  const R = S / 2;

  function rr(c, x, y, w, h, r) {
    c.beginPath();
    c.moveTo(x + r, y);
    c.arcTo(x + w, y, x + w, y + h, r);
    c.arcTo(x + w, y + h, x, y + h, r);
    c.arcTo(x, y + h, x, y, r);
    c.arcTo(x, y, x + w, y, r);
    c.closePath();
  }

  function shadow(c) {
    const g = c.createRadialGradient(R, S * 0.86, S * 0.02, R, S * 0.86, S * 0.34);
    g.addColorStop(0, 'rgba(0,0,0,0.55)');
    g.addColorStop(1, 'rgba(0,0,0,0)');
    c.fillStyle = g;
    c.beginPath();
    c.ellipse(R, S * 0.86, S * 0.34, S * 0.075, 0, 0, Math.PI * 2);
    c.fill();
  }

  function glow(c, color, radius) {
    const g = c.createRadialGradient(R, R, S * 0.05, R, R, radius);
    g.addColorStop(0, color.replace('ALPHA', '0.38'));
    g.addColorStop(0.55, color.replace('ALPHA', '0.12'));
    g.addColorStop(1, color.replace('ALPHA', '0'));
    c.fillStyle = g;
    c.fillRect(0, 0, S, S);
  }

  /* -------------------------------- ingot -------------------------------- */
  /* A two-tier bar on an isometric footprint: the eye reads the rhombus as a
     square seen from above, and the side walls give it mass. */
  function ingot(c) {
    glow(c, 'rgba(255,190,80,ALPHA)', S * 0.46);
    shadow(c);

    const cx = R, cy = S * 0.56;
    const wx = S * 0.30, wy = S * 0.16;      // half-diagonals of the base
    const tier = S * 0.085;                   // wall height per tier
    const inset = 0.62;                       // top tier scale

    function rhombus(c, cx, cy, wx, wy) {
      c.beginPath();
      c.moveTo(cx, cy - wy);
      c.lineTo(cx + wx, cy);
      c.lineTo(cx, cy + wy);
      c.lineTo(cx - wx, cy);
      c.closePath();
    }

    function walls(c, cx, cy, wx, wy, h, leftCol, rightCol) {
      c.fillStyle = leftCol;                  // away from the light
      c.beginPath();
      c.moveTo(cx - wx, cy); c.lineTo(cx, cy + wy);
      c.lineTo(cx, cy + wy + h); c.lineTo(cx - wx, cy + h);
      c.closePath(); c.fill();
      c.fillStyle = rightCol;
      c.beginPath();
      c.moveTo(cx + wx, cy); c.lineTo(cx, cy + wy);
      c.lineTo(cx, cy + wy + h); c.lineTo(cx + wx, cy + h);
      c.closePath(); c.fill();
    }

    // Lower tier
    walls(c, cx, cy, wx, wy, tier, '#6E4109', '#C2801A');
    const lowFace = c.createLinearGradient(cx - wx, cy - wy, cx + wx, cy + wy);
    lowFace.addColorStop(0, '#FFE08A');
    lowFace.addColorStop(0.42, '#F5A927');
    lowFace.addColorStop(0.78, '#D2761A');
    lowFace.addColorStop(1, '#9A5310');
    c.fillStyle = lowFace;
    rhombus(c, cx, cy, wx, wy); c.fill();

    // Upper tier, lifted by one wall height
    const ty = cy - tier * 1.15;
    walls(c, cx, ty, wx * inset, wy * inset, tier * 0.9, '#7A4A0C', '#D9922A');
    const topFace = c.createLinearGradient(cx - wx * inset, ty - wy * inset,
                                           cx + wx * inset, ty + wy * inset);
    topFace.addColorStop(0, '#FFFAE4');
    topFace.addColorStop(0.38, '#FFD46A');
    topFace.addColorStop(0.72, '#F09A22');
    topFace.addColorStop(1, '#B2680F');
    c.fillStyle = topFace;
    rhombus(c, cx, ty, wx * inset, wy * inset); c.fill();

    // Warm core: molten gold, the thing the flat first pass was missing.
    c.save();
    rhombus(c, cx, ty, wx * inset, wy * inset); c.clip();
    const core = c.createRadialGradient(cx, ty, 1, cx, ty, wx * inset);
    core.addColorStop(0, 'rgba(255, 176, 40, 0.55)');
    core.addColorStop(1, 'rgba(255, 140, 20, 0)');
    c.fillStyle = core;
    c.fillRect(0, 0, S, S);
    c.restore();

    // Specular streak across the top tier
    c.save();
    rhombus(c, cx, ty, wx * inset, wy * inset); c.clip();
    const spec = c.createLinearGradient(cx - wx * 0.5, ty - wy, cx + wx * 0.1, ty + wy);
    spec.addColorStop(0, 'rgba(255,255,255,0)');
    spec.addColorStop(0.42, 'rgba(255,255,255,0.8)');
    spec.addColorStop(0.6, 'rgba(255,255,255,0)');
    c.fillStyle = spec; c.fillRect(0, 0, S, S);
    c.restore();

    // Edge highlights: the two edges facing the moon stay bright.
    c.strokeStyle = 'rgba(255,250,220,0.95)';
    c.lineWidth = S * 0.008;
    c.beginPath();
    c.moveTo(cx - wx * inset, ty); c.lineTo(cx, ty - wy * inset); c.lineTo(cx + wx * inset, ty);
    c.stroke();
    c.strokeStyle = 'rgba(255,240,190,0.55)';
    c.beginPath();
    c.moveTo(cx - wx, cy); c.lineTo(cx, cy - wy); c.lineTo(cx + wx, cy);
    c.stroke();
  }

  /* -------------------------------- jewel -------------------------------- */
  function jewel(c) {
    glow(c, 'rgba(90,180,255,ALPHA)', S * 0.46);
    shadow(c);

    const rad = S * 0.30, cy = S * 0.50;

    // Gold bezel
    const bez = c.createLinearGradient(R - rad, cy - rad, R + rad, cy + rad);
    bez.addColorStop(0, '#FFE9A8');
    bez.addColorStop(0.4, '#D79E30');
    bez.addColorStop(0.75, '#8A5B12');
    bez.addColorStop(1, '#F0C560');
    c.fillStyle = bez;
    c.beginPath(); c.arc(R, cy, rad, 0, Math.PI * 2); c.fill();

    // Inner shadow where the bezel meets the stone
    c.strokeStyle = 'rgba(60, 34, 4, 0.55)';
    c.lineWidth = S * 0.012;
    c.beginPath(); c.arc(R, cy, rad * 0.80, 0, Math.PI * 2); c.stroke();

    // Claws: small, tapered, and only where they would actually sit
    c.fillStyle = '#FBE2A0';
    for (let i = 0; i < 6; i++) {
      const a = (i / 6) * Math.PI * 2 + 0.52;
      c.save();
      c.translate(R + Math.cos(a) * rad * 0.82, cy + Math.sin(a) * rad * 0.82);
      c.rotate(a);
      c.beginPath();
      c.ellipse(0, 0, rad * 0.11, rad * 0.062, 0, 0, Math.PI * 2);
      c.fill();
      c.restore();
    }

    // Faceted stone: a ring of triangles around a table, each facet its own tone
    const sr = rad * 0.74;
    const facets = 10;
    for (let i = 0; i < facets; i++) {
      const a0 = (i / facets) * Math.PI * 2 - 0.3;
      const a1 = ((i + 1) / facets) * Math.PI * 2 - 0.3;
      const lit = 0.5 + 0.5 * Math.cos(a0 - Math.PI * 1.25);
      const g = c.createLinearGradient(R, cy, R + Math.cos(a0) * sr, cy + Math.sin(a0) * sr);
      g.addColorStop(0, `rgba(${Math.round(120 + lit * 110)}, ${Math.round(190 + lit * 55)}, 255, 1)`);
      g.addColorStop(1, `rgba(${Math.round(10 + lit * 40)}, ${Math.round(70 + lit * 60)}, ${Math.round(160 + lit * 60)}, 1)`);
      c.fillStyle = g;
      c.beginPath();
      c.moveTo(R, cy);
      c.lineTo(R + Math.cos(a0) * sr, cy + Math.sin(a0) * sr);
      c.lineTo(R + Math.cos(a1) * sr, cy + Math.sin(a1) * sr);
      c.closePath();
      c.fill();
    }

    // Table facet
    const table = c.createLinearGradient(R - sr * 0.5, cy - sr * 0.5, R + sr * 0.4, cy + sr * 0.5);
    table.addColorStop(0, 'rgba(255,255,255,0.92)');
    table.addColorStop(0.4, 'rgba(120,205,255,0.85)');
    table.addColorStop(1, 'rgba(20,90,190,0.9)');
    c.fillStyle = table;
    c.beginPath(); c.arc(R, cy, sr * 0.52, 0, Math.PI * 2); c.fill();

    // Specular spot and a thin caustic
    c.fillStyle = 'rgba(255,255,255,0.95)';
    c.beginPath();
    c.ellipse(R - sr * 0.26, cy - sr * 0.30, sr * 0.20, sr * 0.13, -0.6, 0, Math.PI * 2);
    c.fill();
    c.strokeStyle = 'rgba(255,255,255,0.5)';
    c.lineWidth = S * 0.006;
    c.beginPath();
    c.arc(R, cy, sr * 0.80, Math.PI * 0.85, Math.PI * 1.35);
    c.stroke();

    // Girdle: the hard line where crown meets pavilion
    c.strokeStyle = 'rgba(8, 40, 96, 0.55)';
    c.lineWidth = S * 0.007;
    c.beginPath(); c.arc(R, cy, sr * 0.985, 0, Math.PI * 2); c.stroke();
  }

  /* --------------------------------- coin --------------------------------- */
  function coin(c) {
    glow(c, 'rgba(255,205,110,ALPHA)', S * 0.46);
    shadow(c);

    const rx = S * 0.34, ry = S * 0.27, cy = S * 0.50, thick = S * 0.055;

    // Edge (the coin has thickness, seen slightly from above)
    const edge = c.createLinearGradient(R - rx, 0, R + rx, 0);
    edge.addColorStop(0, '#6E4410');
    edge.addColorStop(0.5, '#C78F27');
    edge.addColorStop(1, '#5C3A0C');
    c.fillStyle = edge;
    c.beginPath();
    c.ellipse(R, cy + thick, rx, ry, 0, 0, Math.PI * 2);
    c.fill();
    c.fillRect(R - rx, cy, rx * 2, thick);

    // Face
    const face = c.createLinearGradient(R - rx, cy - ry, R + rx * 0.6, cy + ry);
    face.addColorStop(0, '#FFF3CE');
    face.addColorStop(0.32, '#FFD66E');
    face.addColorStop(0.68, '#E0912A');
    face.addColorStop(1, '#8A5410');
    c.fillStyle = face;
    c.beginPath(); c.ellipse(R, cy, rx, ry, 0, 0, Math.PI * 2); c.fill();

    // Milled rim
    c.strokeStyle = 'rgba(120,76,14,0.55)';
    c.lineWidth = S * 0.006;
    for (let i = 0; i < 64; i++) {
      const a = (i / 64) * Math.PI * 2;
      c.beginPath();
      c.moveTo(R + Math.cos(a) * rx * 0.92, cy + Math.sin(a) * ry * 0.92);
      c.lineTo(R + Math.cos(a) * rx * 0.99, cy + Math.sin(a) * ry * 0.99);
      c.stroke();
    }
    c.strokeStyle = 'rgba(255,245,214,0.8)';
    c.lineWidth = S * 0.008;
    c.beginPath(); c.ellipse(R, cy, rx * 0.88, ry * 0.88, 0, 0, Math.PI * 2); c.stroke();

    // Struck motif: two sabres crossing under a palm. Drawn twice — a dark
    // pass for the cut and a light pass one step up for the bevel — which is
    // what makes an engraving read as struck metal rather than a sticker.
    c.save();
    c.translate(R, cy);
    c.scale(1, ry / rx);
    const m = rx * 0.62;

    function sabre(c, dir) {
      c.beginPath();
      c.moveTo(-dir * m * 0.92, m * 0.46);
      c.quadraticCurveTo(-dir * m * 0.15, m * 0.86, dir * m * 0.80, -m * 0.05);
      c.stroke();
      c.beginPath();                        // hilt
      c.moveTo(-dir * m * 0.92, m * 0.46);
      c.lineTo(-dir * m * 1.06, m * 0.62);
      c.stroke();
    }

    function palm(c) {
      c.beginPath();
      c.moveTo(0, m * 0.20); c.lineTo(0, -m * 0.52);
      c.stroke();
      for (let i = 0; i < 5; i++) {
        const a = -Math.PI * 0.88 + (i / 4) * Math.PI * 0.76;
        c.beginPath();
        c.moveTo(0, -m * 0.52);
        c.quadraticCurveTo(Math.cos(a) * m * 0.34, -m * 0.52 + Math.sin(a) * m * 0.34,
                           Math.cos(a) * m * 0.60, -m * 0.34 + Math.sin(a) * m * 0.60);
        c.stroke();
      }
    }

    c.lineCap = 'round';
    c.strokeStyle = 'rgba(118, 74, 14, 0.9)';
    c.lineWidth = S * 0.019;
    sabre(c, 1); sabre(c, -1);
    c.lineWidth = S * 0.014;
    palm(c);

    c.translate(0, -S * 0.008);
    c.strokeStyle = 'rgba(255, 244, 208, 0.55)';
    c.lineWidth = S * 0.010;
    sabre(c, 1); sabre(c, -1);
    c.lineWidth = S * 0.008;
    palm(c);
    c.restore();

    // Specular sweep
    c.save();
    c.beginPath(); c.ellipse(R, cy, rx, ry, 0, 0, Math.PI * 2); c.clip();
    const spec = c.createLinearGradient(R - rx, cy - ry, R + rx * 0.2, cy + ry * 0.6);
    spec.addColorStop(0, 'rgba(255,255,255,0)');
    spec.addColorStop(0.42, 'rgba(255,255,255,0.55)');
    spec.addColorStop(0.58, 'rgba(255,255,255,0)');
    c.fillStyle = spec;
    c.fillRect(0, 0, S, S);
    c.restore();
  }

  return { ingot, jewel, coin };
};

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setContent('<canvas id="c"></canvas>');

  const files = await page.evaluate(({ size, ss, src }) => {
    const draw = new Function('return ' + src)()(size * ss);
    const out = {};
    for (const [name, fn] of Object.entries(draw)) {
      const big = document.createElement('canvas');
      big.width = big.height = size * ss;
      fn(big.getContext('2d'));
      const small = document.createElement('canvas');
      small.width = small.height = size;
      const sc = small.getContext('2d');
      sc.imageSmoothingQuality = 'high';
      sc.drawImage(big, 0, 0, size, size);
      out[name] = small.toDataURL('image/png');
    }
    return out;
  }, { size: SIZE, ss: SS, src: DRAW.toString() });

  const map = { ingot: 'note_tabl_hd', jewel: 'note_swords_hd', coin: 'note_tar_hd' };
  for (const [key, data] of Object.entries(files)) {
    const buf = Buffer.from(data.split(',')[1], 'base64');
    fs.writeFileSync(path.join(OUT, map[key] + '.png'), buf);
    console.log(map[key] + '.png', (buf.length / 1024).toFixed(1) + ' KB');
  }
  await browser.close();
})();
