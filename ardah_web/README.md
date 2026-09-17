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
| Look around | hold the arrows under the crowd meter, or tilt the handset | hold `1` / `2` |
| Park the view | drag the slider under those arrows | Tab to it, then `←` `→` |
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

**Each pad is rendered from the angle the camera really has to it.** With the
camera 2.10 field-half-widths up and the keycap row at z = 0.856, the centre
pad is seen at 67.8° elevation straight on and a side pad at 62.7° and **37.9°
round to the side**. Viewing from azimuth φ is the same as spinning the object
by −φ about its own vertical, so this needs no off-axis camera — it is just
`ry`. The elevations are those real numbers; the azimuth is **not**. At a true
37.9° a pad reads as a diamond rather than as a key, and the concept turns them
far less, so this follows the concept at 13°. It is the one place here where
the drawing beats the arithmetic, deliberately.

The three pads are cropped **symmetrically about their projected anchor** — the
centre of the coloured face, which sits on the pad's own vertical axis, so
turning the pad does not move it. That puts the face centre at the exact centre
of every sprite in the group, which is why `_keycaps` can draw the key glyph
dead centre and have it land correctly on all three, turned or not. No per-lane
offset table.

The three pads are cropped to a **shared frame**. They are one object at three
angles and `_keycaps` scales by the sprite's height; a 13° rotation grows a
square's bounding box by about 20%, so trimming them independently would draw
the side pads smaller and the turn would read as a size difference.

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

### Note colour variants

Each lane keeps one **shape** and varies **colour**: crystal in amber, ruby and
amethyst; gem in sapphire, emerald and amethyst; coin in gold and silver. This
is what the concept image does — gold ingots on the left, blue and green gems
in the middle, gold and silver coins on the right — and it is the only way to
put colour on the runway without costing readability, because the lane stays
identifiable by position and silhouette, which is what a player reads at speed.

For the two dielectrics the colour is an **absorption coefficient, not a
pigment**: it is what the stone takes out of the light crossing it, so the high
numbers are the channels it rejects. Amber rejects blue; ruby rejects green and
blue; emerald rejects red and blue.

Which variant a note wears is hashed from its own time, so it is stable across
frames, retries and pauses without storing anything on the chart.

### Keycap press and the note landing

The key glyph is laid **onto the pad's face**, not floated square-on above it.
`faceBasis` pushes the face's two in-plane directions — across `(1,0,0)` and
along `(0,0,1)` — through the same `Rx(elev) * Ry(azim)` the pad was rendered
with and drops the depth, giving a canvas transform directly:

```
across -> ( cos a, -sin a sin e )
along  -> ( sin a,  cos a sin e )
```

That is a rotation **and a shear**. A letter painted on a tilted, turned plane
is sheared, and rotating it alone looks almost right, which is worse.
`CAP_VIEW` in `js/render.js` mirrors the one in `deck/lib/scene.js`; they have
to agree.

A hit note then travels from the judgment line into its pad — `_lands`, drawn
*before* the keycaps so it sinks behind the key rather than over it, which is
what makes the pad look like it swallowed the note. The travel eases **in**,
not out: a note that drifts down and settles looks like it missed, and the
point is that it was struck.



`_keycaps` eases each pad towards its held state: it dips 3.4 pt, shrinks 7.5 %
and pools a little of `fx_glow` underneath. The press **snaps** to 1 and only
the release is eased — a tap can be 30 ms long, and easing both ends would let
the pad reach a third of the way down and back before anyone saw it, so the
animation would do nothing on exactly the input it exists to acknowledge.
`Game._press` drives it on the input rather than on the judgement, so a stray
tap still moves a key, and `Renderer.keyReset` pairs with `Input.reset` so a
run that ends with a finger down does not leave a pad depressed into the next.

### Looking around: parallax

Two adjacent buttons top-left, or keys **1** and **2**, swing the view, and a
long slider under them parks it. On a handset the same axis comes from the
gyroscope; the buttons are how it is driven and demonstrated on a desktop.

**It is one camera move, not layers sliding at invented rates.** The runway is
a real projection — `x = centre + laneOffset/z` — so the camera orbits about
the judgment line and every depth follows from the projection itself:

```
shift(z) = -tilt * PARALLAX * (1 - 1/z)
```

At `z = 1` that is **zero**, so the judgment line, the keycaps, the lane labels
and the hit testing never move. That is the whole constraint: a rhythm game
whose targets drift under a tilt is unplayable. As `z` grows the shift
approaches the full `PARALLAX`, and the backdrop — which sits beyond the far
end — takes exactly that. Near things move least, far things most, which is
what an orbit does and the *opposite* of what sliding layers would give you.

Two things fall out of the maths and are worth knowing:

