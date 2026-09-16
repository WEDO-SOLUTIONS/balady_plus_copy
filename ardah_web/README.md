# Ardah — web prototype

A playable rhythm-game prototype for **Ardah** (العرضة), built the way the
concept doc recommends shipping it: a self-contained web app that runs inside
the Balady+ mini-app WebView **and** in any browser on your desk.

Concept, delivery options and the audio background: [`docs/ardah-concept.md`](../docs/ardah-concept.md).

- No build step, no bundler, no npm install.
- No external requests: no CDN, no web fonts, no audio files. It works offline
  from the first frame, which is what an event on Founding Day needs.
- ~60 KB of source in total.

## Run it

Serve the folder — this mirrors how the superapp runs it (the mini-app engine
extracts an archive and serves it from a localhost HTTP server):

```bash
cd ardah_web
python3 -m http.server 8000     # or: npx http-server -p 8000 .
# open http://localhost:8000
```

Opening `index.html` directly (`file://`) also works — scripts are classic, not
modules, precisely so that it does.

Append `?debug=1` for the latency lab, or press the **Latency lab** button.

### One file to pass around

```bash
./build-single.sh        # -> dist/ardah-standalone.html (~80 KB, git-ignored)
```

Inlines the CSS and scripts into a single HTML file you can mail, drop into a
chat, or double-click. Same code — the split version is what ships, because the
mini-app engine serves a folder.

## Controls

| | Touch | Keyboard |
|---|---|---|
| Strike | tap a lane | `A` `S` `D`, or `←` `↓` `→` |
| | lanes are **TABL** (deep drum), **SWORDS** (blades) and **TAR** (frame drum) | |
| Raise (hold) | press and hold, release on the last beat | hold the lane key |
| Flourish | swipe across the lanes | `Space` |
| Pause | — | `Esc` |
| Mute music | the speaker button, top right | `M` |

Mute takes the **music bus**, not the master: the calibration metronome hangs
off the master directly, because that screen exists to measure the device's
audio and silencing it would make the measurement impossible. The calibration
screen says so when muted. Timing is untouched either way — the conductor runs
off the audio clock and keeps scheduling on mute, so a muted run is judged
exactly like a loud one. The choice persists in `localStorage`.

## Calibrate first

**Menu → Calibrate timing.** Eight clicks, tap along, the median becomes the
device's audio offset (stored in `localStorage`). Every device delays its audio
differently — 20 ms on a desktop, 200 ms on some Android handsets — and without
this measurement the game feels broken through no fault of the player. The
manual ±5 ms buttons are there for fine-tuning after a run.

## The latency lab

The debug panel is the reason this prototype exists before any production code:

```
fps        60   dpr 2          frame pacing — the WebView's weak spot
ctx        running @48000Hz    audio context state and rate
base lat   5.3 ms              browser-reported buffer latency
out lat    32.0 ms             scheduled → audible delay
calib      +64 ms              measured device offset
mean       -6.4 ms  (n=48)     how early/late the player actually is
jitter σ   2.9 ms              spread — the number that decides everything
```

`mean` is calibratable: a constant offset just shifts the clock. **`jitter` is
not.** If σ stays small on a low-end Android inside the superapp WebView, the
HTML path works. If it is wide, that is the signal to fall back to native.

Run the same measurement in a browser, then in the superapp WebView **with the
MBC radio playing**, and compare. That comparison is the spike the concept doc
asks for (§5.4).

## Artwork

`assets/` holds art **cut out of the Ardah concept image** by `assets/extract.py`
— an experiment in how far a single rendered still gets us. The game runs
without it; each image swaps in the frame after it decodes, and `?art=0` forces
the drawn version so the two can be compared side by side.

What the slicing produced, at **180 KB total in WebP**:

| Asset | How it was cut | Works? |
|---|---|---|
| `bg_stage` | Rectangular crop of the stage band, title plaque painted out and blurred back into the sky | Yes — this is most of the visual win |
| `note_tabl/swords/tar` | Keyed against the dark deck: distance-from-background alpha, colour unmultiplied, largest blob kept, ellipse mask to cut the neighbouring coin | Yes |
| `key_tabl/swords/tar` | **No keying at all** — a plain crop with a rounded-rect mask. Keying kept eating a bevel or a corner off these (they are layered: coloured top, metal base, and sparks drawn over the S), and the dark pixels a plain mask keeps are the deck, which is what the caps are drawn back onto | Yes |
| `ui_plaque` | Keyed against the sky | Cut cleanly, **but unusable**: the title is baked in as English pixels, so it cannot localise. Kept in `assets/` as the exhibit for why the brief bans text in artwork |
| Performers, musicians, fires | — | **Not cuttable.** They sit against the fort, not a flat background, and they overlap each other. They stay baked into `bg_stage`, which is why the stage no longer animates in art mode |

