# Drift the Desert — Balady+ Maps mini game

A self-contained HTML/CSS/JS game ("Arabic drift" / *hajwalah*): keep the SUV
balanced on two wheels for 60 seconds, collect coins, build a combo, earn
tokens. Built to run inside the Balady+ WebView and, unchanged, in a desktop
browser for review.

No build step, no bundler, no external requests. The artwork in `img/` is cut
straight out of the design mockup (see **Artwork** below); everything else —
the animated desert, the dust, the whole soundtrack — is generated at runtime,
so the mini app ships no third-party code, no web fonts and no audio files. It
is ~520 KB in total and works offline and from `file://`.

## Run it in a browser

```bash
cd assets/games/drift_the_desert
python3 -m http.server 8777
# open http://127.0.0.1:8777/index.html
```

Opening `index.html` directly as a file works too. In a desktop browser, use a
narrow window (or the device toolbar at 390×844) — the layout is portrait
phone-first and centres itself on wide screens.

Query parameters:

| Parameter | Values     | Effect                                   |
|-----------|------------|------------------------------------------|
| `lang`    | `en`, `ar` | Forces the language (otherwise: host preference, then browser locale) |

Controls: the on-screen **TAP LEFT** / **TAP RIGHT** buttons, a tap anywhere on
the left/right half of the play area, or `←`/`→` (`A`/`D`) on a keyboard.
`Esc`/`P` pauses, `Enter`/`Space` starts a run.

## Single-file build

`dist/drift-the-desert.html` is the whole game — markup, styles and all six
scripts — inlined into one document. Use it to hand the game to a reviewer as a
single attachment, or for a WebView that can only be pointed at one file.
Open it by double-clicking; no server needed.

The multi-file sources stay the source of truth. Regenerate the bundle after
changing any of them:

```bash
cd assets/games/drift_the_desert
python3 build_standalone.py
```

Images are inlined as data URIs, which is most of the file's weight.

Only `index.html`, `css/`, `js/` and `img/` are registered in `pubspec.yaml`,
so `dist/`, `tools/`, this README and the build script are not shipped inside
the app.

## Run it in the app's WebView

The files are registered in the root `pubspec.yaml`, so `webview_flutter` can
load them straight out of the bundle — relative `css/` and `js/` paths resolve
correctly:

```dart
final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(Colors.transparent)
  ..addJavaScriptChannel(
    'DriftChannel',
    onMessageReceived: (message) {
      final payload = jsonDecode(message.message) as Map<String, dynamic>;
      switch (payload['event']) {
        case 'driftRunFinished':   // {score, time, combo, coins, tokens, crashed}
        case 'driftRewardsClaimed':// {tokens, level, xp, badgeUnlocked, skinUnlocked}
        case 'driftOpenMap':
        case 'driftClose':
      }
    },
  )
  ..loadFlutterAsset('assets/games/drift_the_desert/index.html');
```

Inside the mini-apps engine (`dsbridge_flutter`) no channel is needed: the game
detects `window.dsBridge` and calls the existing `closeCurrentMiniApp`,
`navigateToSuperAppScreen` and `trackEvent` handlers. `flutter_inappwebview`
hosts are detected via `callHandler` as well. With no host at all every call
degrades to a `console.info`, which is what makes the browser build work.

To preselect the language from Dart, inject `window.__DRIFT_LANG__ = 'ar';`
before load, or append `?lang=ar` to the asset URL.

## Files

| File            | Responsibility |
|-----------------|----------------|
| `index.html`    | The eight screens from the design (splash, how to play, countdown, HUD, results, rewards, pause) |
| `css/style.css` | Design tokens and layout — deep-green panels, gold CTAs, mint accents, RTL-aware |
| `js/i18n.js`    | EN/AR strings, `dir` switching |
| `js/bridge.js`  | Host detection, events out, `localStorage` persistence with a memory fallback |
| `js/audio.js`   | Procedural engine loop, taps, coins, combo, crash — no audio assets |
| `js/backdrop.js`| Draws the baked parallax plates |
| `js/ground.js`  | The WebGL ground plane: sand, road, motion blur, dusk |
| `js/sprites.js` | Draws a baked sprite sheet — props, cliffs — with haze and dusk |
| `js/plates.js`  | Generated: plate sizes and skyline curves |
| `js/scene.js`   | Canvas renderer: perspective track, the car, dust, coins, FX |
| `js/game.js`    | Rules only, no DOM: balance physics, scoring, combo, coins, run lifecycle |
| `js/main.js`    | Screen flow, HUD bindings, FX layer, input |
| `img/`          | Artwork cut out of the mockup |
| `img/bg/`       | Baked backdrop plates |
| `tools/extract_assets.py` | Re-derives `img/` from the mockup sheet |
| `tools/bake_background.html` | The offline shader the backdrop is rendered from |
| `tools/bake_background.js` | Renders the plates headlessly |
| `tools/pack_background.py` | Compresses them and emits `js/plates.js` |
| `build_standalone.py` | Inlines everything above into `dist/drift-the-desert.html` |

