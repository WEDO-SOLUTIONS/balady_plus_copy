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
- **Artwork is optional, always.** `js/assets.js` loads `assets/*.webp` fire and
  forget; every draw call null-checks the image and falls back to the drawn
  version. Never `await` an asset, never let a missing file break a frame, and
  keep `?art=0` working — it is how the two versions get compared.
- **The runway deck is warped once.** `assets/runway.webp` is in runway space,
  not screen space. `Renderer._deckSprite` warps it into the current layout
  once per resize (one `drawImage` per row, no vertical resampling, because the
  texture's rows are spaced uniformly in `1/z`) and caches it next to the
  gradients. Warping it per frame would be hundreds of draw calls a frame.
- **Effect sprites are added, never blended.** `fx_spark`, `fx_flare`,
  `fx_ring` and `fx_glow` carry intensity in the alpha channel and chroma in
  RGB, for `globalCompositeOperation = 'lighter'`. Alpha-blending them is
  wrong and looks it. The shards are ordinary solid sprites and draw normally.
- **No text baked into artwork.** `docs/ardah-art-brief.md` §1: every string
  localises to Arabic and the layout flips to RTL. The keycap sprites carry no
  letter. The glyph is its own rendered sprite (`glyph_a/s/d/dot`, from
  `deck/make_glyphs.js`) that `_keycaps` draws over the pad — modelled rather
  than flat canvas text, but still swappable, which is the whole reason for
  keeping it off the cap. Localising is re-running that script with a different
  `GLYPHS` list.
- **Objects in a `group` share one crop.** The three keycaps are one pad seen
  from three angles and `_keycaps` scales by the sprite's *height*, so cropping
  them independently would make the turned side pads draw smaller and the
  rotation would read as a size change. `deck/make_notes.js` crops a group to a
  common frame.
- **Sprites are trimmed to their content.** `js/render.js` sizes a sprite by
  the whole PNG — a note by its width, a keycap by its height — so transparent
  margin is drawn too. `deck/make_notes.js` trims every master; if you add one
  that is not trimmed, it will render small and the art will look wrong rather
  than the padding.
- **Capture animations in slow motion.** Taking a screenshot costs 200–300 ms,
  which is longer than most of these animations last, so asking for a
  particular moment is a lottery. `deck/verify.js` scales the renderer's `dt`
  for the capture — physics included — stops the robot first (slow motion does
  not slow *its* timer, so its bursts would pile up ten deep) and pushes the
  chart's notes into the future so nothing else is on screen.
- **Verify in a browser, not by eye.** `node deck/verify.js` serves this
  directory, plays a run with a robot, screenshots it and reports console
  errors, failed loads and the fallback path. `node deck/fps.js` measures the
  frame rate with and without artwork — never take a frame rate measured while
  screenshotting, capture stalls the compositor and the number is meaningless.
- **`js/judge.js` stays pure.** No canvas, no audio, no globals: it is the part
  a native rewrite would port line for line, and the part worth unit tests.
- **Mute is the music bus, never the master.** `AudioEngine.setMuted` ramps
  `musicGain`; the calibration metronome is wired to `master` on purpose and
  must keep sounding, or the screen that measures the device's latency cannot
  do its job. Ramp, never jump — a gain cut mid-sample clicks.
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
