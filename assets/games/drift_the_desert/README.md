# Drift the Desert — Balady+ Maps mini game

A self-contained HTML/CSS/JS game ("Arabic drift" / *hajwalah*): keep the SUV
balanced on two wheels for 60 seconds, collect coins, build a combo, earn
tokens. Built to run inside the Balady+ WebView and, unchanged, in a desktop
browser for review.

No build step, no bundler, no external requests: no CDN scripts, no web fonts,
no image or audio files. Everything is drawn on a `<canvas>` and the sound is
synthesised with the Web Audio API, so the whole mini app is ~100 KB of text and
works offline and from `file://`.

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
| `js/scene.js`   | Canvas renderer: sky, mesas, dunes, perspective track, the car, dust, coins |
| `js/game.js`    | Rules only, no DOM: balance physics, scoring, combo, coins, run lifecycle |
| `js/main.js`    | Screen flow, HUD bindings, FX layer, input |

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