## Artwork

`img/` is derived from the design sheet (`Arabic_drift.png`, a 4x2 grid of
phone mockups) rather than hand-drawn, so the game reads as the design rather
than as an approximation of it:

| Asset | Where it comes from | Where it is used |
|-------|--------------------|------------------|
| `car.png` | a supplied studio rear shot of a Nissan Patrol, cut off its white | the car you steer, and the how-to screen |
| `driver.png` | the countdown screen's driver, matted separately | **not loaded** — the driver is out of the window for now |
| `coin.png` | a floating token on the danger screen | collectibles and the HUD coin pill |
| `sky.jpg` | a clean column of the splash sky, mirror-tiled | the scrolling sky |
| `ridge.png` | the splash mesas, mirror-tiled, both edges feathered | the parallax horizon |
| `results-art.jpg` | the results screen's sunset strip | the results screen |
| `logo.png`, `title.png` | the Balady+ mark and the brush wordmark | every screen header, the splash |
| `tokens.png`, `badge.png`, `skin.jpg` | the three reward cards | the rewards screen |
| `icon-*.png` | the results stat icons | the results cards |

Regenerate them with:

```bash
pip install pillow "rembg[cpu]" opencv-contrib-python-headless
curl -L -o tools/models/EDSR_x4.pb \
  https://raw.githubusercontent.com/Saafke/EDSR_Tensorflow/master/models/EDSR_x4.pb
python3 tools/extract_assets.py /path/to/Arabic_drift.png
```

The EDSR weights are 38 MB and are not versioned. They are optional — without
them the script falls back to Lanczos and says so — but worth fetching: the
crops are tiny and the game draws them large, and a super-resolution pass
recovers edge that sharpening cannot invent. On the rear car it brings back the
tail-light rims, the roof rails and the body seams, and it gives `rembg` a
better input, so the mattes come out cleaner too. EDSR beat FSRCNN and LapSRN
on these crops; Real-ESRGAN would likely beat all three but does not build
against the current toolchain.

The cut-outs are alpha-matted with `rembg`; the marks and icons are pulled off
their dark backgrounds with a luminance key; the scenery strips are clean
rectangles widened by mirroring.

The hero sprite is **a supplied studio photograph** of a Nissan Patrol Super
Safari, dead-on from behind, cut off its white background — not the mockup crop
it used to be. That crop was 90×88, which is why rembg returned a rounded
rectangle for it and the sprite carried a block of the original desert inside
its alpha; the slab that leaned out from under the car in play was that block,
and it is gone. The replacement is a genuine outline, with daylight between the
wheels, so the car now casts its **own silhouette** as a shadow the way the
roadside props do, and that shadow is the only thing holding it on the ground.

Three constants had to move with it. `x0` goes from `-w * 0.46` to `-w * 0.50`,
because a dead-on rear pivots on its middle and a three-quarter crop did not.
`y0` becomes `-h * 0.674`, which is what puts the tyres on the shadow line for
the new aspect — the sprite's foot lands `0.345 × size` below the car's centre,
exactly where it did before. And `CAR_LEAN` drops from `-0.30` to `-0.07`:
seventeen degrees of roll read as a drift lean on a three-quarter view, but on
a dead-on rear it reads as tipping over, and it swung the tyres up to 51 px off
the shadow line, which was most of what made the new sprite look like it was
hovering. The tail-lamp glow positions are measured off the sprite rather than
guessed — the red clusters sit at 0.055 and 0.936 of its width, halfway up.

**It rides on two wheels, and the pivot is what makes that work.** Rolled about
the car's *centre* — which is what the code did — a lean lifts both wheel sets
off the ground at once: at `-0.30` the tyres swung up to 51 px clear of the
shadow line and the car simply hovered, which is why it had to be flattened to
`-0.07`, and flat it read as driving on all four. Rolling about the **contact
tyre** is what the pose actually is: the down-side wheels stay planted and the
up-side wheels lift. So the lean can go back to something you can see —
`CAR_LEAN` is `-0.785` — **45° to the ground** — and steering is worth `0.15`
rather than `0.24`, which used to cancel the lean at full lock and set the car
back down. The roll runs 54° to 36° and it is never on four wheels.

Two things follow from an angle that steep. Rolling about a tyre swings the
body *sideways* as well as up, and at 45° that walked the car off the screen —
its box ran from −37 to 247 across a 390-wide frame. The whole draw is slid
back by however far the rotation moved the sprite's centre, which re-centres it
without lifting the tyre, because a horizontal shift cannot change a height.

