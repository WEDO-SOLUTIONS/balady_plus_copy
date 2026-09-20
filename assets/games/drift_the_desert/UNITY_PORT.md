# Porting Drift the Desert to Unity — handover

This is the web build's accumulated knowledge, written for whoever rebuilds the
game in Unity. `README.md` is the reference for how the web version works;
this file is about **what to carry across and what to throw away**.

Read the short version first: most of the hard work in the web build is
*emulating a camera*. Unity has one. The fake-perspective machinery — which is
the bulk of `js/ground.js` and half of `js/scene.js` — should not be ported at
all. What is worth carrying is the design, the art, the bake pipeline, and a
list of traps that are engine-independent and will be rediscovered the hard way
otherwise.

---

## 1. What does NOT transfer

Delete these problems rather than solve them again.

| Web build | Why it exists | Unity |
|---|---|---|
| Pinhole mapping `t = 0` at horizon → `1` at frame bottom, depth ∝ `1/t` | Canvas has no camera | A real perspective camera |
| The ground as a WebGL quad with per-pixel perspective, hand-rolled mipmap LOD bias and `EXT_texture_filter_anisotropic` | Canvas 2D could not draw a perspective plane without banding | A ground mesh (or a large quad) with normal texture import settings |
| `Ground.metrics()` / `scene.place(depth, lateral, lean)` / the single world clock in texels | Everything on the floor had to agree about speed with a texture scroll | `transform.position`, moved by one speed value |
| Band approximation, the "velocity step at seams" fix | An earlier Canvas-2D ground | n/a |
| Horizon-relative placement and the "hold still when the horizon moves" work | The horizon was a number that other things were derived from | The camera moves; the world does not care |
| Haze as a flat-coloured sprite copy composited per object | No cheap tint for `drawImage` | Fog, or a shader property |
| `Sheet.drawShadow`, contact pools, footprint trapezoids | No shadow casting | Real shadows, or a projector / blob shadow |
| The coin as 24 baked frames of a turn, solved analytically as a ray against a cylinder | No 3D at runtime | A coin mesh with a metallic material, spun by `transform.Rotate` |
| `build_standalone.py`, the plate fallback path, `img/` inlining | A single-file WebView deliverable | n/a |

**Do not port the 45° car lean as a sprite rotation either.** In Unity the car
should be a model that actually rolls; see §4.

---

## 2. What transfers as design

These are the numbers that encode decisions, not implementation. They are
dimensionless or in seconds and should be carried over as-is, then re-tuned by
feel.

**Run and balance** (`js/game.js`, `CONFIG`). `tilt` runs −1 (about to flip onto
its side) to +1 (dropping back onto four wheels); 0 is the sweet spot of a
two-wheel drift. This is the whole game:

```
runSeconds 60
zoneGreat 0.30   zoneGood 0.58   tiltFail 1.0
instabilityStart 1.05 → instabilityEnd 2.15   (push away from balance over the run)
gustStart 0.10 → gustEnd 0.42
damping 1.55   tapImpulse 0.62   tapMaxVel 1.45
```

**Scoring**, tuned so a clean 60 s run lands in 4 000–4 500, which is what the
design mockups show: `scoreBase 36`, `scorePerCombo 2`, `goodZoneFactor 0.55`,
`comboEvery 2.0 s`, `greatPopEvery 1.6 s`, `coinEvery 1.45 s`, `coinScore 25`.

**Speed**: `speed = min(700, 260 + combo*9 + progress*140)`. The important part
is that speed is mostly *earned by combo*, not by time.

**World scale.** The road spans `2 × TRACK_HALF × TILE_ACROSS = 0.949` of the
screen width at the car, independent of texture size. So a 4 m track puts the
camera about 4.2 m across at the car, and one ground tile is about 8.8 m.
Ripples in the sand texture come out ~14 cm apart at that scale, which is what
real ones measure. Use this to size a Unity scene; do not trust metre figures
in older comments, which were wrong and have been corrected.

**The road bends** over hundreds of metres, as a sum of two sines with an
irrational-ish ratio (`js/ground.js`, `curveLine`). Keep the idea: a meander
baked into the *texture* arrives twice a second and reads as the road snaking,
which is a bug the web build already made and fixed.

---

## 3. What transfers as art

The baked textures are ordinary PNG/JPEG and drop straight into Unity. `img/`
holds 28 files totalling 11 MB, 27 of which are loaded; the 13 in `img/bg/` are
the baked ones and account for nearly all of that:

