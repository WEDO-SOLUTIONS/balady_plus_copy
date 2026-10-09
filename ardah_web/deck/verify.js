/* Load the real game in a browser, play it with a robot, and capture.

   This is the check that the wiring works, not a mock: it serves the actual
   ardah_web directory, runs the actual engine, and screenshots what a player
   would see. It also reports console errors, failed asset loads and a measured
   frame rate, because "it looks right" and "it runs" are different claims. */
const { chromium } = require('./lib/pw');
const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const OUT = path.join(__dirname, 'out');
const TYPES = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css',
                '.webp': 'image/webp', '.png': 'image/png', '.json': 'application/json' };

const server = http.createServer((req, res) => {
  const p = path.join(ROOT, decodeURIComponent(req.url.split('?')[0]));
  const f = p.endsWith('/') ? path.join(p, 'index.html') : p;
  fs.readFile(f, (err, data) => {
    if (err) { res.writeHead(404); res.end('no'); return; }
    res.writeHead(200, { 'Content-Type': TYPES[path.extname(f)] || 'application/octet-stream' });
    res.end(data);
  });
});


/* Capturing a frame costs 200-300 ms, which is longer than most of these
   animations last, so asking for a particular moment is a lottery. Scaling the
   renderer's dt slows everything consistently -- physics included -- and makes
   the capture deterministic. Restored straight afterwards. */
async function slowmo(page, factor) {
  await page.evaluate((f) => {
    const r = window.Ardah.game.renderer;
    if (f === 1) { if (r.__origDraw) { r.draw = r.__origDraw; delete r.__origDraw; } return; }
    if (!r.__origDraw) r.__origDraw = r.draw;
    const orig = r.__origDraw;
    r.draw = function (state, dt) { return orig.call(this, state, dt / f); };
  }, factor);
}