And the pivot is the **outer edge** of the planted tread, not its centre. Seen
from behind a wheel is a tread, not a circle, and under an anticlockwise roll
the point that goes lowest is its outer shoulder — which is also what a car
rolls onto when it comes up on two. Pinned at the tread's centre the real
contact slid up to 29 px away from the pivot across the steering range and the
contact pool sat beside the tyre instead of under it. Measured off the sprite:
the left tread runs 0.053 to 0.199 of the width, the right one centres on
0.848, and both tyres bottom out on the same row.

The cast shadow is rolled about the same tyre *before* it is sheared, so what
gets projected is the car in the pose it is actually in and the shadow narrows
as the far wheels come up. On its own that still read as hovering: the shear
carries the ink away to the right and leaves bright sand at the contact itself,
which is exactly where a real shadow is darkest. A tight pool of dark sits on
the pivot to fix that, and tracks whichever way the car is rolled.

The car is also smaller and lower than it was — `0.46 / 0.22` of the frame
instead of `0.52 / 0.25`, at `0.700` of its height instead of `0.655`. The
Patrol crop fills more of its own sprite than the old three-quarter one did, so
the old numbers put a bigger car higher up the frame than they used to.

**The driver is out of the window for now.** Both paths lost him, the photo
composite and the painted fallback; `img/driver.png` is no longer loaded and
`drawDriver` and the SEAT / LIFT / DRIVER constants are kept, unused, so that
putting him back is a line rather than a rewrite.

> A trap worth knowing: `build_standalone.py` rewrites **every** `img/…` string
> it finds in the sources, comments included. A comment saying which sprite is
> no longer loaded embedded 40 KB of base64 for a sprite nobody draws. Write
> the bare filename in prose, not the path.

### The resolution ceiling

The car body is now 520 px of sprite drawn at about 480 device pixels on a
phone — roughly 1:1, so nothing further is to be had from resampling,
sharpening or drawing it smaller. What is left is baked in: the source is 90 px
wide. A genuinely crisp car needs a bigger original — the designer's render,
a stock rear three-quarter of a Land Cruiser, or a generated one. Dropping it
in is a small change: the pipeline below already mattes, seats and draws. Three details of the matting matter:
the default `rembg` thresholds eat his sleeves (white on a bright sky), so he
is matted gently; a loose matte then picks up a corner of the countdown panel,
which `largest_blob` drops; and sharpening has to happen before compositing,
or the unsharp pass rings his edge against the dark rear window and draws a
pale box around him.

The rear shot is only 90 px wide on the sheet and the game draws it six times
that, so it goes through EDSR before anything else touches it. The mockup has no unobstructed full-width
background — the hero car sits in the middle of every screen — so the dunes,
the track geometry and the dust stay procedural and the photographic strips
scroll behind them.

Every image is optional at runtime: `js/scene.js` keeps its vector car, drawn
coin, gradient sky and generated mesas as fallbacks, so a missing or
slow-loading file degrades instead of leaving a blank frame.

## The background

Four plates scroll behind the track at their own speeds: sky, a far range of
buttes, a near range, and the dune field. They are not drawn live — they are
**baked offline** and shipped as images.

That is the whole trick. Rendering the desert per frame meant fitting it into
the budget of a cheap Android GPU, which capped it at four octaves of noise and
flat, untextured rock. Baking moves that cost to build time, where there is no
budget at all: `tools/bake_background.html` is the same shader with eight
octaves, sedimentary strata and erosion gullies in the rock, wind ripples and
rim light on the dunes, two cloud decks and crepuscular rays. Rendering one
frame of it would be hopeless on a phone; rendering it once on a build machine
costs a few seconds.

```bash
node   tools/bake_background.js     # render the plates (needs playwright)
python3 tools/pack_background.py    # compress them, emit js/plates.js
```

Three things make the result cheap to ship and to draw:

- **Seamless.** The noise is sampled around a cylinder in x, so a plate's left
  and right edges are the same point and the parallax wraps forever.
- **No alpha.** A terrain plate is opaque below a per-column skyline, so the
  colour goes out as a JPEG and the silhouette as a height curve of a few
  hundred bytes that `js/backdrop.js` replays as a clip path. That took a
  2048×480 layer from ~900 KB as RGBA PNG to ~30 KB. All eight plates plus the
  curves come to ~435 KB.
- **Baked at 2048.** A plate is stretched to its layer's on-screen height and
  tiled at whatever width that implies: on a 412 CSS phone the sky tile lands
  near 1700 device px at DPR 2 and 2500 at DPR 3, so the old 1280 was visibly
  upscaled. Every plate is now downsampled instead. Each pixel is also four
  jittered samples rather than one — the strata, the wind ripples and the
  silhouettes are all high-frequency enough to alias, and supersampling is
  free when it happens at build time. The JPEGs go out at quality 94 with no
  chroma subsampling: a plate is the whole background, and colour smear along
  a dune crest is exactly what the eye picks up.
