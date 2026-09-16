/* Trace the three note objects to 512 px masters.

   The sprites in assets/ are cut from the concept image, where the coin is 72
   pixels across. The game draws it at ~115 pt near the judgment line, which on
   a 3x screen is ~345 device pixels -- a five-fold upscale of a lossy crop. No
   filtering puts that detail back; the only way up is to produce the object at
   the size it is actually used.

   Earlier passes painted them with canvas gradients, which is why they read as
   illustrations: every highlight sat where a hand put it. These are ray traced
   instead. The shapes are real convex polyhedra, so facet edges are exact and
   facet normals come from the geometry; the crystal and the gem are dielectrics
   with Fresnel, refraction and Beer-Lambert absorption, so their colour is the
   light that survived the path through them; the coin is a metal reflecting a
   procedural version of the stage. The whole frame is accumulated in linear
   HDR, bloomed there, and tone mapped once at the end.

   Run: node deck/make_notes.js [--size 512] [--ss 3]  */

'use strict';

const fs = require('fs');
const path = require('path');
const { hitConvex, rot, apply, sdStar } = require('./lib/trace');
const { env, schlick, reflect, refract, directSpec, toSRGB } = require('./lib/shade');
const scene = require('./lib/scene');
const png = require('./lib/png');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const argv = process.argv.slice(2);
const arg = (k, d) => { const i = argv.indexOf(k); return i < 0 ? d : Number(argv[i + 1]); };
const SIZE = arg('--size', 512);
const SS = arg('--ss', 3);
const FOV = 16 * Math.PI / 180;
const MAX_BOUNCE = 6;
const EXPOSURE = arg('--exposure', 1.15);
const BLOOM_CUT = 1.30;   // linear radiance a pixel must exceed to bleed
const BLOOM_MIX = 0.30;
const GLOW_GAIN = 0.55;

/* --------------------------- surface perturbation -------------------------- */

/* The coin's relief, as a height field on the face. An eight-point rosette:
   deliberately NOT the crossed sabres under a palm an earlier pass struck
   here, which is the arrangement of the Saudi state emblem and is ruled out
   as decoration by docs/ardah-art-brief.md. */
function relief(x, z) {
  const r = Math.hypot(x, z);
  // A struck coin is slightly domed. Without it the face is perfectly flat,
  // every pixel reflects the same direction of a distant environment, and the
  // gold comes out as one even tone -- the giveaway of a render that has not
  // been thought about.
  let h = 0.052 * (1 - Math.min(1, (r / 0.455) * (r / 0.455)));
  const sd = sdStar(x, z, 0.245, 8, 3.0);
  h -= 0.034 * smooth(0.012, -0.005, sd);          // the star, cut in
  if (r < 0.080) h += 0.018 * smooth(0.080, 0.056, r);   // raised centre boss
  h -= 0.013 * Math.exp(-Math.pow((r - 0.368) / 0.015, 2));  // rim groove
  return h;
}

function smooth(e0, e1, x) {
  const t = Math.max(0, Math.min(1, (x - e0) / (e1 - e0)));
  return t * t * (3 - 2 * t);
}

/* Replace a facet normal where the geometry is a stand-in for something
   smoother or finer than the polygon count. */
function perturb(kind, px, py, pz, nx, ny, nz, out) {
  if (kind === 1) {
    // A 128-gon side is really a cylinder; recover the true normal, then cut
    // the milling into it as a tangential ripple.
    const r = Math.hypot(px, pz) || 1;
    let ex = px / r, ez = pz / r;
    const th = Math.atan2(pz, px);
    const ripple = 0.30 * Math.cos(th * 72);
    let tx = -ez, tz = ex;
    out[0] = ex + tx * ripple; out[1] = 0; out[2] = ez + tz * ripple;
  } else if (kind === 2) {
    const e = 0.0016;
    const h0 = relief(px, pz);
    const hx = (relief(px + e, pz) - h0) / e;
    const hz = (relief(px, pz + e) - h0) / e;
    const s = ny >= 0 ? 1 : -1;
    out[0] = -hx; out[1] = s; out[2] = -hz;
  } else {
    out[0] = nx; out[1] = ny; out[2] = nz;
    return;
  }
  const l = Math.hypot(out[0], out[1], out[2]) || 1;
  out[0] /= l; out[1] /= l; out[2] /= l;
}

/* --------------------------------- tracer --------------------------------- */

