# Management deck

`ardah-overview.pptx` — 18 slides in English for a management review: what the
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
chart — not mockups, not renders. The only staged frame is the "crowd on the
edge" one, where the sync meter is set low so the slide can show the fail state;
everything else is the game playing itself.

The song is 77 s, so `capture.js` takes about two minutes: it waits on the
conductor's own clock (`judgeTimeMs`) to hit each mark, which is why the
flourish and hold frames land on the right beat every time.

## Verifying the deck without PowerPoint

LibreOffice cannot load any file in this sandbox, so `preview.py` renders the
slides by reading `ppt/slides/*.xml` straight out of the package and drawing it
with Pillow. It reports shapes that fall off the slide and text that may
overflow its box. Fonts differ from PowerPoint's, so it **errs wide**: if a box
looks tight in the preview it has slack in the real deck.

```bash
python3 deck/preview.py deck/ardah-overview.pptx /tmp/preview
```
