/* Capture (a) a note travelling the runway frame by frame, and (b) the strip
   under the lanes, straight from the running game. */
const { chromium } = require('./lib/pw');
const OUT = require('path').join(__dirname, 'sheets');

(async () => {
  const b = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required', '--mute-audio'] });
  const p = await b.newPage({ viewport: { width: 440, height: 956 }, deviceScaleFactor: 2 });
  await p.goto('http://localhost:8123/index.html', { waitUntil: 'load' });
  await p.evaluate(() => { document.documentElement.style.setProperty('--ardah-safe-top', '62px');
                           window.Ardah.game.renderer.resize(); });
  await p.click('#btn-play');

  // A robot plays the chart, and the sync meter is pinned so an unattended run
  // cannot end mid-capture. The conductor is untouched: the travel below is the
  // real projection, just sampled.
  await p.evaluate(() => {
    const A = window.Ardah, held = {}; let cursor = 0;
    // `broken` latches, so clearing the meter alone is not enough: screenshots
    // starve requestAnimationFrame, the robot drops notes, and an unattended run
    // would end mid-capture.
    setInterval(() => {
      if (!A.game.judge) return;
      A.game.judge.sync = 100;
      A.game.judge.broken = false;
    }, 60);
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
  });
  await p.waitForFunction(() => window.Ardah.game.conductor.judgeTimeMs() > 11400, null, { polling: 20 });
  for (let i = 0; i < 8; i++) {
    await p.screenshot({ path: `${OUT}/travel-${i}.png`, clip: { x: 0, y: 430, width: 440, height: 400 } });
    await p.waitForTimeout(150);
  }

  // The lane strip, with a hit flash on the middle lane.
  await p.evaluate(() => { window.Ardah.game.renderer.hit(1, 'perfect'); });
  await p.waitForTimeout(60);
  await p.screenshot({ path: `${OUT}/lane-strip.png`, clip: { x: 0, y: 700, width: 440, height: 256 } });

  // A flourish banner and a hold ribbon, drawn live on the canvas — these are
  // code, not files, so they are captured rather than exported.
  await p.evaluate(() => {
    const r = window.Ardah.game.renderer, c = r.ctx;
    c.save();
    c.fillStyle = '#0E1018';
    c.fillRect(0, 300, r.w, 300);
    c.translate(0, 300 - r.yAt(1.6) + 60);
    r._flourishNote(c, 1.6, 900);
    c.restore();
    c.save();
    c.fillStyle = '#0E1018';
    c.fillRect(0, 600, r.w, 340);
    c.translate(0, 600 - r.yAt(2.4) + 40);
    r._holdRibbon(c, { lane: 0, t: 0, durMs: 1200, state: 'pending' }, -1300);
    r._gem(c, 0, 2.4, true);
    c.restore();
  });
  await p.screenshot({ path: `${OUT}/drawn-bits.png`, clip: { x: 0, y: 300, width: 440, height: 640 } });

  console.log('motion frames captured');
  await b.close();
})();