- `cliffs.png` 2048×5120 — **10 landforms**, 2 cols × 5 rows, 1024 px cells
- `props.png` 2048×1536 — 12 roadside objects, 4×3, 512 px cells
- `coin3d.png` 768×512 — 24 frames of a coin's turn, 6×4, 128 px cells
- `sand.jpg`, `track.jpg` 2048² — tiling ground
- 8 backdrop plates (sky / far range / near range / dunes × golden-hour and dusk)
- `car.png` 752×674 — the Patrol rear shot, cut off its studio white

They are **generated**, not painted: `tools/bake_background.html` is a GLSL
shader, `tools/bake_background.js` drives headless Chromium to render each
layer, `tools/pack_background.py` compresses and writes `js/plates.js`. The
shader is the source of truth and is portable — if Unity wants different sizes
or more variants, re-run the bake rather than resample the PNGs:

```bash
node tools/bake_background.js && python3 tools/pack_background.py   # ~4 min
```

**The geology is researched and worth keeping.** Two rocks: Tuwaiq limestone
(pale cream-grey, flat-topped, thin horizontal courses, talus apron — the
escarpment past Riyadh) and Hegra / Al-Ula sandstone (honey to rust, massive
rather than thin-bedded, rounded tops, **undercut at the foot** because
wind-blown sand never gets more than a metre or two up, crossbedding at an
angle, tafoni honeycomb pitting). The ten forms are: escarpment wall, butte,
massif, pedestal, wind-polished dome, pinnacle, cuesta, cut stack, natural arch,
tower group. Plants are the local ones — thumam, arfaj, ghada, arta, saltbush,
thorn bush. Sand is Nefud red, from iron oxide on the quartz.

If the Unity version models cliffs in 3D, this list is the brief. If it keeps
billboards, the sheet is ready.

---

## 4. Traps that will recur in Unity

These cost real time here and none of them are Canvas-specific.

**Temporal aliasing on the scrolling ground.** At the original speed the ground
advanced 42 px per frame against a 32 px ripple spacing in the texture — past
Nyquist, so the sand appeared to *pour into the centre of the screen* rather
than flow past. Fixed by halving the world speed (`WORLD_SCALE 0.48`) and
multi-tap blur derived from actual per-frame travel. In Unity this is motion
blur / TAA, but **check it at the real speed**: the symptom is direction
reversal, not fuzz, and it is the single most damaging artefact the web build
hit.

**A thing must not be more present than the ground under it.** Cliffs read as
floating for three iterations. The cause was not their position: the textured
ground faded in over a band below the horizon, and the cliffs lived entirely
inside it — measured, a cliff at full opacity stood on ground drawn at **19%**,
and two others on **0%**. In Unity: object fade and fog density must agree. Tie
them to one curve.

**A straight horizontal bottom edge reads as a cut-out.** Even with the ground
right, distant cliffs still looked pasted on, because the sprite was chopped
square at the cell's bottom. It needs an irregular edge that dissolves — and
the *colour* has to reach sand before the alpha starts dropping, or you get a
dark fringe that reads as a cut-out just as plainly.

**Fixed spawn lanes read as an effect, not as nature.** The ground-rush streaks
used 16 hashed-but-constant x positions: 16 columns of sand, forever. Drawing
the lane from index *and lap* gives 584 distinct positions over 120 laps. Same
class of bug in the cliffs: an even spacing around the band is what makes them
arrive in index order so that sides can strictly alternate.

**Hashes that are uniform in the long run are lumpy in the short one.** A
`sin`-based hash stepped by a lap counter covered 5 of 6 landforms over the
first four laps — which is most of a 60-second session. An integer mix covers
all of them. Any per-spawn randomness needs checking over the run length a
player actually sees, not over a million samples.

**A flat metal face reflects one flat colour.** The coin's first cut baked out
as a single washed pale disc: gold is a metal, so nearly all of what you see is
its surroundings sampled along the reflected ray — and off a dead-flat face
that ray is the same ray at every pixel. The struck relief was present and was
modulating brightness by a tenth, which is invisible. Doming the field by a
hair is what makes it read as metal, because that is what sweeps the
environment across it. In Unity this is a normal map plus a real reflection
probe, and the same rule decides whether it works: **if the normal does not
vary, neither does the metal.** The matching half is that relief must be a
tilt of the normal rather than a painted highlight, or it will not turn with
the object.

**Ellipse shadows make everything the same object.** A thorn bush and a boulder
cast the same blob. The fix was the object's own silhouette, squashed and
sheared. In Unity, real shadows do this — but if blob shadows are used for
performance, shape them.

