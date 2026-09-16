/* The three note objects, as geometry rather than as drawings.

   Sizes are in object units; each object is auto-fitted to the frame by its
   bounding radius, so these numbers are about proportion, not scale.

   Colours still come from the measurements taken off the sprites cut from the
   concept image -- warm orange around H 26-33 deg, shadows to near-black,
   highlights clipping cream -- but they now enter as physical quantities: an
   absorption coefficient for the crystal and the gem, a reflectance for the
   gold. The lighting decides the rest. */

'use strict';

const { prism, roundRect, roundChamfer, cone, sdStar } = require('./trace');

const TAU = Math.PI * 2;

/* Every object lies on the runway rather than standing on it, and is seen
   from the elevation the game's camera actually has.

   From render.js on a 440x956 phone: C = judgeY - vpY = 425 and halfNear =
   202, and since C = f * cameraHeight while halfNear = f * fieldHalfWidth,
   the camera sits C / halfNear = 2.1 field-half-widths above the floor. That
   is atan(2.1 / 1) = 64 degrees down onto the judgment line and atan(2.1 / 5)
   = 23 degrees at the spawn point. One sprite has to serve the whole runway,
   so it is cut near the middle of that range, a little towards the judging
   end where the note is largest and actually being read. */
const TILT = 52 * Math.PI / 180;

/* ------------------------------ tabl: crystal ----------------------------- */
/* A six-sided crystal with a tall termination. The lane's object was a
   faceted block to begin with; as a crystal the same silhouette gets to
   refract, which is most of what sells a render. */
/* Colour variants.

   The concept image varies colour WITHIN a lane while keeping the shape
   constant -- gold ingots on the left, blue and green gems in the middle, gold
   and silver coins on the right -- so the lane stays identifiable by position
   and silhouette while the runway still has colour on it. These follow that.

   For the two dielectrics the colour is an absorption coefficient, not a
   pigment: it is what the stone takes OUT of the light crossing it, so the
   high numbers are the channels the stone rejects. Amber rejects blue, ruby
   rejects green and blue, emerald rejects red and blue. */
const CRYSTAL_TINT = {
  '':  { absorb: [0.24, 1.25, 4.60], glow: [1.00, 0.44, 0.10] },   // amber
  _b:  { absorb: [0.32, 3.30, 3.80], glow: [1.00, 0.22, 0.34] },   // ruby
  _c:  { absorb: [1.70, 3.50, 0.85], glow: [0.72, 0.30, 1.00] },   // amethyst
};
const GEM_TINT = {
  '':  { absorb: [7.60, 1.95, 0.40], glow: [0.22, 0.72, 1.00] },   // sapphire
  _b:  { absorb: [4.60, 0.85, 3.30], glow: [0.20, 1.00, 0.55] },   // emerald
  _c:  { absorb: [1.90, 4.40, 1.05], glow: [0.78, 0.34, 1.00] },   // amethyst
};
const COIN_TINT = {
  '':  { f0: [0.96, 0.520, 0.140], glow: [1.00, 0.60, 0.14] },     // gold
  _b:  { f0: [0.93, 0.945, 0.975], glow: [0.72, 0.82, 1.00] },     // silver
};

function crystal(v) {
  v = v || '';
  const t = CRYSTAL_TINT[v];
  const R = 0.300;
  const planes = [];
  for (let i = 0; i < 6; i++) {
    const a = (i / 6) * TAU + 0.26;
    planes.push([Math.cos(a), 0, Math.sin(a), R, 0]);
  }
  planes.push(...cone(6, R, 0.30, 1.05, 1, 0.26));      // termination
  planes.push(...cone(6, R, 0.26, 0.74, 1, 0.26 + Math.PI / 6));   // shoulder bevel
  planes.push(...cone(6, R, -0.42, -0.80, -1, 0.26));   // lower point
  planes.push(...cone(6, R, -0.38, -0.64, -1, 0.26 + Math.PI / 6)); // lower bevel
  return {
    name: 'tabl' + v,
    radius: 0.83,
    rot: { rx: TILT, ry: 0.20, rz: Math.PI / 2 },
    glow: t.glow,
    parts: [{
      planes,
      mat: {
        type: 'glass',
        ior: 1.56,
        // absorbs blue hard and green moderately: what comes through is amber
        absorb: t.absorb,
        spec: 900,
      },
    }],
  };
}