So the experiment's answer: a flat still gets you the backdrop, the props and
the UI furniture almost for free, and gets you **no animation at all**. The
performers' idle sway, the sword raise on a hit, the drummers answering the
track — all of it needs the layered delivery specified in
[`../docs/ardah-art-brief.md`](../docs/ardah-art-brief.md) §3.3.

To keep the plate from looking dead, the renderer adds firelight flicker over
the baked braziers and a slow scale "breath" on the beat. It helps; it is not a
substitute.

**Provenance and status:** derived from the client's own concept image, for
evaluation only. Not cleared for release — and note that the banners in it carry
the state emblem, which is exactly the compliance question raised in the brief's
§1.

### Traced note sprites

`assets/hd/` holds 512 px masters of the three note objects, produced by
`deck/make_notes.js` rather than cut from the concept image. The cut sprites
are 60–80 px crops, and the game draws a note at ~115 pt near the judgment
line — 345 device pixels on a 3x screen — so those crops run at a five-fold
upscale and show it.

Earlier passes painted them with canvas gradients, which is why they read as
illustrations: every highlight sat where a hand put it. These are **ray
traced**, in about 400 lines and with no dependencies:

- `deck/lib/trace.js` — geometry. Bodies are convex polyhedra, so a ray is an
  exact slab test over the planes: facet edges are analytic, not marched to,
  and facet normals come from the geometry. The gem's collet is the one
  non-convex part, done as a CSG difference of two convex solids.
- `deck/lib/shade.js` — the environment and the tone map. The environment is
  the stage the game paints: moon high and left, braziers low and in front, a
  dark night sky. Every reflection and refraction samples it, so a facet is
  bright because it points at the moon, not because a highlight was placed
  there. It is kept deliberately dark — fill the whole sphere with light and
  gold renders as one flat lemon tone.
- `deck/lib/scene.js` — the three objects. The crystal and the gem are
  dielectrics with Fresnel, refraction and Beer-Lambert absorption, so their
  colour is whatever light survived the path through them; the coin is a metal.
- `deck/lib/png.js` — a minimal RGBA PNG writer.

Everything accumulates in linear HDR, blooms there, and is tone mapped once
through an ACES curve at the end. Run it with `node deck/make_notes.js`;
`--size`, `--ss` and `--exposure` are the knobs (`--ss 2` for a fast look).

**They lie on the runway, they do not stand on it.** The elevation comes from
`js/render.js`: on a 440x956 phone `C = judgeY - vpY` is 425 and `halfNear` is
202, and since `C = f * cameraHeight` while `halfNear = f * fieldHalfWidth`,
the camera sits 2.1 field-half-widths above the floor — 64° down onto the
judgment line, 23° at the spawn point. One sprite serves the whole runway, so
`TILT` in `deck/lib/scene.js` cuts that at 52°, a little towards the judging
end where the note is largest and actually being read. The crystal is laid on
its side with the third rotation axis (`rz`); the gem and the coin lie face
up.

Their drawn widths are also equalised to ~340 px, because `_gem` in
`js/render.js` sizes a note by the sprite's **width** and lets the height
follow the aspect — three silhouettes of different widths would render at
three different scales.

Two constraints the objects answer to:

- **The tabl lane's object is a crystal**, not a gold bar. That is what the
  lane's drawn fallback in `js/render.js` always was, and a faceted crystal
  gets to refract, which is most of what sells a render.
- **The coin's motif is an eight-point geometric rosette.** An earlier pass
  struck two crossed sabres under a palm, which is the arrangement of the
  **Saudi state emblem**; `docs/ardah-art-brief.md` §1 rules that out as
  decoration. Anything struck on the coin has to clear that bar.

**Highlights are deliberately muted.** Two things were making the gold glare
and the stones look like tinted plastic, and both are in the physics rather
than in any post pass:

- The environment's sources were near-pinpricks (the moon at `md^128`, the
  braziers at `d^16`) with very high peaks. A tiny, very hot source is exactly
  what produces a mirror-sharp blown highlight. They are now broad and much
  dimmer (`md^32`, `d^8`), which gives a sheen that still reads as a highlight
  but stays inside the tone map — under 4 % of pixels clip anywhere on the
  three sprites.
