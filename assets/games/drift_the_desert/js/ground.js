/* Drift the Desert — the sand under the car.

   Everything else in the scene is painted: gradients, strokes, a few
   silhouettes. The floor is the one surface the player stares at for a whole
   run, and a gradient with lines on it will never pass for sand. So this maps
   a baked, tileable sand texture onto the ground plane in perspective.

   The mapping is the standard one for a pinhole camera looking at a plane:
   with `t` running 0 at the horizon to 1 at the bottom of the frame, depth
   goes as 1/t, so a texel's width on screen goes as t and its height as t².
   Both are linear inside a band, so the floor is drawn as a handful of
   horizontal bands, each a single pattern fill under its own transform.

   Two details do most of the work:

   - **Adaptive bands.** Each band is cut where the depth has grown by a fixed
     ratio rather than at a fixed height, so the near field is a few tall
     bands and the far field a stack of thin ones. Thirteen bands cover the
     whole floor with the distortion inside each one down in the noise.
   - **Hand-rolled mips.** A pattern fill does not filter minification the way
     a GPU does, and sand at a fifth of its size crawls and sparkles. The
     texture is halved into a chain of canvases at load and each band picks
     the level where a texel lands near a device pixel.

   If anything here is missing — the texture, DOMMatrix, pattern transforms —
   `draw` returns false and js/scene.js keeps its painted floor. */