(async () => {
  await new Promise((r) => server.listen(0, r));
  const port = server.address().port;
  const browser = await chromium.launch();
  const page = await browser.newPage({
    viewport: { width: 440, height: 956 }, deviceScaleFactor: 2,
  });

  const errors = [];
  page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });
  page.on('pageerror', (e) => errors.push('pageerror: ' + e.message));
  const failed = [];
  page.on('requestfailed', (r) => failed.push(r.url()));
  page.on('response', (r) => { if (r.status() >= 400) failed.push(r.status() + ' ' + r.url()); });

  await page.goto(`http://127.0.0.1:${port}/index.html`);
  await page.waitForTimeout(1200);

  const stats = await page.evaluate(() => window.Ardah.assets.stats);
  console.log('assets:', JSON.stringify(stats));

  fs.mkdirSync(OUT, { recursive: true });
  await page.screenshot({ path: path.join(OUT, 'live_menu.png') });

  // Start a run.
  await page.evaluate(() => {
    const b = [...document.querySelectorAll('button')]
      .find((x) => /start|play|stage|игр/i.test(x.textContent));
    if (b) b.click();
  });
  await page.waitForTimeout(1500);

  // Robot: hit every note as it reaches the line, so the effects actually
  // fire. It calls Game._press directly rather than synthesising key events,
  // because the judging clock is the conductor's, not the DOM's.
  await page.evaluate(() => {
    const g = window.Ardah.game;
    window.__robot = setInterval(() => {
      if (!g.judge || !g.conductor) return;
      const now = g.conductor.judgeTimeMs();
      for (const n of g.judge.notes) {
        if (n.state !== 'pending') continue;
        if (n.t - now > 30) break;
        if (Math.abs(n.t - now) < 30) {
          g._press(n.lane, 0);
          // Always release, including taps: a real player's finger comes off,
          // and without this the pads stay depressed for the whole capture.
          setTimeout(() => g._release(n.lane, 0), n.durMs || 90);
        }
      }
    }, 6);
  });

  const shots = [];
  for (let i = 0; i < 6; i++) {
    await page.waitForTimeout(2300);
    const f = path.join(OUT, `live_${i}.png`);
    await page.screenshot({ path: f });
    shots.push(f);
  }

  // Frame rate, measured over a second of real play.
  const fps = await page.evaluate(() => new Promise((res) => {
    let n = 0; const t0 = performance.now();
    const tick = () => { n++; if (performance.now() - t0 < 1000) requestAnimationFrame(tick);
                         else res(n * 1000 / (performance.now() - t0)); };
    requestAnimationFrame(tick);
  }));
  console.log('fps:', fps.toFixed(1));

  // The note-into-pad landing is a 165 ms animation, so it is triggered and
  // caught deliberately rather than hoped for in a random frame.
  // The robot has to stop first. Slow motion scales the renderer's dt but not
  // the robot's timer, so it would keep landing hits whose bursts, shards and
  // score floats then linger ten times as long and bury the frame.
  await page.evaluate(() => {
    clearInterval(window.__robot);
    const g = window.Ardah.game;
    // Push the chart far into the future rather than emptying it: with the
    // robot stopped the notes would otherwise pile up past the judgment line,
    // and a note sitting at Z_LIP is drawn large enough to fill the frame.
    // Deleting them instead would let the run finish and leave the results
    // screen.
    for (const n of g.judge.notes) n.t += 1e6;
    const r = g.renderer;
    for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats]) a.length = 0;
    r.popup = null;
    r.shake = 0;
  });
  await page.waitForTimeout(120);

  // Both of these are captured in slow motion; see slowmo() above.
  //
  // The landing is pushed straight onto the queue rather than through hit(),
  // because hit() also fires the burst and the shards and the flash buries the
  // very thing the frame exists to show. The lanes are staggered so one
  // screenshot carries three stages of the same animation.
  await slowmo(page, 10);

  await page.evaluate(() => {
    const g = window.Ardah.game;
    for (const a of [g.renderer.lands, g.renderer.drops, g.renderer.sparks,
                     g.renderer.bursts, g.renderer.shards, g.renderer.floats]) a.length = 0;
    g.renderer.popup = null;
    const push = (lane, t) => g.renderer.lands.push({ lane, t, life: 1 });
    push(2, 3000);
    setTimeout(() => push(1, 2000), 550);
    setTimeout(() => push(0, 1000), 1100);
  });
  await page.waitForTimeout(1250);
  await page.screenshot({ path: path.join(OUT, 'live_landing.png') });

  await page.evaluate(() => {
    const g = window.Ardah.game;
    for (const a of [g.renderer.lands, g.renderer.drops, g.renderer.sparks,
                     g.renderer.bursts, g.renderer.shards, g.renderer.floats]) a.length = 0;
    g.renderer.popup = null;
    g.renderer.shake = 0;
    const miss = (lane, t) => g.renderer.hit(lane, 'miss', t);
    miss(2, 3000);
    setTimeout(() => miss(1, 2000), 900);
    setTimeout(() => miss(0, 1000), 1800);
  });
  await page.waitForTimeout(1950);
  await page.evaluate(() => { window.Ardah.game.renderer.shake = 0; });
  await page.screenshot({ path: path.join(OUT, 'live_miss.png') });

  // The three break styles, side by side: crystal shatters, gem flashes, coin
  // scatters. Triggered on all three lanes at once so one frame compares them.
  await page.evaluate(() => {
    const g = window.Ardah.game;
    const r = g.renderer;
    for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats]) a.length = 0;
    r.popup = null; r.shake = 0;
    r._break(0, 1000, true);
    r._break(1, 2000, true);
    r._break(2, 7000, true);
  });
  await page.waitForTimeout(1400);
  await page.screenshot({ path: path.join(OUT, 'live_break.png') });

  /* The parallax, at full left, centre and full right.

     The tilt is set directly and the ease is skipped, because these frames are
     about the geometry at the extremes rather than the ramp into them. The
     pad's buttons and keys 1 and 2 drive the same setter. */
  for (const [t, tag] of [[-1, 'l'], [0, 'c'], [1, 'r']]) {
    await page.evaluate((v) => {
      const g = window.Ardah.game, r = g.renderer;
      for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats, r.waves]) a.length = 0;
      r.popup = null; r.shake = 0;
      const n = g.judge.notes[0];
      if (n) { n.type = 'tap'; n.lane = 1; n.state = 'pending';
               n.t = g.conductor.visualTimeMs() + 900; }
      r.setTilt(v);
      r.tilt = v;
    }, t);
    await page.waitForTimeout(170);
    await page.screenshot({ path: path.join(OUT, `live_tilt_${tag}.png`) });
  }

  /* The flourish: three frames, because it is three things.

     It has to go in notes[0]: _notes walks the array in order and BREAKS on
     the first note whose lead exceeds APPROACH_MS, and the chart was pushed
     into the future above, so anything placed after index 0 is never
     reached. */
  await page.evaluate(() => {
    const g = window.Ardah.game, r = g.renderer;
    for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats, r.waves]) a.length = 0;
    r.popup = null; r.shake = 0;
    const n = g.judge.notes[0];
    if (n) { n.type = 'flourish'; n.lane = 1; n.state = 'pending';
             n.t = g.conductor.visualTimeMs() + 900; }
  });
  await page.waitForTimeout(340);
  await page.screenshot({ path: path.join(OUT, 'live_flourish_in.png') });

  // The sweep on its own, so it can be seen at all: the lane bursts that fire
  // with it in the real thing are brighter than it is.
  await page.evaluate(() => {
    const r = window.Ardah.game.renderer;
    for (const a of [r.sparks, r.bursts, r.shards, r.waves]) a.length = 0;
    r.waves.push({ life: 1 });
  });
  await page.waitForTimeout(1500);
  await page.screenshot({ path: path.join(OUT, 'live_flourish_wave.png') });

  // And the whole answer as the game actually plays it.
  await page.evaluate(() => {
    const r = window.Ardah.game.renderer;
    for (const a of [r.sparks, r.bursts, r.shards, r.waves]) a.length = 0;
    r.flourishBurst();
    r.shake = 0;
  });
  await page.waitForTimeout(900);
  await page.evaluate(() => { window.Ardah.game.renderer.shake = 0; });
  await page.screenshot({ path: path.join(OUT, 'live_flourish_hit.png') });

  // Back to real time for the two SUSTAINED states below. Slow motion exists
  // for transients that finish before a screenshot does; a hold and a held pad
  // are states, not moments, so capture latency does not matter -- and slowing
  // dt would throttle the ember trickle to nothing while the judge, which runs
  // off the conductor rather than dt, expired the hold in real time anyway.
  await slowmo(page, 1);

  // A hold in progress in every lane. The chart's notes were pushed into the
  // future above, so three of them are pulled back and put into the state the
  // judge would have left them in mid-hold.
  await page.evaluate(() => {
    const g = window.Ardah.game;
    const r = g.renderer;
    for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats]) a.length = 0;
    r.popup = null; r.shake = 0;
    const now = g.conductor.judgeTimeMs();
    for (let i = 0; i < 3; i++) {
      const n = g.judge.notes[i];
      if (!n) continue;
      n.lane = i; n.type = 'hold'; n.durMs = 1600;
      n.t = now - 150; n.state = 'holding';
      r.keyDown(i);
    }
  });
  await page.waitForTimeout(420);
  await page.screenshot({ path: path.join(OUT, 'live_hold.png') });
  await page.evaluate(() => {
    for (let i = 0; i < 3; i++) window.Ardah.game.renderer.keyUp(i);
  });

  // A frame with two pads actually held, so the press animation is captured
  // rather than assumed.
  await page.evaluate(() => {
    const g = window.Ardah.game;
    g.renderer.keyDown(0);
    g.renderer.keyDown(2);
  });
  await page.waitForTimeout(260);
  await page.screenshot({ path: path.join(OUT, 'live_pressed.png') });
  await page.evaluate(() => {
    const g = window.Ardah.game;
    g.renderer.keyUp(0);
    g.renderer.keyUp(2);
  });
  await slowmo(page, 1);

  /* The camera lock, driven the way a player drives it: a real mouse drag on
     the real <input type="range">, not a call to setTiltLock.

     Three claims are checked, not just photographed. The tilt must follow the
     bead; the judgment line and the keycaps must not move, because the lock
     goes through the same single camera orbit pinned at z = 1; and pressing a
     parallax button must put the bead back at centre -- which is the one part
     of this that lives in two places at once (the game owns tiltLock, the DOM
     owns the slider position) and so is the part that can drift. */
  const lock = await page.$('#tilt-lock');
  const box = await lock.boundingBox();
  const midY = box.y + box.height / 2;

  await page.mouse.move(box.x + box.width / 2, midY);
  await page.mouse.down();
  await page.mouse.move(box.x + box.width * 0.9, midY, { steps: 12 });
  await page.mouse.up();
  await page.waitForTimeout(500);                 // let the ease settle

  const locked = await page.evaluate(() => {
    const g = window.Ardah.game, r = g.renderer;
    return { slider: Number(document.getElementById('tilt-lock').value),
             lock: g.tiltLock, tilt: r.tilt,
             judge: r.judgeY, key1: r.xAt(1, 1), key0: r.xAt(0, 1),
             far: r.shiftAt(1e9) };
  });
  await page.screenshot({ path: path.join(OUT, 'live_lock.png') });

  // Released: the drag is over, the finger is off, and the view has to STAY
  // there. That is the whole point of the control.
  await page.waitForTimeout(900);
  const held = await page.evaluate(() => window.Ardah.game.renderer.tilt);

  // A parallax button, pressed and released, has to reset the bead.
  await page.evaluate(() => {
    const b = document.getElementById('btn-tilt-l');
    b.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true }));
    b.dispatchEvent(new PointerEvent('pointerup', { bubbles: true }));
  });
  await page.waitForTimeout(700);
  const afterBtn = await page.evaluate(() => ({
    slider: Number(document.getElementById('tilt-lock').value),
    lock: window.Ardah.game.tiltLock,
    tilt: window.Ardah.game.renderer.tilt,
  }));

  const pinned = Math.abs(locked.key1 - 220) < 0.01 && Math.abs(locked.key0 - 220 + 134) < 2;
  console.log('lock: slider', locked.slider, 'game', locked.lock.toFixed(2),
              'tilt', locked.tilt.toFixed(3), '| far shift', locked.far.toFixed(1),
              '| pinned at z=1:', pinned);
  console.log('lock holds after release:', held.toFixed(3),
              '| reset by button: slider', afterBtn.slider, 'game', afterBtn.lock,
              'tilt', afterBtn.tilt.toFixed(3));

  /* And key 1, which reaches the same setter through input.js -- plus the
     thing that goes wrong if the slider keeps focus: ArrowLeft is lane 0, so
     a focused slider would eat the keyboard for the rest of the run. */
  await page.mouse.move(box.x + box.width * 0.25, midY);
  await page.mouse.down(); await page.mouse.up();
  await page.waitForTimeout(120);
  const focus = await page.evaluate(() => document.activeElement.id || document.activeElement.tagName);
  const preKey = await page.evaluate(() => Number(document.getElementById('tilt-lock').value));
  await page.keyboard.down('1');
  await page.waitForTimeout(60);
  const onKey = await page.evaluate(() => ({
    slider: Number(document.getElementById('tilt-lock').value),
    lock: window.Ardah.game.tiltLock,
  }));
  await page.keyboard.up('1');
  console.log('after drag focus:', focus, '| reset by key 1:', preKey, '->',
              onKey.slider, 'game', onKey.lock);

  // And a parked camera must not survive the pad being hidden: pausing puts a
  // panel over the stage and takes the slider away with it.
  await page.mouse.move(box.x + box.width * 0.85, midY);
  await page.mouse.down(); await page.mouse.up();
  await page.waitForTimeout(80);
  const beforePause = await page.evaluate(() => window.Ardah.game.tiltLock);
  await page.evaluate(() => window.Ardah.ui.showScreen('screen-pause'));
  await page.waitForTimeout(80);
  const afterPause = await page.evaluate(() => ({
    slider: Number(document.getElementById('tilt-lock').value),
    lock: window.Ardah.game.tiltLock,
  }));
  console.log('lock cleared when the pad hides:', beforePause.toFixed(2), '-> slider',
              afterPause.slider, 'game', afterPause.lock);

  // The fallback has to keep working: AGENTS.md makes ?art=0 a standing rule,
  // and _runway and _keycaps both grew a sprite branch in this change.
  const bare = await browser.newPage({ viewport: { width: 440, height: 956 }, deviceScaleFactor: 2 });
  const bareErrors = [];
  bare.on('pageerror', (e) => bareErrors.push(e.message));
  await bare.goto(`http://127.0.0.1:${port}/index.html?art=0`);
  await bare.waitForTimeout(900);
  await bare.evaluate(() => {
    const b2 = [...document.querySelectorAll('button')].find((x) => /start|play|stage/i.test(x.textContent));
    if (b2) b2.click();
  });
  await bare.waitForTimeout(2600);
  await bare.screenshot({ path: path.join(OUT, 'live_art0.png') });
  console.log('?art=0 errors:', bareErrors.length ? bareErrors : 'none');
  console.log('console errors:', errors.length ? errors.slice(0, 5) : 'none');
  console.log('failed requests:', failed.length ? failed.slice(0, 8) : 'none');

  await browser.close();
  server.close();
})();