- `(1 - 1/z)` is **linear in screen y**, because `1/z = (y - vpY)/C`. So the
  same camera move is a plain horizontal **shear** on screen, which means the
  pre-warped deck bitmap takes it in one transform and stays exactly consistent
  with `xAt()`. Anything positioned through `xAt()` (the notes) must be drawn
  *outside* that shear or it swings twice.
- The plate is cropped to the screen, so it needs **headroom**: its scale is
  raised until it is `w + 2 * PARALLAX` wide, or a tilt slides its edge in and
  shows the base fill behind.

Sources and precedence: three of them feed one number, so the order matters. A
held button or key wins outright while it is held; the **lock slider** is the
standing angle below that; the gyroscope is the resting state under that again.
Zero means "not driving" for the top two, which is what lets a released button
fall through to the lock and a centred lock fall through to the wrist. Without
the precedence a player on a handset could hold the button and watch the view
drift back under their thumb. `Input.reset` releases the tilt along with
everything else.

### The camera lock

The buttons are a *held* look; the slider is the *parked* one — drag it and the
view stays at that angle, which is what you want when showing the stage to
someone rather than playing it. It drives the same `shiftAt` through the same
setter, so everything above still holds: the judgment line and the keycaps do
not move, whatever angle it is parked at.

Four decisions in it are not obvious:

- **It is long on purpose, and plateless on purpose.** Its whole job is to be
  aimable with a mouse, and a short throw quantises the angle to a few pixels
  of travel. But a 200px panel at this height would read as a second HUD over
  the backdrop, so the control is a hairline, a centre tick and a bead at half
  opacity — brighter on hover, and a half-step brighter (`data-locked`) while
  it is parked off centre, because a swung stage with no visible cause reads as
  a bug. The row it sits in — under `CROWD`, well above the vanishing point at
  `0.48h - 62` — is empty on every layout, so length there costs nothing.
- **Pressing left or right clears it** rather than suspending it. The player
  has just said where they want to look; restoring a parked angle on release
  would swing the stage back to a decision they made some time ago. The game
  owns `tiltLock`, `main.js` owns the DOM bead, and `Game.onTiltLockReset` is
  the one seam between them — the part that can drift, so `deck/verify.js`
  drags the real input with a real mouse and asserts both halves for the button
  *and* for key **1**.
- **A parked camera does not outlive the pad.** The stage keeps burning behind
  the menus, so `showScreen` clears the lock whenever it hides the pad: a view
  left locked off centre with the only control to un-lock it hidden is a skewed
  stage the player cannot fix — keys **1** and **2** still work, but a touch
  device has no keys.
- **It gives up focus on release**, because `ArrowLeft` and `ArrowRight` are
  lane keys (`input.js`). A slider left holding focus after a drag would
  swallow half the keyboard for the rest of the run. Arrows still nudge it
  while it *is* focused, which is the accessible path (Tab, then arrows), and
  `input.js` skips its lane handling for events targeted at it.
- **The pad is positioned with `left`, not `inset-inline-start`.** The canvas
  HUD does not mirror — the score plate is always at `w - 58`, the crowd meter
  always at 16 — and this pad is anchored under the meter, so mirrored in
  Arabic it landed on the score. `direction: ltr` one level down for the same
  reason: the left button must be on the left, and a range input in an RTL
  context puts its minimum on the right, which would invert the drag against
  the stage. The floating sound toggle had the same latent bug and is now
  `right: 12px`.

iOS 13+ will not deliver `deviceorientation` without permission and only grants
it from a user gesture, so the request rides on the first press of a button the
player has already chosen to touch. If they decline, the buttons still work.

On `?art=0` the runway parallax works — it is procedural — but the drawn
backdrop does not shift: `scene.js` bakes its offscreen at exactly the canvas
size, so moving it would expose an edge, and widening it for a comparison mode
is not worth the change. The art path is the shipping look.

### The flourish

The flourish is not a lane note: it spans the runway and is taken with a swipe
across all three lanes, so its object is a ceremonial **bar** rather than
anything you could mistake for a tap. It carries the runway's own lozenge
lattice with a rosette struck at the centre — the same vocabulary as the rails
— and deliberately not the crossed sabres the drawn fallback uses, since that
arrangement is the state emblem's.

Its proportions are the sprite's job: `_flourishNote` draws it at
`halfAt(z) * 1.92` wide and takes the height from the sprite's aspect, so the
bar's thickness on screen is a property of the object rather than a number in
the renderer.

On approach a **glint runs its length**, and the period shortens as the note
closes — `lead` drives it, so the bar is visibly more urgent in its last half
second. Nothing about a static bar says "swipe"; a highlight travelling across
it is the gesture it wants. On the hit it answers with **one sweep** along the
judgment line rather than three separate bursts, with a flare head running out
to each side, because the input was one gesture across all three lanes.

### Holds, and breaking by material

