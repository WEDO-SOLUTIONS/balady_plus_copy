#!/usr/bin/env node
/* Drive tools/bake_background.html headlessly and write img/bg/.
 *
 * The runtime used to render the background live, which capped how much
 * detail it could afford on a weak phone GPU. Baking moves that cost offline:
 * the shader can spend as long as it likes per pixel, and the game just draws
 * the resulting plates.
 *
 * Every plate wraps horizontally, so the parallax can scroll forever. Two
 * time-of-day variants are baked and cross-faded at runtime.
 *
 *     node tools/bake_background.js
 */

const path = require('path');
const fs = require('fs');
const { chromium } = require(process.env.PLAYWRIGHT_MODULE ||
  '/opt/node22/lib/node_modules/playwright');

const ROOT = path.resolve(__dirname, '..');
const OUT = path.join(ROOT, 'img', 'bg');
const PAGE = 'file://' + path.join(__dirname, 'bake_background.html');

// A plate is stretched to the layer's on-screen height and tiled at whatever
// width that implies, so the source has to out-resolve the tallest case. On a
// 412 CSS phone the sky tile lands around 1700 device px wide at DPR 2 and
// 2500 at DPR 3; 1280 meant a visible 1.3-2x upscale, so every plate is baked
// at 2048 and is now downsampled rather than blown up.
const PLATES = [
  { name: 'sky', layer: 0, w: 2048, h: 1024 },
  { name: 'far', layer: 1, w: 2048, h: 480 },
  { name: 'near', layer: 2, w: 2048, h: 416 },
  { name: 'dunes', layer: 3, w: 2048, h: 576 }
];

const TIMES = [
  { suffix: 'gold', dusk: 0.0 },
  { suffix: 'dusk', dusk: 1.0 }
];

// The ground plane's own texture: tiled over the sand in perspective by the
// game, so it wraps in both axes and is square. Only the golden bake ships —
// two of these would double both the download and the per-band fill cost, and
// the dusk end of the run is a multiply over the same texture.
const SQUARE = [
  { name: 'sand', layer: 4, w: 2048, h: 2048, dusk: 0.0 },
  // The roadside sprite sheet: rocks and desert scrub, 512 px each.
  { name: 'props', layer: 5, w: 2048, h: 1536, dusk: 0.0 },
  // The road: the same ground mapping, clipped to the track by the game.
  { name: 'track', layer: 6, w: 2048, h: 2048, dusk: 0.0 },
  // The outcrops the track runs between: ten of them, 1024 px each, two
  // columns by five rows.
  { name: 'cliffs', layer: 7, w: 2048, h: 5120, dusk: 0.0 }
];

(async () => {
  fs.mkdirSync(OUT, { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1400, height: 900 } });
  const errors = [];
  page.on('pageerror', (e) => errors.push(e.message));

  await page.goto(PAGE);
  await page.waitForFunction(() => window.bakeReady === true, { timeout: 15000 });

  for (const time of TIMES) {
    for (const plate of PLATES) {
      const dataUrl = await page.evaluate(
        ([w, h, layer, dusk]) => window.bake(w, h, layer, dusk),
        [plate.w, plate.h, plate.layer, time.dusk]
      );
      const file = path.join(OUT, `${plate.name}-${time.suffix}.png`);
      fs.writeFileSync(file, Buffer.from(dataUrl.split(',')[1], 'base64'));
      const kb = (fs.statSync(file).size / 1024).toFixed(1);
      console.log(`  ${path.basename(file).padEnd(18)} ${plate.w}x${plate.h}  ${kb.padStart(7)} KB`);
    }
  }

  for (const plate of SQUARE) {
    const dataUrl = await page.evaluate(
      ([w, h, layer, dusk]) => window.bake(w, h, layer, dusk),
      [plate.w, plate.h, plate.layer, plate.dusk]
    );
    const file = path.join(OUT, `${plate.name}.png`);
    fs.writeFileSync(file, Buffer.from(dataUrl.split(',')[1], 'base64'));
    const kb = (fs.statSync(file).size / 1024).toFixed(1);
    console.log(`  ${path.basename(file).padEnd(18)} ${plate.w}x${plate.h}  ${kb.padStart(7)} KB`);
  }

  if (errors.length) {
    console.error('page errors:\n  ' + errors.join('\n  '));
    process.exitCode = 1;
  }
  await browser.close();
  console.log('baked to img/bg — run tools/pack_background.py to compress');
})();