- **Two times of day.** A golden-hour and a dusk bake, cross-faded by the same
  `dusk` value that drives the rest of the run, with either draw skipped once
  its weight rounds away.

## Holding still

A racing frame is mostly motion, so the things that are *not* supposed to move
have to be watched carefully. Four of them were not:

- **The horizon** was rounded to a whole pixel and followed the speed frame by
  frame, so it stepped — and everything hung off it stepped too. It is a
  smooth fraction now, easing towards the speed over about half a second.
- **The plates** are deliberately not snapped to whole pixels. One creeps a
  fraction of a pixel per frame; snapping makes it sit still for eight frames
  and then jump one, which is the shimmer sub-pixel placement exists to avoid.
- **The GL canvas** was sized from the current horizon, so it was reallocated
  every time the horizon crossed a pixel. It is sized from the highest the
  horizon ever goes, and the horizon is passed in as a uniform.
- **The horizon itself** now carries its own dust: a warm band across the
  skyline with a few billows drifting on the wind, slowly enough to read as
  weather rather than as flicker. It hides the join where the baked plates
  stop and the ground plane begins, and it gives everything arriving from the
  distance the same tan to arrive out of.
- **The speed streaks** switched on at full weight exactly on the horizon line
  and switched off at the bottom of the frame — nine of them, twice a second.
  They start below the skyline now and fade in and out along the way.

Anything arriving from the distance reaches the dust colour **completely** at
the far end of the band — not most of the way there — and the short fade that
brings it in happens there, while it is still that colour. Both halves matter.
Fading in over the part of the run where the haze has already let go makes a
thing look like a ghost of itself for its whole approach, which is what the
cliffs did; switching on at four fifths of its weight pops.

That puts a limit on how far off the road a landmark can stand. Its inner edge
leaves the frame when `(distance − width) × scale` passes the half-width, so a
taller rock at the same distance stays in view far longer; push one out until
it is gone before the haze releases it and it is never seen as rock at all.
The outcrops sit at twenty-three to thirty-four metres and stand twenty-five to
forty tall, which is the ratio that lets them come clear of the dust while
there is still a second or two of them left. The ground's own far field is
biased several mip levels coarser, because a few rows below the skyline one
screen pixel covers thousands of texels and whichever of them the filter lands
on changes fast enough to crawl.

## The ground

The floor is the one surface the player stares at for a whole run, and a
gradient with lines drawn on it was never going to pass for sand. So the
bake also produces two square, tileable ground textures — the open sand and
the track — and `js/ground.js` maps them onto the ground plane in perspective
(`tools/bake_background.html`, layers 4 and 6).

The mapping is the standard one for a pinhole camera looking at a plane: with
`t` running 0 at the horizon to 1 at the bottom of the frame, depth goes as
`1/t`, so a texel is `t` wide and `t²` tall on screen.

**This is done in WebGL, and the reason is worth writing down**, because two
Canvas-2D versions came first and both looked wrong in ways that were hard to
name. A 2D context can only fill a shape with a pattern under an affine
transform, and perspective is not affine. The usual dodge is to cut the floor
into horizontal bands and give each the transform that is right at its middle.
In a still frame that is invisible. In motion it is not: the texture inside a
band translates at one uniform rate and the band below it at another, so every
seam is a step in velocity and the floor reads as a stack of conveyor belts —
stripes pouring down the screen rather than ground going past a car. Varying
the motion blur per band added a second set of stripes, in sharpness.

So the plane is two triangles with the mapping done per pixel:

- **Exact perspective.** Every pixel computes its own depth and lateral
  offset, so there is nothing to step between.
- **Hardware filtering.** Mipmaps and anisotropic filtering are what actually
  stop sand crawling at a grazing angle, and a pattern fill has neither. This
  is the single biggest reason the GPU path looks calmer than the hand-rolled
  mip chain it replaced.
- **Motion blur in the shader**, two taps back along the direction of travel,
  the length taken from how far the car moved this frame. It varies smoothly
  with depth on its own, because a fixed offset in texels is a larger offset
  on screen the closer it is.
- **The road in the same pass**, sampled from its own texture with the tile
  centred on the track and blended in through the same wobbling edge the
  painted track uses — no clip, no second pass.

The plane is rendered into an offscreen GL canvas at device resolution and no
more than 1.7 MP, and blitted in with one `drawImage`,
which leaves the rest of the renderer untouched. A device that cannot hold the
frame gets fewer ground pixels rather than a slideshow. If WebGL is missing,
the context is lost, or the textures are cross-origin (a WebView running the
game off `file://` with separate asset files would taint them), `draw` returns
false and the painted floor takes over.

The textures are baked at golden hour only — a second set would double both
the download and the fills — so the evening is a multiply over the same sand,
band by band, fading out with the same ramp so it never spills onto the plates
above.

The **track** is the same mapping again, sampled in the same shader. Three
things about it are worth knowing.