/* ----------------------------- swords: gem -------------------------------- */
/* A round brilliant in a plain gold collet. Facet counts are the real ones:
   16 crown facets to a table, a girdle band, 16 pavilion facets to a culet,
   with the pavilion rotated half a facet so the light that enters the crown
   leaves through a different face. */
function gem(v) {
  v = v || '';
  const gt = GEM_TINT[v];
  const R = 0.40, gy = 0.022, crownH = 0.155, Rt = R * 0.54;
  const k = crownH / (R - Rt);
  const planes = [];
  for (let i = 0; i < 16; i++) {
    const a = (i / 16) * TAU;
    planes.push([Math.cos(a), 0, Math.sin(a), R, 0]);   // girdle band
  }
  planes.push(...cone(16, R, gy, gy + k * R, 1, 0));     // crown
  planes.push([0, 1, 0, gy + crownH, 0]);               // table
  planes.push(...cone(16, R, -gy, -0.50, -1, Math.PI / 16));  // pavilion

  const OUT = 0.462, IN = 0.404, H = 0.052;
  return {
    name: 'swords' + v,
    radius: 0.54,
    rot: { rx: TILT, ry: 0.22, rz: 0 },
    glow: gt.glow,
    parts: [
      {
        planes: prism(64, OUT, H, -H, 0, 1, 0),
        sub: prism(64, IN, H * 3, -H * 3, 0, 1, 0),
        mat: { type: 'metal', f0: [0.96, 0.555, 0.175], rough: 0.34, spec: 230 },
      },
      {
        planes,
        mat: {
          type: 'glass',
          ior: 1.72,
          absorb: gt.absorb,
          spec: 1400,
        },
      },
    ],
  };
}

/* The coin's face. An eight-point rosette: deliberately NOT the crossed sabres
   under a palm an earlier pass struck here, which is the arrangement of the
   Saudi state emblem and is ruled out as decoration by docs/ardah-art-brief.md.
   A struck coin is also slightly domed -- without it the face is perfectly
   flat, every pixel reflects the same direction of a distant environment, and
   the gold comes out as one even tone. */
function coinRelief(x, z) {
  const r = Math.hypot(x, z);
  let h = 0.052 * (1 - Math.min(1, (r / 0.455) * (r / 0.455)));
  h -= 0.034 * smooth(0.012, -0.005, sdStar(x, z, 0.245, 8, 3.0));
  if (r < 0.080) h += 0.018 * smooth(0.080, 0.056, r);
  h -= 0.013 * Math.exp(-Math.pow((r - 0.368) / 0.015, 2));
  return h;
}

/* ------------------------------ tar: coin --------------------------------- */
/* A struck gold disc. The body is a 128-gon whose side normals are smoothed
   back to a true cylinder at shading time, so the rim turns rather than
   banding, and the milling and the relief are both normal perturbations --
   which is how a coin would be rendered for real. */
function coin(v) {
  v = v || '';
  const ct = COIN_TINT[v];
  return {
    name: 'tar' + v,
    radius: 0.65,
    rot: { rx: TILT, ry: 0.30, rz: 0 },
    glow: ct.glow,
    parts: [{
      planes: prism(128, 0.455, 0.072, -0.072, 0, 1, 2),
      bump: { h: coinRelief },
      mat: { type: 'metal', f0: ct.f0, rough: 0.26, spec: 260 },
    }],
  };
}

/* sRGB hex to linear, so albedos can be written the way the palette is. */
function lin(hex) {
  const v = [0, 2, 4].map((i) => parseInt(hex.substr(i + 1, 2), 16) / 255);
  return v.map((c) => (c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)));
}

function smooth(e0, e1, x) {
  const t = Math.max(0, Math.min(1, (x - e0) / (e1 - e0)));
  return t * t * (3 - 2 * t);
}

/* ------------------------------- keycaps ---------------------------------- */
/* The three strike pads at the foot of the lanes: a dark bronze plinth with a
   chamfered top, a recess milled into it, and the lane's own material set into
   the recess -- amber, sapphire, gold -- so a pad reads as belonging to its
   lane before any colour-blind player has to tell the glows apart.

   They carry NO letter. The cut keycaps have their letters baked in as pixels,
   which is the thing docs/ardah-art-brief.md §1 forbids: the strings localise
   into Arabic and the layout flips to RTL, and the caps also have to show a
   dot rather than a letter once the player is on touch. The glyph belongs to
   `_keycaps` in js/render.js, drawn over the sprite.

   Seen from a little steeper than the notes: the pads sit below the judgment
   line, so the camera is looking further down onto them. */
