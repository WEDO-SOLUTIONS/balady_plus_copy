/* Frame rate with and without artwork, measured during real play.

   No screenshots while measuring: capturing a frame stalls the compositor and
   makes the number meaningless. The robot runs the whole time so the effect
   path is actually exercised. */
const { chromium } = require('./lib/pw');
const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const TYPES = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css',
                '.webp': 'image/webp', '.png': 'image/png' };
const server = http.createServer((req, res) => {
  const f = path.join(ROOT, decodeURIComponent(req.url.split('?')[0]));
  fs.readFile(f, (err, data) => {
    if (err) { res.writeHead(404); res.end('no'); return; }
    res.writeHead(200, { 'Content-Type': TYPES[path.extname(f)] || 'application/octet-stream' });
    res.end(data);
  });
});

async function run(browser, query, label) {
  const page = await browser.newPage({ viewport: { width: 440, height: 956 }, deviceScaleFactor: 2 });
  await page.goto(`http://127.0.0.1:${server.address().port}/index.html${query}`);
  await page.waitForTimeout(1000);
  await page.evaluate(() => {
    const b = [...document.querySelectorAll('button')].find((x) => /start|play|stage/i.test(x.textContent));
    if (b) b.click();
  });
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    const g = window.Ardah.game;
    window.__robot = setInterval(() => {
      if (!g.judge || !g.conductor) return;
      const now = g.conductor.judgeTimeMs();
      for (const n of g.judge.notes) {
        if (n.state !== 'pending') continue;
        if (n.t - now > 30) break;
        if (Math.abs(n.t - now) < 30) { g._press(n.lane, 0); if (n.durMs) setTimeout(() => g._release(n.lane, 0), n.durMs); }
      }
    }, 6);
  });
  await page.waitForTimeout(4000);
  const r = await page.evaluate(() => new Promise((res) => {
    let n = 0; const t0 = performance.now();
    const tick = () => { n++; if (performance.now() - t0 < 4000) requestAnimationFrame(tick);
                         else res(n * 1000 / (performance.now() - t0)); };
    requestAnimationFrame(tick);
  }));
  console.log(`${label.padEnd(22)} ${r.toFixed(1)} fps`);
  await page.close();
}

(async () => {
  await new Promise((r) => server.listen(0, r));
  const browser = await chromium.launch();
  await run(browser, '?art=0', 'drawn (?art=0)');
  await run(browser, '', 'traced artwork');
  await browser.close();
  server.close();
})();
