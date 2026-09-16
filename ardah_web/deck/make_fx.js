/* Hit effects, rendered as light rather than as surfaces.

   The ray tracer next door is the wrong tool for most of these. A spark is not
   an object with a normal -- it is a small emitter seen through nothing, and
   what makes it read is the shape of its falloff and the way its colour shifts
   from white-hot in the middle to deep ember at the edge. So these are
   radiance fields, integrated per pixel and pushed through the same linear
   pipeline and the same ACES curve as everything else, which is what keeps
   them in the game's atmosphere instead of looking like stock glows.

   (The one effect here that IS geometry -- the gold shards thrown off a
   perfect hit -- lives in deck/lib/scene.js and is traced with the notes.)

   STORAGE. These are drawn with globalCompositeOperation = 'lighter', where
   canvas adds source RGB scaled by source alpha. So intensity goes in the
   alpha channel and the colour channels carry chroma normalised to its
   brightest component: the core comes out white because all three channels
   saturate together there, the rim stays orange, and the game gets to scale
   the whole thing by one globalAlpha over the effect's life.

   Run: node deck/make_fx.js [--ss 3]  */

'use strict';

const fs = require('fs');
const path = require('path');
const { toSRGB } = require('./lib/shade');
const png = require('./lib/png');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const argv = process.argv.slice(2);
const arg = (k, d) => { const i = argv.indexOf(k); return i < 0 ? d : Number(argv[i + 1]); };
const SS = arg('--ss', 3);

/* Ember colours, from the core outwards: the same ramp the braziers use. */
const CORE = [1.00, 0.96, 0.88];
const MID  = [1.00, 0.62, 0.20];
const EDGE = [1.00, 0.24, 0.04];

function ramp(t, out) {
  // t = 0 at the faint edge, 1 at the hot core.
  if (t < 0.5) {
    const k = t * 2;
    for (let i = 0; i < 3; i++) out[i] = EDGE[i] + (MID[i] - EDGE[i]) * k;
  } else {
    const k = (t - 0.5) * 2;
    for (let i = 0; i < 3; i++) out[i] = MID[i] + (CORE[i] - MID[i]) * k;
  }
}

/* An ember: a hot core with a wide, slowly decaying halo. The halo is the
   part that matters -- a gaussian alone dies too fast and reads as a dot. */
function spark(x, y, S) {
  const r = Math.hypot(x - S / 2, y - S / 2) / (S / 2);
  const core = 2.6 * Math.exp(-(r / 0.13) * (r / 0.13));
  const halo = 0.85 / Math.pow(1 + (r / 0.17) * (r / 0.17), 1.6);
  return core + halo;
}

/* A hit flare: core, halo, a long horizontal streak and a four-point star.
   The horizontal streak is what makes a flash read as impact rather than as a
   light bulb, because it echoes the judgment line the hit happened on. */
function flare(x, y, S) {
  const dx = (x - S / 2) / (S / 2), dy = (y - S / 2) / (S / 2);
  const r = Math.hypot(dx, dy);
  let i = 3.2 * Math.exp(-(r / 0.055) * (r / 0.055));        // core
  i += 0.55 / Math.pow(1 + (r / 0.13) * (r / 0.13), 1.5);    // halo

  // Streaks: a gaussian across the bar, decaying along it.
  const streak = (a, b, len, w, amp) => {
    const along = Math.abs(a), across = Math.abs(b);
    if (along > len) return 0;
    const fall = 1 - along / len;
    const q = across / (w * (0.25 + fall));
    return amp * fall * fall * Math.exp(-(q * q));
  };
  i += streak(dx, dy, 0.98, 0.030, 1.35);                    // horizontal
  i += streak(dy, dx, 0.62, 0.022, 0.75);                    // vertical
  const s = Math.SQRT1_2;
  i += streak((dx + dy) * s, (dx - dy) * s, 0.42, 0.016, 0.34);
  i += streak((dx - dy) * s, (dx + dy) * s, 0.42, 0.016, 0.34);
  return i;
}