- The stones' absorption coefficients were too low for path length to matter,
  so a ray crossing 1.2 units came out the same colour as one crossing 0.3 and
  the stone had no depth. Raised until thickness is visible: thin edges stay
  bright, the body goes deep.

The trade is real — at ~38 pt the traced sprites now sit dimmer than the cuts,
which carry the concept's own baked highlights. That is the cost of matching
the game's night-stage atmosphere rather than the concept render's.

Colour still answers to the cuts. Their measured mid-tone (H 26–33°, S ≈ 0.7),
near-black shadows and cream-clipping highlights are in the header of
`make_notes.js`, but they now enter as physical quantities — an absorption
coefficient for the stones, a reflectance for the gold — and the lighting
decides the rest.

`deck/notes_sheets.py` rebuilds two sheets into `deck/out/`: `notes_hd.png`
(the masters on a checkerboard) and `notes_compare.png` (cut vs traced at the
~38 / ~67 / ~115 pt the runway actually uses). Judge on the compare sheet, not
at 512 px — a note is never seen that large. Judge by eye, too: the cuts'
luminance statistics include baked-in dark fringe from the crop that a traced
sprite has no reason to reproduce, so matching their mean is the wrong target.

### Traced keycaps

`deck/lib/scene.js` also builds the three strike pads: a metal plinth with a
chamfered top, a recess milled into it, and a domed coloured face set in the
recess. The plinth is a rounded rectangle, which stays convex — its support
function is exact (`h(n) = a|nx| + b|nz| + r`, the Minkowski sum of a box and a
disc), so a ring of planes at `h(n)` gives the shape and the slab test still
applies. A new `enamel` material does the faces: a diffuse body under a clear
coat, which metals cannot stand in for because they have no diffuse term.

Lane colours come from **`KEYCAP`** in `js/render.js` — copper, steel blue,
green — and not from `LANE.glow`, where tabl and tar are both warm gold and the
two pads would be hard to tell apart at 45 pt. The concept's own keycaps use
the same three hues.

**They carry no letter, and that is the point.** The cut keycaps have `A`/`S`/`D`
baked in as pixels, which is exactly what `docs/ardah-art-brief.md` §1 rules
out: the strings localise to Arabic, the layout flips to RTL, and the pads have
to show a dot instead of a letter once the player is on touch. That is why
`_keycaps` currently skips its glyph when a sprite is present. Wiring the
traced pads in therefore needs one change in `js/render.js`: draw
`state.touchUsed ? '●' : LANE_KEYS[lane]` over the sprite as well as under the
fallback. Until then the traced pads would render without a key hint.

### Traced runway

`deck/make_runway.js` renders the deck: dark glass with a gold Najdi lozenge
lattice down both edges and thin gold lane dividers, from the concept image.

**It is not a perspective image, deliberately.** Rendering the runway as it
appears on screen bakes in one layout — `js/render.js` derives `vpY`, `C` and
`halfNear` from the window, so the trapezoid is a different shape on every
device. Instead the deck is rendered in *runway space* (across by world x,
along by depth z) while each texel is shaded from the view ray the game's
camera would actually have to that world point. The texture is therefore
layout-independent, but the glass keeps its correct grazing-angle reflection —
the whole character of the material, and the one thing a flat top-down bake
would lose.

Rows are spaced uniformly in `1/z`, which is uniform in screen y, so putting it
on screen is a row-for-row blit with no vertical resampling:

```
z   = C / (y - vpY)                       // invert yAt
row = (1/z - 1/Z_FAR) / (1/Z_LIP - 1/Z_FAR)
draw that row across 2 * halfAt(z) * 1.165, centred on w/2
```

`deck/runway_preview.py` does exactly that and writes
`deck/out/runway_preview.png`, which is how to check it.

Two things this surfaced:

- **The ornament's period is set by how the deck is seen, not by world
  proportion.** `dy/dz = -C/z²`, so at the judgment line one world unit of
  depth is ~425 px while the band is only ~40 px across. A lozenge period
  chosen to look square in world space came out four times too long on screen.
- **The deck needs a light the note objects do not.** `shade.js` puts its
  sources on the camera's side, which is right for a small object near the
  judgment line but wrong for a mirror lying down the runway: reflected off a
  floor those directions point away from the light and the deck came back dead
  black. What a floor aimed at the stage actually reflects is the stage — the
  fires and the lit fort just above the horizon — which is the warm glow along
  the deck in the concept. `envDeck` adds that on top of the shared
  environment, and it is scoped to the runway for that reason.

### Traced hit effects

`deck/make_fx.js` renders four effects, and `deck/lib/scene.js` a fifth.