**Rolling about the centre lifts both wheel sets.** For the two-wheel drift
pose, rotating the car about its centre swung the tyres up to 51 px clear of
the ground and it hovered; that forced the lean flat, and flat it read as
driving on all four. **Roll about the contact tyre.** In Unity this is a
pivot / centre-of-rotation choice and the same rule applies. Two refinements:
at a steep angle the body swings sideways too and walks out of frame, and the
contact migrates to the **outer shoulder** of the tread, because seen from
behind a wheel is a tread and not a circle.

**A photo crop is not a cut-out.** The old car sprite was matted by rembg from
a 90×88 crop; the model returned a rounded rectangle and the sprite carried a
block of the original desert inside its alpha, which showed in play as a
translucent slab leaning out from under the car. Anything matted from a small
source needs checking by looking at the alpha channel, not the composite.

**`build_standalone.py` rewrites every `img/…` string it finds, comments
included.** A comment naming a sprite that is no longer loaded embedded 40 KB
of base64 for something nobody draws. Irrelevant in Unity, but the general
lesson — a build step that scans text will find your prose — is not.

---

## 5. How this was verified

Worth copying as a practice, because most of the findings above came out of it
and none came from looking at screenshots alone.

Everything was checked by **measurement in a headless browser**: drive the
scene with `requestAnimationFrame` stubbed out, step it at a fixed 1/60 s, and
read numbers back. Examples that caught real bugs:

- Frame-stepping plus strip-matching optical flow, to prove the ground and the
  props moved at the same rate (props track the ground to 0.06 px; the coin
  loses exactly the ground's depth).
- Depth drift across a moving horizon — 0.0000% after the fix, 3.6% before.
- Drawing the car alone on a blank canvas and finding its lowest opaque pixel,
  to check the tyres sit on the ground line at every steering angle.
- Reading the alpha channel directly, to find that `car.png` was 76% opaque and
  that a sheet's subject stood at 0.988 of its cell rather than the assumed
  0.95.
- Layer bisection: stub one draw call at a time and diff. **One caution** — an
  early bisect harness stored the originals under short keys and then assigned
  `S[key]` instead of `S[methodName]`, so no stub ever applied and every panel
  looked identical. Verify a bisect harness actually removes something obvious
  before trusting it.

**A second caution, from this session.** A screenshot is a different path out
of the browser than the canvas is, and twice it lied: once because a frame was
already queued when `requestAnimationFrame` was stubbed, so the game repainted
over the test before the shot was taken, and once because a draw made outside
any frame had not reached the compositor when the shot was. Both times the
picture was of something real, just not of what had been drawn. Reading the
canvas back with `getImageData` and counting changed pixels settled it in one
run. Prefer the number over the picture when the question is "did this draw at
all".

The scratch harnesses are not in the repo (they live in the session's scratch
directory), but they are twenty-line Playwright scripts and rebuilding one is
minutes of work.

---

## 6. State of the web build

Branch `claude/pensive-clarke-av24br`, 14 commits in this session on top of
`52b9b83e`. Verified clean at 390×844, 360×640 DPR3 and 412×915, in the painted
no-plates fallback, with `car.png` blocked so the painted fallback car draws,
with the coin sheet blocked so its two fallbacks draw, and in the standalone
build (15.9 MB, no external requests).

**Known defects and open questions, carried over honestly:**

- `img/driver.png` is retained but **not loaded** — the driver was taken out of
  the window on request, "for now". `drawDriver` and the SEAT / LIFT / DRIVER
  constants are kept unused so he can be put back in a line.
- `car.png` is a **manufacturer press photograph** supplied for this session.
  Rights for production use have not been checked. A Unity build almost
  certainly wants a licensed 3D model instead, which also solves the lean, the
  shadow and the tail lights properly.
- The 45° lean reads as a Saudi *hajwalah* sidewall stunt rather than a drift.
  That was the explicit request; if the Unity version wants a drift, 25–30° is
  the range that reads that way.
- The cliff sheet is 5.4 MB, 54% of all assets, because it is a PNG with alpha
  and nothing may be downscaled. In Unity this is a texture-compression setting
  (ASTC/ETC2) and stops being a problem.
- `tintSheet`'s cache holds up to 6 flat-coloured copies of a sheet; for the
  cliff sheet that is 42 MB each if they are all live. It has never been
  measured as a problem in practice, but it is the one place the web build
  could surprise a low-memory device.