It is a **road, not a trapezoid**. The width used to be fitted to the screen —
a fraction of the frame at the car, a larger fraction at the horizon — which
made it nearly three times wider in the world at the far end than at the near
one. Everything lined up against its edges therefore slid sideways on the way
in, and the texture had to stretch to fit. The half-width is a constant in
world texels now and only the projection narrows it.

It **bends**, over hundreds of metres. The meander used to be baked into the
texture, where the longest wavelength available is one tile — about five
metres of desert, which arrives twice a second and reads as the road snaking.
It is a property of the centre line now: two long sines of absolute distance,
measured relative to the car's own place on them so the car stays on the road,
and computed identically in `js/ground.js` and in its shader so the painted
edges and the textured surface cannot part company.

Its tile spans **the road** rather than two screen widths, which is twice the
texels across the part of the frame the player actually looks at. That makes a
texel about half as wide as it is long, so the bake lays its gravel out on a
lattice with fewer cells across than along — stones come out round on screen
rather than stretched into lozenges. A
desert track in Saudi is not a road: it is a braid of tyre ruts worn through
the loose sand into the crust underneath, so the texture is seven meandering
grooves with tread in the bottom of them, berms of thrown sand along their
edges, gravel shouldered out to the sides, and drag streaks running with the
traffic. It is paler and smoother than the dune it cuts across, but only a
little — a heavier hand turned it into a concrete strip laid across the
desert. The band fades back into ordinary sand at the edges of the tile,
because the blend edge is never exactly a tile wide. Over the top of it the
painted track is down to a 12% wash that only feathers the edges and carries
the fade into the horizon.

## One clock

Everything standing on the ground — rocks, bushes, the outcrops, the coins,
the drift of sand along the track's shoulder — is placed by **depth**, in the
same texels the ground texture is measured in, and depth shrinks as the world
comes at you. That is the only way any of it can move with the road.

It is worth being explicit about why, because the first version had each of
them on a clock of its own and they visibly slid against each other. The
ground is a true perspective plane: a thing twice as far away takes more than
twice as long to arrive, because the time to cover a depth is what is uniform,
not the time to cross the frame. Anything advancing evenly in *screen* terms —
props stepping through a 0…1 parameter, coins on a fixed two-and-a-half second
run in, a shoulder wobble keyed to the clock rather than to the sand —
accelerates differently from the floor underneath it, and the eye reads that
immediately even when it cannot name it.

So `js/ground.js` publishes the metrics (the depth at the bottom of the frame,
the texels-per-pixel at that depth, the distance travelled) and the scene
places everything through one `place(depth, lateral)`. The stretch of desert
that is tracked is a **fixed length of world** — about a hundred metres — and
not, as it first was, a multiple of the depth at the bottom of the frame. That
depth is a camera measurement: it moves with the horizon, the horizon moves
with speed, and so every rock and cliff in the desert was quietly re-laid-out
whenever the car sped up. Freezing the world and nudging the horizon ten
pixels used to shift things by 3.6% of their distance; it now shifts them by
nothing at all. Props hold a fixed spot
in the desert and wrap round the band as it passes them. Coins keep the rules'
own 0…1 progress, but it is mapped onto a depth band picked so its rate equals
the ground's exactly, and `js/game.js` scales it by speed so the two stay
locked at any velocity. The shoulder wobble is a function of depth, in both
the scene and the shader, so the drift comes at the camera instead of sliding
along the horizon. Measured frame to frame at 1/60 s: a prop at `t` = 0.42
moves 3.53 px against the ground's 3.59 at the same depth, and a coin loses
exactly the depth the ground does.

The backdrop plates are the other half of it. Driving straight at a ridge a
kilometre off does not move it sideways; drifting past it does. So the plates
take most of their offset from the car's lean now and only a trickle from the
distance covered, where before the whole background slid along at a fixed rate
whatever the car was doing.

Three more passes sit on the floor, all of them live because they have to
move with the car rather than slide sideways under parallax:

- **Dune flanks** either side of the track, in the painted fallback only.
  Sized correctly in the world, a metre-and-a-half bank beside the road covers
  a large part of the near frame — and a wash cannot occlude what is behind
  it, so over the textured floor all it did was lay a translucent wedge across
  the sand. The ground texture and the road's own berms carry the shoulder.
