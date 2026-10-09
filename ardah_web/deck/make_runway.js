/* Trace the runway deck: dark glass with a gold Najdi lattice down both edges.

   WHY THIS IS NOT A PERSPECTIVE IMAGE
   The obvious thing is to render the runway the way it appears on screen. That
   bakes in one layout: js/render.js derives vpY, C and halfNear from the
   window, so the trapezoid is a different shape on every device.

   So this renders the deck in *runway space* instead -- across the deck by
   world x, along it by depth z -- while shading each texel from the view ray
   the game's camera would actually have to that world point. The texture is
   therefore layout independent, but the glass still has correct grazing-angle
   reflection, which is the whole character of the material and the one thing a
   flat top-down bake would lose.

   Rows are spaced uniformly in 1/z, which is uniform in screen y, so mapping it
   back on screen is a straight row-for-row blit with no vertical resampling:

       z   = C / (y - vpY)                 // invert yAt
       row = (1/z - 1/Z_FAR) / (1/Z_LIP - 1/Z_FAR)
       draw that row across 2 * halfAt(z) * (1 + 2 * BAND), centred

   Geometry matches js/render.js: the deck is world x in [-1, 1] (because
   halfAt(z) = halfNear / z, so the field is one unit wide at any depth), the
   lane dividers sit at x = +/- 1/3, and Z_LIP / Z_FAR bound the depth.

   Run: node deck/make_runway.js [--w 1280] [--h 900] [--ss 3]  */

'use strict';

const fs = require('fs');
const path = require('path');
const { env, schlick, reflect, directSpec, toSRGB, LIGHTS } = require('./lib/shade');
const png = require('./lib/png');

const OUT = path.join(__dirname, '..', 'assets', 'hd');
const argv = process.argv.slice(2);
const arg = (k, d) => { const i = argv.indexOf(k); return i < 0 ? d : Number(argv[i + 1]); };
/* 1280x900, which is what ships, because export_assets.py exports the deck at
   a longest side of 1280: a smaller master is upscaled on the way out and the
   lozenge lattice goes soft. The default used to be 1024x768 and the shipped
   master was made by passing --w 1280 --h 900 by hand, which was recorded
   nowhere -- so a fresh clone that ran the documented command got a blurrier
   runway than the one in the repository and no way to know why. */
const TW = arg('--w', 1280);
const TH = arg('--h', 900);
const SS = arg('--ss', 3);

const Z_LIP = 0.86, Z_FAR = 5.0;          // from js/render.js
const CAM_H = 2.10;                        // C / halfNear on a 440x956 phone
const BAND = 0.200;                        // ornament band width, world units
const X_MAX = 1 + BAND;
const EXPOSURE = 1.15;

/* ------------------------------- the surface ------------------------------ */

function sstep(e0, e1, x) {
  const t = Math.max(0, Math.min(1, (x - e0) / (e1 - e0)));
  return t * t * (3 - 2 * t);
}

/* A raised bar: 1 at the centre line, falling to 0 over `w`. */
function bar(d, w) { return 1 - sstep(w * 0.45, w, Math.abs(d)); }

/* Height of the inlay at a world point, in world units. Everything gold on
   this deck stands slightly proud of the glass, which is what gives the bevel
   its own highlight instead of looking like a painted line. */
function inlay(x, z) {
  const ax = Math.abs(x);
  let h = 0;

  // Lane dividers: thin, inside the deck.
  h = Math.max(h, 0.85 * bar(ax - 1 / 3, 0.016));

  if (ax > 1 - 0.004 && ax < X_MAX + 0.004) {
    const s = (ax - 1) / BAND;                    // 0 inner edge, 1 outer edge
    h = Math.max(h, 1.00 * bar(s - 0.050, 0.090));  // inner rail
    h = Math.max(h, 1.00 * bar(s - 0.950, 0.070));  // outer rail

    // Najdi lattice between the rails: a chain of lozenges, each with a
    // smaller one inside, repeating along the deck.
    //
    // The period is set against how the deck is SEEN, not how wide the band
    // is in world units. dy/dz = -C/z^2, so at the judgment line one world
    // unit of depth is ~425 px while the band is only ~40 px across: a period
    // picked to look square in world space comes out four times too long on
    // screen. 0.075 puts a lozenge at roughly 32 px tall where the player is
    // looking.
    const u = (s - 0.145) / 0.74;                 // across the lattice field
    if (u > -0.08 && u < 1.08) {
      const P = 0.075;                            // period in world depth
      let t = (z / P) % 1; if (t < 0) t += 1;
      const du = Math.abs(u - 0.5), dt = Math.abs(t - 0.5);
      const outer = du / 0.50 + dt / 0.50;
      const inner = du / 0.23 + dt / 0.23;
      h = Math.max(h, 0.85 * bar(outer - 1, 0.24));
      h = Math.max(h, 0.75 * bar(inner - 1, 0.40));
    }
  }
  return h * 0.020;                               // world height of the inlay
}

/* --------------------------------- shading -------------------------------- */

/* The deck sees a part of the scene the note objects do not.

   shade.js puts its sources on the camera's side, which is right for a small
   object near the judgment line but wrong for a mirror lying down the runway:
   reflected off a floor those directions go away from the light and the deck
   comes back dead black. What a floor pointing at the stage actually reflects
   is the stage -- the fires and the lit fort at the far end, just above the
   horizon -- which is exactly the warm glow along the deck in the concept
   image. So the deck samples the shared environment plus that. */