/* A shockwave ring, drawn in screen space on purpose.

   A ring lying on the deck is the tempting version, but the geometry says no:
   at the judgment line the camera is 64 degrees above the floor and a ring of
   any useful radius spans a large slice of depth, so its near edge projects
   far larger than its far edge. The result is not an ellipse but an egg, and
   it reads as a mistake rather than as a shockwave. */
function ring(x, y, S) {
  const dx = (x - S / 2) / (S / 2), dy = (y - S / 2) / (S / 2);
  const r = Math.hypot(dx, dy);
  const wide = (r - 0.78) / 0.085, tight = (r - 0.78) / 0.020;
  const band = Math.exp(-(wide * wide)) * 1.9;
  const edge = Math.exp(-(tight * tight)) * 1.5;             // bright leading edge
  const fill = 0.10 * Math.max(0, 1 - r / 0.80);             // faint interior
  return band + edge + fill;
}

/* A soft lane glow, for the flash under a lane and behind the judgment line. */
function glow(x, y, S) {
  const dx = (x - S / 2) / (S / 2), dy = (y - S / 2) / (S / 2);
  const r = Math.hypot(dx, dy);
  return 1.35 / Math.pow(1 + (r / 0.26) * (r / 0.26), 1.35);
}

/* Every field has to reach zero before the frame does, or the sprite ends on a
   straight edge and the effect reads as a lit rectangle. The lane glow is a
   Lorentzian and still carries 3% of its peak at the border, which is plainly
   visible once it is added to a dark deck. */
function window(x, y, S) {
  const dx = (x - S / 2) / (S / 2), dy = (y - S / 2) / (S / 2);
  const r = Math.hypot(dx, dy);
  const t = Math.max(0, Math.min(1, (1.0 - r) / 0.28));
  return t * t * (3 - 2 * t);
}

function render(fn, S, gain) {
  const rgba = new Uint8Array(S * S * 4);
  const col = [0, 0, 0];
  for (let py = 0; py < S; py++) {
    for (let px = 0; px < S; px++) {
      let acc = 0, ar = 0, ag = 0, ab = 0;
      for (let sy = 0; sy < SS; sy++) {
        for (let sx = 0; sx < SS; sx++) {
          const qx = px + (sx + 0.5) / SS, qy = py + (sy + 0.5) / SS;
          const i = fn(qx, qy, S) * gain * window(qx, qy, S);
          ramp(Math.max(0, Math.min(1, i / 1.5)), col);
          acc += i; ar += col[0] * i; ag += col[1] * i; ab += col[2] * i;
        }
      }
      const n = SS * SS;
      const I = acc / n;
      const o = (py * S + px) * 4;
      if (I <= 0.0015) { rgba[o] = rgba[o + 1] = rgba[o + 2] = rgba[o + 3] = 0; continue; }
      // Chroma normalised to its brightest component; intensity goes to alpha.
      let r = ar / acc, g = ag / acc, b = ab / acc;
      const m = Math.max(r, g, b) || 1;
      rgba[o] = toSRGB(r / m); rgba[o + 1] = toSRGB(g / m); rgba[o + 2] = toSRGB(b / m);
      rgba[o + 3] = toSRGB(I);
    }
  }
  return rgba;
}

const JOBS = [
  { name: 'fx_spark', fn: spark, size: 128, gain: 1.0 },
  { name: 'fx_flare', fn: flare, size: 384, gain: 1.0 },
  { name: 'fx_ring',  fn: ring,  size: 320, gain: 1.0 },
  { name: 'fx_glow',  fn: glow,  size: 256, gain: 1.0 },
];

fs.mkdirSync(OUT, { recursive: true });
for (const j of JOBS) {
  const t0 = Date.now();
  const rgba = render(j.fn, j.size, j.gain);
  const file = path.join(OUT, j.name + '_hd.png');
  fs.writeFileSync(file, png.encode(rgba, j.size, j.size));
  console.log(`${j.name}_hd.png  ${j.size}x${j.size}  ` +
              `${(fs.statSync(file).size / 1024).toFixed(1)} KB  ` +
              `${((Date.now() - t0) / 1000).toFixed(1)}s`);
}