- **The outcrops the track runs between** (`img/bg/cliffs.png`, ten cells of
  1024 px, two columns by five): **ten landforms, and two different rocks.**
  The escarpment that runs past Riyadh is Tuwaiq limestone — pale cream-grey,
  flat-topped, ruled into thin courses — and two cells are that: a long low
  escarpment wall and a butte. The other six are the Hegra and Al-Ula
  sandstone, which is a different rock and reads nothing like it: warm honey
  to rust, *massive* rather than thin-bedded (seven courses where the
  limestone has twenty-one), rounded on top, and **undercut at the foot**,
  because the sand the wind carries never gets more than a metre or two off
  the ground and that is where it does its work. A massif, a pedestal, a
  wind-polished dome, a pinnacle, a cuesta with its beds dipping one way, and
  a stack cut at the waist, a **natural arch** and a **group of towers**.
  Crossbedding, from the dunes the rock was laid down as, runs through them at
  an angle; tafoni — the honeycomb pitting — eats into the shaded lower faces.
  Drawing every one of them as a thin-bedded layered mesa is what made the set
  read as Utah.

  The arch is a half-ellipse of nothing *cut out of the mask*, widest at the
  ground and closing to a rounded crown, rather than built from two legs and a
  lintel — so the span and its legs stay one piece of rock with one set of
  bedding running through them. Kept near the middle: offset to one side with
  a thin leg on that side, it reads as a cave mouth bitten into a cliff
  instead. The group of towers is likewise one mass with clefts cut down into
  it, stopping short of the foot so the three of them rise off a shared
  plinth, each with its own skyline — the way they stand in Wadi Disah. Three
  separate silhouettes would have meant three of everything below.

  Each instance is mirrored on a coin-flip and stretched over 0.86–1.28 of its
  height, which is two more axes of variation for no extra texture; the
  half-width used to place it carries the stretch, or the frame-edge exit the
  whole placement is built on stops being where it says. Courses of unequal
  thickness, each with its own tone, two or three of them standing proud far
  enough to step the silhouette and throw a shadow line on the bed below;
  manganese streaks down from the rim; fallen blocks in the talus. Four of
  them, out near the edge of the frame, and they **alternate sides**: the
  depth slots are spaced evenly around the band rather than scattered by a
  hash, so they wrap — and so arrive — in index order, and the side can come
  straight off the index. An odd count breaks it; six or four do not.

  **Distance and height are one quantity, not two.** They used to be hashed
  independently, so far-out times short was a speck and close times tall was a
  wall — and the wall came up often enough to be the thing you noticed:
  measured, one reached **68% of the frame** while still on screen, and the
  cliffs covered 13.4% of the frame on average. They are now chosen as a pair:
  `tExit`, the depth at which the inner edge finally clears the frame, and
  `tall`, how much of the frame it fills at that moment, which is its largest.
  Both the size and the offset from the road then grow with the same `grow =
  t / tExit`, so at `grow = 1` the inner edge is half a frame plus half a
  sprite from the centre — the frame edge, by construction. No pair of hashes
  can make a wall, and none can make a speck. Measured after: **36% of the
  frame at worst, 5.2% mean coverage.**

  The haze has to outlast the fade-in. When the two ramps overlapped, a cliff
  at half opacity was already half its own colour — a rock fading up out of
  nothing rather than dust resolving into a rock. These also leave the frame
  *sideways* rather than by going past the camera, so on the shared fade ramp
  the nearest-exiting of them was still fading up as it left; cliffs carry
  their own `ramp` of 0.20 against the props' 0.5. One is 93% dust at half
  opacity and clear of the haze before it reaches the frame edge.

  **They stand where the ground actually is.** The textured plane used to be
  invisible until `t = 0.045` and only fully opaque at `t = 0.21` — a 109 px
  band below the horizon whose only ground was the painted dunes plate, which
  slides on its own clock rather than the world's. Every outcrop lives in
  exactly that band, so they were solid rock on a surface that was not there:
  measured, one at `t = 0.076` was fully opaque over ground drawn at **19%**,
  and the two nearer the horizon stood on **0%**. That is what read as
  floating, and as not moving with everything else — what they were standing
  on genuinely was not moving with everything else. The ramp is now
  `(t − 0.008) / 0.075`, opaque by `t = 0.083` (43 px below the horizon rather
  than 109), and the same three cliffs stand on 32%, 45% and 91%.

  A cliff then clears its haze on a schedule tied to that ramp, at
  `GROUND_IN × 0.84`, so it is never conspicuously more present than what it
  stands on. Tying the two *exactly* was the first attempt and it is too
  strict — the horizon dust lies over the sand as well, so ground drawn at 60%
  does not read as 60% of a surface, and matching a cliff to that number
  bleached it to nothing. Measured now: 10% solid on 32% ground, 62% on 61%,
  100% on 91%.

  Drawing ground that close to the horizon raises the frame-to-frame delta in
  that band from 2.61 to 3.06. That is not shimmer returning — raising the LOD
  bias, which is what would fix aliasing, barely moves it (3.12 → 3.03). It is
  the band no longer being a nearly-static painted plate, which is the whole
  point.

  **Each sheet stands on its own baseline.** `Sheet.draw` assumed every
  subject sat at 0.95 of its cell. Measured off the alpha, the props end at
  0.986 and the cliffs at 0.963 — so the two sheets were on two different
  ground lines, each sunk below its own by a few per cent of its height. The
  figure is now measured by `tools/pack_background.py` and carried per sheet
  in `plates.js`, at the depth the subject is *solid* rather than where its
  last faint pixel is — a cliff's talus dissolves over the bottom of its cell
  now, and putting the ground line at the end of that tail would hang the rock
  above its own dust.

  **And the foot dissolves.** Getting the ground underneath right did not stop
  the distant ones reading as floating, because the sprite was still cut off
  *square* across the bottom of its cell. At distance that dead straight
  horizontal edge is the whole of what the eye needs to call something a
  cut-out pasted on the desert. The silhouette now ends on an irregular line
  and fades out over the last 5% of the cell — and the colour gets there
  first: the talus goes to blown sand *before* the alpha starts dropping,
  because fading it out as it stood left a dark speckled fringe round every
  foot, and a dark fringe reads as a cut-out just as plainly as the straight
  edge did.

  **An undercut still reaches the ground.** Run all the way down to `up = 0`,
  the waist ate the whole base: measured on the pedestal, its half-width went
  from 0.98 of its widest at seven tenths height to **0.32, 0.13, 0.05 and
  then nothing** — a boulder balanced on a needle, and a needle that then
  dissolves into sand is a boulder hanging in the air. The wind hollows a
  rock's flank; it does not saw through it. The waist is now a band that stops
  short of the ground and lets the rock flare back out into a foot, with sand
  banked against it — held full a little way *up* the rock rather than peaking
  at `up = 0`, which is exactly where the foot is dissolving, because a bank
  drawn at one fifth opacity is not a bank. Same measurement after: **0.82 at
  the same height, and 0.91 below it.**

  Three more shape traps, all of which produced a silhouette rather than a bug.
  The weathering notch subtracted a *fixed* depth from the half-width, which
  is wider than a pinnacle is — it cut clean through and left the tip floating
  above the break as a separate island; clamped to a share of the width it
  was biting into, it severed nothing, but a waist nipped into something that
  narrow still turns a spire into a bottle, so the notch stays off a pinnacle
  entirely. And the rounded crown was an arc measured across the *cell*, while
  the rock is not as wide as its cell — only the middle third of the curve
  ever showed, which is why the dome kept coming out flat on top however far
  the arc was pushed. Measuring it across the rock's own width meant choosing
  the width before the cap rather than after.

  **A lump in the draw.** The per-lap choices — which landform, mirrored or
  not, how wide — came off the same `sin`-based hash as everything else, with
  a lap counter stepping its input by one. That hash is uniform over hundreds
  of steps but lumpy over a handful, which is all a lap counter ever gets:
  measured over the first four laps it covered five of the six landforms,
  drawing one of them six times in sixteen and another not at all. Those
  draws now use an integer mix (`ihash`), which covers all six over the same
  four laps. Both are uniform in the long run; the argument is entirely about
  the short one, which is the only run a session actually plays.

  One sheet serves both sides of the road, so strong directional shading
  cannot be right for both: whichever flank it made dark became a black wall
  up the edge of the frame for the cliffs on that side. The palette is flat
  and pale, and the shadow side is filled the way sand bounces light into a
  real one — measured, a cliff now averages RGB (141, 103, 69) against sand
  at (138, 107, 81).