**A held note has to look like work.** The ribbon was already shrinking towards
the line, but a shrinking shape alone is a weak signal: it looks the same
whether the player is holding or has let go and the note is expiring. While the
key is down the ribbon's body goes **darker**, not brighter — a dark channel
with a bright core — so that the highlight running up it and the ember trickle
at the line have something to be bright against. The trickle is accumulated in
milliseconds, so its rate does not follow the frame rate.

Building it surfaced a real bug: `_holdRibbon` clamped the consumed end with
`Math.min(z0, 1)`, which is the wrong direction. It only bit once the note had
passed the line — which is precisely when a hold is held — so the ribbon grew
*down past* the judgment line towards the keycaps instead of being eaten at it.

**Breaking is per material, in the note's own colour.** Gold shards for
everything read as one generic effect: an amethyst crystal that shatters into
gold is not shattering, it is emitting confetti.

| lane | breaks by | debris |
| --- | --- | --- |
| tabl | shattering — hard, wide, a short sharp flare | 8 crystal chips in its own colour |
| swords | flashing — a wide ring and a colour bloom | none; a cut stone should flash, not leave rubble |
| tar | scattering — fewer, heavier, slower pieces | 5 gold or silver flakes |

The chips are the same irregular-convex trick as the shards but carry the
parent's material. Their **absorption is scaled up 2.6×**, not copied: a chip is
a fraction of a crystal's size so the path through it is a fraction as long,
and at the parent's coefficients it would come out nearly clear. Beer-Lambert
cuts both ways, so matching the *look* means raising the coefficient.

### The miss

A missed note is dropped, not deleted: it carries on past the line, tumbles and
falls away behind the keycap row, under a red bloom at the point it was lost.
Nothing else in the frame tells the player *which* note they lost — the screen
shake alone does not.

It falls **slower than it was travelling**. A note crosses the judgment line at
about 1.1 pt/ms (`dy/dz = -C/z²` is −425 at z = 1, and z covers 4 units in
`APPROACH_MS`), and carrying that speed on would take it off the bottom of the
screen in a fifth of a second — a blur, not a miss. It starts at half that and
gravity takes it back up.

It is **not** desaturated, though that was the first instinct. Canvas 2D can
only apply a blend mode to the whole destination, not to a single sprite, and
`ctx.filter` is not safe to rely on in an older iOS WebView; the alpha fade
against the dark deck carries it instead.

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

### The stage plate is painted once, properly

`AGENTS.md` has said "the backdrop is painted once" from the beginning, and the
plate half of it was not: everything below the join — the floor wash stretched
up from a 24×6 blur, the seam feather, the distance shade, the across gradient
and the floor grid — was five full-screen passes **every frame**. It cost 5 fps,
and the art path sat at 55 against the drawn path's 60.

Finding it took measurement rather than reading. Profiling the renderer's
sub-passes put the entire script cost at 0.21 ms/frame, which rules out code as
the answer and points at the rasteriser; an A/B that stubbed out one pass at a
time then put the whole 5 fps on `_plate`, and a second A/B inside it put ~4.5
on the floor wash alone. Two fixes that looked obvious measured **nothing** —
pre-scaling the plate image (it is upscaled every frame) and baking only the
wash — which is what showed the cost is the *number* of full-screen passes, not
the filtering of any one of them. Baking all five into one layer takes the art
path to 60.0 fps, level with the drawn one.

Verified by pixel diff against the previous build, with a control proving the
capture is deterministic: the runway deck is identical, the plate's
`drawImage` arguments and transform are byte-identical, and the residual is
zero-mean edge noise from resampling. One thing that did have to match: the
bake originally used `imageSmoothingQuality = 'high'` where the main context
uses `'low'`, which biased the whole plate; it now takes the context's own
setting.

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
- **The keycap glyph.** `deck/make_glyphs.js` renders it as its own sprite:
  rasterise the character, take the exact Euclidean distance from its edge
  (Felzenszwalb–Huttenlocher — a chamfer approximation's error is anisotropic
  and turns into visible striations on an S once the bevel differentiates it),
  raise that into a rounded bevel and light it with the same sources. The bevel
  is deliberately narrow (12 px against a ~40 px stroke): wider and the profile
  never plateaus, so the whole stroke creases along the letter's medial axis.
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

- **All percussion is synthesised** in `js/audio.js` — modelled on the real
  section rather than sampled from it (see below). Real Ardah percussion and,
  above all, the chant must be licensed or commissioned.
- **The stage is drawn with canvas paths** — a Diriyah-style fort with a lit
  gate, palms, green banners, brazier fires, a tiled plaza, two facing rows of
  five, and a tabl player and an oud player on stools. Stylised on purpose,
  dignified posture, no caricature. It follows the concept art's composition,
  but real artwork is commissioned and goes through cultural review first.
