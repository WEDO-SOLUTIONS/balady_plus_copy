/* Optional artwork.

   The game runs with everything drawn in code. If the files in `assets/` are
   present they are used instead — a rendered stage plate behind the runway,
   sprite notes, sprite keycaps. Nothing waits on them: the loader is fire and
   forget, each image swaps in the frame after it decodes, and a missing or
   broken file just means that piece keeps its drawn version.

   `?art=0` forces the drawn version, which is how you compare the two.

   Provenance: these assets are cut from the Ardah concept image with
   `assets/extract.py`. They are a PLACEHOLDER for evaluating the look — the
   performers are baked into the backdrop and therefore do not animate, and the
   real production path is the layered delivery in docs/ardah-art-brief.md. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var NAMES = [
    'bg_stage',
    'note_tabl', 'note_swords', 'note_tar',
    'key_tabl', 'key_swords', 'key_tar'
  ];

  var images = {};
  var enabled = !/[?&]art=0/.test(location.search);
  var loaded = 0, failed = 0;

  function load() {
    if (!enabled) return;
    NAMES.forEach(function (name) {
      var img = new Image();
      img.onload = function () { images[name] = img; loaded++; };
      img.onerror = function () { failed++; };
      // The single-file build has no `assets/` next to it — it carries the
      // artwork inline instead (see build-single.sh).
      var inline = window.ArdahInlineAssets && window.ArdahInlineAssets[name];
      img.src = inline || ('assets/' + name + '.webp');
    });
  }

  A.assets = {
    get enabled() { return enabled; },
    /** The decoded image, or null — callers must handle null every frame. */
    img: function (name) { return images[name] || null; },
    get stats() { return { loaded: loaded, failed: failed, total: NAMES.length }; }
  };

  load();
})(window.Ardah);
