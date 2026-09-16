/* Forge high-resolution note sprites.

   The sprites in assets/ are cut from the concept image, where the coin is 72
   pixels across. The game draws it at ~120 pt near the judgment line, which on
   a 3x screen is 360 device pixels — a five-fold upscale of a lossy crop. No
   amount of filtering puts detail back; the only way up is to draw the object
   at the size it will actually be used.

   The palette is not invented: it is sampled from the cuts themselves, so the
   redraws sit in the same firelight as the rest of the concept.

       mid tone     H 26-33 deg, S 0.68-0.75   (deep orange, not yellow gold)
       shadow core  #050000 .. #230100         (the cuts really do go black)
       highlight    #FFFBE7 / #FFFFC9          (clipped, cream — never blue-white)
       swords       cyan stone AND a warm rim; the cut carries both #1EE1FF
                    and #D27732, because the braziers light the bezel

   Everything is drawn at 4x and downsampled. Two post-passes do the rest of
   the work: a bloom that squares the luminance before blurring, so only real
   speculars bleed, and a fine warm grain so the metal is not glassy-clean. */
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const path = require('path');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const SIZE = 512;
const SS = 4;                       // supersampling factor

const DRAW = (S) => {
  const R = S / 2;

  /* ------------------------------ lighting ------------------------------- */
  /* Two sources, the same ones the stage scene uses: a cool moon high to the
     left, and the braziers low and in front. Every face below gets one or the
     other, which is what stops a drawn object reading as a flat icon. */

  function shadow(c, cy, rx) {
    // Contact shadow: tight and genuinely dark under the object, fading wide.
    const g = c.createRadialGradient(R, cy, S * 0.01, R, cy, rx);
    g.addColorStop(0, 'rgba(0,0,0,0.72)');
    g.addColorStop(0.45, 'rgba(12,2,0,0.34)');
    g.addColorStop(1, 'rgba(0,0,0,0)');
    c.fillStyle = g;
    c.beginPath();
    c.ellipse(R, cy, rx, rx * 0.22, 0, 0, Math.PI * 2);
    c.fill();
  }

  function glow(c, color, radius) {
    const g = c.createRadialGradient(R, R, S * 0.04, R, R, radius);
    g.addColorStop(0, color.replace('ALPHA', '0.34'));
    g.addColorStop(0.5, color.replace('ALPHA', '0.11'));
    g.addColorStop(1, color.replace('ALPHA', '0'));
    c.fillStyle = g;
    c.fillRect(0, 0, S, S);
  }

  // Warm light thrown up onto a form from the braziers below.
  function bounce(c, cx, cy, rx, ry) {
    c.save();
    c.globalCompositeOperation = 'lighter';
    const g = c.createRadialGradient(cx, cy, 1, cx, cy, rx);
    g.addColorStop(0, 'rgba(255, 96, 8, 0.50)');
    g.addColorStop(0.6, 'rgba(210, 62, 0, 0.16)');
    g.addColorStop(1, 'rgba(180, 40, 0, 0)');
    c.fillStyle = g;
    c.beginPath();
    c.ellipse(cx, cy, rx, ry, 0, 0, Math.PI * 2);
    c.fill();
    c.restore();
  }

  /* -------------------------------- ingot -------------------------------- */
  /* A two-tier bar on an isometric footprint: the eye reads the rhombus as a
     square seen from above, and the side walls give it mass. */
  function ingot(c) {
    glow(c, 'rgba(255,124,16,ALPHA)', S * 0.48);

    const cx = R, cy = S * 0.58;
    const wx = S * 0.30, wy = S * 0.16;      // half-diagonals of the base
    const tier = S * 0.086;                   // wall height per tier
    const inset = 0.56;                       // top tier scale

    shadow(c, cy + tier + S * 0.035, S * 0.36);

    function rhombus(c, cx, cy, wx, wy) {
      c.beginPath();
      c.moveTo(cx, cy - wy);
      c.lineTo(cx + wx, cy);
      c.lineTo(cx, cy + wy);
      c.lineTo(cx - wx, cy);
      c.closePath();
    }

    // The walls are where the near-black of the cuts lives. The left wall is
    // turned away from the moon, the right one faces it; the braziers reach
    // both from below. Every tier is lit by the same routine, so a raised step
    // reads as a step rather than a recess.
    function wall(c, cx, cy, wx, wy, h, dir, grad, bright) {
      c.save();
      c.beginPath();
      c.moveTo(cx + dir * wx, cy); c.lineTo(cx, cy + wy);
      c.lineTo(cx, cy + wy + h); c.lineTo(cx + dir * wx, cy + h);
      c.closePath();
      c.clip();
      c.fillStyle = grad;
      c.fill();
      c.globalAlpha = bright;
      bounce(c, cx + dir * wx * 0.55, cy + wy * 0.85 + h, wx * 0.8, h * 1.5);
      c.restore();
    }

    function walls(c, cx, cy, wx, wy, h) {
      const left = c.createLinearGradient(cx - wx, cy, cx - wx, cy + h);
      left.addColorStop(0, '#C9600F');
      left.addColorStop(1, '#5A2103');
      wall(c, cx, cy, wx, wy, h, -1, left, 0.55);

      const right = c.createLinearGradient(cx + wx, cy, cx, cy + wy + h);
      right.addColorStop(0, '#F07207');
      right.addColorStop(0.55, '#B24703');
      right.addColorStop(1, '#4A1A01');
      wall(c, cx, cy, wx, wy, h, 1, right, 0.85);
    }

    // Lower tier
    walls(c, cx, cy, wx, wy, tier);
    const lowFace = c.createLinearGradient(cx - wx, cy - wy, cx + wx, cy + wy);
    lowFace.addColorStop(0, '#FFD786');
    lowFace.addColorStop(0.34, '#F79A16');
    lowFace.addColorStop(0.70, '#C34A00');
    lowFace.addColorStop(1, '#431400');
    c.fillStyle = lowFace;
    rhombus(c, cx, cy, wx, wy); c.fill();

    // The upper tier beds into the lower one with an occlusion gradient at the
    // crease. There is deliberately no separate cast shadow: the step is only
    // half a wall high, so a projected rhombus would sit clear of the tier
    // that casts it and read as a hole punched in the bar.
    const ty = cy - tier * 0.55;
    c.save();
    rhombus(c, cx, cy, wx, wy); c.clip();

    const ao = c.createRadialGradient(cx, ty + wy * 0.15, S * 0.01, cx, ty + wy * 0.15, wx * 0.60);
    ao.addColorStop(0, 'rgba(32, 10, 0, 0.66)');
    ao.addColorStop(1, 'rgba(32, 10, 0, 0)');
    c.fillStyle = ao;
    c.fillRect(0, 0, S, S);
    c.restore();

    // Upper tier, lifted by one wall height
    walls(c, cx, ty, wx * inset, wy * inset, tier * 0.85);
    const topFace = c.createLinearGradient(cx - wx * inset, ty - wy * inset,
                                           cx + wx * inset, ty + wy * inset);
    topFace.addColorStop(0, '#FFF6D2');
    topFace.addColorStop(0.30, '#FFBE44');
    topFace.addColorStop(0.66, '#F08010');
    topFace.addColorStop(1, '#5F2001');
    c.fillStyle = topFace;
    rhombus(c, cx, ty, wx * inset, wy * inset); c.fill();

    // Molten core: the saturated orange the cuts sit at, pushed through the
    // middle of the top face so the bar looks lit from inside rather than
    // painted.
    c.save();
    rhombus(c, cx, ty, wx * inset, wy * inset); c.clip();
    const core = c.createRadialGradient(cx, ty, 1, cx, ty, wx * inset);
    core.addColorStop(0, 'rgba(255, 128, 8, 0.42)');
    core.addColorStop(0.7, 'rgba(240, 92, 0, 0.14)');
    core.addColorStop(1, 'rgba(220, 70, 0, 0)');
    c.fillStyle = core;
    c.fillRect(0, 0, S, S);
    c.restore();

    // Specular: a broad gloss band, then a tight clipped hotspot on top of it.
    c.save();
    rhombus(c, cx, ty, wx * inset, wy * inset); c.clip();
    const spec = c.createLinearGradient(cx - wx * 0.55, ty - wy, cx + wx * 0.15, ty + wy);
    spec.addColorStop(0, 'rgba(255,251,231,0)');
    spec.addColorStop(0.34, 'rgba(255,251,231,0.34)');
    spec.addColorStop(0.46, 'rgba(255,255,244,0.92)');
    spec.addColorStop(0.56, 'rgba(255,251,231,0.30)');
    spec.addColorStop(0.72, 'rgba(255,251,231,0)');
    c.fillStyle = spec; c.fillRect(0, 0, S, S);
    c.restore();

    // Edge highlights: the two edges facing the moon stay bright and clipped.
    c.lineCap = 'round';
    c.strokeStyle = 'rgba(255,253,240,0.98)';
    c.lineWidth = S * 0.009;
    c.beginPath();
    c.moveTo(cx - wx * inset, ty); c.lineTo(cx, ty - wy * inset); c.lineTo(cx + wx * inset, ty);
    c.stroke();
    c.strokeStyle = 'rgba(255,226,150,0.62)';
    c.lineWidth = S * 0.007;
    c.beginPath();
    c.moveTo(cx - wx, cy); c.lineTo(cx, cy - wy); c.lineTo(cx + wx, cy);
    c.stroke();
    // and the lit bottom edge picks up the fire, not the moon
    c.strokeStyle = 'rgba(255,150,40,0.55)';
    c.beginPath();
    c.moveTo(cx, cy + wy + tier); c.lineTo(cx + wx, cy + tier);
    c.stroke();
  }

  /* -------------------------------- jewel -------------------------------- */
  /* Cyan stone in a gold bezel. The cut carries both #1EE1FF and #D27732 —
     the stone is cool, the metal around it is firelit, and the two meet in a
     warm reflection inside the pavilion. */
  function jewel(c) {
    glow(c, 'rgba(40,200,255,ALPHA)', S * 0.46);

    const rad = S * 0.30, cy = S * 0.50;
    shadow(c, cy + rad * 1.10, S * 0.33);

    // Gold bezel, lit orange from below-right and cream from upper-left
    const bez = c.createLinearGradient(R - rad, cy - rad, R + rad, cy + rad);
    bez.addColorStop(0, '#FFE9B4');
    bez.addColorStop(0.3, '#E8A02A');
    bez.addColorStop(0.62, '#8A5410');
    bez.addColorStop(0.82, '#3A1A02');
    bez.addColorStop(1, '#D27732');
    c.fillStyle = bez;
    c.beginPath(); c.arc(R, cy, rad, 0, Math.PI * 2); c.fill();

    c.save();
    c.beginPath(); c.arc(R, cy, rad, 0, Math.PI * 2); c.clip();
    bounce(c, R + rad * 0.3, cy + rad * 0.95, rad * 1.1, rad * 0.55);
    c.restore();

    // Inner shadow where the bezel meets the stone
    c.strokeStyle = 'rgba(24, 8, 0, 0.72)';
    c.lineWidth = S * 0.014;
    c.beginPath(); c.arc(R, cy, rad * 0.89, 0, Math.PI * 2); c.stroke();

    // Claws: small, tapered, and only where they would actually sit
    for (let i = 0; i < 6; i++) {
      const a = (i / 6) * Math.PI * 2 + 0.52;
      const lit = 0.5 + 0.5 * Math.cos(a - Math.PI * 1.25);
      c.fillStyle = `rgb(${Math.round(168 + lit * 87)}, ${Math.round(108 + lit * 130)}, ${Math.round(40 + lit * 130)})`;
      c.shadowColor = 'rgba(30, 12, 0, 0.8)';
      c.shadowBlur = S * 0.008;
      c.save();
      c.translate(R + Math.cos(a) * rad * 0.93, cy + Math.sin(a) * rad * 0.93);
      c.rotate(a);
      c.beginPath();
      c.ellipse(0, 0, rad * 0.085, rad * 0.055, 0, 0, Math.PI * 2);
      c.fill();
      c.restore();
      c.shadowBlur = 0;
    }

    // Faceted stone. The dark facets go to the cut's #001E89 rather than a
    // polite mid-blue, which is most of what makes a gem read as a gem.
    const sr = rad * 0.86;
    const facets = 10;
    for (let i = 0; i < facets; i++) {
      const a0 = (i / facets) * Math.PI * 2 - 0.3;
      const a1 = ((i + 1) / facets) * Math.PI * 2 - 0.3;
      const lit = 0.5 + 0.5 * Math.cos(a0 - Math.PI * 1.25);
      const g = c.createLinearGradient(R, cy, R + Math.cos(a0) * sr, cy + Math.sin(a0) * sr);
      g.addColorStop(0, `rgba(${Math.round(60 + lit * 162)}, ${Math.round(200 + lit * 50)}, 255, 1)`);
      g.addColorStop(1, `rgba(0, ${Math.round(14 + lit * 104)}, ${Math.round(74 + lit * 150)}, 1)`);
      c.fillStyle = g;
      c.beginPath();
      c.moveTo(R, cy);
      c.lineTo(R + Math.cos(a0) * sr, cy + Math.sin(a0) * sr);
      c.lineTo(R + Math.cos(a1) * sr, cy + Math.sin(a1) * sr);
      c.closePath();
      c.fill();
    }

    // Firelight reflected off the bezel into the lower pavilion — the warm
    // note inside a cool stone that the cut has and a clean vector icon lacks.
    c.save();
    c.beginPath(); c.arc(R, cy, sr, 0, Math.PI * 2); c.clip();
    c.globalCompositeOperation = 'lighter';
    const warm = c.createRadialGradient(R + sr * 0.25, cy + sr * 0.62, 1,
                                        R + sr * 0.25, cy + sr * 0.62, sr * 0.9);
    warm.addColorStop(0, 'rgba(255, 120, 26, 0.55)');
    warm.addColorStop(1, 'rgba(210, 119, 50, 0)');
    c.fillStyle = warm;
    c.fillRect(0, 0, S, S);
    c.restore();

    // Table facet
    const table = c.createLinearGradient(R - sr * 0.5, cy - sr * 0.5, R + sr * 0.4, cy + sr * 0.5);
    table.addColorStop(0, 'rgba(255,255,248,0.94)');
    table.addColorStop(0.38, 'rgba(30,225,255,0.88)');
    table.addColorStop(1, 'rgba(0,16,86,0.94)');
    c.fillStyle = table;
    c.beginPath(); c.arc(R, cy, sr * 0.40, 0, Math.PI * 2); c.fill();

    // Specular spot, clipped cream rather than blue-white, plus a caustic
    c.fillStyle = 'rgba(255,255,201,0.97)';
    c.beginPath();
    c.ellipse(R - sr * 0.26, cy - sr * 0.30, sr * 0.21, sr * 0.14, -0.6, 0, Math.PI * 2);
    c.fill();
    c.strokeStyle = 'rgba(142,250,255,0.62)';
    c.lineWidth = S * 0.006;
    c.beginPath();
    c.arc(R, cy, sr * 0.80, Math.PI * 0.85, Math.PI * 1.35);
    c.stroke();

    // Girdle: the hard line where crown meets pavilion
    c.strokeStyle = 'rgba(0, 20, 78, 0.68)';
    c.lineWidth = S * 0.007;
    c.beginPath(); c.arc(R, cy, sr * 0.985, 0, Math.PI * 2); c.stroke();
  }

  /* --------------------------------- coin --------------------------------- */
  function coin(c) {
    glow(c, 'rgba(255,150,40,ALPHA)', S * 0.48);

    const rx = S * 0.34, ry = S * 0.27, cy = S * 0.50, thick = S * 0.055;
    shadow(c, cy + ry + thick + S * 0.03, S * 0.37);

    // Edge (the coin has thickness, seen slightly from above)
    const edge = c.createLinearGradient(R - rx, 0, R + rx, 0);
    edge.addColorStop(0, '#2A0E00');
    edge.addColorStop(0.42, '#C06215');
    edge.addColorStop(0.62, '#8A3D06');
    edge.addColorStop(1, '#1E0900');
    c.fillStyle = edge;
    c.beginPath();
    c.ellipse(R, cy + thick, rx, ry, 0, 0, Math.PI * 2);
    c.fill();
    c.fillRect(R - rx, cy, rx * 2, thick);

    // Fire on the bottom edge
    c.save();
    c.beginPath(); c.ellipse(R, cy + thick, rx, ry, 0, 0, Math.PI * 2); c.clip();
    bounce(c, R, cy + ry + thick * 0.6, rx * 0.9, thick * 2.2);
    c.restore();

    // Face
    const face = c.createLinearGradient(R - rx, cy - ry, R + rx * 0.6, cy + ry);
    face.addColorStop(0, '#FFF3CE');
    face.addColorStop(0.26, '#FFD27A');
    face.addColorStop(0.58, '#EFA233');
    face.addColorStop(0.84, '#9E5C0E');
    face.addColorStop(1, '#4E1C01');
    c.fillStyle = face;
    c.beginPath(); c.ellipse(R, cy, rx, ry, 0, 0, Math.PI * 2); c.fill();

    // Warm bounce back up into the lower half of the face
    c.save();
    c.beginPath(); c.ellipse(R, cy, rx, ry, 0, 0, Math.PI * 2); c.clip();
    bounce(c, R + rx * 0.1, cy + ry * 0.78, rx * 0.85, ry * 0.6);
    c.restore();

    // Milled rim
    c.strokeStyle = 'rgba(56, 22, 0, 0.72)';
    c.lineWidth = S * 0.006;
    for (let i = 0; i < 64; i++) {
      const a = (i / 64) * Math.PI * 2;
      c.beginPath();
      c.moveTo(R + Math.cos(a) * rx * 0.92, cy + Math.sin(a) * ry * 0.92);
      c.lineTo(R + Math.cos(a) * rx * 0.99, cy + Math.sin(a) * ry * 0.99);
      c.stroke();
    }
    c.strokeStyle = 'rgba(255,251,231,0.82)';
    c.lineWidth = S * 0.008;
    c.beginPath(); c.ellipse(R, cy, rx * 0.88, ry * 0.88, 0, 0, Math.PI * 2); c.stroke();

    // Struck motif: an eight-point geometric rosette. It is deliberately NOT
    // the crossed-sabres-and-palm arrangement an earlier pass used: that is
    // the Saudi state emblem, which docs/ardah-art-brief.md rules out as
    // decoration. A geometric star is culturally at home, carries no state
    // symbolism, and stays legible at the ~38 pt the far end of the runway
    // draws it. Struck twice -- a dark cut, then a light bevel one step up --
    // which is what makes an engraving read as metal rather than a sticker.
    c.save();
    c.translate(R, cy);
    c.scale(1, ry / rx);
    const m = rx * 0.62;

    function star(c, fill) {
      for (const phase of [0, Math.PI / 8]) {
        c.beginPath();
        for (let i = 0; i < 8; i++) {
          const a = phase + (i / 8) * Math.PI * 2;
          const b = phase + ((i + 0.5) / 8) * Math.PI * 2;
          const px = Math.cos(a) * m * 0.86, py = Math.sin(a) * m * 0.86;
          const qx = Math.cos(b) * m * 0.40, qy = Math.sin(b) * m * 0.40;
          if (i === 0) c.moveTo(px, py); else c.lineTo(px, py);
          c.lineTo(qx, qy);
        }
        c.closePath();
        if (fill) c.fill(); else c.stroke();
      }
      c.beginPath();                       // boss at the centre
      c.arc(0, 0, m * 0.17, 0, Math.PI * 2);
      if (fill) c.fill(); else c.stroke();
    }

    c.lineJoin = 'round';
    c.strokeStyle = 'rgba(46, 16, 0, 0.88)';
    c.lineWidth = S * 0.016;
    star(c, false);

    c.translate(0, -S * 0.009);
    c.strokeStyle = 'rgba(255, 246, 214, 0.66)';
    c.lineWidth = S * 0.009;
    star(c, false);
    c.restore();

    // Specular sweep: broad gloss with a clipped core, angled across the face
    c.save();
    c.beginPath(); c.ellipse(R, cy, rx, ry, 0, 0, Math.PI * 2); c.clip();
    const spec = c.createLinearGradient(R - rx, cy - ry, R + rx * 0.25, cy + ry * 0.7);
    spec.addColorStop(0, 'rgba(255,251,231,0)');
    spec.addColorStop(0.36, 'rgba(255,251,231,0.14)');
    spec.addColorStop(0.45, 'rgba(255,255,240,0.52)');
    spec.addColorStop(0.54, 'rgba(255,251,231,0.12)');
    spec.addColorStop(0.72, 'rgba(255,251,231,0)');
    c.fillStyle = spec;
    c.fillRect(0, 0, S, S);
    c.restore();
  }

  return { ingot, jewel, coin };
};

