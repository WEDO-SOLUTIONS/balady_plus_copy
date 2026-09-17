/* Drift the Desert — canvas scene.

   Everything is drawn procedurally (no image assets): sunset sky, clouds,
   sandstone mesas, dune ridges, a perspective desert track, the two-wheeled
   Land-Cruiser-style SUV with its driver hanging out of the window, dust,
   sand spray and collectible coins. */
(function (global) {
  'use strict';

  var TAU = Math.PI * 2;

  /* Resting lean of a two-wheel drift. The hero sprite is a rear shot of a car
     sitting flat, so the whole pose is applied here. */
  var CAR_LEAN = -0.30;

  /* Where the driver sits on the car, in car-sprite units — the geometry
     tools/extract_assets.py worked out with the crops. The two are shipped as
     separate sprites and composited here: baked into one image, his arm span
     widened the bounding box and cost the car 15% of its resolution. */
  var SEAT = 0.835;   // fraction of the car's width his torso centres on
  var LIFT = 1.10;    // how far his waist sits below the roof, in his heights
  var DRIVER = 0.36;  // his height relative to the car's

  function clamp(v, a, b) { return v < a ? a : (v > b ? b : v); }
  function lerp(a, b, t) { return a + (b - a) * t; }
  function rand(a, b) { return a + Math.random() * (b - a); }
  function noop() { return false; }

  /** `rgb(...)` with an alpha, for gradient stops that need to fade out. */
  function rgba(rgbString, alpha) {
    return rgbString.replace('rgb(', 'rgba(').replace(')', ',' + alpha + ')');
  }

  /** Blend two #rrggbb colours — used to walk the palette into dusk. */
  function mixHex(a, b, t) {
    var ai = parseInt(a.slice(1), 16), bi = parseInt(b.slice(1), 16);
    var r = Math.round(lerp((ai >> 16) & 255, (bi >> 16) & 255, t));
    var g = Math.round(lerp((ai >> 8) & 255, (bi >> 8) & 255, t));
    var bl = Math.round(lerp(ai & 255, bi & 255, t));
    return 'rgb(' + r + ',' + g + ',' + bl + ')';
  }

  /* Deterministic pseudo-random so the terrain silhouette is stable between
     frames without storing every vertex. */
  function hash(n) {
    var x = Math.sin(n * 127.1) * 43758.5453;
    return x - Math.floor(x);
  }

  /* Art cut out of the design mockup (see tools/extract_assets.py). Every
     draw path keeps its procedural version, so a missing or still-loading
     image degrades to vector art instead of a blank frame. */
  var IMG = {};

  /** `entries` is a list of [key, url] pairs. The key is explicit so the
      single-file build can rewrite the urls into data URIs without the lookup
      names changing underneath it. */
  function loadImages(entries, onProgress) {
    var left = entries.length;
    if (!left && onProgress) onProgress(1);
    for (var i = 0; i < entries.length; i++) {
      (function (key, url) {
        var img = new global.Image();
        function done(ok) {
          if (ok) IMG[key] = img;
          if (onProgress) onProgress(1 - (--left) / entries.length);
        }
        img.onload = function () { done(true); };
        img.onerror = function () { done(false); };
        img.src = url;
      })(entries[i][0], entries[i][1]);
    }
  }

  var Backdrop = global.DriftBackdrop || { ready: false, drawSky: noop, drawRanges: noop, drawDunes: noop };

  var Scene = {
    images: IMG,
    loadImages: loadImages,
    canvas: null,
    ctx: null,
    w: 0,
    h: 0,
    dpr: 1,

    horizon: 0,
    scroll: 0,
    time: 0,
    shake: 0,
    flash: 0,

    particles: [],
    sparks: [],

    init: function (canvas) {
      this.canvas = canvas;
      this.ctx = canvas.getContext('2d');
      this.resize();
      global.addEventListener('resize', this.resize.bind(this));
      global.addEventListener('orientationchange', this.resize.bind(this));
    },

    resize: function () {
      var rect = this.canvas.getBoundingClientRect();
      var w = Math.max(1, Math.round(rect.width));
      var h = Math.max(1, Math.round(rect.height));
      // Cap the device pixel ratio: mid-range Android WebViews choke on 3x.
      this.dpr = Math.min(global.devicePixelRatio || 1, 2);
      this.w = w;
      this.h = h;
      this.canvas.width = Math.round(w * this.dpr);
      this.canvas.height = Math.round(h * this.dpr);
      this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
      this.baseHorizon = Math.round(h * 0.44);
      this.horizon = this.baseHorizon;
      this._sky = null; // gradients are cached per size
    },

    /* ----------------------------------------------------------- helpers */

    /** What the baked plates need to place themselves in this frame. */
    plateState: function (dusk) {
      return {
        w: this.w,
        h: this.h,
        horizon: this.horizon,
        scroll: this.scroll,
        dusk: clamp(dusk || 0, 0, 1)
      };
    },

    /** Depth 0 = horizon, 1 = at the camera. Returns {y, s}. */
    project: function (d) {
      var t = Math.pow(clamp(d, 0, 1), 2.35);
      return {
        y: this.horizon + (this.h * 1.04 - this.horizon) * t,
        s: 0.035 + 0.965 * t
      };
    },

    addDust: function (x, y, amount, tint) {
      for (var i = 0; i < amount; i++) {
        this.particles.push({
          x: x + rand(-14, 14),
          y: y + rand(-6, 10),
          vx: rand(-40, 40),
          vy: rand(-58, -8),
          r: rand(8, 20),
          life: 1,
          decay: rand(0.55, 1.15),
          tint: tint || 0
        });
      }
    },

    addSparks: function (x, y, amount, color) {
      for (var i = 0; i < amount; i++) {
        var a = rand(0, TAU);
        var sp = rand(60, 260);
        this.sparks.push({
          x: x, y: y,
          vx: Math.cos(a) * sp,
          vy: Math.sin(a) * sp - 60,
          life: 1,
          decay: rand(1.2, 2.2),
          color: color || '#F7E2A8',
          size: rand(2, 5)
        });
      }
    },

    kick: function (power) { this.shake = Math.max(this.shake, power); },
    flashWhite: function (power) { this.flash = Math.max(this.flash, power); },

    /* -------------------------------------------------------------- sky */

    drawSky: function (dusk) {
      var ctx = this.ctx;
      if (Backdrop.drawSky(ctx, this.plateState(dusk))) return;

      var sky = IMG.sky;

      if (sky) {
        // The strip is mirror-tiled, so it wraps: pan it for parallax.
        var sh = this.horizon + 30;
        var sw = sh * (sky.width / sky.height);
        var off = (this.scroll * 0.03) % sw;
        for (var x = -off; x < this.w; x += sw) ctx.drawImage(sky, x, 0, sw, sh);
      } else {
        if (!this._sky) {
          var g = ctx.createLinearGradient(0, 0, 0, this.horizon + 30);
          g.addColorStop(0.00, '#123A55');
          g.addColorStop(0.28, '#3C6E88');
          g.addColorStop(0.55, '#8CAFB8');
          g.addColorStop(0.78, '#E3B27C');
          g.addColorStop(1.00, '#F6D79D');
          this._sky = g;
        }
        ctx.fillStyle = this._sky;
        ctx.fillRect(0, 0, this.w, this.horizon + 30);
      }

      // Sun, low over the dunes.
      var sx = this.w * 0.68;
      var sy = this.horizon - this.h * 0.055;
      var glow = ctx.createRadialGradient(sx, sy, 2, sx, sy, this.h * 0.24);
      glow.addColorStop(0, 'rgba(255, 233, 186, 0.95)');
      glow.addColorStop(0.28, 'rgba(255, 199, 122, 0.45)');
      glow.addColorStop(1, 'rgba(255, 176, 96, 0)');
      ctx.fillStyle = glow;
      ctx.beginPath();
      ctx.arc(sx, sy, this.h * 0.24, 0, TAU);
      ctx.fill();

      ctx.fillStyle = 'rgba(255, 244, 214, 0.95)';
      ctx.beginPath();
      ctx.arc(sx, sy, this.h * 0.035, 0, TAU);
      ctx.fill();

      if (!sky) this.drawClouds();
    },

    drawClouds: function () {
      var ctx = this.ctx;
      var drift = this.scroll * 0.012;
      ctx.save();
      for (var i = 0; i < 7; i++) {
        var seed = i * 7.31;
        var baseX = (hash(seed) * 1.6 - 0.3) * this.w;
        var x = ((baseX - drift * (0.4 + hash(seed + 1) * 0.6)) % (this.w * 1.8) + this.w * 1.8) % (this.w * 1.8) - this.w * 0.4;
        var y = this.horizon * (0.12 + hash(seed + 2) * 0.58);
        var scale = 0.5 + hash(seed + 3) * 1.1;
        var alpha = 0.10 + hash(seed + 4) * 0.20;
        ctx.fillStyle = 'rgba(255, 248, 238, ' + alpha.toFixed(3) + ')';
        for (var b = 0; b < 4; b++) {
          var bx = x + (b - 1.5) * 26 * scale;
          var by = y + Math.sin(b * 1.7 + seed) * 5 * scale;
          var br = (16 + hash(seed + b) * 16) * scale;
          ctx.beginPath();
          ctx.ellipse(bx, by, br, br * 0.44, 0, 0, TAU);
          ctx.fill();
        }
      }
      ctx.restore();
    },

    /* ------------------------------------------------------------ mesas */

    drawMesas: function (dusk) {
      var ctx = this.ctx;
      if (Backdrop.drawRanges(ctx, this.plateState(dusk))) return;

      var warm = this.ctx.createLinearGradient(0, this.horizon - this.h * 0.20, 0, this.horizon + this.h * 0.03);
      warm.addColorStop(0, 'rgba(246, 206, 150, 0)');
      warm.addColorStop(1, 'rgba(246, 206, 150, 0.85)');
      ctx.fillStyle = warm;
      ctx.fillRect(0, this.horizon - this.h * 0.20, this.w, this.h * 0.23);

      if (IMG.ridge) {
        var r = IMG.ridge;
        var bh = this.h * 0.085;
        var bw = bh * (r.width / r.height);
        var off = (this.scroll * 0.09) % bw;
        var top = this.horizon + 6 - bh;
        for (var rx = -off; rx < this.w; rx += bw) ctx.drawImage(r, rx, top, bw, bh);

        var haze = ctx.createLinearGradient(0, this.horizon - this.h * 0.05, 0, this.horizon + this.h * 0.02);
        haze.addColorStop(0, 'rgba(246, 215, 157, 0)');
        haze.addColorStop(1, 'rgba(246, 215, 157, 0.6)');
        ctx.fillStyle = haze;
        ctx.fillRect(0, this.horizon - this.h * 0.05, this.w, this.h * 0.07);
        return;
      }

      var layers = [
        { h: 0.075, color: '#A9866A', alpha: 0.5, par: 0.010, seed: 3, step: 0.30 },
        { h: 0.055, color: '#8A6449', alpha: 0.75, par: 0.026, seed: 11, step: 0.24 }
      ];

      for (var l = 0; l < layers.length; l++) {
        var cfg = layers[l];
        var step = this.w * cfg.step;
        var off = this.scroll * cfg.par;
        var base = this.horizon + 2;

        ctx.save();
        ctx.globalAlpha = cfg.alpha;
        ctx.fillStyle = cfg.color;

        for (var i = -1; i <= Math.ceil(this.w / step) + 1; i++) {
          var k = i + Math.floor(off / step);
          var gap = hash(k * 3.1 + cfg.seed);
          if (gap < 0.32) continue;                       // open desert between buttes

          var x = i * step - (off % step);
          var hgt = this.h * cfg.h * (0.55 + hash(k * 1.7 + cfg.seed) * 0.9);
          var wdt = step * (0.34 + hash(k * 2.3 + cfg.seed) * 0.34);
          var top = base - hgt;
          var lean = (hash(k * 5.7 + cfg.seed) - 0.5) * wdt * 0.12;

          // Flat-topped sandstone butte with sloped talus at the base.
          ctx.beginPath();
          ctx.moveTo(x, base);
          ctx.lineTo(x + wdt * 0.13, top + hgt * 0.16);
          ctx.lineTo(x + wdt * 0.26 + lean, top);
          ctx.lineTo(x + wdt * 0.76 + lean, top - hgt * 0.04);
          ctx.lineTo(x + wdt * 0.89, top + hgt * 0.20);
          ctx.lineTo(x + wdt, base);
          ctx.closePath();
          ctx.fill();

          // Sun-facing side catches the light.
          ctx.save();
          ctx.globalAlpha = cfg.alpha * 0.35;
          ctx.fillStyle = '#F0C68F';
          ctx.beginPath();
          ctx.moveTo(x + wdt * 0.76 + lean, top - hgt * 0.04);
          ctx.lineTo(x + wdt * 0.89, top + hgt * 0.20);
          ctx.lineTo(x + wdt, base);
          ctx.lineTo(x + wdt * 0.82, base);
          ctx.closePath();
          ctx.fill();
          ctx.restore();
        }
        ctx.restore();
      }

      // Heat haze softening the base of the range into the sand.
      var haze = ctx.createLinearGradient(0, this.horizon - this.h * 0.06, 0, this.horizon + this.h * 0.02);
      haze.addColorStop(0, 'rgba(246, 215, 157, 0)');
      haze.addColorStop(1, 'rgba(246, 215, 157, 0.75)');
      ctx.fillStyle = haze;
      ctx.fillRect(0, this.horizon - this.h * 0.06, this.w, this.h * 0.08);
    },

    /* ------------------------------------------------------------ dunes */

    drawGround: function (dusk) {
      var ctx = this.ctx;
      var night = clamp(dusk || 0, 0, 1);

      // The gradient starts transparent well above the horizon so the ground
      // dissolves into the ridge instead of butting against it with an edge.
      var top = this.horizon - this.h * 0.05;
      var g = ctx.createLinearGradient(0, top, 0, this.h);
      g.addColorStop(0.00, rgba(mixHex('#EBC694', '#6B4A48', night), 0));
      g.addColorStop(0.07, rgba(mixHex('#EBC694', '#6B4A48', night), 1));
      g.addColorStop(0.24, mixHex('#D9A874', '#553A38', night));
      g.addColorStop(0.60, mixHex('#BC8552', '#3B2724', night));
      g.addColorStop(1.00, mixHex('#8E5C32', '#241816', night));
      ctx.fillStyle = g;
      ctx.fillRect(0, top, this.w, this.h - top);

      if (Backdrop.drawDunes(ctx, this.plateState(night))) {
        // The dune plate stops partway down the frame; wash the ground colour
        // back over its lower edge so the seam disappears. Erasing instead
        // would punch a hole through the ground fill underneath it.
        var end = Backdrop.duneBottom || (this.horizon + this.h * 0.2);
        var seam = ctx.createLinearGradient(0, end - this.h * 0.085, 0, end + this.h * 0.02);
        seam.addColorStop(0, rgba(mixHex('#C79463', '#4A322C', night), 0));
        seam.addColorStop(1, rgba(mixHex('#C79463', '#4A322C', night), 1));
        ctx.fillStyle = seam;
        ctx.fillRect(0, end - this.h * 0.085, this.w, this.h * 0.105);
        return;
      }

      // Two dune ridges rolling towards the camera.
      var ridges = [
        { d: 0.10, amp: 0.020, color: 'rgba(255, 224, 178, 0.30)', par: 0.05, seed: 21 },
        { d: 0.24, amp: 0.030, color: 'rgba(150, 96, 50, 0.22)', par: 0.13, seed: 37 }
      ];

      for (var r = 0; r < ridges.length; r++) {
        var cfg = ridges[r];
        var baseY = this.project(cfg.d).y;
        var off = this.scroll * cfg.par;
        ctx.fillStyle = cfg.color;
        ctx.beginPath();
        ctx.moveTo(-10, baseY + this.h * 0.08);
        for (var x = -10; x <= this.w + 10; x += 12) {
          var n =
            Math.sin((x + off) * 0.012 + cfg.seed) * 0.6 +
            Math.sin((x + off) * 0.031 + cfg.seed * 2) * 0.3 +
            Math.sin((x + off) * 0.006) * 0.4;
          ctx.lineTo(x, baseY + n * this.h * cfg.amp);
        }
        ctx.lineTo(this.w + 10, baseY + this.h * 0.12);
        ctx.closePath();
        ctx.fill();
      }
    },

    /* ------------------------------------------------------------ track */

    /** Half-width of the track at depth `d`, and the x it is centred on. */
    trackAt: function (d, lateral) {
      var p = this.project(d);
      var cx = lerp(this.w * 0.5 - lateral * this.w * 0.06, this.w * 0.5, p.s);
      return { y: p.y, s: p.s, cx: cx, half: lerp(this.w * 0.055, this.w * 0.95, p.s) * 0.5 };
    },

    /** Wobble of the track's edge at depth `d` — the drift of loose sand that
        stops the shoulders reading as painted runway lines. */
    edgeNoise: function (d, side) {
      var t = d * 7 + this.scroll * 0.004 + (side > 0 ? 31.7 : 0);
      return (Math.sin(t) * 0.6 + Math.sin(t * 2.7 + 1.3) * 0.3 + Math.sin(t * 6.1) * 0.1);
    },

    drawTrack: function (lateral, dusk) {
      var ctx = this.ctx;
      var night = clamp(dusk || 0, 0, 1);
      var farY = this.project(0.0).y;
      var nearY = this.h * 1.04;
      var STEPS = 26;
      var self = this;

      /* The track outline, with both edges eaten into by drifting sand. */
      function edgePath() {
        ctx.beginPath();
        var i, t, p;
        for (i = 0; i <= STEPS; i++) {
          t = self.trackAt(i / STEPS, lateral);
          p = t.cx - t.half * (1 - self.edgeNoise(i / STEPS, -1) * 0.13 * t.s);
          if (i === 0) ctx.moveTo(p, t.y); else ctx.lineTo(p, t.y);
        }
        for (i = STEPS; i >= 0; i--) {
          t = self.trackAt(i / STEPS, lateral);
          p = t.cx + t.half * (1 - self.edgeNoise(i / STEPS, 1) * 0.13 * t.s);
          ctx.lineTo(p, t.y);
        }
        ctx.closePath();
      }

      ctx.save();
      edgePath();
      var g = ctx.createLinearGradient(0, farY, 0, nearY);
      g.addColorStop(0.00, rgba(mixHex('#D3AE81', '#7B5850', night), 0));
      g.addColorStop(0.09, mixHex('#D3AE81', '#7B5850', night));
      g.addColorStop(0.45, mixHex('#A87B4B', '#4B3128', night));
      g.addColorStop(1.00, mixHex('#7E552C', '#2E1E18', night));
      ctx.fillStyle = g;
      ctx.fill();
      ctx.clip();

      /* Drag marks running down the road. The photographic sand tile was tried
         here first and had to go: at 264 px stretched across the full width it
         resolved into rectangular patches wherever two slices sampled
         different parts of it. Longitudinal streaks are what a packed sand
         track actually shows at speed, and they stay sharp at any resolution. */
      var streaks = 16;
      for (var st = 0; st < streaks; st++) {
        var sseed = st * 2.11;
        var lane = (hash(sseed) - 0.5) * 1.9;
        var phase = (hash(sseed + 4.3) + this.scroll * 0.0016) % 1;
        var len = 0.30 + hash(sseed + 8.9) * 0.45;
        var pale = hash(sseed + 1.7) > 0.5;

        ctx.beginPath();
        var drawn = 0;
        for (var sj = 0; sj <= 14; sj++) {
          var sd = phase + (sj / 14) * len;
          if (sd > 1) break;
          if (sd < 0.30) continue;
          var stt = this.trackAt(sd, lateral);
          var sx = stt.cx + lane * stt.half + this.edgeNoise(sd * 1.3, st % 2 ? 1 : -1) * stt.half * 0.05;
          if (drawn++ === 0) ctx.moveTo(sx, stt.y); else ctx.lineTo(sx, stt.y);
        }
        if (drawn < 2) continue;
        ctx.strokeStyle = pale
          ? 'rgba(255, 228, 184, ' + (0.07 * (1 - night * 0.6)).toFixed(3) + ')'
          : 'rgba(78, 48, 22, 0.09)';
        ctx.lineWidth = 2 + hash(sseed + 5.5) * 5;
        ctx.stroke();
      }

      /* Two tyre ruts: a scooped shadow with a lit ridge of thrown sand on the
         outside of each. */
      for (var side = -1; side <= 1; side += 2) {
        for (var pass = 0; pass < 2; pass++) {
          ctx.beginPath();
          var started = 0;
          for (var j = 0; j <= STEPS; j++) {
            var d = j / STEPS;
            if (d < 0.28) continue;
            var tr = this.trackAt(d, lateral);
            var wob = this.edgeNoise(d * 0.55, side) * 0.11;
            var x = tr.cx + side * tr.half * (0.40 + wob) + (pass ? tr.half * side * 0.075 : 0);
            if (started++ === 0) ctx.moveTo(x, tr.y); else ctx.lineTo(x, tr.y);
          }
          ctx.strokeStyle = pass
            ? 'rgba(255, 226, 178, ' + (0.16 * (1 - night * 0.6)).toFixed(3) + ')'
            : 'rgba(74, 44, 18, 0.30)';
          ctx.lineWidth = pass ? 3 : 7;
          ctx.stroke();
        }
      }

      /* Stones and scrub scattered over the surface, scaled and spaced by
         perspective so they rush at the camera with everything else. */
      var pebbles = 34;
      for (var k = 0; k < pebbles; k++) {
        var seed = k * 1.37;
        var pd = ((hash(seed) + this.scroll * 0.0013) % 1);
        if (pd < 0.30) continue;
        var pt = this.trackAt(pd, lateral);
        var across = (hash(seed + 3.1) - 0.5) * 1.75;
        var px = pt.cx + across * pt.half;
        var r = (0.8 + hash(seed + 7.7) * 2.2) * pt.s * 2.2;
        if (r < 0.4) continue;
        ctx.fillStyle = hash(seed + 11.3) > 0.72
          ? 'rgba(62, 48, 22, 0.45)'          // scrub
          : 'rgba(96, 66, 34, 0.38)';         // stone
        ctx.beginPath();
        ctx.ellipse(px, pt.y, r, r * 0.55, 0, 0, TAU);
        ctx.fill();
      }

      ctx.restore();

      /* Banks of loose sand piled along the edges — drawn as a soft band that
         follows the same wobble, rather than a ruled line. */
      ctx.save();
      for (var sd = -1; sd <= 1; sd += 2) {
        ctx.beginPath();
        for (var m = 0; m <= STEPS; m++) {
          var md = m / STEPS;
          var mt = this.trackAt(md, lateral);
          var mx = mt.cx + sd * mt.half * (1 - this.edgeNoise(md, sd) * 0.13 * mt.s);
          if (m === 0) ctx.moveTo(mx, mt.y); else ctx.lineTo(mx, mt.y);
        }
        var bank = ctx.createLinearGradient(0, farY, 0, nearY);
        bank.addColorStop(0.00, 'rgba(255, 226, 180, 0)');
        bank.addColorStop(0.12, 'rgba(255, 226, 180, 0)');
        bank.addColorStop(0.45, 'rgba(255, 226, 180, ' + (0.12 * (1 - night * 0.7)).toFixed(3) + ')');
        bank.addColorStop(1, 'rgba(255, 226, 180, ' + (0.26 * (1 - night * 0.7)).toFixed(3) + ')');
        ctx.strokeStyle = bank;
        ctx.lineWidth = 10;
        ctx.lineJoin = 'round';
        ctx.stroke();
      }
      ctx.restore();
    },

    /* -------------------------------------------------------------- car */

    /** Front-three-quarter SUV riding on two wheels, with the driver leaning
        out of the window — the hero pose from the design. */
    drawCar: function (cx, cy, size, tilt, wobble, danger) {
      if (IMG.car) {
        this.drawCarPhoto(cx, cy, size, tilt, wobble, danger);
        return;
      }
      var ctx = this.ctx;
      // Resting lean of a two-wheel drift, plus the player's deviation.
      var angle = -0.44 + tilt * 0.46 + Math.sin(wobble) * 0.018;

      // Ground shadow stays flat under the car.
      ctx.save();
      ctx.globalAlpha = 0.20;
      ctx.fillStyle = '#4A2E13';
      ctx.beginPath();
      ctx.ellipse(cx + tilt * size * 0.12, cy + size * 0.34, size * 0.42, size * 0.055, 0, 0, TAU);
      ctx.fill();
      ctx.restore();

      ctx.save();
      ctx.translate(cx, cy + Math.sin(wobble) * size * 0.012);
      ctx.rotate(angle);
      ctx.scale(size / 100, size / 100);

      var white = '#F2F3F0';
      var shade = '#C9CCC6';

      // --- wheels (drawn first; the body sits over their top half) --------
      function wheel(wx, wy, rw, rh) {
        ctx.fillStyle = '#121413';
        ctx.beginPath();
        ctx.ellipse(wx, wy, rw, rh, 0, 0, TAU);
        ctx.fill();
        // Tread blocks around the visible bottom of the tyre.
        ctx.strokeStyle = '#2C302E';
        ctx.lineWidth = 1.5;
        for (var a = 0.15; a < 2.85; a += 0.34) {
          ctx.beginPath();
          ctx.moveTo(wx + Math.cos(a) * rw * 0.78, wy + Math.sin(a) * rh * 0.78);
          ctx.lineTo(wx + Math.cos(a) * rw, wy + Math.sin(a) * rh);
          ctx.stroke();
        }
        ctx.fillStyle = '#5A5F5C';
        ctx.beginPath();
        ctx.ellipse(wx, wy, rw * 0.5, rh * 0.5, 0, 0, TAU);
        ctx.fill();
        ctx.fillStyle = '#9BA19C';
        ctx.beginPath();
        ctx.ellipse(wx, wy, rw * 0.24, rh * 0.24, 0, 0, TAU);
        ctx.fill();
      }
      wheel(-34, 32, 14, 16);   // airborne side
      wheel(34, 32, 14, 16);    // loaded side

      // --- chassis / bumper ------------------------------------------------
      ctx.fillStyle = '#20241F';
      roundRect(ctx, -47, 14, 94, 18, 5);
      ctx.fill();

      // Fog lamps
      ctx.fillStyle = 'rgba(255, 226, 160, 0.92)';
      ctx.beginPath(); ctx.ellipse(-37, 24, 4.6, 3.2, 0, 0, TAU); ctx.fill();
      ctx.beginPath(); ctx.ellipse(37, 24, 4.6, 3.2, 0, 0, TAU); ctx.fill();

      // --- main body -------------------------------------------------------
      var bodyGrad = ctx.createLinearGradient(-48, -30, 48, 30);
      bodyGrad.addColorStop(0, '#FFFFFF');
      bodyGrad.addColorStop(0.55, white);
      bodyGrad.addColorStop(1, shade);
      ctx.fillStyle = bodyGrad;
      roundRect(ctx, -48, -16, 96, 33, 8);
      ctx.fill();

      // Wheel arches tie the body to the tyres.
      ctx.fillStyle = 'rgba(28, 32, 29, 0.85)';
      ctx.beginPath(); ctx.ellipse(-34, 19, 16, 9, 0, Math.PI, TAU); ctx.fill();
      ctx.beginPath(); ctx.ellipse(34, 19, 16, 9, 0, Math.PI, TAU); ctx.fill();

      // Grille
      ctx.fillStyle = '#2A2E2B';
      roundRect(ctx, -21, -7, 42, 14, 3);
      ctx.fill();
      ctx.strokeStyle = '#787D79';
      ctx.lineWidth = 1.3;
      for (var gi = 0; gi < 3; gi++) {
        ctx.beginPath();
        ctx.moveTo(-19, -3.5 + gi * 4);
        ctx.lineTo(19, -3.5 + gi * 4);
        ctx.stroke();
      }

      // Headlights with a warm beam
      function lamp(lx) {
        var lg = ctx.createRadialGradient(lx, -1, 1, lx, -1, 13);
        lg.addColorStop(0, 'rgba(255, 250, 228, 0.9)');
        lg.addColorStop(0.55, 'rgba(255, 224, 155, 0.32)');
        lg.addColorStop(1, 'rgba(255, 210, 120, 0)');
        ctx.fillStyle = lg;
        ctx.beginPath(); ctx.arc(lx, -1, 13, 0, TAU); ctx.fill();
        ctx.fillStyle = '#FFFDF2';
        roundRect(ctx, lx - 9, -6, 18, 10, 3);
        ctx.fill();
        ctx.strokeStyle = 'rgba(120, 126, 122, 0.8)';
        ctx.lineWidth = 1;
        roundRect(ctx, lx - 9, -6, 18, 10, 3);
        ctx.stroke();
      }
      lamp(-34);
      lamp(34);

      // --- cabin ------------------------------------------------------------
      ctx.fillStyle = white;
      ctx.beginPath();
      ctx.moveTo(-42, -16);
      ctx.lineTo(-34, -46);
      ctx.lineTo(34, -46);
      ctx.lineTo(42, -16);
      ctx.closePath();
      ctx.fill();

      // Windscreen
      var glass = ctx.createLinearGradient(0, -46, 0, -16);
      glass.addColorStop(0, '#31504B');
      glass.addColorStop(0.6, '#1D2C29');
      glass.addColorStop(1, '#13201D');
      ctx.fillStyle = glass;
      ctx.beginPath();
      ctx.moveTo(-34, -19);
      ctx.lineTo(-28, -42);
      ctx.lineTo(28, -42);
      ctx.lineTo(34, -19);
      ctx.closePath();
      ctx.fill();

      // Reflection streak across the glass
      ctx.fillStyle = 'rgba(255, 255, 255, 0.09)';
      ctx.beginPath();
      ctx.moveTo(-26, -42);
      ctx.lineTo(-8, -42);
      ctx.lineTo(-24, -19);
      ctx.lineTo(-33, -19);
      ctx.closePath();
      ctx.fill();

      // Open driver's window — the door is on the right in this view.
      ctx.fillStyle = '#101A18';
      roundRect(ctx, 30, -40, 12, 22, 3);
      ctx.fill();

      // Roof + roof rack
      ctx.fillStyle = shade;
      roundRect(ctx, -36, -50, 72, 6, 3);
      ctx.fill();
      ctx.fillStyle = '#1F2321';
      roundRect(ctx, -31, -53, 62, 3, 1.5);
      ctx.fill();

      // Snorkel, because it is a desert truck.
      ctx.fillStyle = '#232724';
      roundRect(ctx, -46, -46, 5, 30, 2.5);
      ctx.fill();

      // Number plate
      ctx.fillStyle = '#E9E4D2';
      roundRect(ctx, -12, 9, 24, 7, 1.6);
      ctx.fill();
      ctx.fillStyle = '#2B2F2C';
      ctx.font = 'bold 5px sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('BALADY+', 0, 14.4);

      // --- driver hanging out of the window ---------------------------------
      drawDriver(ctx, 40, -30, wobble);

      // Danger rim light
      if (danger > 0) {
        ctx.globalAlpha = danger * 0.7;
        ctx.strokeStyle = '#FF5A5F';
        ctx.lineWidth = 3;
        roundRect(ctx, -48, -16, 96, 33, 8);
        ctx.stroke();
        ctx.globalAlpha = 1;
      }

      ctx.restore();
    },

    /** The mockup's own hero shot, matted out and pivoted on its contact
        patch. The photo already carries the two-wheel lean, so only the
        player's deviation is applied on top of it. */
    drawCarPhoto: function (cx, cy, size, tilt, wobble, danger) {
      var ctx = this.ctx;
      var img = IMG.car;
      var w = size * 1.18;
      var h = w * (img.height / img.width);

      ctx.save();
      ctx.globalAlpha = 0.16;
      ctx.fillStyle = '#4A2E13';
      ctx.beginPath();
      ctx.ellipse(cx + tilt * size * 0.10, cy + size * 0.33, size * 0.34, size * 0.035, 0, 0, TAU);
      ctx.fill();
      ctx.restore();

      ctx.save();
      ctx.translate(cx, cy + Math.sin(wobble) * size * 0.012);
      ctx.rotate(CAR_LEAN + tilt * 0.42 + Math.sin(wobble) * 0.012);

      if (danger > 0) {
        ctx.shadowColor = 'rgba(255, 70, 70, ' + (danger * 0.9).toFixed(2) + ')';
        ctx.shadowBlur = 26 * danger;
      }
      // The sprite is the car alone now, so the pivot is back on its centre.
      var x0 = -w * 0.46;
      var y0 = -h * 0.72;
      ctx.drawImage(img, x0, y0, w, h);

      // Tail lights, always faintly lit and flaring when the car is in trouble
      // or the sun has gone.
      var lamp = Math.max(0.18, Math.max(danger, this.lastDusk || 0) * 0.9);
      ctx.globalCompositeOperation = 'lighter';
      for (var side = 0; side < 2; side++) {
        var lx = x0 + w * (side ? 0.845 : 0.155);
        var ly = y0 + h * 0.615;
        var r = w * 0.17;
        var g = ctx.createRadialGradient(lx, ly, 1, lx, ly, r);
        g.addColorStop(0, 'rgba(255, 90, 70, ' + (0.55 * lamp).toFixed(3) + ')');
        g.addColorStop(0.45, 'rgba(255, 40, 30, ' + (0.22 * lamp).toFixed(3) + ')');
        g.addColorStop(1, 'rgba(255, 20, 10, 0)');
        ctx.fillStyle = g;
        ctx.beginPath();
        ctx.arc(lx, ly, r, 0, TAU);
        ctx.fill();
      }
      ctx.globalCompositeOperation = 'source-over';

      // The driver, hung out of the right-hand window — the flank that is in
      // the air. He rides inside the car's rotation, with a little extra sway.
      if (IMG.driver) {
        var dh = h * DRIVER;
        var dw = dh * (IMG.driver.width / IMG.driver.height);
        var dx = x0 + w * SEAT - dw / 2;
        var dy = y0 - dh + dh * LIFT;
        ctx.save();
        ctx.translate(dx + dw / 2, dy + dh);
        ctx.rotate(Math.sin(wobble * 0.5) * 0.03 - tilt * 0.05);

        var sx = -dw * 0.16;
        var sy = -dh * 0.10;
        var cast = ctx.createRadialGradient(sx, sy, 1, sx, sy, dw * 0.30);
        cast.addColorStop(0, 'rgba(24, 14, 8, 0.30)');
        cast.addColorStop(1, 'rgba(24, 14, 8, 0)');
        ctx.fillStyle = cast;
        ctx.beginPath();
        ctx.ellipse(sx, sy, dw * 0.30, dh * 0.11, 0, 0, TAU);
        ctx.fill();

        ctx.drawImage(IMG.driver, -dw / 2, -dh, dw, dh);
        ctx.restore();
      }

      ctx.restore();
    },

    /* ----------------------------------------------------------- coins */

    drawCoin: function (x, y, r, spin) {
      var ctx = this.ctx;
      var squash = Math.abs(Math.cos(spin));

      if (IMG.coin) {
        ctx.save();
        ctx.translate(x, y);
        ctx.drawImage(IMG.coin, -r * squash, -r, Math.max(1, r * 2 * squash), r * 2);
        ctx.restore();
        return;
      }

      ctx.save();
      ctx.translate(x, y);

      var g = ctx.createLinearGradient(-r, -r, r, r);
      g.addColorStop(0, '#FFF0C0');
      g.addColorStop(0.45, '#F2C864');
      g.addColorStop(1, '#C79333');
      ctx.fillStyle = g;
      ctx.beginPath();
      ctx.ellipse(0, 0, Math.max(1.2, r * squash), r, 0, 0, TAU);
      ctx.fill();

      ctx.strokeStyle = 'rgba(255, 249, 214, 0.9)';
      ctx.lineWidth = Math.max(1, r * 0.13);
      ctx.beginPath();
      ctx.ellipse(0, 0, Math.max(0.8, r * squash * 0.66), r * 0.66, 0, 0, TAU);
      ctx.stroke();

      if (squash > 0.45) {
        ctx.fillStyle = 'rgba(122, 82, 20, 0.85)';
        ctx.font = 'bold ' + (r * 1.0).toFixed(1) + 'px sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText('$', 0, r * 0.06);
      }
      ctx.restore();
    },

    /* ------------------------------------------------------- particles */

    stepParticles: function (dt) {
      var i;
      for (i = this.particles.length - 1; i >= 0; i--) {
        var p = this.particles[i];
        p.x += p.vx * dt;
        p.y += p.vy * dt;
        p.vy += 26 * dt;
        p.vx *= 0.985;
        p.r += 34 * dt;
        p.life -= p.decay * dt;
        if (p.life <= 0) this.particles.splice(i, 1);
      }
      for (i = this.sparks.length - 1; i >= 0; i--) {
        var s = this.sparks[i];
        s.x += s.vx * dt;
        s.y += s.vy * dt;
        s.vy += 620 * dt;
        s.life -= s.decay * dt;
        if (s.life <= 0) this.sparks.splice(i, 1);
      }
      if (this.particles.length > 220) this.particles.splice(0, this.particles.length - 220);
    },

    drawParticles: function (dusk) {
      var ctx = this.ctx;
      var i;
      var lightFade = 1 - clamp(dusk || 0, 0, 1) * 0.55;
      ctx.save();
      for (i = 0; i < this.particles.length; i++) {
        var p = this.particles[i];
        var a = clamp(p.life, 0, 1) * 0.11 * lightFade;
        ctx.fillStyle = p.tint
          ? 'rgba(230, 140, 100, ' + (a * 1.1).toFixed(3) + ')'
          : 'rgba(224, 186, 136, ' + (a * 1.15).toFixed(3) + ')';
        ctx.beginPath();
        ctx.ellipse(p.x, p.y, p.r, p.r * 0.62, 0, 0, TAU);
        ctx.fill();
      }
      for (i = 0; i < this.sparks.length; i++) {
        var s = this.sparks[i];
        ctx.globalAlpha = clamp(s.life, 0, 1);
        ctx.fillStyle = s.color;
        ctx.beginPath();
        ctx.arc(s.x, s.y, s.size, 0, TAU);
        ctx.fill();
      }
      ctx.restore();
    },

    /* ----------------------------------------------------------- frame */

    render: function (state, dt) {
      var ctx = this.ctx;
      this.time += dt;
      this.scroll += (state.speed || 0) * dt;

      var dusk = clamp(state.dusk || 0, 0, 1);
      this.lastDusk = dusk;
      var speedNorm = clamp(((state.speed || 0) - 240) / 460, 0, 1);

      // The camera sits lower as the car picks up speed, so the horizon rises.
      this.horizon = Math.round(this.baseHorizon - speedNorm * this.h * 0.022);

      this.stepParticles(dt);

      ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
      ctx.clearRect(0, 0, this.w, this.h);

      // Camera shake when things go wrong.
      if (this.shake > 0.001) {
        var mag = this.shake * 10;
        ctx.translate(rand(-mag, mag), rand(-mag, mag));
        this.shake = Math.max(0, this.shake - dt * 2.4);
      }

      this.drawSky(dusk);
      this.drawMesas(dusk);
      this.drawGround(dusk);
      this.drawTrack(state.tilt || 0, dusk);

      // Coins approaching from the horizon.
      var coins = state.coins || [];
      for (var i = 0; i < coins.length; i++) {
        var c = coins[i];
        var p = this.project(c.d);
        var cxp = this.w * 0.5 + c.lane * this.w * 0.26 * p.s;
        this.drawCoin(cxp, p.y - 150 * p.s - this.h * 0.02, Math.max(2, 26 * p.s), c.spin);
      }

      // Hero car.
      var carY = this.h * 0.655;
      var carSize = Math.min(this.w * 0.52, this.h * 0.25);
      var carX = this.w * 0.5 + (state.tilt || 0) * this.w * 0.085;

      // Dust plume trailing the rear wheels.
      if (state.running) {
        this.addDust(carX + rand(-0.6, 0.6) * carSize, carY + carSize * 0.26, 1, state.danger > 0.5 ? 1 : 0);
      }
      this.drawParticles(dusk);
      this.drawHeadlights(carX, carY, carSize, state.tilt || 0, dusk);

      this.drawCar(
        carX,
        carY,
        carSize,
        state.tilt || 0,
        this.time * 9,
        state.danger || 0
      );

      // Speed streaks at the edges, stronger the faster you go.
      this.drawSpeedLines(state.speed || 0);
      this.drawGroundRush(state.speed || 0, dusk);

      // Warm grade over the gameplay layer. The shader already applies its own
      // vignette, so this only tints the track and the actors when it is on.
      var grade = ctx.createLinearGradient(0, 0, 0, this.h);
      grade.addColorStop(0, 'rgba(255, 190, 120, 0.05)');
      grade.addColorStop(1, dusk > 0.5 ? 'rgba(40, 20, 40, 0.34)' : 'rgba(120, 60, 20, 0.16)');
      ctx.fillStyle = grade;
      ctx.fillRect(0, 0, this.w, this.h);

      if (this.flash > 0.002) {
        ctx.fillStyle = 'rgba(255, 255, 255, ' + (this.flash * 0.55).toFixed(3) + ')';
        ctx.fillRect(0, 0, this.w, this.h);
        this.flash = Math.max(0, this.flash - dt * 3.2);
      }

      ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    },

    /** Near-field smear plus wind-blown grains: the camera is low and fast,
        so the closest sand should not read as a crisp texture. */
    drawGroundRush: function (speed, dusk) {
      var ctx = this.ctx;
      var intensity = clamp((speed - 220) / 460, 0, 1);
      if (intensity <= 0.02) return;

      ctx.save();
      ctx.globalCompositeOperation = 'lighter';
      ctx.globalAlpha = intensity * 0.10;
      var warm = dusk > 0.5 ? 'rgba(255, 170, 120, 1)' : 'rgba(255, 224, 176, 1)';
      for (var i = 0; i < 16; i++) {
        var seed = (this.time * (1.6 + (i % 5) * 0.5) + i * 0.13) % 1;
        var d = 0.55 + seed * 0.5;
        var p = this.project(Math.min(d, 1));
        var len = 30 + seed * 150 * intensity;
        var x = this.w * (hash(i * 3.7) * 1.4 - 0.2);
        ctx.strokeStyle = warm;
        ctx.lineWidth = 1 + seed * 2.5;
        ctx.beginPath();
        ctx.moveTo(x, p.y);
        ctx.lineTo(x + (x - this.w * 0.5) * 0.06, p.y + len);
        ctx.stroke();
      }
      ctx.restore();

      // A veil of dust hugging the bottom of the frame.
      ctx.save();
      ctx.globalAlpha = intensity * 0.22;
      var veil = ctx.createLinearGradient(0, this.h * 0.82, 0, this.h);
      veil.addColorStop(0, 'rgba(226, 190, 140, 0)');
      veil.addColorStop(1, dusk > 0.5 ? 'rgba(150, 96, 70, 0.9)' : 'rgba(228, 194, 146, 0.9)');
      ctx.fillStyle = veil;
      ctx.fillRect(0, this.h * 0.82, this.w, this.h * 0.18);
      ctx.restore();
    },

    /** Head-lamp spill on the track once the sun is low.

        The camera sits behind the car, so the beams run *away* from it, up the
        road towards the horizon — the pool of light narrows with distance
        instead of opening towards the viewer. */
    drawHeadlights: function (cx, cy, size, tilt, dusk) {
      if (dusk < 0.28) return;
      var ctx = this.ctx;
      var power = (dusk - 0.28) / 0.72;

      var near = cy - size * 0.22;                 // just past the car's nose
      var far = this.horizon + this.h * 0.02;      // fading out at the horizon

      ctx.save();
      ctx.globalCompositeOperation = 'lighter';

      var beam = ctx.createLinearGradient(0, near, 0, far);
      beam.addColorStop(0, 'rgba(255, 238, 198, ' + (0.22 * power).toFixed(3) + ')');
      beam.addColorStop(0.5, 'rgba(255, 220, 160, ' + (0.09 * power).toFixed(3) + ')');
      beam.addColorStop(1, 'rgba(255, 210, 130, 0)');
      ctx.fillStyle = beam;
      ctx.beginPath();
      ctx.moveTo(cx - size * 0.44 + tilt * size * 0.08, near);
      ctx.lineTo(cx + size * 0.44 + tilt * size * 0.08, near);
      ctx.lineTo(cx + size * 0.10, far);
      ctx.lineTo(cx - size * 0.10, far);
      ctx.closePath();
      ctx.fill();

      ctx.restore();
    },

    drawSpeedLines: function (speed) {
      var ctx = this.ctx;
      var intensity = clamp((speed - 240) / 420, 0, 1);
      if (intensity <= 0.01) return;
      ctx.save();
      ctx.globalAlpha = intensity * 0.28;
      ctx.strokeStyle = '#FFF3DC';
      ctx.lineWidth = 2;
      for (var i = 0; i < 9; i++) {
        var seed = (this.time * 2.2 + i * 0.37) % 1;
        var y = this.horizon + (this.h - this.horizon) * seed;
        var len = 26 + seed * 90;
        var side = i % 2 === 0 ? -1 : 1;
        var x = this.w * 0.5 + side * (this.w * 0.34 + seed * this.w * 0.2);
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x + side * len * 0.35, y + len * 0.5);
        ctx.stroke();
      }
      ctx.restore();
    }
  };

  /* ------------------------------------------------------------ shapes */

  function roundRect(ctx, x, y, w, h, r) {
    var rr = Math.min(r, w / 2, h / 2);
    ctx.beginPath();
    ctx.moveTo(x + rr, y);
    ctx.lineTo(x + w - rr, y);
    ctx.quadraticCurveTo(x + w, y, x + w, y + rr);
    ctx.lineTo(x + w, y + h - rr);
    ctx.quadraticCurveTo(x + w, y + h, x + w - rr, y + h);
    ctx.lineTo(x + rr, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - rr);
    ctx.lineTo(x, y + rr);
    ctx.quadraticCurveTo(x, y, x + rr, y);
    ctx.closePath();
  }

  /** The celebrating driver in thobe + shemagh leaning out of the window. */
  function drawDriver(ctx, x, y, wobble) {
    var sway = Math.sin(wobble * 0.5) * 0.07;
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(0.30 + sway);

    // Thobe (torso), leaning out of the window
    ctx.fillStyle = '#FBFBF7';
    ctx.beginPath();
    ctx.moveTo(-7, 3);
    ctx.quadraticCurveTo(-10, 16, -7, 22);
    ctx.lineTo(7, 22);
    ctx.quadraticCurveTo(10, 14, 6, 3);
    ctx.closePath();
    ctx.fill();

    // Arms thrown up in a V
    ctx.strokeStyle = '#FBFBF7';
    ctx.lineWidth = 4.6;
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(-4, 6);
    ctx.lineTo(-14, -8);
    ctx.moveTo(4, 6);
    ctx.lineTo(14, -8);
    ctx.stroke();

    // Hands
    ctx.fillStyle = '#C89264';
    ctx.beginPath(); ctx.arc(-15, -9.5, 2.6, 0, TAU); ctx.fill();
    ctx.beginPath(); ctx.arc(15, -9.5, 2.6, 0, TAU); ctx.fill();

    // Head, shemagh and agal
    ctx.fillStyle = '#C89264';
    ctx.beginPath(); ctx.arc(0, -2, 5.4, 0, TAU); ctx.fill();

    ctx.fillStyle = '#FFFFFF';
    ctx.beginPath();
    ctx.moveTo(-6.6, -3);
    ctx.quadraticCurveTo(0, -12.5, 6.6, -3);
    ctx.quadraticCurveTo(8, 7, 0, 6);
    ctx.quadraticCurveTo(-8, 7, -6.6, -3);
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = '#C89264';
    ctx.beginPath();
    ctx.ellipse(0, -1.4, 3.4, 3.8, 0, 0, TAU);
    ctx.fill();

    ctx.strokeStyle = '#1D1D1B';
    ctx.lineWidth = 1.7;
    ctx.beginPath();
    ctx.ellipse(0, -6.4, 5.8, 2.0, 0, 0, TAU);
    ctx.stroke();

    ctx.restore();
  }

  Scene.roundRect = roundRect;
  global.DriftScene = Scene;
})(window);
