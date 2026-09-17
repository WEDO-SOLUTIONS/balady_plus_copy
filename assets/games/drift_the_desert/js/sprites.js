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

  var Sprites = {
    ready: false,
    img: null,
    cols: 4,
    rows: 2,
    cell: 0,

    tints: {},         // colour -> canvas: the sheet as a flat silhouette
    tintKeys: [],

    load: function (url, grid, onDone) {
      var self = this;
      var img = new global.Image();
      img.onload = function () {
        self.img = img;
        self.cols = (grid && grid[0]) || 4;
        self.rows = (grid && grid[1]) || 2;
        self.cell = img.naturalWidth / self.cols;
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
      if (this.tints[colour]) return this.tints[colour];

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
    draw: function (ctx, index, x, y, height, o) {
      if (!this.ready) return false;
      var n = this.cols * this.rows;
      var i = ((index % n) + n) % n;
      var sx = (i % this.cols) * this.cell;
      var sy = Math.floor(i / this.cols) * this.cell;

      // The sprite is square and its subject stands on the cell's baseline.
      var size = height / 0.95;
      var dx = x - size * 0.5;
      var dy = y - size * 0.95;

      ctx.drawImage(this.img, sx, sy, this.cell, this.cell, dx, dy, size, size);
      var was = ctx.globalAlpha;

      if (o.dusk > 0.02 && o.duskColour) {
        ctx.globalCompositeOperation = 'multiply';
        ctx.globalAlpha = was * o.dusk;
        ctx.drawImage(this.tintSheet(o.duskColour), sx, sy, this.cell, this.cell, dx, dy, size, size);
        ctx.globalCompositeOperation = 'source-over';
      }

      if (o.fog > 0.01 && o.hazeColour) {
        ctx.globalAlpha = was * o.fog;
        ctx.drawImage(this.tintSheet(o.hazeColour), sx, sy, this.cell, this.cell, dx, dy, size, size);
      }

      ctx.globalAlpha = was;
      return true;
    }
  };

  global.DriftSprites = Sprites;
})(window);