function render(obj) {
  const W = SIZE * SS;
  const hdr = new Float32Array(W * W * 4);          // premultiplied linear RGB + A
  const R = rot(obj.rot.rx, obj.rot.ry, obj.rot.rz);
  const dist = obj.radius / Math.tan(FOV / 2) * 1.30;

  // Rays are built in world space, then rotated into the object's frame; the
  // object sits at the origin, so that is a rotation and nothing more.
  const hit = { tN: 0, tF: 0, nx: 0, ny: 0, nz: 0, nk: 0, fx: 0, fy: 0, fz: 0, fk: 0 };
  const sub = { tN: 0, tF: 0, nx: 0, ny: 0, nz: 0, nk: 0, fx: 0, fy: 0, fz: 0, fk: 0 };
  const inner = { tN: 0, tF: 0, nx: 0, ny: 0, nz: 0, nk: 0, fx: 0, fy: 0, fz: 0, fk: 0 };
  const v3 = [0, 0, 0], w3 = [0, 0, 0], e3 = [0, 0, 0], acc = [0, 0, 0];
  const tan = Math.tan(FOV / 2);

  // Camera basis in object space: the eye is on +Z looking at the origin.
  const ro = [0, 0, 0];
  apply(R.t, 0, 0, dist, ro);

  for (let py = 0; py < W; py++) {
    const sy = (1 - 2 * (py + 0.5) / W) * tan;
    for (let px = 0; px < W; px++) {
      const sx = (2 * (px + 0.5) / W - 1) * tan;
      let dx = sx, dy = sy, dz = -1;
      const dl = Math.hypot(dx, dy, dz);
      dx /= dl; dy /= dl; dz /= dl;
      apply(R.t, dx, dy, dz, v3);

      acc[0] = acc[1] = acc[2] = 0;
      const a = shadeRay(obj, ro[0], ro[1], ro[2], v3[0], v3[1], v3[2],
                         R, hit, sub, inner, w3, e3, acc);
      if (a > 0) {
        const o = (py * W + px) * 4;
        hdr[o] = acc[0]; hdr[o + 1] = acc[1]; hdr[o + 2] = acc[2]; hdr[o + 3] = a;
      }
    }
  }
  return { hdr, W };
}

/* Returns coverage (0 or 1) and writes linear radiance into acc. */
function shadeRay(obj, ox, oy, oz, dx, dy, dz, R, hit, sub, inner, w3, e3, acc) {
  let best = 1e30, bp = null, bnx = 0, bny = 0, bnz = 0, bk = 0;
  for (let i = 0; i < obj.parts.length; i++) {
    const part = obj.parts[i];
    if (!hitConvex(part.planes, ox, oy, oz, dx, dy, dz, hit)) continue;
    let t = hit.tN, nx = hit.nx, ny = hit.ny, nz = hit.nz, k = hit.nk;
    if (part.sub && hitConvex(part.sub, ox, oy, oz, dx, dy, dz, sub)) {
      // CSG difference: if the entry point is inside the subtracted solid, the
      // visible surface is where the ray leaves it -- with the normal flipped.
      if (sub.tN <= t && sub.tF > t) {
        t = sub.tF;
        if (t > hit.tF) continue;                  // the part is cut away here
        nx = -sub.fx; ny = -sub.fy; nz = -sub.fz; k = sub.fk;
      }
    }
    if (t > 1e-4 && t < best) { best = t; bp = part; bnx = nx; bny = ny; bnz = nz; bk = k; }
  }
  if (!bp) return 0;

  const hx = ox + dx * best, hy = oy + dy * best, hz = oz + dz * best;
  perturb(bk, hx, hy, hz, bnx, bny, bnz, w3);
  const nx = w3[0], ny = w3[1], nz = w3[2];

  if (bp.mat.type === 'metal') shadeMetal(bp.mat, nx, ny, nz, dx, dy, dz, R, e3, acc);
  else shadeGlass(bp, hx, hy, hz, nx, ny, nz, dx, dy, dz, R, hit, inner, w3, e3, acc);
  return 1;
}

/* Sample the environment for an object-space direction. */
function envWorld(R, x, y, z, tmp, out) {
  apply(R.m, x, y, z, tmp);
  env(tmp[0], tmp[1], tmp[2], out);
}