- **Roadside props** — from a second baked sheet (`img/bg/props.png`, twelve
  cells of 512 px) — streaming out of the horizon along both shoulders and
  swelling as they pass. The plates give depth but no
  speed; these are what sell how fast the car is going. Each fades into the
  horizon haze weighted by apparent size rather than by depth, since the
  projection is `d^2.35`. Haze and dusk are a flat-coloured copy of the sheet
  drawn over the sprite — source-over for the haze, multiply for the evening —
  because there is no cheap way to tint a `drawImage`, and the copy is rebuilt
  only when the quantised time of day moves.
- **Wind swells and blowing sand**: the painted ripple bands from before, at a
  third of their weight now that the texture has real ones, plus a handful of
  soft sheets crossing on the wind instead of rushing at the camera.

The run still walks through the evening: the palette slides into a red-violet
dusk, the canvas darkens the track, dims its shoulders and the dust, and
switches on the headlights. Speed lifts the horizon, adds edge streaks, a
near-field smear and a veil of dust along the bottom of the frame.

**The ground rush** (`drawGroundRush`) is the sand blowing back under the car,
and it had two faults. It arrived rather than grew: the ramp read 9% at the
speed a run starts at and reached full only at the 700 cap, so it was
invisible through the first half and then it was simply there. Speed never
drops below the 260 base, so the range now starts there and the curve is eased
to put the growth early — **22% at the start, 44% a third in, 57% mid-run**,
against 9 / 24 / 39 before.