/* Post-passes, run on the supersampled canvas before it is downsampled. */
const POST = (S) => {
  /* Bloom. Squaring the image through a 'multiply' self-composite crushes the
     mid-tones and leaves the speculars near 1, so the blur that follows bleeds
     only from real highlights instead of fogging the whole sprite. */
  function bloom(src, amount, radius) {
    const mask = document.createElement('canvas');
    mask.width = mask.height = S;
    const mc = mask.getContext('2d');
    mc.drawImage(src, 0, 0);
    mc.globalCompositeOperation = 'multiply';
    mc.drawImage(mask, 0, 0);
    mc.drawImage(mask, 0, 0);          // luminance^4: only clipped whites survive
    mc.globalCompositeOperation = 'source-over';

    const c = src.getContext('2d');
    c.save();
    c.globalCompositeOperation = 'lighter';
    c.globalAlpha = amount;
    c.filter = `blur(${radius}px)`;
    c.drawImage(mask, 0, 0);
    c.restore();
  }

  /* Grain, kept inside the sprite's own alpha. Warm-biased, because the cuts
     carry the concept's film grain and a perfectly smooth gradient is the
     clearest tell that something was drawn by a machine. */
  function grain(src, amount) {
    const n = 256;
    const nc = document.createElement('canvas');
    nc.width = nc.height = n;
    const nx = nc.getContext('2d');
    const id = nx.createImageData(n, n);
    for (let i = 0; i < n * n; i++) {
      const v = 128 + (Math.random() - 0.5) * 255 * amount;
      id.data[i * 4] = Math.min(255, v * 1.06);
      id.data[i * 4 + 1] = v;
      id.data[i * 4 + 2] = Math.max(0, v * 0.94);
      id.data[i * 4 + 3] = 255;
    }
    nx.putImageData(id, 0, 0);

    // Mask the grain to the sprite's own alpha first: 'overlay' composites
    // over transparent pixels as well, so painting it straight onto the
    // sprite would fog the whole square.
    const layer = document.createElement('canvas');
    layer.width = layer.height = S;
    const lc = layer.getContext('2d');
    lc.fillStyle = lc.createPattern(nc, 'repeat');
    lc.fillRect(0, 0, S, S);
    lc.globalCompositeOperation = 'destination-in';
    lc.drawImage(src, 0, 0);

    const c = src.getContext('2d');
    c.save();
    c.globalCompositeOperation = 'overlay';
    c.globalAlpha = 0.5;
    c.drawImage(layer, 0, 0);
    c.restore();
  }

  return { bloom, grain };
};

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setContent('<canvas id="c"></canvas>');

  const files = await page.evaluate(({ size, ss, src, post }) => {
    const big4 = size * ss;
    const draw = new Function('return ' + src)()(big4);
    const fx = new Function('return ' + post)()(big4);
    const out = {};
    for (const [name, fn] of Object.entries(draw)) {
      const big = document.createElement('canvas');
      big.width = big.height = big4;
      fn(big.getContext('2d'));
      fx.bloom(big, 0.55, big4 * 0.018);
      fx.grain(big, 0.10);
      const small = document.createElement('canvas');
      small.width = small.height = size;
      const sc = small.getContext('2d');
      sc.imageSmoothingQuality = 'high';
      sc.drawImage(big, 0, 0, size, size);
      out[name] = small.toDataURL('image/png');
    }
    return out;
  }, { size: SIZE, ss: SS, src: DRAW.toString(), post: POST.toString() });

  const map = { ingot: 'note_tabl_hd', jewel: 'note_swords_hd', coin: 'note_tar_hd' };
  for (const [key, data] of Object.entries(files)) {
    const buf = Buffer.from(data.split(',')[1], 'base64');
    fs.writeFileSync(path.join(OUT, map[key] + '.png'), buf);
    console.log(map[key] + '.png', (buf.length / 1024).toFixed(1) + ' KB');
  }
  await browser.close();
})();