(function (global) {
  'use strict';

  // How many tiles span the screen width at the bottom of the frame. With the
  // baked texture's ripple spacing this puts them about 14 cm apart, which is
  // what the real ones measure.
  var TILE_ACROSS = 2.1;

  // Texels of travel per unit of `scroll`. Tuned against the speed streaks so
  // the floor and the rest of the frame agree about how fast the car is going.
  var TRAVEL = 12;

  // Depth ratio allowed inside one band. Smaller is more exact and costs more
  // fills; past about 1.3 the difference stops being visible.
  var BAND_RATIO = 1.28;

  /** One texture and its mip chain. Two of these ship: the open sand, and the
      road, which is the same mapping clipped to the track. */
  function Texture() {
    this.ready = false;
    this.size = 0;
    this.levels = [];      // level 0 is the texture itself, each next halved
    this.patterns = [];    // created lazily, per level, from the scene's context
  }

  Texture.prototype.load = function (url, onDone) {
    var self = this;
    var img = new global.Image();
    img.onload = function () {
      try {
        self.build(img);
        self.ready = true;
      } catch (e) {
        self.ready = false;
      }
      if (onDone) onDone(self.ready);
    };
    img.onerror = function () { if (onDone) onDone(false); };
    img.src = url;
  };

  /** Halve the texture down to 64 px, so every scale has a level to sit on. */
  Texture.prototype.build = function (img) {
    var size = img.naturalWidth || img.width;
    var c = global.document.createElement('canvas');
    c.width = size;
    c.height = size;
    c.getContext('2d').drawImage(img, 0, 0);

    this.size = size;
    this.levels = [c];
    this.patterns = [];

    var prev = c;
    while (prev.width > 64) {
      var next = global.document.createElement('canvas');
      next.width = prev.width >> 1;
      next.height = prev.height >> 1;
      var nc = next.getContext('2d');
      nc.imageSmoothingEnabled = true;
      nc.drawImage(prev, 0, 0, next.width, next.height);
      this.levels.push(next);
      prev = next;
    }
  };

  Texture.prototype.patternFor = function (ctx, level) {
    if (!this.patterns[level]) {
      this.patterns[level] = ctx.createPattern(this.levels[level], 'repeat');
    }
    return this.patterns[level];
  };

  var Ground = {
    ready: false,
    roadReady: false,
    sand: new Texture(),
    road: new Texture(),

    /** `urls` is {sand, road} — file paths, or data URIs in the single-file
        build. The road is optional; without it the track stays painted. */
    load: function (urls, onDone) {
      var self = this;
      var left = 2;
      function step() {
        if (--left > 0) return;
        self.ready = self.sand.ready;
        self.roadReady = self.road.ready;
        if (onDone) onDone(self.ready);
      }
      this.sand.load(urls.sand, step);
      if (urls.road) this.road.load(urls.road, step); else step();
    },

    /** Draw the floor. `o` is {w, h, horizon, dpr, scroll, lateral, dusk}.
        Returns false if the texture is not usable, so the caller can fall
        back to its own painted ground. */
    draw: function (ctx, o) {
      return this.bands(ctx, o, this.sand, false);
    },

    /** The road. Same mapping, same scroll, so it cannot drift against the
        sand it is cut into; the only difference is that the tile is centred
        on the track rather than on the frame, which puts the baked ruts under
        the wheels. The caller has already clipped to the track. */
    drawRoad: function (ctx, o) {
      if (!this.roadReady) return false;
      return this.bands(ctx, o, this.road, true);
    },

    bands: function (ctx, o, tex, centred) {
      if (!tex.ready || !global.DOMMatrix) return false;

      var bottom = o.h * 1.04;
      var span = bottom - o.horizon;
      if (span <= 1) return false;

      var A0 = TILE_ACROSS * o.w / tex.size;     // css px per texel at t = 1
      var TD = span / A0;                        // depth at the bottom, texels
      var travel = o.scroll * TRAVEL;
      var maxLevel = tex.levels.length - 1;

      var tBot = 1;
      ctx.save();
      // The floor never reaches the horizon: the last band would be a single
      // row of pixels holding a thousand texels. It dissolves into the haze
      // instead, which is where the plates take over.
      while (tBot > 0.035) {
        var tTop = tBot / BAND_RATIO;
        if (tTop < 0.035) tTop = 0.035;

        var yBot = o.horizon + span * tBot;
        var yTop = o.horizon + span * tTop;
        var tyBot = TD / tBot + travel;
        var tyTop = TD / tTop + travel;

        var tMid = (tTop + tBot) * 0.5;
        var a = A0 * tMid;                       // css px per texel across
        var d = (yBot - yTop) / (tyBot - tyTop); // css px per texel down

        // Pick the level whose texels land near a device pixel.
        var level = Math.round(Math.log(1 / Math.max(1e-6, a * o.dpr)) / Math.LN2);
        level = level < 0 ? 0 : (level > maxLevel ? maxLevel : level);
        var k = 1 << level;

        var pattern = tex.patternFor(ctx, level);
        if (!pattern || !pattern.setTransform) { ctx.restore(); return false; }

        // The track's centre drifts with the steering; the floor goes with it,
        // so the world turns rather than the road sliding over it.
        var s = 0.035 + 0.965 * tMid;
        var cx = o.w * 0.5 - (o.lateral || 0) * o.w * 0.06 * (1 - s);
        // The road tile carries its ruts down the middle, so its centre
        // column is what has to land on the track's centre line.
        if (centred) cx -= a * tex.size * 0.5;

        pattern.setTransform(new global.DOMMatrix([
          a * k, 0, 0, d * k, cx, yTop - d * tyTop
        ]));

        // A long ramp: the floor has to dissolve into the hazy band the
        // plates end in, and a short one left a horizon-wide step in it.
        var alpha = tMid < 0.20 ? (tMid - 0.035) / 0.165 : 1;
        var bh = yBot - yTop + 1;
        ctx.globalAlpha = alpha;
        ctx.fillStyle = pattern;
        ctx.fillRect(0, yTop, o.w, bh);

        // Motion blur, near field only. A photograph taken from a car at this
        // speed has no sharp pebbles at the bottom of the frame, and leaving
        // them sharp was the last thing making the floor look like a texture
        // rather than like ground going past. Two trailing copies, offset
        // back up the frame, are enough to smear it.
        // Ramped in rather than switched on: a hard cutoff put a horizontal
        // seam across the frame where the sharp bands met the smeared ones.
        var smear = o.blur * (tMid < 0.35 ? 0 : (tMid > 0.75 ? 1 : (tMid - 0.35) / 0.40));
        if (smear > 0.02) {
          pattern.setTransform(new global.DOMMatrix([
            a * k, 0, 0, d * k, cx, yTop - d * tyTop - bh * 0.55 * smear * tMid
          ]));
          ctx.globalAlpha = alpha * 0.42 * smear;
          ctx.fillRect(0, yTop, o.w, bh);
          ctx.globalAlpha = alpha;
        }

        // Evening. The texture is baked at golden hour only — a second bake
        // would double both the download and the fills — so dusk is a
        // multiply over the same sand, band by band, following the same fade
        // so it never spills onto the plates above.
        if (o.dusk > 0.02 && o.tint) {
          ctx.globalCompositeOperation = 'multiply';
          ctx.globalAlpha = alpha * o.dusk;
          ctx.fillStyle = o.tint;
          ctx.fillRect(0, yTop, o.w, bh);
          ctx.globalCompositeOperation = 'source-over';
        }

        tBot = tTop;
      }
      ctx.restore();
      return true;
    }
  };

  global.DriftGround = Ground;
})(window);
