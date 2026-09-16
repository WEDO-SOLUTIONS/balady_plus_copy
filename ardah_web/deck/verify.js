/* Load the real game in a browser, play it with a robot, and capture.

   This is the check that the wiring works, not a mock: it serves the actual
   ardah_web directory, runs the actual engine, and screenshots what a player
   would see. It also reports console errors, failed asset loads and a measured
   frame rate, because "it looks right" and "it runs" are different claims. */
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
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
          if (n.durMs) setTimeout(() => g._release(n.lane, 0), n.durMs);
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