function shadeMetal(mat, nx, ny, nz, dx, dy, dz, R, tmp, acc) {
  const rf = [0, 0, 0], e = [0, 0, 0];
  reflect(dx, dy, dz, nx, ny, nz, rf);
  envWorld(R, rf[0], rf[1], rf[2], tmp, e);
  // A cheap stand-in for roughness: blend the mirror direction's radiance with
  // the normal's, which is the low-frequency part of the same environment.
  const eN = [0, 0, 0];
  envWorld(R, nx, ny, nz, tmp, eN);
  const q = mat.rough;
  const f0 = mat.f0;
  acc[0] += f0[0] * (e[0] * (1 - q) + eN[0] * q);
  acc[1] += f0[1] * (e[1] * (1 - q) + eN[1] * q);
  acc[2] += f0[2] * (e[2] * (1 - q) + eN[2] * q);

  // Direct lobes, in world space so the moon lands where the moon is.
  apply(R.m, nx, ny, nz, tmp);
  const wn = [tmp[0], tmp[1], tmp[2]];
  apply(R.m, -dx, -dy, -dz, tmp);
  directSpec(wn[0], wn[1], wn[2], tmp[0], tmp[1], tmp[2], mat.spec, f0, acc);
}

function shadeGlass(part, hx, hy, hz, nx, ny, nz, dx, dy, dz, R, hit, inner, tmp, e3, acc) {
  const mat = part.mat;
  const cosI = -(dx * nx + dy * ny + dz * nz);
  const f0 = Math.pow((mat.ior - 1) / (mat.ior + 1), 2);
  const F = schlick(f0, Math.max(0, cosI));

  // Reflected off the front facet
  const rf = [0, 0, 0], e = [0, 0, 0];
  reflect(dx, dy, dz, nx, ny, nz, rf);
  envWorld(R, rf[0], rf[1], rf[2], tmp, e);
  acc[0] += F * e[0]; acc[1] += F * e[1]; acc[2] += F * e[2];

  // Transmitted: walk the inside of the solid, absorbing as it goes, until it
  // refracts out or runs out of bounces. This is where a gem's colour and its
  // internal sparkle actually come from.
  const tr = [0, 0, 0];
  if (!refract(dx, dy, dz, nx, ny, nz, 1 / mat.ior, tr)) return;
  let px = hx, py = hy, pz = hz;
  let vx = tr[0], vy = tr[1], vz = tr[2];
  let ar = 1 - F, ag = 1 - F, ab = 1 - F;

  for (let b = 0; b < MAX_BOUNCE; b++) {
    if (!hitConvex(part.planes, px + vx * 1e-4, py + vy * 1e-4, pz + vz * 1e-4,
                   vx, vy, vz, inner)) break;
    const d = inner.tF + 1e-4;
    ar *= Math.exp(-mat.absorb[0] * d);
    ag *= Math.exp(-mat.absorb[1] * d);
    ab *= Math.exp(-mat.absorb[2] * d);
    px += vx * d; py += vy * d; pz += vz * d;
    let ex = inner.fx, ey = inner.fy, ez = inner.fz;
    if (inner.fk) { perturb(inner.fk, px, py, pz, ex, ey, ez, tmp); ex = tmp[0]; ey = tmp[1]; ez = tmp[2]; }

    // Facing normal for a ray on its way out: the stored plane normal points
    // out of the solid, which is the same way the ray is travelling, and
    // Fresnel needs the one it is travelling into.
    const gx = -ex, gy = -ey, gz = -ez;
    const out = [0, 0, 0];
    if (refract(vx, vy, vz, gx, gy, gz, mat.ior, out)) {
      const ci = Math.max(0, -(vx * gx + vy * gy + vz * gz));
      const Fo = schlick(f0, ci);
      envWorld(R, out[0], out[1], out[2], tmp, e3);
      acc[0] += ar * (1 - Fo) * e3[0];
      acc[1] += ag * (1 - Fo) * e3[1];
      acc[2] += ab * (1 - Fo) * e3[2];
      ar *= Fo; ag *= Fo; ab *= Fo;
    }
    // whatever did not leave is reflected back inside
    reflect(vx, vy, vz, ex, ey, ez, out);
    vx = out[0]; vy = out[1]; vz = out[2];
    if (ar + ag + ab < 0.004) break;
  }

  // A sharp direct highlight on the entry facet, which is what reads as polish.
  apply(R.m, nx, ny, nz, tmp);
  const wn = [tmp[0], tmp[1], tmp[2]];
  apply(R.m, -dx, -dy, -dz, tmp);
  directSpec(wn[0], wn[1], wn[2], tmp[0], tmp[1], tmp[2], mat.spec, [F * 3, F * 3, F * 3], acc);
}

/* ---------------------------- resolve and post ---------------------------- */

function downsample(hdr, W, size, ss) {
  const out = new Float32Array(size * size * 4);
  const n = ss * ss;
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      let r = 0, g = 0, b = 0, a = 0;
      for (let j = 0; j < ss; j++) {
        const row = (y * ss + j) * W;
        for (let i = 0; i < ss; i++) {
          const o = (row + x * ss + i) * 4;
          r += hdr[o]; g += hdr[o + 1]; b += hdr[o + 2]; a += hdr[o + 3];
        }
      }
      const o = (y * size + x) * 4;
      out[o] = r / n; out[o + 1] = g / n; out[o + 2] = b / n; out[o + 3] = a / n;
    }
  }
  return out;
}