- **Charts are generated** from a groove table rather than authored against a
  recording.
- No backend, no leaderboard, no tutorial gate, no seasonal gating. Scores live
  in `localStorage`.

## The drum line

The sound is synthesised, and the thing being synthesised is a specific
ensemble rather than "some drums".

A Najdi Ardah drum section is not one instrument, and the character comes from
the relationship between two sizes of drum:

| | what it is | what it does |
|---|---|---|
| **takhmir** | the big double-headed drums, curved stick on one head, hand on the other | the slow heavy pulse, and almost nothing else — what you hear from across the square |
| **thakir** | the small tight drums | fill every gap between the takhmir; they are why the music feels fast while the big drums stay slow |
| **tar** | the frame drum, `dum` in the centre and `tak` at the rim | answers, and stops the bar from repeating itself |

Only three of those are lanes, because three lanes is a game decision, not a
musical one. Put the thakir fills in a lane and the chart becomes a 16th-note
wall nobody can play; leave them out and three drums a bar is a march. So they
live in an **ornament layer** in `chart.js`: scheduled on the same clock as
everything else, never turned into a note. The claps are the row's own hands
and belong to the chorus — that is the moment the crowd joins in.

### Why the drums are not oscillators with an envelope

That is what a drum machine sounds like. `_skin()` builds four things, and each
of them is audible by its absence:

- **Inharmonic modes.** A circular membrane rings at 1, 1.59, 2.14, 2.30, 2.65
  × its fundamental — the zeros of a Bessel function, not a harmonic series.
  That ratio set is why a drum has a pitch you can almost name but never quite.
- **A pitch drop at the strike.** The blow stretches the skin, so it starts
  sharp and settles within tens of milliseconds. Take this out and the biggest
  drum in the world is a sine wave. The takhmir starts a fifth and a half sharp
  and settles over 55 ms; that one number is most of its character.
- **A transient that is not the skin.** Stick on hide, palm on rim. It is most
  of what tells you *how* the drum was hit.
- **A body.** The shell and the air behind the skin, ringing around one
  frequency.

Measured alone, that gives six voices that are actually distinct rather than
three settings of one drum:

| voice | decay to −40 dB | spectral centroid |
|---|---|---|
| takhmir | 640 ms | 127 Hz |
| tar (`dum`) | 420 ms | 236 Hz |
| thakir | 300 ms | 305 Hz |
| tar (`tak`) | 240 ms | 564 Hz |
| claps | 440 ms | 2.4 kHz |
| sabres | 580 ms | 2.8 kHz |

### The three things that make it a row of people, not a drum machine

- **The courtyard.** An Ardah happens outdoors between stone walls. The
  convolution impulse is generated, not sampled (an IR is a file): 1.1 s of
  noise under an exponential decay, with a handful of discrete early
  reflections in the first 60 ms — walls close enough to hear individually —
  and a tail that darkens as it decays, because stone and air eat treble first.
- **The claps are eleven pairs of hands**, scattered across 28 ms with
  different levels and filter centres. The spread *is* the crowd; one loud clap
  is one person.
- **Nothing repeats exactly.** Every mode is detuned by a hair and every noise
  burst starts somewhere else in the buffer, all from a seeded PRNG rather than
  `Math.random` — so it varies, and it still reproduces.

The ornament layer is scattered by ±5 ms too, because a section that is
sample-accurate sounds like a machine. The scatter is **baked into the chart**
rather than applied at playback, so "the drums cannot drift from the chart"
stays literally true — and it is applied only to ornaments. A groove hit is the
cue a player is judged against; moving one by 5 ms is a bug wearing a
musician's hat.

### What is deliberately missing

The chanted poem. It is the heart of a real Ardah, and it is exactly what the
concept doc flags twice: the chant needs explicit rights (§11.2), and a
mis-scanned chant is a PR incident rather than a bug (§11.1). A synthetic voice
singing approximate Arabic would be the worst of both. Hand-claps are in,
because a clap has no scansion.

### Levels

`deck/audio_preview.js` renders the real engine through an `OfflineAudioContext`
and reports peak, RMS and a voice census per section. Current bed: peak −2.5 to
−3.3 dBFS, RMS ≈ −22.5 dBFS, and the safety limiter at the end of the chain
hangs unused — the loudest moment in the song (the flourish, measured with the
limiter bypassed) reaches −2.1 dBFS against a −1 dBFS threshold.

That is also how a long-standing bug surfaced: three places in the chart
builder wrote an accent on a slot the groove already played, so two identical
drums landed on the same sample — 6 dB up, perfectly in phase. It read as "the
flourish is loud". `pushDrum()` now merges anything of the same voice inside
12 ms and keeps the louder, because two hits that close are not two hits.

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
js/audio.js       the synthesised drum section, courtyard reverb, metronome
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
