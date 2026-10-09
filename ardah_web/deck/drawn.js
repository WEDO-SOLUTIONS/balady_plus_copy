/* Export the elements that move but are NOT image files, by drawing them onto a
   canvas of our own — the game's own canvas is repainted every frame, so
   anything drawn into it is gone before a screenshot lands. */
const { chromium } = require('./lib/pw');
const OUT = require('path').join(__dirname, 'sheets');

(async () => {
  const b = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required', '--mute-audio'] });
  const p = await b.newPage({ viewport: { width: 440, height: 956 }, deviceScaleFactor: 2 });
  await p.goto('http://localhost:8123/index.html', { waitUntil: 'load' });
  await p.click('#btn-play');
  await p.waitForTimeout(800);

  await p.evaluate(() => {
    const r = window.Ardah.game.renderer;
    const W = 440, H = 660;
    const cv = document.createElement('canvas');
    cv.id = 'export';
    cv.width = W * 2; cv.height = H * 2;
    cv.style.cssText = `position:fixed;left:0;top:0;width:${W}px;height:${H}px;z-index:999`;
    document.body.appendChild(cv);
    const c = cv.getContext('2d');
    c.scale(2, 2);
    c.fillStyle = '#12131B';
    c.fillRect(0, 0, W, H);

    // Flourish banner, as it looks partway down the runway.
    c.save();
    c.translate(0, 120 - r.yAt(1.9));
    r._flourishNote(c, 1.9, 900);
    c.restore();

    // Hold: a short ribbon with its head note, so both ends stay on screen.
    c.save();
    c.translate(0, 330 - r.yAt(2.6));
    r._holdRibbon(c, { lane: 0, t: 0, durMs: 500, state: 'pending' }, -600);
    r._gem(c, 0, 2.6, true);
    c.restore();

    // The three note sprites at the size they reach the judgment line.
    c.save();
    c.translate(0, 540 - r.yAt(1.15));
    for (var lane = 0; lane < 3; lane++) r._gem(c, lane, 1.15, false);
    c.restore();
  });

  const el = await p.$('#export');
  await el.screenshot({ path: `${OUT}/drawn-bits.png` });
  console.log('drawn elements exported');
  await b.close();
})();
