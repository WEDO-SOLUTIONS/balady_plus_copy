const { chromium } = require('./lib/pw');
const OUT = require('path').join(__dirname, 'frames');
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
  const A = window.Ardah, held = {}; let cursor = 0;
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
const waitSong = (p, ms) => p.waitForFunction(t => window.Ardah.game.conductor.judgeTimeMs() >= t, ms, { timeout: 90000, polling: 30 });

(async () => {
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required', '--mute-audio'] });
  const ctx = await browser.newContext({ viewport: { width: 440, height: 956 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true });

  // muted, in play
  let p = await ctx.newPage();
  await p.goto(URL, { waitUntil: 'load' });
  await prep(p);
  await p.click('#btn-mute');
  await p.click('#btn-play'); await p.evaluate(ROBOT);
  await waitSong(p, 33000);
  await p.screenshot({ path: `${OUT}/17-muted.png` });
  await p.close();

  // latency lab, in play
  p = await ctx.newPage();
  await p.goto(URL + '?debug=1', { waitUntil: 'load' });
  await prep(p);
  await p.click('#btn-play'); await p.evaluate(ROBOT);
  await waitSong(p, 34000);
  await p.screenshot({ path: `${OUT}/18-latency-lab.png` });
  await p.close();

  // pause, over a lit stage
  p = await ctx.newPage();
  await p.goto(URL, { waitUntil: 'load' });
  await prep(p);
  await p.click('#btn-play'); await p.evaluate(ROBOT);
  await waitSong(p, 35000);
  await p.keyboard.press('Escape'); await p.waitForTimeout(500);
  await p.screenshot({ path: `${OUT}/15-pause.png` });
  await p.close();

  await browser.close();
  console.log('re-captured');
})();
