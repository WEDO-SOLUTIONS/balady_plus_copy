/* Embossed key glyphs.

   The keycap sprites carry no letter -- docs/ardah-art-brief.md §1 forbids text
   baked into artwork, because the strings localise to Arabic, the layout flips
   to RTL, and a player on touch needs a dot rather than a key name. But flat
   canvas text on top of a traced pad looks exactly like what it is.

   So the glyph gets rendered too, as its own sprite: rasterise the character,
   take the distance from its edge, raise that into a rounded bevel, and light
   the result with the same sources as everything else. The letter keeps its
   own 3D without being welded to the pad, and localising is re-running this
   with a different GLYPHS list -- which is the entire point of not baking it
   into the cap.

   Run: node deck/make_glyphs.js  */

'use strict';

const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const path = require('path');
const { LIGHTS, env, schlick, reflect, directSpec, toSRGB } = require('./lib/shade');
const png = require('./lib/png');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const S = 320;                 // raster size
/* The bevel has to be narrow relative to the stroke.

   At 26 px against a ~40 px stroke the profile never reached its plateau, so
   the whole stroke was bevel and the height field creased along the letter's
   medial axis -- which a distance field represents as a fan of ridges, and
   differentiating it into a normal turned that fan into visible striations.
   At 12 px each stroke gets a flat face with rolled edges, which is what the
   concept's letters have anyway. */
const BEVEL = 12;              // bevel width in px
const HEIGHT = 13;             // peak height, same units as the pixel grid

// name -> character. Localising means changing this list, nothing else.
const GLYPHS = { glyph_a: 'A', glyph_s: 'S', glyph_d: 'D', glyph_dot: '●' };

/* Exact Euclidean distance to the outside of the glyph, by Felzenszwalb and
   Huttenlocher's lower-envelope transform: a 1D pass down the columns, then
   another across the rows, each O(n).

   A chamfer approximation is shorter, but its error is anisotropic, and on the
   curved strokes of an S it turns into visible striations once the bevel
   amplifies the gradient. The bevel IS the derivative of this field, so the
   field has to be smooth. */
function edt1d(f, n, d, v, z) {
  let k = 0;
  v[0] = 0; z[0] = -Infinity; z[1] = Infinity;
  for (let q = 1; q < n; q++) {
    let s = ((f[q] + q * q) - (f[v[k]] + v[k] * v[k])) / (2 * q - 2 * v[k]);
    while (s <= z[k]) {
      k--;
      s = ((f[q] + q * q) - (f[v[k]] + v[k] * v[k])) / (2 * q - 2 * v[k]);
    }
    k++; v[k] = q; z[k] = s; z[k + 1] = Infinity;
  }
  k = 0;
  for (let q = 0; q < n; q++) {
    while (z[k + 1] < q) k++;
    d[q] = (q - v[k]) * (q - v[k]) + f[v[k]];
  }
}

function distanceInside(mask, w, h) {
  const INF = 1e12;
  const g = new Float64Array(w * h);
  for (let i = 0; i < w * h; i++) g[i] = mask[i] > 0.5 ? INF : 0;

  const n = Math.max(w, h);
  const f = new Float64Array(n), d = new Float64Array(n);
  const v = new Int32Array(n), z = new Float64Array(n + 1);

  for (let x = 0; x < w; x++) {
    for (let y = 0; y < h; y++) f[y] = g[y * w + x];
    edt1d(f, h, d, v, z);
    for (let y = 0; y < h; y++) g[y * w + x] = d[y];
  }
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) f[x] = g[y * w + x];
    edt1d(f, w, d, v, z);
    for (let x = 0; x < w; x++) g[y * w + x] = Math.sqrt(d[x]);
  }
  return g;
}

/* A circular arc profile: flat on top, rolling off to nothing at the edge.
   A linear ramp reads as a chamfer; the arc reads as a struck letter. */
function profile(t) {
  const u = 1 - Math.max(0, Math.min(1, t));
  return Math.sqrt(Math.max(0, 1 - u * u));
}

/* Separable 1-2-1, `passes` times. */
function blur3(src, w, h, passes) {
  let a = src;
  for (let p = 0; p < passes; p++) {
    const b = new Float32Array(w * h);
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const i = y * w + x;
        const l = x > 0 ? a[i - 1] : a[i], r = x < w - 1 ? a[i + 1] : a[i];
        b[i] = (l + 2 * a[i] + r) * 0.25;
      }
    }
    const c = new Float32Array(w * h);
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const i = y * w + x;
        const u = y > 0 ? b[i - w] : b[i], d2 = y < h - 1 ? b[i + w] : b[i];
        c[i] = (u + 2 * b[i] + d2) * 0.25;
      }
    }
    a = c;
  }
  return a;
}

