/* Drift the Desert — the baked roadside sprite sheet.

   Four rocks and four dry bushes, 512 px each in a 4x2 grid, lit in the same
   bake as the background. They replace the canvas paths that drew them
   before: a flat blob with an ellipse of highlight on it passed well enough
   over a painted floor and stopped passing the moment the sand underneath
   became a photograph.

   The one thing that needs care is haze. Distant props have to wash out into
   the same horizon colour as everything else, and there is no cheap way to
   tint a drawImage. So a second, flat-coloured copy of the sheet is kept
   alongside the real one and drawn over the top at the right weight. It is
   rebuilt only when the time of day has moved far enough to matter, which
   over a run is a couple of dozen times rather than sixty times a second. */
(function (global) {
  'use strict';

  /* One sheet. Two ship: the roadside props, and the cliffs that stand
     further out, which are the same thing at ten times the size. */
  function Sheet() {
    this.ready = false;
    this.img = null;
    this.cols = 4;
    this.rows = 2;
    this.cell = 0;
    // How far down its cell this sheet's subject actually stands, measured
    // off the alpha by tools/pack_background.py. It is not the same for every
    // sheet — the props end at 0.988 of their cell and the cliffs at 0.971 —
    // and assuming one number for both put them on two different ground
    // lines.
    this.foot = 0.95;
    this.tints = {};   // colour -> canvas: the sheet as a flat silhouette
    this.tintKeys = [];
  }

  Sheet.prototype = {
    load: function (url, grid, onDone, foot) {
      var self = this;
      var img = new global.Image();
      img.onload = function () {
        self.img = img;
        self.cols = (grid && grid[0]) || 4;
        self.rows = (grid && grid[1]) || 2;
        self.cell = img.naturalWidth / self.cols;
        self.foot = foot || 0.95;
        self.ready = self.cell > 0;
        if (onDone) onDone(self.ready);
      };
      img.onerror = function () { if (onDone) onDone(false); };
      img.src = url;
    },

    /** Silhouette of the whole sheet, filled with `colour`, cached per colour.
        Composite only — no getImageData, which a WebView running the game off
        file:// would refuse. */
    tintSheet: function (colour) {
      if (this.tints[colour]) {
        // Move it to the back of the queue. The eviction below was plain
        // FIFO, which ages a colour that is asked for every single frame just
        // as fast as one that is never asked for again — and rebuilding one of
        // these means repainting the whole sheet. Now that the shadows want a
        // colour of their own alongside the haze and the dusk, that matters.
        var at = this.tintKeys.indexOf(colour);
        if (at >= 0) { this.tintKeys.splice(at, 1); this.tintKeys.push(colour); }
        return this.tints[colour];
      }

      var c = global.document.createElement('canvas');
      c.width = this.img.naturalWidth;
      c.height = this.img.naturalHeight;
      var ctx = c.getContext('2d');
      ctx.drawImage(this.img, 0, 0);
      ctx.globalCompositeOperation = 'source-in';
      ctx.fillStyle = colour;
      ctx.fillRect(0, 0, c.width, c.height);

      this.tints[colour] = c;
      this.tintKeys.push(colour);
      // The haze colour is quantised by the caller, so this stays small; the
      // cap is only here so a long run cannot accumulate sheets forever.
      while (this.tintKeys.length > 6) {
        delete this.tints[this.tintKeys.shift()];
      }
      return c;
    },

    /** Draw sprite `index` with its base centred on (x, y) and `height` tall.
        `o.dusk` walks it into the evening and `o.fog` washes it towards the
        horizon, in that order — an evening rock is dark first and hazy
        second. The sheet is baked at golden hour only; dusk is a multiply
        through the silhouette, which keeps the relief a flat tint would lose
        and costs a megabyte less than a second bake. */
    /** The subject's own outline, laid flat on the sand and leaned away from
        the sun. An ellipse is the same shape whatever stands on it — a thorn
        bush and a boulder cast the same blob — and at these sizes the shape
        of the shadow is most of what tells you which one it is.

        The mirror is applied inside the sheared space, not outside it: the
        shear displaces by y alone, so flipping x cannot change which way the
        shadow leans. The sun does not flip when the sprite does. */
    drawShadow: function (ctx, index, x, y, height, o) {
      if (!this.ready) return false;
      var n = this.cols * this.rows;
      var i = ((index % n) + n) % n;
      var sx = (i % this.cols) * this.cell;
      var sy = Math.floor(i / this.cols) * this.cell;
      var f = this.foot;
      var size = height / f;
      var wide = size * ((o && o.wide) || 1);
      var was = ctx.globalAlpha;

      ctx.save();
      ctx.translate(x, y);
      ctx.transform(1, 0, -((o && o.skew) || 0.55), (o && o.squash) || 0.20, 0, 0);
      if (o && o.flip) ctx.scale(-1, 1);
      ctx.globalAlpha = was * ((o && o.strength) || 0.30);
      ctx.drawImage(this.tintSheet((o && o.colour) || '#3A2410'),
                    sx, sy, this.cell, this.cell,
                    -wide * 0.5, -size * f, wide, size);
      ctx.restore();
      ctx.globalAlpha = was;
      return true;
    },

    draw: function (ctx, index, x, y, height, o) {
      if (!this.ready) return false;
      var n = this.cols * this.rows;
      var i = ((index % n) + n) % n;
      var sx = (i % this.cols) * this.cell;
      var sy = Math.floor(i / this.cols) * this.cell;

      // The sprite is square and its subject stands on the cell's baseline.
      var f = this.foot;
      var size = height / f;
      // Mirrored and stretched per instance. Six baked landforms go a long
      // way, but the same one coming past the same way round is still the
      // same one; this is two more axes of variation for no extra texture.
      var wide = size * ((o && o.wide) || 1);
      var dx = x - wide * 0.5;
      var dy = y - size * f;
      var was = ctx.globalAlpha;
      var flip = !!(o && o.flip);
      if (flip) { ctx.save(); ctx.translate(x * 2, 0); ctx.scale(-1, 1); }

      ctx.drawImage(this.img, sx, sy, this.cell, this.cell, dx, dy, wide, size);

      if (o.dusk > 0.02 && o.duskColour) {
        ctx.globalCompositeOperation = 'multiply';
        ctx.globalAlpha = was * o.dusk;
        ctx.drawImage(this.tintSheet(o.duskColour), sx, sy, this.cell, this.cell, dx, dy, wide, size);
        ctx.globalCompositeOperation = 'source-over';
      }

      if (o.fog > 0.01 && o.hazeColour) {
        ctx.globalAlpha = was * o.fog;
        ctx.drawImage(this.tintSheet(o.hazeColour), sx, sy, this.cell, this.cell, dx, dy, wide, size);
      }

      if (flip) ctx.restore();
      ctx.globalAlpha = was;
      return true;
    }
  };

  var Sprites = new Sheet();
  Sprites.create = function () { return new Sheet(); };
  global.DriftSprites = Sprites;
})(window);
