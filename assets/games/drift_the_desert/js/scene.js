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

  /** `#rrggbb` or `rgb(r,g,b)` to a triple. */
  function toRgb(c) {
    if (c.charAt(0) === '#') {
      var i = parseInt(c.slice(1), 16);
      return [(i >> 16) & 255, (i >> 8) & 255, i & 255];
    }
    var m = c.match(/\d+/g);
    return [+m[0], +m[1], +m[2]];
  }

  /** Blend two colours — used to walk the palette into dusk, and again to
      push the roadside props into the horizon haze. Either argument may be
      the `rgb(...)` this returns, so the blends chain. */
  function mixHex(a, b, t) {
    var x = toRgb(a), y = toRgb(b);
    return 'rgb(' +
      Math.round(lerp(x[0], y[0], t)) + ',' +
      Math.round(lerp(x[1], y[1], t)) + ',' +
      Math.round(lerp(x[2], y[2], t)) + ')';
  }

  /* Deterministic pseudo-random so the terrain silhouette is stable between
     frames without storing every vertex. */
  function hash(n) {
    var x = Math.sin(n * 127.1) * 43758.5453;
    return x - Math.floor(x);
  }

  /* An integer mix, for draws that step an input by one at a time. The sine
     hash above evens out over hundreds of steps but is lumpy over a handful,
     which is all a lap counter ever gets: measured over the outcrops' first
     four laps, it covered five of the six baked landforms, drawing one of
     them six times in sixteen and another not at all. This covers all six
     over the same four laps. Both are uniform in the long run — the argument
     for this one is entirely about the short one, which is the only run a
     session actually plays. */
  function ihash(a, b, c) {
    var n = (a | 0) * 374761393 + (b | 0) * 668265263 + (c | 0) * 2246822519;
    n = Math.imul(n ^ (n >>> 13), 1274126177);
    return ((n ^ (n >>> 16)) >>> 0) / 4294967296;
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
  var Ground = global.DriftGround || { ready: false, draw: noop };
  var Sprites = global.DriftSprites || { ready: false, draw: noop };
  var NO_SHEET = { ready: false, draw: noop };

  /* The cliff sheet is made at load time by js/main.js, which runs after
     this file, so it cannot be captured here the way the props sheet is. */
  function cliffSheet() { return global.DriftCliffs || NO_SHEET; }

  /* World travel per unit of the game's speed. See render(). */
  var WORLD_SCALE = 0.48;
  // The depth at which the textured ground plane finishes fading in — the end
  // of the ramp in js/ground.js, kept here because what stands on the ground
  // has to agree with how much of it is drawn. Change one, change the other.
  var GROUND_IN = 0.083;
  // An outcrop clears its haze a little sooner than the ground beneath it
  // finishes arriving. Tying the two exactly, which is where this started,
  // is too strict: the horizon dust lies over the sand as well, so ground
  // drawn at 60% does not read as 60% of a surface, and matching a cliff to
  // that number bleached it to nothing. What has to hold is the direction —
  // never conspicuously more present than what it stands on, which is the
  // 100%-on-19% case that read as floating. Measured against this: 10% solid
  // on 32% ground, 62% on 61%, 100% on 91%.
  var CLIFF_CLEAR = GROUND_IN * 0.84;

  /* What the floor is multiplied by at full dusk. */
  var DUSK_TINT = [0.43, 0.29, 0.32];

  /* Height of each plant on the baked sheet, relative to a rock of the same
     prop size: tussock, tussock, ghada, ghada, dead, saltbush, thorn bush. */
  var PLANT_SIZE = [1.55, 1.55, 1.70, 1.70, 1.40, 1.05, 2.30];

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
      this.syncWorld();
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
        // Driving straight at a ridge a kilometre off does not move it
        // sideways; drifting past it does. The plates take most of their
        // offset from the lean now and only a trickle from the distance
        // covered, which is what stopped the whole background sliding along
        // on a clock of its own.
        lean: this.leanEase || 0,
        dusk: clamp(dusk || 0, 0, 1)
      };
    },

    /* ------------------------------------------------------- the world

       Everything that stands on the ground — rocks, bushes, coins, the drift
       along the track's shoulder — is placed by depth, in the same texels the
       ground texture is measured in, and depth shrinks as the world comes at
       you. That is the only way any of it can move with the road: the ground
       is a true perspective plane, where a thing twice as far away takes more
       than twice as long to arrive, and anything advancing on a clock of its
       own slides against it.

       Refreshed once a frame, because it depends on the horizon, which moves
       with speed. */
    syncWorld: function () {
      this.world = Ground.metrics({
        w: this.w, h: this.h, horizon: this.horizon, scroll: this.scroll
      });
      // The furthest we place anything. Past this the haze has it anyway.
      // Where a thing first exists: the far end of the band, expressed the
      // way everything else is. Anything that arrives has to be pure dust
      // colour here and fade up over the next little way, or it is seen to
      // arrive.
      this.world.tSpawn = this.world.TD / (this.world.band + this.world.near);
      return this.world;
    },

    /** Where a thing at this depth and lateral offset lands on screen.
        `lateral` is in texels from the track's centre line. */
    place: function (depth, lateral, lean) {
      var W = this.world;
      var t = W.TD / Math.max(depth, W.TD * 0.02);
      var s = 0.035 + 0.965 * t;
      var a = W.A0 * t;
      // The road bends, and everything standing beside it bends with it.
      // js/ground.js computes the same curve in its shader.
      // Measured against the car rather than the camera: the car sits at the
      // bottom of the frame, one frame-depth in front of the eye, and it is
      // the car that has to stay on the road.
      var bend = Ground.curveAt
        ? Ground.curveAt(depth, W.travelCurve, W.size || 2048, W.TD) : 0;
      var cx = this.w * 0.5 - (lean || 0) * this.w * 0.06 * (1 - s);
      return {
        t: t,
        s: s,
        a: a,
        x: cx + (bend + (lateral || 0)) * a,
        y: this.horizon + W.span * t
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

    drawGround: function (dusk, lateral) {
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
        var textured = this.drawFloor(night, lateral);
        if (!textured) this.drawSandField(night, false);
        this.drawHorizonDust(night);
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

      if (!this.drawFloor(night, lateral)) this.drawSandField(night, false);
      this.drawHorizonDust(night);
    },

    /** The ground plane, drawn by js/ground.js — sand, the road, the motion
        blur and the evening, all in one pass. Returns true when it drew,
        which tells the painted passes to step back: with real ripples, real
        stones and real ruts in the textures, theirs are down to adding the
        big swells the tiles are deliberately without. */
    drawFloor: function (night, lateral) {
      this.floorTextured = Ground.draw(this.ctx, {
        w: this.w,
        h: this.h,
        dpr: this.dpr,
        horizon: this.horizon,
        top: this.baseHorizon - this.h * 0.024 - 2,
        scroll: this.scroll,
        dScroll: this.dScroll || 0,
        speed: (this.lastSpeed || 0) * WORLD_SCALE,
        lateral: lateral || 0,
        dusk: night,
        tint: DUSK_TINT
      }) === true;
      return this.floorTextured;
    },

    /** Wind ripples and gravel over the open sand, in perspective.

        Below the dune plate the ground was a plain vertical gradient: correct
        in colour, but with nothing in it to move, so the desert looked painted
        on glass. These bands sweep the whole width, scroll with everything
        else and swell as they come, which gives the floor both texture and
        speed. The track is drawn over the top of them. */
    drawSandField: function (night, textured) {
      var ctx = this.ctx;
      var w = this.w;
      var top = this.horizon + this.h * 0.004;
      // Over a real texture these are swells, not ripples: the same bands at
      // a third of the weight, and no gravel, because the tile has its own.
      var weight = textured ? 0.34 : 1;

      ctx.save();
      ctx.beginPath();
      ctx.rect(0, top, w, this.h - top);
      ctx.clip();

      // Long crescent ripples, as filled bands rather than lines: a hairline
      // stroke read as a contour on a map, and aliased into a crawling mess
      // once it started moving. Each band is a shadow with its lit windward
      // face stacked on top, and both fade out again in the near field, where
      // the ground is moving too fast to hold detail.
      var bands = 22;
      for (var i = 0; i < bands; i++) {
        var seed = i * 3.77;
        var d = (hash(seed) + this.scroll * 0.00092) % 1;
        if (d < 0.05) continue;
        var p = this.project(d);
        var fade = clamp((d - 0.05) / 0.22, 0, 1) * clamp((1.02 - d) / 0.25, 0, 1);
        if (fade <= 0.02) continue;

        var amp = this.h * (0.006 + hash(seed + 2.3) * 0.024) * p.s;
        var freq = (0.9 + hash(seed + 5.1) * 2.4) / w * TAU;
        var phase = hash(seed + 8.4) * TAU;
        var thick = Math.max(1.2, this.h * 0.020 * p.s);
        var SEG = 20;                     // points across, whatever the depth
        var step = (w + 40) / SEG;

        function wave(x) {
          return Math.sin(x * freq + phase) * amp +
                 Math.sin(x * freq * 2.7 + phase * 1.7) * amp * 0.35;
        }

        // Shadowed lee side: the band below the crest.
        ctx.beginPath();
        var j, x;
        for (j = 0; j <= SEG; j++) { x = -20 + j * step; ctx.lineTo(x, p.y + wave(x)); }
        for (j = SEG; j >= 0; j--) { x = -20 + j * step; ctx.lineTo(x, p.y + wave(x) + thick); }
        ctx.closePath();
        ctx.fillStyle = 'rgba(96, 58, 24, ' + (0.13 * weight * fade * (1 - night * 0.45)).toFixed(3) + ')';
        ctx.fill();

        // Lit windward face just above it.
        ctx.beginPath();
        for (j = 0; j <= SEG; j++) { x = -20 + j * step; ctx.lineTo(x, p.y + wave(x) - thick * 0.75); }
        for (j = SEG; j >= 0; j--) { x = -20 + j * step; ctx.lineTo(x, p.y + wave(x)); }
        ctx.closePath();
        ctx.fillStyle = 'rgba(255, 233, 190, ' + (0.11 * weight * fade * (1 - night * 0.55)).toFixed(3) + ')';
        ctx.fill();
      }

      // Gravel: enough to break the gradient, not enough to read as noise.
      var stones = textured ? 0 : 44;
      for (var k = 0; k < stones; k++) {
        var sseed = k * 1.93 + 0.5;
        var sd = (hash(sseed) + this.scroll * 0.00118) % 1;
        if (sd < 0.10) continue;
        var sp = this.project(sd);
        var sx = hash(sseed + 4.7) * w * 1.1 - w * 0.05;
        var r = (0.7 + hash(sseed + 9.1) * 2.6) * sp.s * 2.4;
        if (r < 0.45) continue;
        var fade = clamp((sd - 0.10) / 0.22, 0, 1);
        ctx.beginPath();
        ctx.ellipse(sx, sp.y, r, r * 0.52, 0, 0, TAU);
        ctx.fillStyle = 'rgba(84, 54, 24, ' + (0.30 * fade * (1 - night * 0.4)).toFixed(3) + ')';
        ctx.fill();
        ctx.beginPath();
        ctx.ellipse(sx - r * 0.25, sp.y - r * 0.30, r * 0.55, r * 0.26, 0, 0, TAU);
        ctx.fillStyle = 'rgba(255, 228, 176, ' + (0.22 * fade * (1 - night * 0.6)).toFixed(3) + ')';
        ctx.fill();
      }

      // Sheets of loose sand blowing across the floor. They travel with the
      // wind rather than with the car, which is the one thing on screen that
      // is not simply rushing at the camera, and it makes the desert feel
      // like weather instead of scenery.
      var wisps = 5;
      for (var m = 0; m < wisps; m++) {
        var wseed = m * 5.31 + 2.1;
        var wd = (hash(wseed) + this.scroll * 0.00060) % 1;
        if (wd < 0.12 || wd > 0.92) continue;
        var wp = this.project(wd);
        var wx = ((hash(wseed + 3.9) + this.time * (0.045 + hash(wseed + 6.2) * 0.05)) % 1.4 - 0.2) * w;
        var rx = w * (0.22 + hash(wseed + 8.7) * 0.30);
        var ry = this.h * 0.020 * wp.s + 2;
        var wa = 0.11 * (1 - night * 0.5) * clamp((wd - 0.12) / 0.2, 0, 1) * clamp((0.92 - wd) / 0.2, 0, 1);

        var wg = ctx.createRadialGradient(wx, wp.y, 0, wx, wp.y, rx);
        wg.addColorStop(0, 'rgba(255, 240, 210, ' + wa.toFixed(3) + ')');
        wg.addColorStop(0.55, 'rgba(255, 236, 200, ' + (wa * 0.55).toFixed(3) + ')');
        wg.addColorStop(1, 'rgba(255, 236, 200, 0)');
        ctx.fillStyle = wg;
        ctx.beginPath();
        ctx.ellipse(wx, wp.y, rx, ry, 0, 0, TAU);
        ctx.fill();
      }

      ctx.restore();
    },

    /** The dust standing on the horizon.

        Two jobs. It hides the join where the baked plates stop and the ground
        plane begins, which is the part of the frame with the most going on
        and the least to look at. And it gives everything that arrives from
        the distance something to arrive out of: the props and the cliffs wash
        towards this exact colour as they recede, so by the time one is far
        enough to be fading in it is the same tan as the air behind it.

        The billows drift on the wind rather than with the car, and slowly —
        a hundred seconds to cross the frame — because anything quicker along
        the skyline reads as flicker rather than as weather. */
    drawHorizonDust: function (night) {
      var ctx = this.ctx;
      var hz = this.horizon;
      var top = hz - this.h * 0.11;
      var bot = hz + this.h * 0.17;
      var col = mixHex('#E7C592', '#6B4A48', night);

      var g = ctx.createLinearGradient(0, top, 0, bot);
      g.addColorStop(0.00, rgba(col, 0));
      g.addColorStop(0.34, rgba(col, (0.20 * (1 - night * 0.30)).toFixed(3)));
      g.addColorStop(0.44, rgba(col, (0.30 * (1 - night * 0.30)).toFixed(3)));
      g.addColorStop(0.62, rgba(col, (0.22 * (1 - night * 0.30)).toFixed(3)));
      g.addColorStop(1.00, rgba(col, 0));
      ctx.fillStyle = g;
      ctx.fillRect(0, top, this.w, bot - top);

      for (var i = 0; i < 5; i++) {
        var seed = i * 7.31;
        var drift = (hash(seed) + this.time * (0.006 + hash(seed + 2.1) * 0.008)) % 1.4;
        var x = (drift - 0.2) * this.w;
        var rx = this.w * (0.26 + hash(seed + 5.3) * 0.34);
        var ry = this.h * (0.035 + hash(seed + 8.7) * 0.030);
        var y = hz + (hash(seed + 9.1) - 0.42) * this.h * 0.055;
        var r = ctx.createRadialGradient(x, y, 0, x, y, rx);
        r.addColorStop(0, rgba(col, (0.11 * (1 - night * 0.35)).toFixed(3)));
        r.addColorStop(0.55, rgba(col, (0.05 * (1 - night * 0.35)).toFixed(3)));
        r.addColorStop(1, rgba(col, 0));
        ctx.fillStyle = r;
        ctx.beginPath();
        ctx.ellipse(x, y, rx, ry, 0, 0, TAU);
        ctx.fill();
      }
    },

    /* ------------------------------------------------------------ track */

    /** Half-width of the track at depth parameter `d`, and the x it is
        centred on. The width is fixed in the world and only the projection
        narrows it: fitting a trapezoid to the screen instead, as this used
        to, made the road nearly three times wider in the world at the horizon
        than at the car, and everything lined up against its edges slid
        sideways on the way in. */
    trackAt: function (d, lean) {
      var t = Math.pow(clamp(d, 0, 1), 2.35);
      var W = this.world;
      var p = this.place(W.TD / Math.max(t, 0.0008), 0, lean);
      return { y: p.y, s: p.s, t: p.t, a: p.a, cx: p.x, half: W.halfTexels * p.a };
    },

    /** Wobble of the track's edge at depth parameter `d` — the drift of loose
        sand that stops the shoulders reading as painted runway lines. Keyed
        to where the ground is, not to what time it is, so the drift comes at
        the camera with everything else. js/ground.js reads the same depth. */
    edgeNoise: function (d, side) {
      var t = Math.pow(clamp(d, 0.001, 1), 2.35);
      var w = (this.world.TD / t + this.world.travelCurve) * 0.00042 + (side > 0 ? 31.7 : 0);
      return (Math.sin(w) * 0.6 + Math.sin(w * 2.7 + 1.3) * 0.3 + Math.sin(w * 6.1) * 0.1);
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
          p = t.cx - t.half * (1 - self.edgeNoise(i / STEPS, -1) * 0.07);
          if (i === 0) ctx.moveTo(p, t.y); else ctx.lineTo(p, t.y);
        }
        for (i = STEPS; i >= 0; i--) {
          t = self.trackAt(i / STEPS, lateral);
          p = t.cx + t.half * (1 - self.edgeNoise(i / STEPS, 1) * 0.07);
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
      // Over the sand texture this is a stain, not a surface: a packed track
      // is the same sand, darker and smoother, and painting it opaque threw
      // away the one part of the frame with real grain in it. With the road
      // texture in as well it drops to a wash that only feathers the edges
      // and carries the fade into the horizon.
      ctx.globalAlpha = this.floorTextured ? (Ground.roadReady ? 0.18 : 0.52) : 1;
      ctx.fill();
      ctx.globalAlpha = 1;
      ctx.clip();

      // The road itself came in with the ground plane, ruts and all. What is
      // left here is the wash that feathers the track's edges and carries it
      // into the horizon, and the marks the texture does not have.
      var roadDrawn = this.floorTextured && Ground.roadReady;

      /* Drag marks running down the road. The photographic sand tile was tried
         here first and had to go: at 264 px stretched across the full width it
         resolved into rectangular patches wherever two slices sampled
         different parts of it. Longitudinal streaks are what a packed sand
         track actually shows at speed, and they stay sharp at any resolution. */
      var streaks = roadDrawn ? 0 : 16;
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
         outside of each. Only when the baked road is missing — it has seven
         of them, meandering, with tread in the bottom. */
      for (var side = -1; roadDrawn ? false : side <= 1; side += 2) {
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
      var pebbles = roadDrawn ? 0 : 34;
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

      /* The dune flanks either side of the track.

         The reference photograph is not a car on a plain, it is a car in a
         trough: the sand rises away from the wheel tracks on both sides, lit
         along one crest and in shadow along the other. Painting that as
         light rather than as geometry keeps the sand texture underneath,
         which is the whole reason it is there.

         With the sun up and to the left, the left flank turns towards it and
         the right flank away, so one is washed with warm light and the other
         with a cool shadow. */
      /* Painted flanks only where there is no textured floor. Sized correctly
         in the world, a metre-and-a-half bank beside the road covers a large
         part of the near frame — and a wash cannot occlude what is behind it,
         so all it did was lay a translucent wedge over the sand. The ground
         texture and the road's own berms carry the shoulder now. */
      if (this.floorTextured) return;

      ctx.save();
      var W = this.world;
      for (var bs = -1; bs <= 1; bs += 2) {
        var lit = bs < 0;
        var crest = [];
        var foot = [];
        for (var bi = 0; bi <= STEPS; bi++) {
          var bd = bi / STEPS;
          var bt = this.trackAt(bd, lateral);
          var fx = bt.cx + bs * bt.half * (1 - this.edgeNoise(bd, bs) * 0.07);
          // The crest sits a fixed distance out in the world and stands a
          // fixed height above the sand — both in texels, like everything
          // else out there. Sized to the screen instead, as this was, it
          // sheared into a pair of translucent wedges once the road stopped
          // being a trapezoid fitted to the frame.
          var rise = (0.30 + this.edgeNoise(bd * 0.42 + 3.1, bs) * 0.08) * W.size * bt.a;
          crest.push([fx + bs * W.halfTexels * 0.85 * bt.a, bt.y - rise]);
          foot.push([fx, bt.y]);
        }

        // Two bands rather than one wash: the upper face of a dune catches
        // the sun and the trough at its foot is in shadow, and a single
        // gradient running down the screen instead of down the slope only
        // ever looked like fog.
        var upper = lit ? 'rgba(255, 226, 172, ' + (0.26 * (1 - night * 0.55)).toFixed(3) + ')'
                        : 'rgba(255, 226, 172, ' + (0.10 * (1 - night * 0.55)).toFixed(3) + ')';
        var lower = lit ? 'rgba(78, 44, 24, ' + (0.10 * (1 - night * 0.4)).toFixed(3) + ')'
                        : 'rgba(78, 44, 24, ' + (0.24 * (1 - night * 0.4)).toFixed(3) + ')';

        for (var pass = 0; pass < 2; pass++) {
          var from = pass ? 0.52 : 0.0;
          var to = pass ? 1.0 : 0.48;
          ctx.beginPath();
          for (var bj = 0; bj <= STEPS; bj++) {
            var pa = crest[bj], pb = foot[bj];
            var x1 = pa[0] + (pb[0] - pa[0]) * from;
            var y1 = pa[1] + (pb[1] - pa[1]) * from;
            if (bj === 0) ctx.moveTo(x1, y1); else ctx.lineTo(x1, y1);
          }
          for (var bk = STEPS; bk >= 0; bk--) {
            var qa = crest[bk], qb = foot[bk];
            ctx.lineTo(qa[0] + (qb[0] - qa[0]) * to, qa[1] + (qb[1] - qa[1]) * to);
          }
          ctx.closePath();
          ctx.fillStyle = pass ? lower : upper;
          ctx.fill();
        }

        // A lit line right along the crest, and shadow pooling at its foot.
        ctx.beginPath();
        for (var bm = 0; bm < crest.length; bm++) {
          if (bm === 0) ctx.moveTo(crest[bm][0], crest[bm][1]);
          else ctx.lineTo(crest[bm][0], crest[bm][1]);
        }
        var rim = ctx.createLinearGradient(0, farY, 0, nearY);
        rim.addColorStop(0, 'rgba(255, 236, 196, 0)');
        rim.addColorStop(0.25, 'rgba(255, 236, 196, ' + (0.30 * (1 - night * 0.6)).toFixed(3) + ')');
        rim.addColorStop(1, 'rgba(255, 240, 205, ' + ((lit ? 0.55 : 0.30) * (1 - night * 0.6)).toFixed(3) + ')');
        ctx.strokeStyle = rim;
        ctx.lineWidth = Math.max(1, this.h * 0.006);
        ctx.lineJoin = 'round';
        ctx.stroke();

        ctx.beginPath();
        for (var bn = 0; bn < foot.length; bn++) {
          if (bn === 0) ctx.moveTo(foot[bn][0], foot[bn][1]);
          else ctx.lineTo(foot[bn][0], foot[bn][1]);
        }
        var toe = ctx.createLinearGradient(0, farY, 0, nearY);
        toe.addColorStop(0, 'rgba(62, 34, 16, 0)');
        toe.addColorStop(1, 'rgba(62, 34, 16, ' + (0.22 * (1 - night * 0.4)).toFixed(3) + ')');
        ctx.strokeStyle = toe;
        ctx.lineWidth = Math.max(1, this.h * 0.010);
        ctx.stroke();
      }
      ctx.restore();
    },

    /* --------------------------------------------------------- roadside */

    /* Boulders, scrub and dry stalks standing along both shoulders.

       The backdrop plates give depth but no speed: they slide sideways under
       parallax and never grow. These do both — they stream out of the horizon
       and swell as they pass the camera, which is what actually sells how
       fast the car is going. Thirty of them, placed by hash and cycled by the
       scroll, so the desert never repeats within a run.

       Drawn after the track and before the coins: they stand on the sand, in
       front of the dunes, behind everything the player interacts with. */

    PROPS: 30,

    /** Where prop `i` is now, or null if it is past the camera or off the
        side of the frame. Each one keeps a fixed place in the desert and the
        desert slides past: the depth band wraps, so a prop that goes under
        the car comes back at the far end as a different rock. */
    propAt: function (i, lean) {
      var W = this.world;
      var seed = i * 2.713;

      // A fixed length of desert, not a camera measurement: the band used to
      // be derived from the depth at the bottom of the frame, so it breathed
      // with the horizon and every prop jumped when the car changed speed.
      var cycles = (hash(seed) * W.band - W.travel) / W.band;
      var depth = W.near + (cycles - Math.floor(cycles)) * W.band;
      var pass = Math.floor(cycles);          // which time round, for variety
      var r = hash(seed + 6.1 + pass * 0.37);

      var p = this.place(depth, 0, lean);
      if (p.t > 1.6) return null;

      // Beyond the shoulder, and further out the closer it is, so they leave
      // at the sides of the frame instead of marching over the car.
      // A fixed number of road-widths out, in world texels — so a rock keeps
      // its distance from the road all the way in instead of drifting across
      // the sand as the projection changed the road's width under it.
      var side = i % 2 ? 1 : -1;
      var out = 1.5 + hash(seed + 3.3 + pass) * 3.2;
      var x = p.x + side * W.halfTexels * out * p.a;
      if (x < -this.w * 0.6 || x > this.w * 1.6) return null;

      return {
        d: p.t, x: x, y: p.y, s: p.t, seed: seed + pass * 0.37, side: side,
        kind: r > 0.80 ? 2 : (r > 0.44 ? 1 : 0),   // 0 boulder, 1 scrub, 2 stalks
        // Which cell of the baked sheet. Five rocks — three limestone slabs
        // off the escarpment, two dark ironstone — then seven plants: two
        // straw tussocks, two ghada shrubs, a dead one, a saltbush and a
        // thorn bush.
        sprite: r > 0.46
          ? 5 + Math.floor(hash(seed + 12.9 + pass) * 7) % 7
          : Math.floor(hash(seed + 12.9 + pass) * 5) % 5,
        size: (0.55 + hash(seed + 9.7) * 0.85) * p.t * this.h * 0.26,
        // How far into the haze it still is, by apparent size rather than by
        // depth. It reaches the dust colour completely — not 98% of the way
        // there — well before the far end of the band, so what fades in is
        // already the same tan as the air it fades in from.
        fog: clamp((0.30 - p.t) / (0.30 - W.tSpawn), 0, 1)
      };
    },

    /* The outcrops the track runs between. Same world clock, same wrapping
       band, but they stand well off the road and are some twenty times the
       size, which is what gives the horizon a shape to read. Four of them,
       alternating sides: nine read as a canyon, and a canyon is not what the
       road out of Riyadh looks like. */
    CLIFFS: 4,

    cliffAt: function (i, lean) {
      var W = this.world;
      var seed = 101.7 + i * 5.317;

      // Evenly spaced around the band rather than scattered through it by a
      // hash. They all travel at the same rate, so an even spacing means they
      // wrap — and therefore arrive — in index order, and `side` below can
      // simply alternate on the index. Scattered, the sides came up in
      // whatever order the hash felt like and three in a row down one side
      // was common. The jitter is kept under half the spacing so it never
      // reorders two of them.
      var slot = (i + (hash(seed) - 0.5) * 0.45) / this.CLIFFS;
      var cycles = slot - W.travel / W.band;
      var depth = W.near + (cycles - Math.floor(cycles)) * W.band;
      var pass = Math.floor(cycles);

      var p = this.place(depth, 0, lean);

      // Strictly alternating, which the even spacing above makes true of the
      // order they arrive in and not just of their indices.
      var side = i % 2 ? 1 : -1;

      // Distance and height used to be hashed independently — so far out
      // times short was a speck and close times tall was a wall, and the wall
      // came up often enough to be the thing you noticed: measured, one
      // reached 68% of the frame while still on screen. They are two ends of
      // one quantity, so they are chosen as one.
      //
      // `tExit` is the depth at which the inner edge finally clears the frame
      // and `tall` how much of the frame it fills at that moment, which is
      // its largest. Everything else follows, because both the size and the
      // offset from the road grow with the same `grow`: at grow = 1 the
      // sprite's inner edge is exactly half a frame plus half a sprite from
      // the centre — which is the frame edge, by construction. No pair of
      // hashes can make a wall, and none can make a speck either.
      var tExit = 0.048 + ihash(i, pass, 1) * 0.016;
      var tall = 0.19 + ihash(i, pass, 2) * 0.08;
      var grow = p.t / tExit;
      if (grow > 1.6) return null;

      // Stretched a little either way, and half of them mirrored. The
      // half-width has to carry the stretch or the frame-edge exit that the
      // whole placement is built on stops being where it says it is.
      var wide = 0.86 + ihash(i, pass, 4) * 0.42;
      var size = tall * this.h * grow;
      var x = p.x + side * (this.w * 0.5 + 0.42 * tall * this.h * wide) * grow;

      return {
        cliff: true,
        d: p.t, x: x, y: p.y, s: p.t, seed: seed + pass * 0.37, side: side,
        sprite: Math.floor(ihash(i, pass, 3) * 6) % 6,
        size: size,
        wide: wide,
        flip: ihash(i, pass, 5) < 0.5,
        // Opaque sooner than a prop. One of these leaves the frame sideways
        // rather than by going past the camera, and on the shared ramp the
        // nearest-exiting of them was still fading up as it left.
        ramp: 0.20,
        // Cleared on the same schedule as the ground plane fades in, so a
        // cliff is never more present than the surface it stands on — that
        // mismatch is what read as floating. It still has to outlast the
        // fade-in above, or the thing is seen to arrive as a rock rather than
        // as dust that resolves into one.
        fog: clamp((CLIFF_CLEAR - p.t) / (CLIFF_CLEAR - W.tSpawn), 0, 1)
      };
    },

    drawRoadside: function (lateral, dusk) {
      var night = clamp(dusk || 0, 0, 1);
      var list = [];
      var i, p;
      for (i = 0; i < this.CLIFFS; i++) {
        p = this.cliffAt(i, lateral);
        if (p && p.size > 2) list.push(p);
      }
      for (i = 0; i < this.PROPS; i++) {
        p = this.propAt(i, lateral);
        if (p && p.size > 0.7) list.push(p);
      }
      // Back to front, so a near boulder can overlap a far one.
      list.sort(function (a, b) { return a.d - b.d; });

      // Quantised, because every change of this string rebuilds the haze
      // sheet: a run walks through about twenty of them, not one a frame.
      var haze = mixHex('#E7C592', '#6B4A48', Math.round(night * 16) / 16);
      var ctx = this.ctx;

      for (var k = 0; k < list.length; k++) {
        var o = list[k];
        o.col = function (dayHex, nightHex) {
          return mixHex(mixHex(dayHex, nightHex, night), haze, this.fog);
        };
        ctx.save();
        // The fade is short, and deep enough into the band that whatever is
        // fading is still solid dust colour — so nothing is ever seen to be
        // half transparent. Switching on at four fifths of its weight, as
        // this first did, pops; ramping in over the part of the run where the
        // haze has already cleared, as it did next, makes the thing look like
        // a ghost of itself for the whole approach.
        var born = this.world.tSpawn;
        ctx.globalAlpha = clamp((o.s - born) / (born * (o.ramp || 0.5)), 0, 1);
        if (!this.drawSprite(o, night, haze) && !o.cliff) {
          if (o.kind === 0) this.drawBoulder(o, night);
          else if (o.kind === 1) this.drawScrub(o, night);
          else this.drawStalks(o, night);
        }
        ctx.restore();
      }
    },

    /** The baked version: a contact shadow, then the sprite. Returns false if
        the sheet has not loaded, and the painted props take over. */
    drawSprite: function (o, night, haze) {
      var ctx = this.ctx;

      if (o.cliff) {
        var sheet = cliffSheet();
        if (!sheet.ready) return false;
        // No contact shadow: the sheet carries its own talus apron, which is
        // what a cliff has instead of a shadow on the sand.
        return sheet.draw(ctx, o.sprite, o.x, o.y, o.size, {
          fog: o.fog, hazeColour: haze, dusk: night, duskColour: '#6B4A54',
          wide: o.wide, flip: o.flip
        });
      }

      if (!Sprites.ready) return false;
      var rock = o.sprite < 5;
      // A saltbush hugs the ground and a thorn bush stands over head height;
      // drawing every plant the same size threw that away.
      var height = o.size * (rock ? 1.15 : PLANT_SIZE[o.sprite - 5]);

      // Shadow first: the sprite is cut off at its waterline, so what beds it
      // into the sand is drawn here rather than baked into the sheet, where
      // it could not follow the sun across the run.
      var sw = height * (rock ? 0.72 : 0.40);
      ctx.beginPath();
      ctx.ellipse(o.x + sw * 0.42, o.y - height * 0.012, sw, sw * 0.26, 0, 0, TAU);
      ctx.fillStyle = 'rgba(58, 34, 14, ' + ((0.34 - night * 0.14) * (1 - o.fog)).toFixed(3) + ')';
      ctx.fill();

      return Sprites.draw(ctx, o.sprite, o.x, o.y, height, {
        fog: o.fog,
        hazeColour: haze,
        dusk: night,
        duskColour: '#6B4A54'
      });
    },

    /** A rock: shadow pooled on the sand, dark body, sunlit cap. */
    drawBoulder: function (o, night) {
      var ctx = this.ctx;
      var w = o.size * (0.62 + hash(o.seed + 2.2) * 0.45);
      var h = o.size * (0.42 + hash(o.seed + 4.4) * 0.40);
      var clear = 1 - o.fog;

      ctx.beginPath();
      ctx.ellipse(o.x + w * 0.18, o.y + h * 0.06, w * 1.05, h * 0.22, 0, 0, TAU);
      ctx.fillStyle = 'rgba(58, 34, 16, ' + ((0.34 - night * 0.14) * clear).toFixed(3) + ')';
      ctx.fill();

      // A squashed dome with hashed notches, so no two rocks are the same
      // ellipse.
      ctx.beginPath();
      var n = 9;
      for (var i = 0; i <= n; i++) {
        var a = Math.PI + (i / n) * Math.PI;
        var rr = 1 - hash(o.seed + i * 1.9) * 0.22;
        var px = o.x + Math.cos(a) * w * rr;
        var py = o.y + Math.sin(a) * h * rr;
        if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
      }
      ctx.closePath();

      var g = ctx.createLinearGradient(o.x - w * 0.4, o.y - h, o.x + w * 0.5, o.y);
      g.addColorStop(0, o.col('#C79B6A', '#5B3F40'));
      g.addColorStop(0.55, o.col('#9A6F45', '#3E2A2C'));
      g.addColorStop(1, o.col('#6A4728', '#241A1C'));
      ctx.fillStyle = g;
      ctx.fill();

      // Low sun catching the upper left edge.
      ctx.beginPath();
      ctx.ellipse(o.x - w * 0.22, o.y - h * 0.62, w * 0.42, h * 0.20, -0.35, 0, TAU);
      ctx.fillStyle = 'rgba(255, 228, 176, ' + (0.26 * (1 - night * 0.55) * clear).toFixed(3) + ')';
      ctx.fill();
    },

    /** A desert bush. Five big circles read as a cartoon blob once one came
        close to the camera, so it is built from a dozen small, unevenly
        scattered clumps in a dry khaki palette, with sprigs standing out of
        the crown. */
    drawScrub: function (o, night) {
      var ctx = this.ctx;
      var w = o.size * 0.44;
      var h = o.size * 0.34;
      var clear = 1 - o.fog;

      ctx.beginPath();
      ctx.ellipse(o.x + w * 0.24, o.y + h * 0.10, w * 1.05, h * 0.26, 0, 0, TAU);
      ctx.fillStyle = 'rgba(52, 34, 14, ' + ((0.28 - night * 0.12) * clear).toFixed(3) + ')';
      ctx.fill();

      // Sprigs first, so the clumps cover where they meet the ground.
      ctx.strokeStyle = o.col('#8A7C4A', '#2A2218');
      ctx.lineWidth = Math.max(0.6, o.size * 0.026);
      ctx.beginPath();
      for (var sp = 0; sp < 9; sp++) {
        var a = -Math.PI * 0.5 + (hash(o.seed + sp * 3.7) - 0.5) * 2.3;
        var len = 0.75 + hash(o.seed + sp * 6.4) * 0.65;
        ctx.moveTo(o.x + (hash(o.seed + sp * 2.2) - 0.5) * w * 0.4, o.y);
        ctx.lineTo(o.x + Math.cos(a) * w * 1.5 * len, o.y + Math.sin(a) * h * 2.4 * len);
      }
      ctx.stroke();

      var tones = ['#8E8551', '#736A38', '#5A5228', '#9B9061'];
      var darks = ['#332F1E', '#282415', '#1E1B10', '#3A3522'];
      for (var i = 0; i < 12; i++) {
        var ang = hash(o.seed + i * 5.1) * TAU;
        var rad = hash(o.seed + i * 7.3);
        var hx = Math.cos(ang) * w * 1.15 * rad;
        var hy = -h * 0.35 - Math.sin(ang) * h * 1.05 * rad - h * 0.25;
        var r = w * (0.17 + hash(o.seed + i * 2.9) * 0.20);
        var tone = i % 4;
        ctx.beginPath();
        ctx.ellipse(o.x + hx, o.y + hy, r, r * (0.66 + hash(o.seed + i * 1.3) * 0.3),
                    hash(o.seed + i * 4.1) * TAU, 0, TAU);
        ctx.fillStyle = o.col(tones[tone], darks[tone]);
        ctx.fill();
      }

      // Low sun catching the crown.
      ctx.beginPath();
      ctx.ellipse(o.x - w * 0.30, o.y - h * 1.35, w * 0.34, h * 0.20, -0.3, 0, TAU);
      ctx.fillStyle = 'rgba(255, 228, 160, ' + (0.20 * (1 - night * 0.6) * clear).toFixed(3) + ')';
      ctx.fill();
    },

    /** Dry stalks: a fan of bleached stems — the cheapest thing in the desert
        that still reads as alive at twenty pixels. */
    drawStalks: function (o, night) {
      var ctx = this.ctx;
      var h = o.size * 0.85;
      var lean = (hash(o.seed + 1.1) - 0.5) * 0.5;

      ctx.beginPath();
      ctx.ellipse(o.x + h * 0.10, o.y, h * 0.34, h * 0.08, 0, 0, TAU);
      ctx.fillStyle = 'rgba(52, 34, 14, ' + ((0.22 - night * 0.10) * (1 - o.fog)).toFixed(3) + ')';
      ctx.fill();

      ctx.strokeStyle = o.col('#D8BE84', '#584039');
      ctx.lineWidth = Math.max(0.6, o.size * 0.030);
      ctx.lineCap = 'round';
      ctx.beginPath();
      for (var i = 0; i < 7; i++) {
        var f = (i / 6 - 0.5);
        var tipX = o.x + f * h * 0.55 + lean * h * 0.6;
        var tipY = o.y - h * (0.55 + hash(o.seed + i * 4.3) * 0.55);
        ctx.moveTo(o.x + f * h * 0.10, o.y);
        ctx.quadraticCurveTo(o.x + f * h * 0.25, o.y - h * 0.45, tipX, tipY);
      }
      ctx.stroke();
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
      // How far the world moved this frame. Scaled down from the raw speed:
      // at the full value the ground covered more ground between two frames
      // than the ripples on it are apart, which aliases into sand pouring
      // towards the vanishing point however well it is drawn. Everything that
      // scrolls reads this, so the plates, the props and the floor stay in
      // step with each other.
      if (Ground.pace) Ground.pace(dt);
      this.lastSpeed = state.speed || 0;
      this.lastLean = state.tilt || 0;
      this.dScroll = this.lastSpeed * dt * WORLD_SCALE;
      this.scroll += this.dScroll;

      var dusk = clamp(state.dusk || 0, 0, 1);
      this.lastDusk = dusk;
      var speedNorm = clamp(((state.speed || 0) - 240) / 460, 0, 1);
      this.speedNorm = speedNorm;

      // Smoothed, because it drives the horizon and the horizon drives most
      // of the frame. Followed frame by frame it twitched with every tap.
      var follow = Math.min(1, dt * 1.5);
      this.speedEase = this.speedEase == null
        ? speedNorm : this.speedEase + (speedNorm - this.speedEase) * follow;
      // A slow follow, on purpose. The car leans back and forth about once a
      // second while the player balances it, and a ridge a kilometre off has
      // no business answering that — it answers where the car has drifted to,
      // which is a much slower thing. At a quarter-second follow the whole
      // background twitched in time with the tapping.
      this.leanEase = this.leanEase == null
        ? 0 : this.leanEase + ((state.tilt || 0) - this.leanEase) * Math.min(1, dt * 0.8);

      // The camera sits lower as the car picks up speed, so the horizon rises.
      // Not rounded: a whole-pixel horizon steps, and everything keyed to it —
      // the plates, the ground's own geometry — steps with it.
      this.horizon = this.baseHorizon - this.speedEase * this.h * 0.022;
      this.syncWorld();

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
      this.drawGround(dusk, state.tilt || 0);
      this.drawTrack(state.tilt || 0, dusk);
      this.drawRoadside(state.tilt || 0, dusk);

      // Coins, on the same plane as everything else that is out there. They
      // come in from a quarter of the way to the horizon rather than from the
      // horizon itself: at this projection the far distance is many seconds
      // away, and a token that takes twenty of them to arrive is not a token.
      var coins = state.coins || [];
      var cfg = global.DriftGame && global.DriftGame.CONFIG;
      var coinFar = this.world.TD + (cfg ? cfg.coinTravel * cfg.speedBase : 650) *
                                    WORLD_SCALE * this.world.travelPerScroll;
      for (var i = 0; i < coins.length; i++) {
        var c = coins[i];
        var cp = this.place(coinFar + (this.world.TD - coinFar) * c.d,
                            c.lane * this.w * 0.26 / this.world.A0, state.tilt || 0);
        ctx.globalAlpha = clamp(c.d / 0.08, 0, 1);
        this.drawCoin(cp.x, cp.y - 150 * cp.t - this.h * 0.02, Math.max(2, 26 * cp.t), c.spin);
        ctx.globalAlpha = 1;
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
      var warm = dusk > 0.5 ? 'rgba(255, 170, 120, 1)' : 'rgba(255, 224, 176, 1)';
      for (var i = 0; i < 16; i++) {
        var seed = (this.time * (1.6 + (i % 5) * 0.5) + i * 0.13) % 1;
        var d = 0.55 + seed * 0.5;
        var p = this.project(Math.min(d, 1));
        var len = 30 + seed * 150 * intensity;
        var x = this.w * (hash(i * 3.7) * 1.4 - 0.2);
        // Faded in and out too, for the same reason.
        ctx.globalAlpha = intensity * 0.10 *
          clamp(seed / 0.16, 0, 1) * clamp((1 - seed) / 0.2, 0, 1);
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
      ctx.strokeStyle = '#FFF3DC';
      ctx.lineWidth = 2;
      for (var i = 0; i < 9; i++) {
        var seed = (this.time * 2.2 + i * 0.37) % 1;
        // Started below the skyline and faded in and out along the way. Each
        // of these used to switch on at full weight exactly on the horizon
        // and switch off at the bottom — nine of them, twice a second, which
        // is what made the horizon flicker.
        var y = this.horizon + (this.h - this.horizon) * (0.08 + 0.92 * seed);
        var len = 26 + seed * 90;
        var side = i % 2 === 0 ? -1 : 1;
        var x = this.w * 0.5 + side * (this.w * 0.34 + seed * this.w * 0.2);
        ctx.globalAlpha = intensity * 0.28 *
          clamp(seed / 0.18, 0, 1) * clamp((1 - seed) / 0.22, 0, 1);
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
