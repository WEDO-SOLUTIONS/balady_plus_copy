/* A small ray tracer, enough for three objects.

   The painted sprites read as illustrations because every highlight was a
   gradient placed by hand. These are traced: the shapes are real convex
   polyhedra, facets take their normals from the geometry, and the light comes
   from an environment standing in for the stage -- moon above, braziers below.
   That is what makes a facet go dark as it turns away, and what puts the room
   into the gold instead of a painted streak.

   Bodies are convex, which earns its constraint: a ray against a convex
   polyhedron is an exact slab test, so facet edges are analytically sharp
   rather than marched to. The gem's setting is the one non-convex part, done
   as a CSG difference of two convex solids, which stays exact.

   Plane form: inside is dot(p, n) <= d, stored as [nx, ny, nz, d, kind].
   kind marks facets needing special treatment at shading time:
     0  flat facet, geometric normal
     1  prism side to be smoothed to a true cylinder, so a 128-gon reads as a
        turned edge instead of 128 shading bands
     2  coin face, bump mapped with the struck relief   */

'use strict';

const V = {
  norm(x, y, z) { const l = Math.hypot(x, y, z) || 1; return [x / l, y / l, z / l]; },
};

/* Ray against a convex polyhedron: the slab test over every plane. Results go
   into a caller-owned object, because this runs a few hundred million times. */
function hitConvex(planes, ox, oy, oz, dx, dy, dz, out) {
  let tN = -1e30, tF = 1e30;
  let nx = 0, ny = 0, nz = 0, nk = 0, fx = 0, fy = 0, fz = 0, fk = 0;
  for (let i = 0; i < planes.length; i++) {
    const p = planes[i];
    const den = dx * p[0] + dy * p[1] + dz * p[2];
    const dist = p[3] - (ox * p[0] + oy * p[1] + oz * p[2]);
    if (den > -1e-12 && den < 1e-12) {
      if (dist < 0) return false;                   // parallel, outside
      continue;
    }
    const t = dist / den;
    if (den < 0) {                                  // entering this half-space
      if (t > tN) { tN = t; nx = p[0]; ny = p[1]; nz = p[2]; nk = p[4]; }
    } else {                                        // leaving it
      if (t < tF) { tF = t; fx = p[0]; fy = p[1]; fz = p[2]; fk = p[4]; }
    }
  }
  if (tN > tF) return false;
  out.tN = tN; out.tF = tF;
  out.nx = nx; out.ny = ny; out.nz = nz; out.nk = nk;
  out.fx = fx; out.fy = fy; out.fz = fz; out.fk = fk;
  return true;
}

/* A regular prism about +Y: `sides` side planes plus two caps. */
function prism(sides, r, yTop, yBot, phase, sideKind, capKind) {
  const planes = [];
  for (let i = 0; i < sides; i++) {
    const a = phase + (i / sides) * Math.PI * 2;
    planes.push([Math.cos(a), 0, Math.sin(a), r, sideKind | 0]);
  }
  planes.push([0, 1, 0, yTop, capKind | 0]);
  planes.push([0, -1, 0, -yBot, capKind | 0]);
  return planes;
}

/* A rounded rectangle, swept into a prism about +Y.

   The support function of a rounded rectangle is exact and cheap -- it is the
   Minkowski sum of a box and a disc, so h(n) = a|nx| + b|nz| + r -- which
   means a ring of planes at h(n) gives the shape directly, and it stays
   convex, so the slab test still applies. */
function roundRect(sides, a, b, r, yTop, yBot, sideKind, capKind) {
  const planes = [];
  for (let i = 0; i < sides; i++) {
    const t = (i / sides) * Math.PI * 2;
    const nx = Math.cos(t), nz = Math.sin(t);
    planes.push([nx, 0, nz, a * Math.abs(nx) + b * Math.abs(nz) + r, sideKind | 0]);
  }
  planes.push([0, 1, 0, yTop, capKind | 0]);
  planes.push([0, -1, 0, -yBot, capKind | 0]);
  return planes;
}

