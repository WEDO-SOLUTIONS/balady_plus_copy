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

### One file to pass around

```bash
./build-single.sh        # -> dist/ardah-standalone.html (~80 KB, git-ignored)
```

Inlines the CSS and scripts into a single HTML file you can mail, drop into a
chat, or double-click. Same code — the split version is what ships, because the
mini-app engine serves a folder.

## Controls

| | Touch | Keyboard |
|---|---|---|
| Strike | tap a lane | `A` `S` `D`, or `←` `↓` `→` |
| | lanes are **TABL** (deep drum), **SWORDS** (blades) and **TAR** (frame drum) | |
| Raise (hold) | press and hold, release on the last beat | hold the lane key |
| Flourish | swipe across the lanes | `Space` |
| Pause | — | `Esc` |
| Mute music | the speaker button, top right | `M` |

Mute takes the **music bus**, not the master: the calibration metronome hangs
off the master directly, because that screen exists to measure the device's
audio and silencing it would make the measurement impossible. The calibration
screen says so when muted. Timing is untouched either way — the conductor runs
off the audio clock and keeps scheduling on mute, so a muted run is judged
exactly like a loud one. The choice persists in `localStorage`.

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

## Artwork

`assets/` holds art **cut out of the Ardah concept image** by `assets/extract.py`
— an experiment in how far a single rendered still gets us. The game runs
without it; each image swaps in the frame after it decodes, and `?art=0` forces
the drawn version so the two can be compared side by side.

What the slicing produced, at **180 KB total in WebP**:

| Asset | How it was cut | Works? |
|---|---|---|
| `bg_stage` | Rectangular crop of the stage band, title plaque painted out and blurred back into the sky | Yes — this is most of the visual win |
| `note_tabl/swords/tar` | Keyed against the dark deck: distance-from-background alpha, colour unmultiplied, largest blob kept, ellipse mask to cut the neighbouring coin | Yes |
| `key_tabl/swords/tar` | **No keying at all** — a plain crop with a rounded-rect mask. Keying kept eating a bevel or a corner off these (they are layered: coloured top, metal base, and sparks drawn over the S), and the dark pixels a plain mask keeps are the deck, which is what the caps are drawn back onto | Yes |
| `ui_plaque` | Keyed against the sky | Cut cleanly, **but unusable**: the title is baked in as English pixels, so it cannot localise. Kept in `assets/` as the exhibit for why the brief bans text in artwork |
| Performers, musicians, fires | — | **Not cuttable.** They sit against the fort, not a flat background, and they overlap each other. They stay baked into `bg_stage`, which is why the stage no longer animates in art mode |

So the experiment's answer: a flat still gets you the backdrop, the props and
the UI furniture almost for free, and gets you **no animation at all**. The
performers' idle sway, the sword raise on a hit, the drummers answering the
track — all of it needs the layered delivery specified in
[`../docs/ardah-art-brief.md`](../docs/ardah-art-brief.md) §3.3.

To keep the plate from looking dead, the renderer adds firelight flicker over
the baked braziers and a slow scale "breath" on the beat. It helps; it is not a
substitute.

**Provenance and status:** derived from the client's own concept image, for
evaluation only. Not cleared for release — and note that the banners in it carry
the state emblem, which is exactly the compliance question raised in the brief's
§1.

### Redrawn note sprites

`assets/hd/` holds 512 px masters of the three note objects, drawn by
`deck/make_notes.js` (canvas at 4x, downsampled) rather than cut from the
concept image. The cut sprites are 60–80 px crops, and the game draws a note at
~115 pt near the judgment line — 345 device pixels on a 3x screen — so those
crops are running at a five-fold upscale and show it.