/* Each pad is rendered from the angle the game's camera really has to it, so
   the side pads come out turned the way they are in the concept image. That
   turn is geometry, not styling: with the camera 2.10 field-half-widths up and
   the keycap row at z = 0.856, the centre pad is seen at 67.8 degrees
   elevation straight on, and a side pad at 62.7 degrees and 37.9 degrees round
   to the side.

   Viewing an object from azimuth phi is the same as spinning it by -phi about
   its own vertical and viewing it head on, which is exactly what ry does here,
   so this needs no off-axis camera.

   The elevations below are those real numbers. The azimuth is NOT: at the true
   37.9 degrees a pad reads as a diamond rather than as a key, and the concept
   image turns them far less than the geometry would. This follows the concept
   at 13 degrees, which keeps the pads facing the player while still fanning
   them out with the lanes. It is the one place here where the drawing wins
   over the arithmetic, on purpose. */
const CAP_VIEW = {
  tabl:   { elev: 62.7, azim: -13 },
  swords: { elev: 67.8, azim: 0 },
  tar:    { elev: 62.7, azim: 13 },
};
const DEG = Math.PI / 180;

/* Lane colours for the pads come from KEYCAP in js/render.js -- copper, steel
   blue, green -- and not from LANE.glow, where tabl and tar are both warm gold
   and the two pads would be hard to tell apart at 45 px. The concept's own
   keycaps use the same three hues. */
const CAP = {
  tabl:   { top: lin('#A2603A'), bezel: [0.86, 0.495, 0.155], glow: [1.00, 0.52, 0.18] },
  swords: { top: lin('#42629E'), bezel: [0.60, 0.62, 0.66],   glow: [0.32, 0.62, 1.00] },
  tar:    { top: lin('#3A7A48'), bezel: [0.86, 0.495, 0.155], glow: [0.34, 0.86, 0.46] },
};

function keycap(lane) {
  const A = 0.60, B = 0.52, Rr = 0.16;      // plinth half-extents and corner
  const TOP = 0.10, BOT = -0.24;
  const body = roundRect(96, A, B, Rr, TOP, BOT, 0, 0);
  body.push(...roundChamfer(96, A, B, Rr, 0.075, TOP, 1));
  body.push(...roundChamfer(96, A, B, Rr, 0.055, BOT, -1));

  // The recess is open at the top, so the solid that cuts it runs past the cap.
  const hA = A - 0.115, hB = B - 0.115, hR = Rr - 0.03;
  const recess = roundRect(64, hA, hB, hR, 1.0, -0.005, 0, 0);

  // The coloured top sits in the recess and stands slightly proud of it, with
  // a chamfer and a shallow dome. The dome is what the cut keycaps have and a
  // flat panel does not: it bends the reflection across the face instead of
  // returning one even tone.
  const iA = hA - 0.012, iB = hB - 0.012, iR = hR - 0.03;
  const inset = roundRect(64, iA, iB, iR, 0.105, -0.02, 0, 2);
  inset.push(...roundChamfer(64, iA, iB, iR, 0.045, 0.105, 1));

  const c = CAP[lane], v = CAP_VIEW[lane];
  return {
    name: 'key_' + lane,
    group: 'key',
    // Centre of the coloured face, on the pad's own vertical axis: turning the
    // pad about that axis leaves it where it is, so cropping the group around
    // it makes the key glyph land correctly on all three without an offset.
    anchor: [0, 0.105, 0],
    radius: 0.86,
    rot: { rx: v.elev * DEG, ry: v.azim * DEG, rz: 0 },
    glow: c.glow,
    parts: [
      { planes: body, sub: recess,
        mat: { type: 'metal', f0: c.bezel, rough: 0.42, spec: 170 } },
      { planes: inset,
        bump: {
          h: (x, z) => {
            const u = Math.max(-1, Math.min(1, x / iA));
            const v = Math.max(-1, Math.min(1, z / iB));
            return 0.048 * (1 - u * u) * (1 - v * v);
          },
        },
        mat: { type: 'enamel', albedo: c.top, f0: 0.055, spec: 260 } },
    ],
  };
}

