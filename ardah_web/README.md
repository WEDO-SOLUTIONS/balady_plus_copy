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

## Controls

| | Touch | Keyboard |
|---|---|---|
| Strike | tap a lane | `A` `S` `D`, or `←` `↓` `→` |
| Raise (hold) | press and hold, release on the last beat | hold the lane key |
| Flourish | swipe across the lanes | `Space` |
| Pause | — | `Esc` |

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
- **The performers are drawn silhouettes.** Stylised on purpose, dignified
  posture, no caricature — but real artwork goes through cultural review first.
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
css/ardah.css     menus; WebView hardening (no selection, no overscroll, safe areas)
js/i18n.js        ar/en strings, RTL flip (gameplay stays LTR by design)
js/bridge.js      dsBridge adapter, no-op in a browser
js/audio.js       synthesised zeer / tar / clap + metronome
js/chart.js       chart format, groove generator, validator
js/conductor.js   the audio clock and schedule-ahead loop
js/judge.js       windows, scoring, combo, sync meter  ← port this as-is
js/render.js      canvas: sky, lanes, notes, the row, HUD
js/input.js       pointer + keyboard, queueing correction, swipe detection
js/game.js        flow, calibration, storage, latency lab
js/main.js        DOM wiring and bootstrap
```

## Verified

Headless Chromium (Playwright), 390×844 @2x: audio context runs, 60 fps
throughout, pause suspends and resume restores the context, calibration
measures and persists an offset, judging and scoring behave, Arabic flips to
RTL, no console errors. Timing numbers from a headless run mean nothing —
measure on real devices.

## Next

1. Measure on a low-end Android and an iPhone, in a browser and in the WebView
   with the radio playing. Record `mean` and `jitter` per device.
2. Decide the path on those numbers (concept doc §6.4).
3. Only then: real audio, real art, authored charts, the tutorial gate.
