/* Capture the deck's frames at iPhone 17 Pro Max logical size (440x956 @3x). */
const { chromium } = require('./lib/pw');
const OUT = require('path').join(__dirname, 'frames');
const VIEW = { width: 440, height: 956 };
const URL = 'http://localhost:8123/index.html';

/* Playwright cannot emulate a notch, so the frames set the inset the game
   reads from CSS. 62 px is what an iPhone 17 Pro Max reports for
   safe-area-inset-top; the HUD then lays itself out below the island using the
   same code path a real device takes. */
const SAFE_TOP = '62px';
/* The look-around pad is hidden for the deck's frames. It is a live control and
   it works, but this deck does not talk about it, and an unexplained pair of
   arrows floating over the stage in every product shot asks a question the
   slides do not answer. This is the same kind of staging as the low sync meter
   and the triggered breaks -- it decides what is on screen, not what the game
   is -- and deck/README.md says so. */
async function prep(p) {
  await p.evaluate((v) => {
    document.documentElement.style.setProperty('--ardah-safe-top', v);
    var pad = document.getElementById('tilt-pad');
    if (pad) pad.style.display = 'none';
    if (window.Ardah && window.Ardah.game && window.Ardah.game.renderer) {
      window.Ardah.game.renderer.resize();
    }
  }, SAFE_TOP);
}

const ROBOT = () => {
  const A = window.Ardah, held = {};
  let cursor = 0;
  (function f() {
    if (A.game.phase === 'playing' && A.game.judge) {
      const t = A.game.conductor.judgeTimeMs(), notes = A.game.judge.notes;
      while (cursor < notes.length && notes[cursor].t < t - 200) cursor++;
      for (let i = cursor; i < notes.length && notes[i].t < t + 40; i++) {
        const n = notes[i];
        if (n.state !== 'pending' || Math.abs(n.t - t) > 18) continue;
        if (n.type === 'flourish') A.game._flourish(0);
        else { A.game._press(n.lane, 0); if (n.type === 'hold') held[n.lane] = n.t + n.durMs; }
      }
      Object.keys(held).forEach(l => { if (t >= held[l]) { A.game._release(+l, 0); delete held[l]; } });
    }
    requestAnimationFrame(f);
  })();
};

async function waitSong(page, ms) {
  await page.waitForFunction(t => window.Ardah.game.conductor.judgeTimeMs() >= t, ms, { timeout: 120000, polling: 30 });
}

(async () => {
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required', '--mute-audio'] });
  const ctx = await browser.newContext({ viewport: VIEW, deviceScaleFactor: 3, isMobile: true, hasTouch: true });
  const shot = (p, name) => p.screenshot({ path: `${OUT}/${name}.png` });

  // ---- static screens -------------------------------------------------
  let p = await ctx.newPage();
  await p.goto(URL, { waitUntil: 'load' });
  await prep(p);
  await p.waitForTimeout(700);
  await shot(p, '01-menu');
  await p.click('#btn-howto'); await p.waitForTimeout(300); await shot(p, '02-howto');
  await p.click('#screen-howto .btn-primary');
  await p.click('#btn-lang'); await p.waitForTimeout(350); await shot(p, '03-menu-ar');
  await p.click('#btn-lang'); await p.waitForTimeout(250);
  await p.click('#btn-calibrate'); await p.click('#btn-calib-start');
  await p.waitForTimeout(600 + 4 * 545);
  for (let i = 0; i < 3; i++) { await p.keyboard.press('Space'); await p.waitForTimeout(545); }
  await shot(p, '04-calibration');
  await p.close();

  // ---- a full run, sampled on the song clock --------------------------
  p = await ctx.newPage();
  await p.goto(URL, { waitUntil: 'load' });
  await prep(p);
  await p.waitForTimeout(500);
  await p.click('#btn-play');
  await p.evaluate(ROBOT);
  const marks = [
    [1200, '05-countin'], [13200, '06-play-early'], [17300, '07-play-three-lanes'],
    [31000, '08-play-chorus'], [38300, '09-flourish-incoming'], [38950, '10-flourish-hit'],
    [52000, '11-combo'], [68900, '12-hold'], [74000, '13-late-run']
  ];
  for (const [t, name] of marks) { await waitSong(p, t); await shot(p, name); }
  await p.waitForFunction(() => window.Ardah.game.phase === 'result', null, { timeout: 60000 });
  await p.waitForTimeout(500);
  await shot(p, '14-result');
  await p.close();

  // ---- staged states ---------------------------------------------------
  p = await ctx.newPage();
  await p.goto(URL, { waitUntil: 'load' });
  await prep(p);
  await p.click('#btn-play'); await p.evaluate(ROBOT);
  await waitSong(p, 20000);
  await p.keyboard.press('Escape'); await p.waitForTimeout(400); await shot(p, '15-pause');
  await p.click('#btn-resume'); await waitSong(p, 24000);
  // The crowd meter under pressure — staged so the frame shows the fail state.
  await p.evaluate(() => { window.Ardah.game.judge.sync = 18; window.Ardah.game.judge.combo = 0; });
  await p.waitForTimeout(200); await shot(p, '16-crowd-low');
  await p.evaluate(() => { window.Ardah.game.judge.sync = 96; });
  await p.click('#btn-mute'); await p.waitForTimeout(300); await shot(p, '17-muted');
  await p.evaluate(() => window.Ardah.game.toggleDebug()); await p.waitForTimeout(300);
  await shot(p, '18-latency-lab');
  await p.close();

  // ---- the drawn (asset-free) build, for the tech slide ---------------
  p = await ctx.newPage();
  await p.goto(URL + '?art=0', { waitUntil: 'load' });
  await prep(p);
  await p.waitForTimeout(600); await shot(p, '19-drawn-menu');
  await p.click('#btn-play'); await p.evaluate(ROBOT);
  await waitSong(p, 31000); await shot(p, '20-drawn-play');
  await p.close();

  await browser.close();
  console.log('frames captured');
})();
