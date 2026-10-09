/* Playwright, wherever it happens to live.

   Every capture and verification script in deck/ drives a headless Chromium.
   They used to require it by absolute path, which worked on exactly one
   machine: a fresh clone of this repository could not run any of them. Normal
   resolution first, so `npm install` is all anyone needs; the fallback is for
   environments that only have it installed globally. */
var pw;
try {
  pw = require('playwright');
} catch (e) {
  pw = require('/opt/node22/lib/node_modules/playwright');
}
module.exports = pw;