Most of them are **light, not surfaces**, so the ray tracer is the wrong tool:
a spark has no normal, and what makes it read is the shape of its falloff and
the colour shift from white-hot core to deep ember rim. They are radiance
fields, integrated per pixel through the same linear pipeline and the same ACES
curve as everything else, which is what keeps them in the game's atmosphere
rather than looking like stock glows.

| asset | what it is |
| --- | --- |
| `fx_spark` | an ember: hot core plus a wide Lorentzian halo — a gaussian alone dies too fast and reads as a dot |
| `fx_flare` | the hit flash: core, halo, a long horizontal streak and a four-point star |
| `fx_ring` | a shockwave |
| `fx_glow` | a soft glow for the lane flash and behind the judgment line |
| `fx_shard_0..5` | gold fragments — the one effect that really is geometry, so it is traced with the notes |

The shards are free in this engine: an intersection of half-spaces is convex by
construction, so a handful of planes at pseudo-random orientations is already
an irregular fragment with exact facet edges. Six axis planes keep it bounded,
which a random set alone would not guarantee.

**The shockwave is in screen space on purpose.** A ring lying on the deck is
the tempting version, but the geometry says no: at the judgment line the camera
is 64° above the floor, and a ring of any useful radius spans a large slice of
depth, so its near edge projects far larger than its far edge. Concretely, at
z = 1 a ring of world radius 0.3 comes out 121 px wide and 280 px tall. That is
not an ellipse, it is an egg, and it reads as a bug rather than as a shockwave.

**Storage: intensity is in the alpha channel.** These are drawn with
`globalCompositeOperation = 'lighter'`, where canvas adds source RGB scaled by
source alpha. So alpha carries intensity and RGB carries chroma normalised to
its brightest component — the core comes out white because all three channels
saturate together there, the rim stays orange, and the game scales the whole
effect with one `globalAlpha` over its life. **Anything judging these has to
add them, not alpha-blend them**, or the result is wrong;
`deck/fx_preview.py` follows the same rule and writes `deck/out/fx_sheet.png`
and `deck/out/fx_hit.png`, a hit composited onto the runway with notes and
keycaps at the sizes `_gem` and `_keycaps` would give them.

One thing that composite shows: a note is drawn `halfNear * 0.731 / z` wide
while a lane is `halfNear * 0.667 / z`, so **a note is about 10 % wider than
its own lane** at every depth. In the concept image the notes are roughly a
third of the lane. With flat cut-out sprites this passed unnoticed; with the
traced ones it is obvious. That is a tuning constant (`0.34` in `_gem`), not an
art problem, and it is left alone here.

### Sizing: the sprites are trimmed

`js/render.js` sizes a sprite by the **whole PNG** — a note by its width
(`dw`), a keycap by its height (`ch`) — so transparent margin is drawn too. A
512 px master whose object covers 340 px renders its content at two thirds the
size of the tightly cropped concept sprites, which reads as the art being wrong
rather than the padding. `make_notes.js` therefore trims every output to its
alpha bounding box with 3 px of margin, which is what makes the masters
drop-in comparable with the cuts. `deck/out/caps_compare.png` is the check:
both rows are scaled to the same height, the way the game will.

**These are now wired in.** `deck/export_assets.py` writes the masters to
`assets/*.webp` at the sizes the game can actually ask for (`Renderer.resize`
caps dpr at 2, so the ceiling is twice the point size, not three times); the
whole set is 0.21 MB against the brief's 4 MB budget. `bg_stage` is still cut
from the concept image; everything else is rendered.

Three things the wiring needed:

- **The note multiplier.** `_gem` drew a sprite at `w * 2.15`, a number
  calibrated against the concept cut-outs, which carry 5–14 % transparent
  padding. The traced masters are trimmed to their content, so the same number
  drew a note *wider than its own lane* — `halfNear * 0.731 / z` against a lane
  of `halfNear * 0.667 / z` — and notes overlapped their neighbours. Now 1.60,
  which puts a note at ~82 % of its lane, where the concept has it.
- **The keycap glyph**, per the no-baked-text rule above.
- **Right-sizing the effects.** `fx_spark` is never drawn above ~52 device px
  and the shards above ~54; exporting them at 128 px was filtering work for
  nothing.

Verified by running it: `node deck/verify.js` serves this directory, plays a
run with a robot that presses through `Game._press`, screenshots it, and checks
console errors, failed loads and the `?art=0` fallback. `node deck/fps.js`
measures the cost: **60.2 fps drawn, 58.3 fps with the artwork** at 440×956 and
dpr 2, during real play with effects firing.