function shadeGlyph(mask, w, h) {
  const d = distanceInside(mask, w, h);
  let hgt = new Float32Array(w * h);
  for (let i = 0; i < w * h; i++) hgt[i] = HEIGHT * profile(d[i] / BEVEL);
  // The mask is thresholded at 0.5, so a near-horizontal edge is a staircase.
  // One narrow blur on the height field removes that without rounding the
  // bevel off, because the bevel is many pixels wide and the staircase is one.
  hgt = blur3(hgt, w, h, 2);

  const rgba = new Uint8Array(w * h * 4);
  const e = [0, 0, 0], rf = [0, 0, 0], acc = [0, 0, 0];
  const ALBEDO = [0.92, 0.88, 0.80];        // warm off-white, not paper white

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const i = y * w + x;
      const o = i * 4;
      const cov = mask[i];
      if (cov <= 0.004) { rgba[o] = rgba[o + 1] = rgba[o + 2] = rgba[o + 3] = 0; continue; }

      const hx = (hgt[i + (x < w - 1 ? 1 : 0)] - hgt[i - (x > 0 ? 1 : 0)]) * 0.5;
      const hy = (hgt[i + (y < h - 1 ? w : 0)] - hgt[i - (y > 0 ? w : 0)]) * 0.5;
      // Screen y runs down, world y runs up.
      let nx = -hx, ny = hy, nz = 1;
      const nl = Math.hypot(nx, ny, nz);
      nx /= nl; ny /= nl; nz /= nl;

      acc[0] = acc[1] = acc[2] = 0;
      env(nx, ny, nz, e);
      let dr = e[0] * 0.9, dg = e[1] * 0.9, db = e[2] * 0.9;
      for (let k = 0; k < LIGHTS.length; k++) {
        const L = LIGHTS[k];
        const nlm = nx * L.d[0] + ny * L.d[1] + nz * L.d[2];
        if (nlm <= 0) continue;
        dr += nlm * L.c[0]; dg += nlm * L.c[1]; db += nlm * L.c[2];
      }
      acc[0] = ALBEDO[0] * dr; acc[1] = ALBEDO[1] * dg; acc[2] = ALBEDO[2] * db;

      const F = schlick(0.05, nz);
      reflect(0, 0, -1, nx, ny, nz, rf);
      env(rf[0], rf[1], rf[2], e);
      acc[0] += F * e[0]; acc[1] += F * e[1]; acc[2] += F * e[2];
      directSpec(nx, ny, nz, 0, 0, 1, 90, [F * 7, F * 7, F * 7], acc);

      rgba[o] = toSRGB(1.9 * acc[0]);
      rgba[o + 1] = toSRGB(1.9 * acc[1]);
      rgba[o + 2] = toSRGB(1.9 * acc[2]);
      rgba[o + 3] = Math.round(Math.min(1, cov) * 255);
    }
  }
  return rgba;
}

function trim(rgba, w, h, pad) {
  let x0 = w, y0 = h, x1 = -1, y1 = -1;
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      if (rgba[(y * w + x) * 4 + 3] > 2) {
        if (x < x0) x0 = x; if (x > x1) x1 = x;
        if (y < y0) y0 = y; if (y > y1) y1 = y;
      }
    }
  }
  if (x1 < 0) return { data: rgba, w, h };
  x0 = Math.max(0, x0 - pad); y0 = Math.max(0, y0 - pad);
  x1 = Math.min(w - 1, x1 + pad); y1 = Math.min(h - 1, y1 + pad);
  const ow = x1 - x0 + 1, oh = y1 - y0 + 1;
  const out = new Uint8Array(ow * oh * 4);
  for (let y = 0; y < oh; y++) {
    out.set(rgba.subarray(((y + y0) * w + x0) * 4, ((y + y0) * w + x1 + 1) * 4), y * ow * 4);
  }
  return { data: out, w: ow, h: oh };
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setContent('<canvas id="c"></canvas>');
  fs.mkdirSync(OUT, { recursive: true });

  for (const [name, ch] of Object.entries(GLYPHS)) {
    const mask = await page.evaluate(({ size, glyph }) => {
      const cv = document.createElement('canvas');
      cv.width = cv.height = size;
      const c = cv.getContext('2d');
      c.clearRect(0, 0, size, size);
      c.fillStyle = '#fff';
      c.textAlign = 'center';
      c.textBaseline = 'middle';
      c.font = `800 ${Math.round(size * 0.66)}px "DejaVu Sans", system-ui, sans-serif`;
      c.fillText(glyph, size / 2, size / 2);
      return Array.from(c.getImageData(0, 0, size, size).data).filter((_, i) => i % 4 === 3);
    }, { size: S, glyph: ch });

    const m = new Float32Array(S * S);
    for (let i = 0; i < S * S; i++) m[i] = mask[i] / 255;
    const cut = trim(shadeGlyph(m, S, S), S, S, 3);
    const file = path.join(OUT, name + '_hd.png');
    fs.writeFileSync(file, png.encode(cut.data, cut.w, cut.h));
    console.log(`${name}_hd.png  ${cut.w}x${cut.h}  ${(fs.statSync(file).size / 1024).toFixed(1)} KB`);
  }
  await browser.close();
})();