const STAGE = (() => { const l = Math.hypot(0, 0.17, -1); return [0, 0.17 / l, -1 / l]; })();

function envDeck(dx, dy, dz, out) {
  env(dx, dy, dz, out);
  const d = dx * STAGE[0] + dy * STAGE[1] + dz * STAGE[2];
  if (d > 0) {
    const d2 = d * d, d4 = d2 * d2;
    const s = d4 * d4 * 1.45 + d4 * 0.30;
    out[0] += s * 1.00; out[1] += s * 0.46; out[2] += s * 0.15;
  }
}

const GOLD = [0.96, 0.520, 0.140];
const GLASS_BODY = [0.011, 0.015, 0.026];         // near-black, faintly cool

const e = [0, 0, 0], rf = [0, 0, 0], tmp = [0, 0, 0];

function shade(x, z, acc) {
  // Surface normal from the inlay height field.
  const d = 0.0016;
  const h0 = inlay(x, z);
  const nx = -(inlay(x + d, z) - h0) / d;
  const nz = -(inlay(x, z + d) - h0) / d;
  const nl = Math.hypot(nx, 1, nz);
  const Nx = nx / nl, Ny = 1 / nl, Nz = nz / nl;

  // The view ray the game's camera would have to this point. The camera looks
  // along -Z from height CAM_H, so depth z sits at world -z.
  let vx = -x, vy = CAM_H - h0, vz = z;
  const vl = Math.hypot(vx, vy, vz);
  vx /= vl; vy /= vl; vz /= vl;                   // points at the camera
  const nv = Math.max(0, Nx * vx + Ny * vy + Nz * vz);

  reflect(-vx, -vy, -vz, Nx, Ny, Nz, rf);
  envDeck(rf[0], rf[1], rf[2], e);

  const gold = h0 > 0.0055;
  if (gold) {
    envDeck(Nx, Ny, Nz, tmp);
    const q = 0.30;                               // roughness
    acc[0] = GOLD[0] * (e[0] * (1 - q) + tmp[0] * q);
    acc[1] = GOLD[1] * (e[1] * (1 - q) + tmp[1] * q);
    acc[2] = GOLD[2] * (e[2] * (1 - q) + tmp[2] * q);
    directSpec(Nx, Ny, Nz, vx, vy, vz, 190, GOLD, acc);
  } else {
    // Dark glass. Almost all of its character is Fresnel: face on it is a
    // near-black slab, and down the deck, where the view grazes it, it turns
    // into a mirror. That is why this had to be shaded from the real camera.
    const F = schlick(0.052, nv);
    acc[0] = F * e[0] + GLASS_BODY[0];
    acc[1] = F * e[1] + GLASS_BODY[1];
    acc[2] = F * e[2] + GLASS_BODY[2];
    directSpec(Nx, Ny, Nz, vx, vy, vz, 900, [F * 2.2, F * 2.2, F * 2.2], acc);

    // Light spilling off the gold onto the glass beside it. The rails are the
    // brightest thing on the deck and a floor next to them would not stay
    // black; without this the inlay reads as a decal laid on the surface.
    const ax = Math.abs(x);
    const near = Math.max(0.55 * sstep(0.030, 0.0, Math.abs(ax - 1 / 3)),
                          sstep(0.055, 0.0, Math.abs(ax - 1)));
    acc[0] += near * 0.085; acc[1] += near * 0.038; acc[2] += near * 0.010;
  }
}

/* ----------------------------------- go ----------------------------------- */

const invFar = 1 / Z_FAR, invLip = 1 / Z_LIP;
const rgba = new Uint8Array(TW * TH * 4);
const acc = [0, 0, 0];
const t0 = Date.now();

for (let j = 0; j < TH; j++) {
  for (let i = 0; i < TW; i++) {
    let r = 0, g = 0, b = 0;
    for (let sj = 0; sj < SS; sj++) {
      // Uniform in 1/z, which is uniform in screen y.
      const v = (j + (sj + 0.5) / SS) / TH;
      const z = 1 / (invFar + v * (invLip - invFar));
      for (let si = 0; si < SS; si++) {
        const x = ((i + (si + 0.5) / SS) / TW * 2 - 1) * X_MAX;
        shade(x, z, acc);
        r += acc[0]; g += acc[1]; b += acc[2];
      }
    }
    const n = SS * SS, o = (j * TW + i) * 4;
    rgba[o] = toSRGB(EXPOSURE * r / n);
    rgba[o + 1] = toSRGB(EXPOSURE * g / n);
    rgba[o + 2] = toSRGB(EXPOSURE * b / n);
    rgba[o + 3] = 255;
  }
}

fs.mkdirSync(OUT, { recursive: true });
const file = path.join(OUT, 'runway_hd.png');
fs.writeFileSync(file, png.encode(rgba, TW, TH));
console.log(`runway_hd.png  ${TW}x${TH}  ${(fs.statSync(file).size / 1024).toFixed(1)} KB` +
            `  ${((Date.now() - t0) / 1000).toFixed(1)}s`);