And each streak sat in a *fixed* lane. Sixteen of them on sixteen hashed but
constant x positions meant the same sixteen columns of sand, over and over —
measured, one position per streak, sixteen in total, forever. Drawing the lane
from the streak's index *and its lap* gives 584 distinct positions over 120
laps. They also ran nearly vertically, which reads as falling past the camera
rather than rushing away under it; a streak is a length of *ground*, so its
two ends are now one world point projected at two depths, and its lateral
offset scales with depth exactly as everything else in the scene does. Rates
are per-streak too — five shared rates had them beating together — and there
are 26 at lower weight rather than 16 at higher, so it reads as a field rather
than as a set of sticks.

**The side streaks** (`drawSpeedLines`) got the same treatment, for the same
reasons: the eased ramp from the base speed, a side and a band drawn per lap
rather than fixed by index — nine of them alternating sides on `i % 2` at one
shared rate came past in the same order all run — and the two-depth projection,
so they lean out harder the closer they get instead of holding one angle the
whole way down the frame.

If a plate fails to decode, `backdrop.ready` stays false and `js/scene.js`
falls back to drawing its own sky, mesas and dunes from the mockup strips —
the path that shipped before the plates existed. Blocking `img/bg/*.jpg` in
devtools exercises it.

Frame rates measured here are not worth much: Chromium's software rasteriser
runs the ground's shader on the CPU, with anisotropic filtering, which is
exactly the work a phone GPU does for free. For the record the whole scene
sits at 13–20 fps under it. The thing to compare is the shape of the work —
one shader pass over a megapixel, against the hundred-odd pattern fills the
2D version needed for the same picture.

## Making it Saudi

The first version of all this was a generic desert: Sahara-yellow sand,
red-brown rock, green tussocks. Arabia is specific, and most of the specifics
are cheap to honour:

- **The sand is red.** Nefud and Rub' al Khali quartz is coated in iron oxide,
  which is why the dunes photograph apricot in the sun and rust in the shade.
  The ground texture, the dune plates and the track all share that palette;
  the paler patches in it are where the wind has stripped the coating off.
- **The escarpment is limestone.** The buttes on the horizon are Tuwaiq, the
  cliff that runs past Riyadh: pale cream-grey, flat-topped, bedded in
  horizontal strata. They are the one thing in the frame that is not warm.
- **The gravel is two rocks.** Desert pavement out here is chalky limestone
  spalled off that escarpment together with dark ironstone blown clean by the
  wind, so both the ground texture and the prop sheet carry the pair of them —
  three limestone slabs, flat and angular, and two rounded ironstone boulders.
- **The plants are the local ones.** Seven of them: two straw tussocks
  (thumam, arfaj), two grey-green whip shrubs (ghada, arta), a bleached dead
  one, a low saltbush mound, and a thorn bush on a short trunk. All of them
  are grey-green or straw, never the green of somewhere it rains.
- **The air is dusty.** There is always a tan band standing on the horizon at
  this time of day, and without it the sky read as somewhere much wetter than
  Arabia.

## How the game works

`tilt` runs from −1 to +1. Zero is the sweet spot of a two-wheel drift, −1 is
flipping onto its side ("TOO FAR LEFT"), +1 is dropping back onto four wheels.
It sits at an *unstable* equilibrium — the further off balance the car is, the
harder it is pulled further, plus a wind gust term — so it always needs input:

```
vel += (instability * tilt + gust) * dt
vel -= vel * damping * dt
tilt += vel * dt
```

Tapping left or right applies an impulse against the lean. Instability and gust
both ramp up across the 60-second run. Zones: `|tilt| < 0.30` is GREAT (full
score rate, builds combo), `< 0.58` is GOOD (55% score rate, holds combo),
beyond that is the danger zone (no score, combo lost), and `1.0` ends the run.

Coins approach from the horizon in a left, centre or right lane, and are only
collected if you are leaning that way — which is exactly what costs you
balance. That trade-off is the game.

All constants live in `CONFIG` at the top of `js/game.js`.

## Tuning check

`js/game.js` has no DOM dependency, so the difficulty curve can be simulated
headlessly. Driving it with reaction-time-limited bots gives:

| Player            | Survived | Score | Max combo |
|-------------------|----------|-------|-----------|
| 120 ms reactions  | 60 s     | ~5100 | x30       |
| 380 ms reactions  | 60 s     | ~3100 | x16       |
| 700 ms reactions  | ~36 s    | ~1400 | x7        |
| no input          | ~10 s    | ~400  | x3        |

## Rewards

Tokens are `score / 60 + coins × 2`. Each level costs 500 XP (1 token = 1 XP).
The *Desert Drifter* badge unlocks at 1 500 points, the *Sand Edition* skin at
level 3. Progress persists in `localStorage` under `drift_the_desert_v1` and is
also reported to the host, which should treat its own copy as authoritative.

## Debug handle

`window.DriftApp` exposes `{ game, show, startRun, openRewards, scene }` for the
WebView inspector and for automated screenshots — e.g. `DriftApp.game.tilt = -0.8`
to force the danger state.
