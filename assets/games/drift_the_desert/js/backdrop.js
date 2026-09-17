/* Drift the Desert — baked parallax backdrop.

   Four plates behind the track: sky, a far range of buttes, a near range, and
   the dune field. Each is baked offline by tools/bake_background.js at a
   detail level no phone could afford per frame, and each wraps horizontally,
   so the parallax scrolls forever.

   Two things keep this cheap at runtime:

   - The terrain plates ship as plain JPEGs. Their silhouettes are not stored
     as an alpha channel — that cost more than the colour did — but as a
     height curve of a few hundred bytes, which is replayed here as a clip
     path. A 1280x300 layer went from ~400 KB to ~25 KB that way.
   - The time of day is a cross-fade between a golden-hour and a dusk bake,
     and either draw is skipped once its weight rounds away.

   Everything is optional: until `ready` flips, js/scene.js keeps drawing its
   own sky and mesas. */
(function (global) {
  'use strict';

  var LAYERS = ['sky', 'far', 'near', 'dunes'];
  var TIMES = ['gold', 'dusk'];

  function decodeHeights(b64) {
    var bin = global.atob(b64);
    var out = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
  }

  var Backdrop = {
    ready: false,
    plates: {},        // name -> { size, heights, img: {gold, dusk} }

    /** `manifest` is the object tools/pack_background.py wrote into
        js/plates.js; `urls` maps each plate file name to its url, so the
        single-file build can swap in data URIs. */
    load: function (manifest, urls, onProgress, onDone) {
      var self = this;
      if (!manifest || !manifest.plates) {
        if (onDone) onDone(false);
        return;
      }

      var total = LAYERS.length * TIMES.length;
      var pending = total;
      var failed = false;

      function step() {
        if (onProgress) onProgress(1 - pending / total);
        if (pending > 0) return;
        self.ready = !failed;
        if (onDone) onDone(self.ready);
      }

      LAYERS.forEach(function (name) {
        var meta = manifest.plates[name] || {};
        var plate = {
          size: meta.size || [1280, 400],
          heights: meta.heights ? decodeHeights(meta.heights) : null,
          img: {}
        };
        self.plates[name] = plate;

        TIMES.forEach(function (time) {
          var key = name + '-' + time + '.jpg';
          var img = new global.Image();
          img.onload = function () { plate.img[time] = img; pending--; step(); };
          img.onerror = function () { failed = true; pending--; step(); };
          img.src = urls[key];
        });
      });
    },

    /* ------------------------------------------------------------ drawing */

    /** Tile one plate across the viewport at `y`, `height`, wrapping by
        `offset`. Both time variants are drawn, the second weighted by dusk. */
    tile: function (ctx, plate, w, y, height, offset, dusk, srcFrac) {
      var frac = srcFrac || 1;
      var srcH = Math.max(1, Math.round(plate.size[1] * frac));
      var tileW = height * (plate.size[0] / srcH);
      var start = -(((offset % tileW) + tileW) % tileW);

      for (var pass = 0; pass < 2; pass++) {
        var img = plate.img[TIMES[pass]];
        if (!img) continue;
        if (pass === 1 && dusk <= 0.01) continue;
        if (pass === 0 && dusk >= 0.99) continue;

        ctx.globalAlpha = pass === 0 ? 1 : dusk;
        for (var x = start; x < w; x += tileW) {
          ctx.drawImage(img, 0, 0, plate.size[0], srcH, x, y, tileW + 1, height);
        }
      }
      ctx.globalAlpha = 1;
    },

    /** Clip to a terrain plate's skyline so the JPEG's filled-in sky does not
        paint a block above the ridge. */
    clipToSkyline: function (ctx, plate, w, y, height, offset, srcFrac) {
      var heights = plate.heights;
      if (!heights) return false;
      var n = heights.length;
      var frac = srcFrac || 1;
      var srcH = Math.max(1, Math.round(plate.size[1] * frac));
      var tileW = height * (plate.size[0] / srcH);
      var bottom = y + height;
      // In CSS pixels: on a 3x screen a coarser step beads the crest line.
      var step = 1;
      // The curve is coarse, so the boundary is nudged a pixel down: shaving a
      // crest is invisible, uncovering the JPEG's filled sky is not.
      var scale = height / frac;

      ctx.beginPath();
      ctx.moveTo(0, bottom);
      for (var x = 0; x <= w + step; x += step) {
        var u = ((x - offset) / tileW) % 1;
        if (u < 0) u += 1;
        // Interpolate between samples: taking the nearest one turned the
        // skyline into a visible staircase wherever a tile was drawn wider
        // than the curve is dense.
        var f = u * n;
        var i0 = Math.floor(f) % n;
        var i1 = (i0 + 1) % n;
        var h = heights[i0] + (heights[i1] - heights[i0]) * (f - Math.floor(f));
        ctx.lineTo(x, Math.min(bottom, y + (h / 255) * scale + 2));
      }
      ctx.lineTo(w + step, bottom);
      ctx.closePath();
      ctx.clip();
      return true;
    },

    /** state: { w, h, horizon, scroll, dusk } */
    drawSky: function (ctx, s) {
      if (!this.ready) return false;
      var plate = this.plates.sky;
      var height = s.horizon * 1.06;
      this.tile(ctx, plate, s.w, 0, height, s.scroll * 0.020, s.dusk);
      return true;
    },

    /** The two rock ranges, sitting on the horizon. */
    drawRanges: function (ctx, s) {
      if (!this.ready) return false;
      var ranges = [
        { name: 'far', height: s.h * 0.090, base: s.horizon + 2, speed: 0.055 },
        { name: 'near', height: s.h * 0.065, base: s.horizon + 5, speed: 0.105 }
      ];
      for (var i = 0; i < ranges.length; i++) {
        var r = ranges[i];
        var plate = this.plates[r.name];
        if (!plate) continue;
        var y = r.base - r.height;
        ctx.save();
        if (this.clipToSkyline(ctx, plate, s.w, y, r.height, s.scroll * r.speed)) {
          this.tile(ctx, plate, s.w, y, r.height, s.scroll * r.speed, s.dusk);
        }
        ctx.restore();
      }
      return true;
    },

    /** The dune field, drawn over the ground fill and under the track. */
    drawDunes: function (ctx, s) {
      if (!this.ready) return false;
      var plate = this.plates.dunes;
      if (!plate) return false;
      var frac = 0.52;
      var height = s.h * 0.20;
      var y = s.horizon - s.h * 0.010;
      var off = s.scroll * 0.19;
      ctx.save();
      if (this.clipToSkyline(ctx, plate, s.w, y, height, off, frac)) {
        this.tile(ctx, plate, s.w, y, height, off, s.dusk, frac);
      }
      ctx.restore();
      // Where the plate ends, so the caller can blend its own ground into it.
      this.duneBottom = y + height;
      return true;
    }
  };

  global.DriftBackdrop = Backdrop;
})(window);