The palette is **sampled from the cuts, not invented**: `deck/make_notes.js`
carries the measured numbers in its header (mid-tone at H 26-33 deg and S ~0.7,
shadows down to near-black, highlights clipping to cream rather than
blue-white, and a warm firelight rim on the sword gem alongside its cyan). Two
post-passes finish them — a bloom that squares the luminance before blurring,
so only real speculars bleed, and a fine warm grain, masked to the sprite's own
alpha because `overlay` would otherwise fog the whole square.

`deck/notes_sheets.py` rebuilds two sheets into `deck/out/` for judging the
result: `notes_hd.png` (the masters on a checkerboard) and `notes_compare.png`
(cut vs redraw at the ~38 / ~67 / ~115 pt the runway actually uses). Judge them
on the compare sheet, not at 512 px — a note is never seen that large.

The coin's motif is an eight-point geometric rosette. An earlier pass had two
crossed sabres under a palm, which is the arrangement of the **Saudi state
emblem**; `docs/ardah-art-brief.md` §1 rules that out as decoration, so it was
replaced. Anything struck on the coin has to clear that bar.

The masters are not wired into the game: swapping them in changes the art
direction (the cut sprites carry the concept's own lighting), so that is a
design call, not a technical one. To try them, export to webp at the size the
lane actually uses and drop them over `assets/note_*.webp`.

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
- **The stage is drawn with canvas paths** — a Diriyah-style fort with a lit
  gate, palms, green banners, brazier fires, a tiled plaza, two facing rows of
  five, and a tabl player and an oud player on stools. Stylised on purpose,
  dignified posture, no caricature. It follows the concept art's composition,
  but real artwork is commissioned and goes through cultural review first.
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
build-single.sh   inlines everything into one distributable HTML file
css/ardah.css     menus; WebView hardening (no selection, no overscroll, safe areas)
js/i18n.js        ar/en strings, RTL flip (gameplay stays LTR by design)
js/bridge.js      dsBridge adapter, no-op in a browser
js/assets.js      optional artwork loader; the game never waits on it
js/audio.js       synthesised tabl / swords / tar + metronome
js/scene.js       the stage: fort, palms, banners, braziers, rows, musicians
js/chart.js       chart format, groove generator, validator
js/conductor.js   the audio clock and schedule-ahead loop
js/judge.js       windows, scoring, combo, sync meter  ← port this as-is
js/render.js      canvas: perspective runway, notes, effects, HUD
js/input.js       pointer + keyboard, queueing correction, swipe detection
js/game.js        flow, calibration, storage, latency lab
js/main.js        DOM wiring and bootstrap
```

## How the scene stays cheap

The backdrop — sky, stars, the fort, bunting, the plaza — never changes, so it
is painted **once** into an offscreen canvas on resize and blitted every frame.
Only firelight, the performers, the drummers, the notes and the effects are
redrawn. Without that split a scene this busy would not hold 60 fps inside a
WebView, where the page is a composited platform view.

The runway is a real projection: distance `z` shrinks linearly with time and
the screen position is `y = vp + C/z`, `x = centre + laneOffset/z`. One division
buys the drift-then-rush approach a rhythm player reads without thinking. The
vanishing point sits *behind* the row, so markers rise out from between the
performers.

## Verified

Headless Chromium (Playwright), 390×844 @2x: audio context runs, **59.7 fps
with the artwork and 59.9 without it** (measured by counting frames, not by the
in-game average — earlier readings of 53–57 came from the test harness's robot
player scanning every note each frame, not from the game). The renderer's own
work is ~0.31 ms per frame, of which the stage plate is 0.13 ms. Also verified: pause suspends and resume restores the context, calibration
measures and persists an offset, judging and scoring behave, Arabic flips to
RTL, no console errors. Timing numbers from a headless run mean nothing —
measure on real devices.

## Next

1. Measure on a low-end Android and an iPhone, in a browser and in the WebView
   with the radio playing. Record `mean` and `jitter` per device.
2. Decide the path on those numbers (concept doc §6.4).
3. Only then: real audio, real art, authored charts, the tutorial gate.
