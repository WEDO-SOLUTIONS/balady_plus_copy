/* Environment, materials and the tone map.

   The environment is the whole reason these read as renders rather than
   drawings: it is the same stage the game paints -- a cool moon high and to
   the left, braziers low and in front, a warm floor and a night sky -- and
   every reflection and refraction samples it. A facet is bright because it
   happens to point at the moon, not because a highlight was placed there.

   All of this runs in linear light. The sRGB transfer is applied once, at the
   very end, after the ACES curve. */

'use strict';

const MOON = (() => { const l = Math.hypot(-0.52, 0.80, 0.30); return [-0.52 / l, 0.80 / l, 0.30 / l]; })();
const FIRE = (() => { const l = Math.hypot(0.18, -0.72, 0.67); return [0.18 / l, -0.72 / l, 0.67 / l]; })();
const RIM  = (() => { const l = Math.hypot(0.75, 0.10, -0.65); return [0.75 / l, 0.10 / l, -0.65 / l]; })();

const LIGHTS = [
  { d: MOON, c: [0.62, 0.65, 0.74] },     // moon, faintly cool
  { d: FIRE, c: [1.30, 0.52, 0.14] },     // braziers, strongly warm
  { d: RIM,  c: [0.52, 0.23, 0.08] },     // a second brazier behind and right
];

/* Radiance arriving from a direction. Kept smooth and cheap: it is sampled
   several times per pixel. */
function env(dx, dy, dz, out) {
  const up = dy * 0.5 + 0.5;
  const dn = 1 - up;
  // night sky above, firelit sandstone floor below
  // Kept deliberately dark. A metal is only as contrasty as its surroundings,
  // and a night stage is mostly darkness with a few hot sources -- fill the
  // whole sphere with light and gold renders as one flat lemon tone.
  let r = 0.020 + 0.028 * up + 0.150 * dn * dn * dn;
  let g = 0.022 + 0.038 * up + 0.052 * dn * dn * dn;
  let b = 0.038 + 0.090 * up + 0.013 * dn * dn * dn;

  const md = dx * MOON[0] + dy * MOON[1] + dz * MOON[2];
  if (md > 0) {
    const m2 = md * md, m4 = m2 * m2, m8 = m4 * m4;
    const disc = m8 * m8 * 5.4;                // md^32, the moon itself
    const halo = m4 * 0.62;                    // md^4, the haze around it
    r += disc * 1.00 + halo * 0.50;
    g += disc * 1.00 + halo * 0.57;
    b += disc * 0.96 + halo * 0.78;
  }
  for (let i = 1; i < LIGHTS.length; i++) {
    const L = LIGHTS[i];
    const d = dx * L.d[0] + dy * L.d[1] + dz * L.d[2];
    if (d > 0) {
      const d2 = d * d, d4 = d2 * d2, d8 = d4 * d4;
      const s = d8 * 3.1 + d2 * 1.15;          // a soft, big flame source
      r += s * L.c[0] * 0.55;
      g += s * L.c[1] * 0.55;
      b += s * L.c[2] * 0.55;
    }
  }
  out[0] = r; out[1] = g; out[2] = b;
}

function schlick(f0, cosT) {
  const m = 1 - cosT, m2 = m * m;
  return f0 + (1 - f0) * m2 * m2 * m;
}

function reflect(dx, dy, dz, nx, ny, nz, out) {
  const d = 2 * (dx * nx + dy * ny + dz * nz);
  out[0] = dx - d * nx; out[1] = dy - d * ny; out[2] = dz - d * nz;
}

/* Returns false on total internal reflection. */
function refract(dx, dy, dz, nx, ny, nz, eta, out) {
  const ci = -(dx * nx + dy * ny + dz * nz);
  const k = 1 - eta * eta * (1 - ci * ci);
  if (k < 0) return false;
  const f = eta * ci - Math.sqrt(k);
  out[0] = eta * dx + f * nx; out[1] = eta * dy + f * ny; out[2] = eta * dz + f * nz;
  return true;
}

/* Direct specular from the three sources, as sharp lobes on a facet. */
function directSpec(nx, ny, nz, vx, vy, vz, power, tint, out) {
  let r = 0, g = 0, b = 0;
  for (let i = 0; i < LIGHTS.length; i++) {
    const L = LIGHTS[i];
    let hx = L.d[0] + vx, hy = L.d[1] + vy, hz = L.d[2] + vz;
    const hl = Math.hypot(hx, hy, hz) || 1;
    hx /= hl; hy /= hl; hz /= hl;
    let nh = nx * hx + ny * hy + nz * hz;
    if (nh <= 0) continue;
    const s = Math.pow(nh, power);
    r += s * L.c[0]; g += s * L.c[1]; b += s * L.c[2];
  }
  out[0] += r * tint[0]; out[1] += g * tint[1]; out[2] += b * tint[2];
}

/* ACES filmic curve, then sRGB. Applying a real tone map is a large part of
   why a traced image stops looking like flat vector fills: the speculars roll
   off into white instead of clipping into a hard disc. */
function aces(x) {
  return (x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14);
}

function toSRGB(v) {
  let c = aces(Math.max(0, v));
  c = c <= 0.0031308 ? c * 12.92 : 1.055 * Math.pow(c, 1 / 2.4) - 0.055;
  return Math.max(0, Math.min(255, Math.round(c * 255)));
}

module.exports = { LIGHTS, MOON, env, schlick, reflect, refract, directSpec, toSRGB };