## What is real and what is a placeholder

Real — and intended to survive into production:

- The **conductor**: `AudioContext.currentTime` is the master clock, drums are
  scheduled ~180 ms ahead, and nothing accumulates frame deltas. Judging uses
  the calibrated clock; drawing uses the reported output latency, so a marker
  crosses the line when the drum is *heard*, not when it was scheduled.
- The **judge**: windows (±45 / ±90 / ±140 ms), combo multipliers, accuracy
  weighting, grades, and the sync meter. Pure logic, no canvas, no audio.
- The **chart format** and its validator — a malformed chart fails at load,
  never mid-run.
- Input handling, including the queueing correction (`event.timeStamp`) and
  swipe-becomes-flourish.

Placeholder — replace before anything ships:

- **All percussion is synthesised** in `js/audio.js` (oscillators and filtered
  noise). Real Ardah percussion and chant must be licensed or commissioned.
- **The stage is drawn with canvas paths** — a Diriyah-style fort with a lit
  gate, palms, green banners, brazier fires, a tiled plaza, two facing rows of
  five, and a tabl player and an oud player on stools. Stylised on purpose,
  dignified posture, no caricature. It follows the concept art's composition,
  but real artwork is commissioned and goes through cultural review first.
- **Charts are generated** from a groove table rather than authored against a
  recording.
- No backend, no leaderboard, no tutorial gate, no seasonal gating. Scores live
  in `localStorage`.

## Inside the superapp

The page detects `window.dsBridge` and adapts; in a browser every host call is
a no-op, which is what keeps one build testable in both places.

Its bridge surface is deliberately **almost empty** — analytics and (best
effort) haptics. The game needs no SSO token, no location, no camera, and
asking for none of them is also the cleanest answer to the bridge's permission
scoping issue noted in the concept doc (§6.3).

WKWebView suspends the `AudioContext` on an interruption (a call, navigation
voice, backgrounding), so the game pauses on `visibilitychange` and asks for a
resume rather than assuming its own pause was the only cause.

## File map

```
index.html        screen shells; the canvas is the whole stage
build-single.sh   inlines everything into one distributable HTML file
css/ardah.css     menus; WebView hardening (no selection, no overscroll, safe areas)
js/i18n.js        ar/en strings, RTL flip (gameplay stays LTR by design)
js/bridge.js      dsBridge adapter, no-op in a browser
js/assets.js      optional artwork loader; the game never waits on it
js/audio.js       synthesised tabl / swords / tar + metronome
js/scene.js       the stage: fort, palms, banners, braziers, rows, musicians
js/chart.js       chart format, groove generator, validator
js/conductor.js   the audio clock and schedule-ahead loop
js/judge.js       windows, scoring, combo, sync meter  ← port this as-is
js/render.js      canvas: perspective runway, notes, effects, HUD
js/input.js       pointer + keyboard, queueing correction, swipe detection
js/game.js        flow, calibration, storage, latency lab
js/main.js        DOM wiring and bootstrap
```

## How the scene stays cheap

The backdrop — sky, stars, the fort, bunting, the plaza — never changes, so it
is painted **once** into an offscreen canvas on resize and blitted every frame.
Only firelight, the performers, the drummers, the notes and the effects are
redrawn. Without that split a scene this busy would not hold 60 fps inside a
WebView, where the page is a composited platform view.

The runway is a real projection: distance `z` shrinks linearly with time and
the screen position is `y = vp + C/z`, `x = centre + laneOffset/z`. One division
buys the drift-then-rush approach a rhythm player reads without thinking. The
vanishing point sits *behind* the row, so markers rise out from between the
performers.

## Verified

Headless Chromium (Playwright), 390×844 @2x: audio context runs, **59.7 fps
with the artwork and 59.9 without it** (measured by counting frames, not by the
in-game average — earlier readings of 53–57 came from the test harness's robot
player scanning every note each frame, not from the game). The renderer's own
work is ~0.31 ms per frame, of which the stage plate is 0.13 ms. Also verified: pause suspends and resume restores the context, calibration
measures and persists an offset, judging and scoring behave, Arabic flips to
RTL, no console errors. Timing numbers from a headless run mean nothing —
measure on real devices.

## Next

1. Measure on a low-end Android and an iPhone, in a browser and in the WebView
   with the radio playing. Record `mean` and `jitter` per device.
2. Decide the path on those numbers (concept doc §6.4).
3. Only then: real audio, real art, authored charts, the tutorial gate.
