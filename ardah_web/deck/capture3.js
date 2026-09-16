/* Frames for the feedback slide: the three break styles, a hold in progress,
   and a miss falling away.

   These cannot be caught by waiting for the robot to happen to produce them:
   a break lasts ~400 ms and taking a screenshot costs 200-300 ms, so the
   moment has to be staged. The staging is honest -- the real renderer, the
   real effects, the real assets -- it only decides WHEN, and for the two
   sustained states (hold, pressed pads) it decides nothing at all.

   Same notch and viewport as capture.js, so the frames drop straight into the
   same device shells. */
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const path = require('path');
const OUT = path.join(__dirname, 'frames');
const URL = 'http://localhost:8123/index.html';
const SAFE_TOP = '62px';

async function prep(p) {
  await p.evaluate((v) => {
    document.documentElement.style.setProperty('--ardah-safe-top', v);
    const g = window.Ardah && window.Ardah.game;
    if (g && g.renderer) g.renderer.resize();
  }, SAFE_TOP);
}

/* Quiet the stage: stop the chart advancing and clear anything in flight, so
   each frame shows one thing. */
async function quiet(p) {
  await p.evaluate(() => {
    const g = window.Ardah.game, r = g.renderer;
    for (const n of g.judge.notes) if (n.t < 1e5) n.t += 1e6;
    // game.js shows its "Listen..." lead-in hint whenever the visual clock is
    // more than 900 ms before notes[0].t, so pushing the whole chart away puts
    // the hint back on screen. Leave one spent note behind as the anchor; it
    // is marked hit, so nothing draws it.
    if (g.judge.notes[0]) {
      g.judge.notes[0].t = g.conductor.judgeTimeMs() - 4000;
      g.judge.notes[0].state = 'hit';
    }
    for (const a of [r.lands, r.drops, r.sparks, r.bursts, r.shards, r.floats]) a.length = 0;
    r.popup = null; r.shake = 0;
    for (let i = 0; i < 3; i++) r.keyUp(i);
  });
}

(async () => {
  const browser = await chromium.launch({
    args: ['--autoplay-policy=no-user-gesture-required', '--mute-audio'],
  });
  const page = await browser.newPage({
    viewport: { width: 440, height: 956 }, deviceScaleFactor: 3,
  });
  await page.goto(URL);
  await prep(page);
  await page.waitForTimeout(700);
  await page.evaluate(() => {
    const b = [...document.querySelectorAll('button')].find((x) => /start|play|stage/i.test(x.textContent));
    if (b) b.click();
  });
  await page.waitForTimeout(2600);
  await prep(page);

  // --- breaking: all three lanes at once, so one frame compares the styles ---
  await quiet(page);
  await page.evaluate(() => {
    const r = window.Ardah.game.renderer;
    // Slow the renderer's clock for this frame only; a break is over long
    // before a screenshot lands.
    r.__orig = r.draw;
    r.draw = function (s, dt) { return r.__orig.call(this, s, dt / 9); };
    r._break(0, 1000, true);
    r._break(1, 2000, true);
    r._break(2, 7000, true);
  });
  await page.waitForTimeout(1500);
  await page.screenshot({ path: path.join(OUT, '21-break-styles.png') });

  // --- a miss falling away, staggered across the lanes ---
  await quiet(page);
  await page.evaluate(() => {
    const r = window.Ardah.game.renderer;
    r.hit(2, 'miss', 3000);
    setTimeout(() => r.hit(1, 'miss', 2000), 900);
    setTimeout(() => r.hit(0, 'miss', 1000), 1800);
  });
  await page.waitForTimeout(1900);
  await page.evaluate(() => { window.Ardah.game.renderer.shake = 0; });
  await page.screenshot({ path: path.join(OUT, '22-miss.png') });

  // Real time again for the sustained states.
  await page.evaluate(() => {
    const r = window.Ardah.game.renderer;
    if (r.__orig) { r.draw = r.__orig; delete r.__orig; }
  });

  // --- a hold running in every lane, with the pads down ---
  await quiet(page);
  await page.evaluate(() => {
    const g = window.Ardah.game, r = g.renderer;
    const now = g.conductor.judgeTimeMs();
    for (let i = 0; i < 3; i++) {
      const n = g.judge.notes[i];
      if (!n) continue;
      n.lane = i; n.type = 'hold'; n.durMs = 1600; n.t = now - 150; n.state = 'holding';
      r.keyDown(i);
    }
  });
  await page.waitForTimeout(430);
  await page.screenshot({ path: path.join(OUT, '23-hold.png') });

  await browser.close();
  console.log('feedback frames captured');
})();
