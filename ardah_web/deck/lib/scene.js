/* The three note objects, as geometry rather than as drawings.

   Sizes are in object units; each object is auto-fitted to the frame by its
   bounding radius, so these numbers are about proportion, not scale.

   Colours still come from the measurements taken off the sprites cut from the
   concept image -- warm orange around H 26-33 deg, shadows to near-black,
   highlights clipping cream -- but they now enter as physical quantities: an
   absorption coefficient for the crystal and the gem, a reflectance for the
   gold. The lighting decides the rest. */

'use strict';

const { prism, cone } = require('./trace');

const TAU = Math.PI * 2;

/* ------------------------------ tabl: crystal ----------------------------- */
/* A six-sided crystal with a tall termination. The lane's object was a
   faceted block to begin with; as a crystal the same silhouette gets to
   refract, which is most of what sells a render. */
function crystal() {
  const R = 0.425;
  const planes = [];
  for (let i = 0; i < 6; i++) {
    const a = (i / 6) * TAU + 0.26;
    planes.push([Math.cos(a), 0, Math.sin(a), R, 0]);
  }
  planes.push(...cone(6, R, 0.20, 0.88, 1, 0.26));      // termination
  planes.push(...cone(6, R, 0.18, 0.60, 1, 0.26 + Math.PI / 6));   // shoulder bevel
  planes.push(...cone(6, R, -0.30, -0.60, -1, 0.26));   // lower point
  planes.push(...cone(6, R, -0.28, -0.50, -1, 0.26 + Math.PI / 6)); // lower bevel
  return {
    name: 'tabl',
    radius: 0.90,
    rot: { rx: -0.11, ry: 0.52 },
    glow: [1.00, 0.44, 0.10],
    parts: [{
      planes,
      mat: {
        type: 'glass',
        ior: 1.56,
        // absorbs blue hard and green moderately: what comes through is amber
        absorb: [0.16, 1.28, 3.70],
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
function gem() {
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
    name: 'swords',
    radius: 0.62,
    rot: { rx: -1.30, ry: 0.22 },
    glow: [0.22, 0.72, 1.00],
    parts: [
      {
        planes: prism(64, OUT, H, -H, 0, 1, 0),
        sub: prism(64, IN, H * 3, -H * 3, 0, 1, 0),
        mat: { type: 'metal', f0: [1.00, 0.590, 0.190], rough: 0.30, spec: 320 },
      },
      {
        planes,
        mat: {
          type: 'glass',
          ior: 1.72,
          absorb: [8.00, 1.45, 0.14],     // the complement: a cool blue stone
          spec: 1400,
        },
      },
    ],
  };
}

/* ------------------------------ tar: coin --------------------------------- */
/* A struck gold disc. The body is a 128-gon whose side normals are smoothed
   back to a true cylinder at shading time, so the rim turns rather than
   banding, and the milling and the relief are both normal perturbations --
   which is how a coin would be rendered for real. */
function coin() {
  return {
    name: 'tar',
    radius: 0.52,
    rot: { rx: -1.02, ry: 0.30 },
    glow: [1.00, 0.60, 0.14],
    parts: [{
      planes: prism(128, 0.455, 0.072, -0.072, 0, 1, 2),
      mat: { type: 'metal', f0: [1.00, 0.545, 0.150], rough: 0.16, spec: 520 },
    }],
  };
}

module.exports = { crystal, gem, coin };
