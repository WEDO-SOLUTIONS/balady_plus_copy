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
| `car.png` | the results screen's rear shot, super-resolved | the car you steer, and the how-to screen |
| `driver.png` | the countdown screen's driver, matted separately | composited into the car's right-hand window at draw time |
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

The hero sprite is a composite. The camera sits behind the car — which is what
the receding track always implied — so the body comes from the results
screen's rear shot. That shot's driver faces away, so the countdown screen's
driver, who is turned towards the camera, is matted separately and hung out of
the right-hand window: the car leans left, so its right flank is the one in
the air, which is the side a drifter hangs out of. He is cropped above the
countdown car's roof line and faded out at the waist so he reads as continuing
down into the cabin. The two ship as separate sprites and are composited by `js/scene.js` at draw
time, using the SEAT / LIFT / SCALE constants the extractor documents. Baked
into one image they cost the car 15% of its resolution: his outstretched arms
widened the sprite's bounding box, and the sprite is normalised to a fixed
width, so a seventh of those pixels went to empty sky around his hands.

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

The plane is rendered into an offscreen GL canvas at nine tenths of device
resolution and no more than 1.25 MP, and blitted in with one `drawImage`,
which leaves the rest of the renderer untouched. A device that cannot hold the
frame gets fewer ground pixels rather than a slideshow. If WebGL is missing,
the context is lost, or the textures are cross-origin (a WebView running the
game off `file://` with separate asset files would taint them), `draw` returns
false and the painted floor takes over.

The textures are baked at golden hour only — a second set would double both
the download and the fills — so the evening is a multiply over the same sand,
band by band, fading out with the same ramp so it never spills onto the plates
above.

The **track** is the same mapping again, sampled in the same shader with the
tile centred on the track's centre line rather than on the frame, so the baked
ruts stay under the wheels. A
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
places everything through one `place(depth, lateral)`. Props hold a fixed spot
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

- **Dune flanks** either side of the track. The reference photograph is not a
  car on a plain, it is a car in a trough: the sand rises away from the wheel
  tracks on both sides, lit along one crest and in shadow along the other.
  That is painted as light rather than built as geometry, which keeps the
  texture underneath.
- **The outcrops the track runs between** (`img/bg/cliffs.png`, four cells of
  1024 px): flat caps of hard limestone over fluted vertical faces with an
  apron of talus, the way the Tuwaiq escarpment breaks up. They stand four to
  eleven track-widths out and are some twenty times the size of a roadside
  rock, which is what gives the horizon a shape to read.
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
