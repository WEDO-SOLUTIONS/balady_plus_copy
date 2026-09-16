# Management deck

`ardah-overview.pptx` — 19 slides in English for a management review: what the
game is, how it plays, how it ships, what is still open. Only the artwork build
is shown; there is no code-vs-art comparison and no engine benchmarks.

The deck is **generated**, not hand-built, and it is git-ignored — rebuild it
instead of editing the binary, unless you are doing a final polish pass in
PowerPoint (in which case save under a new name).

## Rebuild

```bash
cd ardah_web && npx http-server -p 8123 -s .     # the game has to be served
node deck/capture.js                              # frames, iPhone 17 Pro Max (440x956 @3x)
node deck/capture2.js                             # muted / latency lab / pause states
node deck/capture3.js                             # break styles, miss, hold
python3 deck/mockup_all.py                        # wrap each frame in a device shell
node deck/deck.js                                 # -> deck/ardah-overview.pptx
```

`deck.js` needs `pptxgenjs` (`npm install --no-save pptxgenjs` from `ardah_web/`),
the capture scripts need Playwright's Chromium.

## The notch

Playwright cannot emulate a safe area, so `capture.js` sets `--ardah-safe-top`
to 62 px — what an iPhone 17 Pro Max reports — and the game lays its HUD out
below it through the same code path a real device takes. The artwork still runs
full-bleed behind the island; only the numbers move down.

`mockup.py` can draw either cutout: `cutout='island'` (default, iPhone) or
`cutout='punch'` (a centred hole, the Galaxy shape). Since the HUD respects the
inset, either shell clears the meters — the shape is a styling choice, not a
workaround.

## What the frames are

Real screenshots of the running build, driven by a robot player that hits the
chart — not mockups, not renders. The only staged frames are the "crowd on the
edge" one, where the sync meter is set low so the slide can show the fail
state, and the three from `capture3.js`; everything else is the game playing
itself.

`capture3.js` has to stage its frames, and it is worth knowing why. A break
lasts about 400 ms and taking a screenshot costs 200–300 ms, so waiting for the
robot to happen to produce one is a lottery — the first attempts caught nothing
but the aftermath. It slows the renderer's `dt` for the transients and triggers
them deliberately. The staging decides only *when*: the renderer, the effects
and the assets are the real ones, and for the sustained states (a hold, a held
pad) it drops back to real time and decides nothing at all — slowing `dt` there
would throttle the ember trickle while the judge, which runs off the conductor
rather than `dt`, expired the hold in real time anyway.

It also leaves one spent note behind when it quiets the chart: `game.js` shows
its "Listen…" lead-in hint whenever the visual clock is more than 900 ms before
`notes[0].t`, so pushing the whole chart into the future puts that hint back on
screen.

The song is 77 s, so `capture.js` takes about two minutes: it waits on the
conductor's own clock (`judgeTimeMs`) to hit each mark, which is why the
flourish and hold frames land on the right beat every time.

## Asset sheets

`asset_sheet.py`, `motion.js` and `drawn.js` produce the reference images for
"what art does this game actually use":

```bash
python3 deck/asset_sheet.py     # every file on a checkerboard, with size and weight
node deck/motion.js             # a note travelling the runway + the keycap strip
node deck/drawn.js              # the flourish banner and hold ribbon, exported
```

`drawn.js` draws onto a canvas of its own rather than the game's: the game
repaints every frame, so anything drawn into its canvas is gone before a
screenshot lands. `motion.js` pins the sync meter *and* clears `judge.broken`
— screenshots starve requestAnimationFrame, the robot player drops notes, and
an unattended run would otherwise end mid-capture.

## Verifying the deck without PowerPoint

LibreOffice cannot load any file in this sandbox, so `preview.py` renders the
slides by reading `ppt/slides/*.xml` straight out of the package and drawing it
with Pillow. It reports shapes that fall off the slide and text that may
overflow its box. Fonts differ from PowerPoint's, so it **errs wide**: if a box
looks tight in the preview it has slack in the real deck.

```bash
python3 deck/preview.py deck/ardah-overview.pptx /tmp/preview
```
