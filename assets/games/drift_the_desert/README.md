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
| `car.png` | the results screen's rear shot, super-resolved, with the countdown screen's driver matted into the right-hand window | the car you steer, and the how-to screen |
| `coin.png` | a floating token on the danger screen | collectibles and the HUD coin pill |
| `sky.jpg` | a clean column of the splash sky, mirror-tiled | the scrolling sky |
| `ridge.png` | the splash mesas, mirror-tiled, both edges feathered | the parallax horizon |
| `sand.jpg` | the countdown screen's foreground track | the track's perspective texture |
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
down into the cabin. His sprite is wider than his torso — arms out — so the
seat position is tuned by eye rather than computed, and `js/scene.js` pivots
the sprite on the car body's measured centre (0.39 of the sprite) rather than
on the sprite's own. Three details of the matting matter:
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
  1280×300 layer from ~400 KB as RGBA PNG to ~25 KB. All eight plates plus the
  curves come to ~220 KB.
- **Two times of day.** A golden-hour and a dusk bake, cross-faded by the same
  `dusk` value that drives the rest of the run, with either draw skipped once
  its weight rounds away.

The run still walks through the evening: the palette slides into a red-violet
dusk, the canvas darkens the track, dims its shoulders and the dust, and
switches on the headlights. Speed lifts the horizon, adds edge streaks, a
near-field smear and a veil of dust along the bottom of the frame.

If a plate fails to decode, `backdrop.ready` stays false and `js/scene.js`
falls back to drawing its own sky, mesas and dunes from the mockup strips —
the path that shipped before the plates existed. Blocking `img/bg/*.jpg` in
devtools exercises it.

Baking also made the game faster: under Chromium's software rasteriser the
plates run at 43–57 fps where the live shader managed 21–39.

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
