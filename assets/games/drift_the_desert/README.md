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
| `js/skygl.js`   | WebGL background: sky, sun, clouds, mesas, dunes, shimmer |
| `js/scene.js`   | Canvas renderer: perspective track, the car, dust, coins, FX (and the 2D background when the shader is off) |
| `js/game.js`    | Rules only, no DOM: balance physics, scoring, combo, coins, run lifecycle |
| `js/main.js`    | Screen flow, HUD bindings, FX layer, input |
| `img/`          | Artwork cut out of the mockup |
| `tools/extract_assets.py` | Re-derives `img/` from the mockup sheet |
| `build_standalone.py` | Inlines everything above into `dist/drift-the-desert.html` |

## Artwork

`img/` is derived from the design sheet (`Arabic_drift.png`, a 4x2 grid of
phone mockups) rather than hand-drawn, so the game reads as the design rather
than as an approximation of it:

| Asset | Where it comes from | Where it is used |
|-------|--------------------|------------------|
| `car.png` | the countdown screen's hero shot, alpha-matted | the car you steer, and the how-to screen |
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
pip install pillow "rembg[cpu]"
python3 tools/extract_assets.py /path/to/Arabic_drift.png
```

The two cut-outs are alpha-matted with `rembg`; the marks and icons are pulled
off their dark backgrounds with a luminance key; the scenery strips are clean
rectangles widened by mirroring. The mockup has no unobstructed full-width
background — the hero car sits in the middle of every screen — so the dunes,
the track geometry and the dust stay procedural and the photographic strips
scroll behind them.

Every image is optional at runtime: `js/scene.js` keeps its vector car, drawn
coin, gradient sky and generated mesas as fallbacks, so a missing or
slow-loading file degrades instead of leaving a blank frame.

## The background

Two stacked canvases. `#glscene` runs a single fragment shader — sky gradient,
sun bloom, drifting fBm clouds, two ranges of flat-topped buttes, three dune
ranges with lit crests, heat shimmer over the horizon and the aerial haze that
ties them together. `#scene` sits on top and draws only the track and the
actors, so the gameplay layer never had to change. Neither canvas carries a
`z-index`: they paint in DOM order, and the HUD, which comes after them, stays
above both.

The run also walks through the evening. A `dusk` value goes 0 → 1 across the
sixty seconds and drives both layers at once: the shader's palette slides from
golden hour into a red-violet dusk and drops the sun behind the mesas, while
the canvas darkens the track, dims its shoulders and the dust, and switches on
the headlights — a beam down the sand plus a flare on each lamp.

Speed is sold by more than the scrolling texture: the horizon lifts slightly,
the shader's vignette and shimmer tighten, and the canvas adds edge streaks, a
near-field smear and a veil of dust along the bottom of the frame.

### Keeping it safe on a weak GPU

A shader background is a luxury, so it is built to get out of the way:

- **It is optional.** If the context will not create, the shader will not
  compile or the context is lost mid-session, `DriftSky` disables itself and
  `js/scene.js` goes back to drawing its own photographic sky, mesas and dunes.
  That path is exercised in review by stubbing out `getContext('webgl')`.
- **It under-renders.** The layer is all gradients and noise, so it draws at a
  fraction of the device resolution and lets the compositor upscale it. That
  is the only lever that matters for fill rate, and the quality ladder walks
  down it: 0.50 → 0.36 → 0.26 of CSS pixels.
- **It measures itself.** `DriftSky.observe()` watches the real frame time and
  steps the ladder down when a 60-frame average goes over 26 ms; if the lowest
  tier still runs over 38 ms it falls back to the 2D scene entirely. Only
  downgrades are applied, so it cannot oscillate.

Under Chromium's software rasteriser — a reasonable stand-in for a poor mobile
GPU — the layer starts at ~21 fps, settles at ~39 fps after two downgrades, and
the 2D fallback runs at ~51 fps. On real hardware it should stay on the top
tier.

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
