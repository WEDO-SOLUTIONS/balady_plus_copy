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
function crystal() {
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
    name: 'tabl',
    radius: 0.83,
    rot: { rx: TILT, ry: 0.20, rz: Math.PI / 2 },
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
    radius: 0.54,
    rot: { rx: TILT, ry: 0.22, rz: 0 },
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
    radius: 0.65,
    rot: { rx: TILT, ry: 0.30, rz: 0 },
    glow: [1.00, 0.60, 0.14],
    parts: [{
      planes: prism(128, 0.455, 0.072, -0.072, 0, 1, 2),
      mat: { type: 'metal', f0: [1.00, 0.545, 0.150], rough: 0.16, spec: 520 },
    }],
  };
}

module.exports = { crystal, gem, coin };
