# Ardah web prototype — agent context

P0 prototype of the Ardah rhythm game as a standalone web app, meant to run
both in a browser and inside the Balady+ mini-app WebView. Background and the
decision it exists to settle: [`docs/ardah-concept.md`](../docs/ardah-concept.md).

## Rules that are not style preferences

- **No build step, no dependencies, no network.** Classic `<script>` tags (not
  ES modules) so `file://` works; no CDN, no web fonts, no audio files. If a
  change needs npm, it is the wrong change for this folder.
- **The audio clock is the master.** Never drive timing from
  `requestAnimationFrame` deltas or `setTimeout`. `js/conductor.js` owns the
  clock; everything else asks it.
- **Two clocks, deliberately different.** `judgeTimeMs` carries the measured
  calibration offset; `visualTimeMs` carries the browser's reported output
  latency. Do not collapse them into one.
- **Nothing DOM-shaped during a run.** Menus are DOM, the run is canvas only —
  a layout pass mid-run costs frames in a composited WebView.
- **The backdrop is painted once.** `scene.js` renders the static half (sky,
  fort, bunting, plaza) into an offscreen canvas on resize; only firelight, the
  performers, the drummers and the notes are per-frame work. Adding per-frame
  drawing to the static half is how this scene stops holding 60 fps.
- **`js/judge.js` stays pure.** No canvas, no audio, no globals: it is the part
  a native rewrite would port line for line, and the part worth unit tests.
- **The bridge surface stays minimal.** Analytics and best-effort haptics. No
  SSO token, no location, no camera — the game needs none of them.

## Tone

Ardah is ceremonial heritage. The loss state is *the row lost its sync*, never
*you failed*; the silhouettes keep a dignified posture. Real art and audio go
through cultural review and licensing before they land (concept doc §11).

## Gotchas already hit

- iOS starts every `AudioContext` suspended and can suspend it again at any
  time (call, backgrounding, navigation voice). `A.audio.unlock()` is called
  from a gesture *and* on every resume.
- `localStorage` throws in private mode — every access is wrapped, and the game
  runs fine without persistence.
- Charts are generated in JS rather than fetched as JSON because `fetch` of a
  local file fails under `file://`. `validate()` is what the real loader runs.

## Checking a change

```bash
cd ardah_web && python3 -m http.server 8000     # then open localhost:8000?debug=1
for f in js/*.js; do node --check "$f"; done
```

There is no test runner yet. A headless Playwright pass (menu → run → pause →
resume → result → calibration, asserting no console errors) is the natural
first one, and `js/judge.js` is the natural first unit-test target.