/* Three box passes approximate a gaussian closely enough for glare. */
function blur(src, size, radius, stride, offset) {
  let cur = src;
  for (let pass = 0; pass < 3; pass++) {
    for (const horiz of [true, false]) {
      const dst = new Float32Array(cur.length);
      for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
          let s0 = 0, s1 = 0, s2 = 0, n = 0;
          for (let k = -radius; k <= radius; k++) {
            const xx = horiz ? x + k : x, yy = horiz ? y : y + k;
            if (xx < 0 || yy < 0 || xx >= size || yy >= size) continue;
            const o = (yy * size + xx) * stride + offset;
            s0 += cur[o]; s1 += cur[o + 1]; s2 += cur[o + 2]; n++;
          }
          const o = (y * size + x) * stride + offset;
          dst[o] = s0 / n; dst[o + 1] = s1 / n; dst[o + 2] = s2 / n;
          if (stride === 4) dst[o + 3 - offset] = cur[(y * size + x) * 4 + 3];
        }
      }
      cur = dst;
    }
  }
  return cur;
}

function resolve(img, size, glowTint) {
  // Exposure first: bloom has to be measured against the white point the tone
  // map will actually use, or every lit pixel qualifies and the sprite fogs.
  const lit = new Float32Array(img.length);
  for (let i = 0; i < size * size; i++) {
    const o = i * 4;
    lit[o] = img[o] * EXPOSURE;
    lit[o + 1] = img[o + 1] * EXPOSURE;
    lit[o + 2] = img[o + 2] * EXPOSURE;
    lit[o + 3] = img[o + 3];
  }

  // Only what is genuinely over the white point spreads.
  const bright = new Float32Array(size * size * 4);
  for (let i = 0; i < size * size; i++) {
    const o = i * 4;
    const l = 0.2126 * lit[o] + 0.7152 * lit[o + 1] + 0.0722 * lit[o + 2];
    const w = l > BLOOM_CUT ? (l - BLOOM_CUT) / l : 0;
    bright[o] = lit[o] * w; bright[o + 1] = lit[o + 1] * w; bright[o + 2] = lit[o + 2] * w;
  }
  const bloom = blur(bright, size, Math.round(size * 0.010), 4, 0);
  const glare = blur(bright, size, Math.round(size * 0.045), 4, 0);

  const rgba = new Uint8Array(size * size * 4);
  for (let i = 0; i < size * size; i++) {
    const o = i * 4;
    const a = Math.max(0, Math.min(1, lit[o + 3]));
    // Glare spills past the silhouette; that halo carries the lane colour and
    // is the only thing outside the object that is allowed to be opaque.
    const gl = (glare[o] + glare[o + 1] + glare[o + 2]) / 3;
    const ga = Math.min(1, gl * GLOW_GAIN) * (1 - a);
    const r = lit[o] + bloom[o] * BLOOM_MIX + gl * ga * glowTint[0];
    const g = lit[o + 1] + bloom[o + 1] * BLOOM_MIX + gl * ga * glowTint[1];
    const b = lit[o + 2] + bloom[o + 2] * BLOOM_MIX + gl * ga * glowTint[2];
    const oa = Math.min(1, a + ga);
    if (oa <= 0.002) { rgba[o] = rgba[o + 1] = rgba[o + 2] = rgba[o + 3] = 0; continue; }
    rgba[o] = toSRGB(r / oa);
    rgba[o + 1] = toSRGB(g / oa);
    rgba[o + 2] = toSRGB(b / oa);
    rgba[o + 3] = Math.round(oa * 255);
  }
  return rgba;
}

/* ----------------------------------- go ----------------------------------- */

fs.mkdirSync(OUT, { recursive: true });
const objects = [scene.crystal(), scene.gem(), scene.coin()];
for (const obj of objects) {
  const t0 = Date.now();
  const { hdr, W } = render(obj);
  const small = downsample(hdr, W, SIZE, SS);
  const rgba = resolve(small, SIZE, obj.glow);
  const file = path.join(OUT, `note_${obj.name}_hd.png`);
  fs.writeFileSync(file, png.encode(rgba, SIZE, SIZE));
  console.log(`note_${obj.name}_hd.png  ${(fs.statSync(file).size / 1024).toFixed(1)} KB` +
              `  ${((Date.now() - t0) / 1000).toFixed(1)}s`);
}