/* -------------------------------- shards ---------------------------------- */
/* Gold fragments thrown off a perfect hit -- the one effect here that really
   is geometry rather than light, so it is traced with the notes.

   An irregular convex solid is free in this engine: the intersection of a set
   of half-spaces is convex by construction, so a handful of planes at pseudo
   random orientations is already a shard, and the slab test still gives exact
   facet edges. Six axis planes keep it bounded, which a random set alone would
   not guarantee. The seed is fixed so a given index always renders the same
   fragment. */
function rng(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6D2B79F5) >>> 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function shard(i) {
  const r = rng(i * 7919 + 17);
  const planes = [];
  for (const ax of [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]) {
    planes.push([ax[0], ax[1], ax[2], 0.34 + r() * 0.30, 0]);
  }
  for (let k = 0; k < 7; k++) {
    const u = r() * 2 - 1, th = r() * Math.PI * 2;
    const sxy = Math.sqrt(Math.max(0, 1 - u * u));
    planes.push([sxy * Math.cos(th), u, sxy * Math.sin(th), 0.22 + r() * 0.20, 0]);
  }
  return {
    name: 'fx_shard_' + i,
    size: 192,
    radius: 0.62,
    rot: { rx: r() * 2 - 1, ry: r() * Math.PI * 2, rz: r() * 2 - 1 },
    glow: [1.00, 0.56, 0.16],
    parts: [{ planes, mat: { type: 'metal', f0: [0.96, 0.520, 0.140], rough: 0.24, spec: 300 } }],
  };
}

/* Debris, so a broken note throws pieces of ITSELF.

   Gold shards for everything was the cheap answer and it read as one generic
   effect: an amethyst crystal that shatters into gold is not shattering, it is
   emitting confetti. These are the same irregular-convex trick as `shard`, but
   carrying the note's own material -- the crystal's dielectric in its own
   colour, and a silver metal for the silver coin.

   The absorption is scaled up hard. A chip is a fraction of a crystal's size,
   so the path through it is a fraction as long, and at the parent's
   coefficients it would come out nearly clear -- Beer-Lambert cuts both ways.
   Matching the LOOK of the parent means raising the coefficient, not copying
   it. */
function chip(v, i) {
  v = v || '';
  const t = CRYSTAL_TINT[v];
  const r = rng(i * 104729 + (v.charCodeAt(1) || 97) * 31 + 7);
  const planes = [];
  for (const ax of [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]) {
    planes.push([ax[0], ax[1], ax[2], 0.30 + r() * 0.34, 0]);
  }
  for (let k = 0; k < 5; k++) {           // fewer cuts than a shard: chips are blockier
    const u = r() * 2 - 1, th = r() * Math.PI * 2;
    const sxy = Math.sqrt(Math.max(0, 1 - u * u));
    planes.push([sxy * Math.cos(th), u, sxy * Math.sin(th), 0.20 + r() * 0.22, 0]);
  }
  return {
    name: 'fx_chip_' + ({ '': 'a', _b: 'b', _c: 'c' }[v]) + i,
    size: 160,
    radius: 0.58,
    rot: { rx: r() * 2 - 1, ry: r() * Math.PI * 2, rz: r() * 2 - 1 },
    glow: t.glow,
    parts: [{
      planes,
      mat: { type: 'glass', ior: 1.56, absorb: t.absorb.map((x) => x * 2.6), spec: 900 },
    }],
  };
}

function flake(i) {
  const r = rng(i * 15485863 + 29);
  const planes = [];
  for (const ax of [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]) {
    planes.push([ax[0], ax[1], ax[2], 0.32 + r() * 0.26, 0]);
  }
  for (let k = 0; k < 6; k++) {
    const u = r() * 2 - 1, th = r() * Math.PI * 2;
    const sxy = Math.sqrt(Math.max(0, 1 - u * u));
    planes.push([sxy * Math.cos(th), u, sxy * Math.sin(th), 0.19 + r() * 0.18, 0]);
  }
  return {
    name: 'fx_flake_' + i,
    size: 160,
    radius: 0.56,
    rot: { rx: r() * 2 - 1, ry: r() * Math.PI * 2, rz: r() * 2 - 1 },
    glow: COIN_TINT._b.glow,
    parts: [{ planes, mat: { type: 'metal', f0: COIN_TINT._b.f0, rough: 0.22, spec: 320 } }],
  };
}

module.exports = { crystal, gem, coin, keycap, shard, chip, flake };