/* A 45-degree chamfer around one face of a rounded rectangle, cutting `c` off
   the edge. dir +1 chamfers the top face, -1 the bottom. */
function roundChamfer(sides, a, b, r, c, y, dir) {
  const planes = [];
  const L = Math.SQRT2;
  for (let i = 0; i < sides; i++) {
    const t = (i / sides) * Math.PI * 2;
    const nx = Math.cos(t), nz = Math.sin(t);
    const h = a * Math.abs(nx) + b * Math.abs(nz) + r;
    planes.push([nx / L, dir / L, nz / L, (h - c + dir * y) / L, 0]);
  }
  return planes;
}

/* A ring of planes from a ring of radius r at height y0 to an apex at yApex.
   dir +1 points the apex up, -1 points it down. */
function cone(sides, r, y0, yApex, dir, phase) {
  const planes = [];
  const k = (dir * (yApex - y0)) / r;
  const L = Math.hypot(k, 1);
  for (let i = 0; i < sides; i++) {
    const a = phase + (i / sides) * Math.PI * 2;
    planes.push([(k * Math.cos(a)) / L, dir / L, (k * Math.sin(a)) / L,
                 (dir * yApex) / L, 0]);
  }
  return planes;
}

function mul(a, b) {
  const o = new Array(9);
  for (let r = 0; r < 3; r++) {
    for (let c = 0; c < 3; c++) {
      o[r * 3 + c] = a[r * 3] * b[c] + a[r * 3 + 1] * b[3 + c] + a[r * 3 + 2] * b[6 + c];
    }
  }
  return o;
}

/* R = Rx * Ry * Rz, as a row-major 3x3 and its transpose (which takes world
   directions into the object's frame).

   The three axes have distinct jobs here. rz lays an object down -- the
   crystal's long axis is local +Y, so it needs a quarter turn about Z to come
   to rest on its side. ry spins it about the floor's normal. rx is the
   viewing tilt: an object lying flat has its up axis along world +Y, and
   rx = elevation swings that towards the camera, so rx = PI/2 is straight
   down onto it and rx = 0 is edge on. */
function rot(rx, ry, rz) {
  const cx = Math.cos(rx), sx = Math.sin(rx);
  const cy = Math.cos(ry), sy = Math.sin(ry);
  const cz = Math.cos(rz || 0), sz = Math.sin(rz || 0);
  const Rx = [1, 0, 0, 0, cx, -sx, 0, sx, cx];
  const Ry = [cy, 0, sy, 0, 1, 0, -sy, 0, cy];
  const Rz = [cz, -sz, 0, sz, cz, 0, 0, 0, 1];
  const m = mul(mul(Rx, Ry), Rz);
  const t = [m[0], m[3], m[6], m[1], m[4], m[7], m[2], m[5], m[8]];
  return { m, t };
}

function apply(m, x, y, z, out) {
  out[0] = m[0] * x + m[1] * y + m[2] * z;
  out[1] = m[3] * x + m[4] * y + m[5] * z;
  out[2] = m[6] * x + m[7] * y + m[8] * z;
}

/* Inigo Quilez's regular-star distance field, used for the coin's relief. */
function sdStar(px, pz, r, n, m) {
  const an = Math.PI / n, en = Math.PI / m;
  const acx = Math.cos(an), acy = Math.sin(an);
  const ecx = Math.cos(en), ecy = Math.sin(en);
  const two = 2 * an;
  let bn = Math.atan2(px, pz) % two;
  if (bn < 0) bn += two;
  bn -= an;
  const len = Math.hypot(px, pz);
  let qx = len * Math.cos(bn) - r * acx;
  let qy = len * Math.abs(Math.sin(bn)) - r * acy;
  const cl = Math.max(0, Math.min(-(qx * ecx + qy * ecy), (r * acy) / ecy));
  qx += ecx * cl; qy += ecy * cl;
  return Math.hypot(qx, qy) * (qx < 0 ? -1 : 1);
}

module.exports = { V, hitConvex, prism, roundRect, roundChamfer, cone, rot, apply, sdStar };
