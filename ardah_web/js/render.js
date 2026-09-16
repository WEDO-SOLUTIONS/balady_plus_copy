/* Canvas renderer: the perspective runway, the notes, the HUD and the effects.
   The stage above it lives in `scene.js`.

   The runway is a real projection, not a stretched rectangle. A note's distance
   `z` shrinks linearly with time (constant speed in world space), and the
   screen position is `y = vp + C/z`, `x = centre + laneOffset/z`. That single
   division is what makes markers drift slowly when far and rush the last few
   metres — the movement a rhythm player reads without thinking.

   Still no images: paths and gradients only. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var APPROACH_MS = 1500;
  var Z_FAR = 5.0;          // spawn distance
  var Z_LIP = 0.86;         // a little past the judgment line, for the near lip
  var PERFORMERS = 10;      // five a side, as in the concept art

  var LANE = [
    // tabl — a gold ingot, swords — a cut gem, tar — a struck coin
    { kind: 'ingot', gem: '#F2B33D', rim: '#7A5310', glow: '#FFD978', cap: '#8A5A2B' },
    { kind: 'gem',   gem: '#3AA3E8', rim: '#123B63', glow: '#9CD8FF', cap: '#2E6FA8' },
    { kind: 'coin',  gem: '#F5D779', rim: '#96701F', glow: '#FFF0B8', cap: '#6B4E12' }
  ];
  var LANE_KEYS = ['A', 'S', 'D'];
  var HUD_RIGHT = 58;      // clearance for the floating sound toggle
  // Keycap faces, matching the lanes: tabl wood, swords steel-blue, tar green.
  var KEY_SPRITE = ['key_tabl', 'key_swords', 'key_tar'];
  var KEYCAP = [
    ['#8A5A2B', '#4A2F14'],
    ['#3F6F9E', '#1B355A'],
    ['#2E7D52', '#143E2A']
  ];

  function Renderer(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d', { alpha: false });
    this.scene = new A.Scene();
    this.performers = [];
    for (var i = 0; i < PERFORMERS; i++) this.performers.push(0);
    this.drumPulse = [0, 0];
    this.drumCursor = 0;
    this.sparks = [];
    this.bursts = [];
    this.floats = [];
    this.flashes = [0, 0, 0];
    this.popup = null;
    this.shake = 0;
    this.tMs = 0;
    this.resize();
  }

  Renderer.prototype.resize = function () {
    this.dpr = Math.min(window.devicePixelRatio || 1, 2);
    this.w = window.innerWidth;
    this.h = window.innerHeight;
    this.canvas.width = Math.round(this.w * this.dpr);
    this.canvas.height = Math.round(this.h * this.dpr);
    this.canvas.style.width = this.w + 'px';
    this.canvas.style.height = this.h + 'px';
    this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);

    // Vertical budget: stage on top, runway below, keycaps at the foot.
    this.keyY = this.h - Math.max(44, this.h * 0.065);
    this.judgeY = this.keyY - Math.max(52, this.h * 0.075);
    this.stageY = Math.round(this.h * 0.48);
    this.vpY = this.stageY - 62;
    this.C = this.judgeY - this.vpY;
    this.halfNear = Math.min(this.w * 0.46, 300);

    // Near-field lane geometry — this is what the player taps, so `game.js`
    // reads these two for hit-testing.
    this.fieldX = this.w / 2 - this.halfNear;
    this.laneW = (this.halfNear * 2) / 3;

    this.scene.build(this.w, this.h, this.dpr, this.stageY);

    // Every gradient below depends only on the layout, so they are built once
    // per resize instead of once per frame. Creating a dozen CanvasGradients
    // every frame was costing three to five frames a second on the art path.
    this._grad = {};
  };

  /** Layout-scoped gradient cache. */
  Renderer.prototype._g = function (key, make) {
    var g = this._grad[key];
    if (!g) { g = make(this.ctx); this._grad[key] = g; }
    return g;
  };

  /* ------------------------------ projection ------------------------------ */

  Renderer.prototype.yAt = function (z) { return this.vpY + this.C / z; };
  Renderer.prototype.halfAt = function (z) { return this.halfNear / z; };
  Renderer.prototype.xAt = function (lane, z) {
    return this.w / 2 + ((lane - 1) * (this.halfNear * 2 / 3)) / z;
  };
  Renderer.prototype.zAt = function (leadMs) {
    var u = Math.max(-0.2, Math.min(1, leadMs / APPROACH_MS));
    return 1 + u * (Z_FAR - 1);
  };
  /** Kept for callers that only need the near-field centre of a lane. */
  Renderer.prototype.laneCenter = function (lane) { return this.xAt(lane, 1); };

  /* -------------------------------- events -------------------------------- */

  Renderer.prototype.hit = function (lane, judgment) {
    if (lane >= 0 && lane < 3) this.flashes[lane] = judgment === 'stray' ? 0.3 : 1;
    if (judgment === 'stray') return;

    if (judgment === 'miss') { this.shake = 1; return; }

    // Raise one sword per side, so both rows answer the beat.
    var half = PERFORMERS / 2;
    this.performers[Math.floor(Math.random() * half)] = 1;
    this.performers[half + Math.floor(Math.random() * half)] = 1;

    if (lane >= 0) this._sparks(this.xAt(lane, 1), this.judgeY, LANE[lane].glow, judgment === 'perfect' ? 18 : 10);
  };

  Renderer.prototype.score = function (lane, amount) {
    this.floats.push({ x: this.xAt(Math.max(0, lane), 1), y: this.judgeY - 44, text: '+' + amount, life: 1 });
  };

  Renderer.prototype.say = function (text, tone) {
    this.popup = { text: text, tone: tone || '#FFD978', life: 1 };
  };

  Renderer.prototype.flourishBurst = function () {
    for (var i = 0; i < PERFORMERS; i++) this.performers[i] = 1;
    this.flashes[0] = this.flashes[1] = this.flashes[2] = 1;
    for (var k = 0; k < 3; k++) this._sparks(this.xAt(k, 1), this.judgeY, '#FFD978', 16);
  };

  Renderer.prototype._sparks = function (x, y, color, n) {
    this.bursts.push({ x: x, y: y, life: 1, color: color, rot: Math.random() * Math.PI });
    for (var i = 0; i < n; i++) {
      var a = -Math.PI / 2 + (Math.random() - 0.5) * Math.PI * 1.25;
      var sp = 0.12 + Math.random() * 0.34;
      this.sparks.push({
        x: x, y: y,
        vx: Math.cos(a) * sp, vy: Math.sin(a) * sp,
        life: 1, color: color, size: 1.5 + Math.random() * 2.2
      });
    }
  };

  /* --------------------------------- draw --------------------------------- */

  Renderer.prototype.draw = function (state, dtMs) {
    var c = this.ctx;
    this.tMs += dtMs;
    var decay = Math.min(1, dtMs / 220);

    c.save();
    if (this.shake > 0.01) {
      c.translate((Math.random() - 0.5) * 7 * this.shake, (Math.random() - 0.5) * 7 * this.shake);
      this.shake -= decay;
    }

    this._advanceDrummers(state, dtMs);
    var plate = A.assets && A.assets.img('bg_stage');
    if (plate) this._plate(c, plate);
    else this.scene.draw(c, this.tMs, dtMs, this.performers, this.drumPulse);
    for (var i = 0; i < PERFORMERS; i++) this.performers[i] = Math.max(0, this.performers[i] - decay * 0.65);
    this.drumPulse[0] = Math.max(0, this.drumPulse[0] - decay * 1.6);
    this.drumPulse[1] = Math.max(0, this.drumPulse[1] - decay * 1.6);

    this._runway(c, !!state.chart);
    if (state.chart) {
      this._notes(c, state);
      this._judgeLine(c);
    }
    this._keycaps(c, state);
    this._effects(c, decay, dtMs);
    if (state.chart) this._hud(c, state);

    for (var k = 0; k < 3; k++) this.flashes[k] = Math.max(0, this.flashes[k] - decay);
    c.restore();
  };

  /* The drummers play what you actually hear: walk the chart's drum track and
     pulse the matching player. O(1) per frame amortised. */
  Renderer.prototype._advanceDrummers = function (state, dtMs) {
    if (!state.chart) { this.drumCursor = 0; return; }
    var t = state.visualTimeMs, drums = state.chart.drums;
    if (this.drumCursor > 0 && drums[this.drumCursor - 1] && drums[this.drumCursor - 1].t > t + 200) {
      this.drumCursor = 0;                       // a restart rewound the clock
    }
    while (this.drumCursor < drums.length && drums[this.drumCursor].t <= t) {
      var voice = drums[this.drumCursor].voice;
      if (voice === 'tabl') this.drumPulse[0] = 1;
      else if (voice === 'tar') this.drumPulse[1] = 1;
      else this.performers[Math.floor(Math.random() * this.performers.length)] = 0.75;
      this.drumCursor++;
    }
  };

  /* A rendered stage plate replaces the drawn scene. The performers are baked
     into it, so the only life left is the light: the braziers flicker and the
     whole plate breathes a little on the beat. That limitation is the point of
     the experiment — animation needs the layered delivery, not a flat still. */
  Renderer.prototype._plate = function (c, img) {
    // The plate's floor must meet the runway's FAR EDGE, not the nominal stage
    // line — otherwise a strip of invented ground sits between the performers'
    // feet and the deck, and the two perspectives visibly disagree.
    var joinY = this.yAt(Z_FAR);
    var scale = Math.max(this.w / img.width, joinY / img.height);
    var dw = img.width * scale, dh = img.height * scale;
    var dx = (this.w - dw) / 2, dy = joinY - dh;

    c.fillStyle = '#0B0A10';
    c.fillRect(0, 0, this.w, this.h);

    var breathe = 1 + Math.sin(this.tMs / 312) * 0.0035;    // ~ one beat at 96 BPM
    c.save();
    c.translate(this.w / 2, joinY);
    c.scale(breathe, breathe);
    c.translate(-this.w / 2, -joinY);

    c.drawImage(img, dx, dy, dw, dh);

    c.restore();

    // Ground beyond the join: the plate's own floor, taken from its cleanest
    // band (just above the bottom, before the carpet and the shoes) and blurred
    // by a round trip through a tiny canvas. Stretching the raw strip smeared
    // the carpet and the feet down the screen; blurring it leaves the tone,
    // which is the only part that has to match.
    var tex = this._groundTex(img);
    c.drawImage(tex, 0, 0, tex.width, tex.height, 0, joinY - 2, this.w, this.h - joinY + 2);

    // A short feather over the join itself: the plate's last rows carry a dark
    // edge from the original render, which otherwise reads as a hairline.
    c.fillStyle = this._g('plateSeam', function (cc) {
      var g = cc.createLinearGradient(0, joinY - 14, 0, joinY + 14);
      g.addColorStop(0, 'rgba(161, 95, 64, 0)');
      g.addColorStop(0.5, 'rgba(161, 95, 64, 0.6)');
      g.addColorStop(1, 'rgba(161, 95, 64, 0)');
      return g;
    });
    c.fillRect(0, joinY - 14, this.w, 28);

    // Darken with distance so the deck stays readable over it, and keep the
    // plate's brighter middle.
    var self = this;
    c.fillStyle = this._g('plateShade', function (cc) {
      var g = cc.createLinearGradient(0, joinY, 0, self.h);
      g.addColorStop(0, 'rgba(10, 7, 6, 0)');
      g.addColorStop(0.45, 'rgba(10, 7, 6, 0.35)');
      g.addColorStop(1, 'rgba(8, 6, 5, 0.82)');
      return g;
    });
    c.fillRect(0, joinY, this.w, this.h - joinY);

    c.fillStyle = this._g('plateAcross', function (cc) {
      var g = cc.createLinearGradient(0, 0, self.w, 0);
      g.addColorStop(0, 'rgba(0, 0, 0, 0.3)');
      g.addColorStop(0.5, 'rgba(255, 205, 150, 0.04)');
      g.addColorStop(1, 'rgba(0, 0, 0, 0.3)');
      return g;
    });
    c.fillRect(0, joinY, this.w, this.h - joinY);

    this._floorGrid(c, joinY);

    // Firelight over the baked braziers, so the scene is not dead still.
    var fires = [[0.335, 0.735], [0.715, 0.73], [0.055, 0.70], [0.945, 0.70]];
    c.globalCompositeOperation = 'lighter';
    for (var i = 0; i < fires.length; i++) {
      var fx = dx + dw * fires[i][0], fy = dy + dh * fires[i][1];
      var flick = 0.5 + 0.5 * Math.abs(Math.sin(this.tMs / 190 + i * 1.7)) * Math.abs(Math.sin(this.tMs / 71 + i));
      var r = 60 + flick * 26;
      var g = c.createRadialGradient(fx, fy, 2, fx, fy, r);
      g.addColorStop(0, 'rgba(255, 170, 80, ' + (0.1 + flick * 0.1).toFixed(3) + ')');
      g.addColorStop(1, 'rgba(255, 150, 60, 0)');
      c.fillStyle = g;
      c.beginPath(); c.arc(fx, fy, r, 0, Math.PI * 2); c.fill();
    }
    c.globalCompositeOperation = 'source-over';
  };

  /* The blurred floor wash, built once per image. */
  Renderer.prototype._groundTex = function (img) {
    if (this._gtex && this._gtexSrc === img.src) return this._gtex;

    var band = Math.max(6, Math.round(img.height * 0.02));
    var top = img.height - band - Math.round(img.height * 0.012);
    var small = document.createElement('canvas');
    small.width = 24; small.height = 6;
    var sc = small.getContext('2d');
    sc.drawImage(img, 0, top, img.width, band, 0, 0, 24, 6);

    this._gtex = small;
    this._gtexSrc = img.src;
    return small;
  };

  /* Tiles on the ground either side of the deck, projected with the SAME
     vanishing point and the same 1/z row spacing as the runway. That shared
     geometry is what makes the plate's floor and the deck read as one surface
     rather than two pictures stacked. */
  Renderer.prototype._floorGrid = function (c, joinY) {
    var cx = this.w / 2, spacing = this.halfNear * 0.62;

    c.save();
    c.beginPath();
    c.rect(0, joinY - 4, this.w, this.h - joinY + 4);
    c.clip();
    c.strokeStyle = 'rgba(255, 216, 160, 0.09)';
    c.lineWidth = 1;

    for (var k = -6; k <= 6; k++) {
      if (k === 0) continue;
      c.beginPath();
      c.moveTo(cx + (k * spacing) / Z_FAR, this.yAt(Z_FAR));
      c.lineTo(cx + (k * spacing) / 0.45, this.yAt(0.45));
      c.stroke();
    }

    var zs = [4.2, 3.4, 2.75, 2.2, 1.75, 1.38, 1.08, 0.84, 0.64];
    for (var i = 0; i < zs.length; i++) {
      var y = this.yAt(zs[i]);
      if (y < joinY - 4) continue;
      c.globalAlpha = Math.min(1, (y - joinY) / 90 + 0.25);
      c.beginPath(); c.moveTo(0, y); c.lineTo(this.w, y); c.stroke();
    }
    c.globalAlpha = 1;
    c.restore();
  };

  /* -------------------------------- runway -------------------------------- */

  Renderer.prototype._runway = function (c, active) {
    var wTop = this.halfAt(Z_FAR), yTop = this.yAt(Z_FAR);
    var wBot = this.halfAt(Z_LIP), yBot = this.yAt(Z_LIP);
    var cx = this.w / 2;

    // Deck
    c.fillStyle = this._g('deck', function (cc) {
      var g = cc.createLinearGradient(0, yTop, 0, yBot);
      g.addColorStop(0, 'rgba(18, 26, 44, 0.35)');
      g.addColorStop(0.55, 'rgba(24, 20, 30, 0.75)');
      g.addColorStop(1, 'rgba(12, 10, 16, 0.92)');
      return g;
    });
    c.beginPath();
    c.moveTo(cx - wTop, yTop); c.lineTo(cx + wTop, yTop);
    c.lineTo(cx + wBot, yBot); c.lineTo(cx - wBot, yBot);
    c.closePath();
    c.fill();

    // Blend the far end into the plaza so the deck does not start on a hard line.
    var fade = c.createLinearGradient(0, yTop - 16, 0, yTop + 46);
    fade.addColorStop(0, 'rgba(90, 62, 40, 0.55)');
    fade.addColorStop(1, 'rgba(90, 62, 40, 0)');
    c.fillStyle = fade;
    c.beginPath();
    c.moveTo(cx - wTop * 1.6, yTop - 16); c.lineTo(cx + wTop * 1.6, yTop - 16);
    c.lineTo(cx + wTop * 2.2, yTop + 46); c.lineTo(cx - wTop * 2.2, yTop + 46);
    c.closePath();
    c.fill();

    // Lane flashes, in perspective
    for (var lane = 0; lane < 3; lane++) {
      if (this.flashes[lane] <= 0) continue;
      var yEnd = this.judgeY;
      var offTop = (this.halfNear * 2 / 3) / Z_FAR, offEnd = (this.halfNear * 2 / 3);
      var ctTop = cx + (lane - 1) * offTop, ctEnd = cx + (lane - 1) * offEnd;
      c.globalAlpha = this.flashes[lane] * 0.26;
      c.fillStyle = this._g('flash' + lane, function (cc) {
        var g = cc.createLinearGradient(0, yTop, 0, yEnd);
        g.addColorStop(0, 'rgba(0,0,0,0)');
        g.addColorStop(1, LANE[lane].glow);
        return g;
      });
      c.beginPath();
      c.moveTo(ctTop - offTop / 2, yTop); c.lineTo(ctTop + offTop / 2, yTop);
      c.lineTo(ctEnd + offEnd / 2, yEnd); c.lineTo(ctEnd - offEnd / 2, yEnd);
      c.closePath();
      c.fill();
      c.globalAlpha = 1;
    }

    // Lane dividers
    c.strokeStyle = 'rgba(231, 180, 76, 0.22)';
    c.lineWidth = 1;
    for (var d = -1; d <= 1; d += 2) {
      var oT = (this.halfNear / 3) / Z_FAR * d, oB = (this.halfNear / 3) / Z_LIP * d;
      c.beginPath(); c.moveTo(cx + oT, yTop); c.lineTo(cx + oB, yBot); c.stroke();
    }

    this._rail(c, -1, active);
    this._rail(c, 1, active);
  };

  /* Ornamented gold rail down one side of the runway. */
  Renderer.prototype._rail = function (c, side, active) {
    var cx = this.w / 2;
    var wTop = this.halfAt(Z_FAR), yTop = this.yAt(Z_FAR);
    var wBot = this.halfAt(Z_LIP), yBot = this.yAt(Z_LIP);
    var thickTop = 5, thickBot = 16;

    var xTopIn = cx + side * wTop, xBotIn = cx + side * wBot;
    c.fillStyle = this._g('rail', function (cc) {
      var g = cc.createLinearGradient(0, yTop, 0, yBot);
      g.addColorStop(0, '#6B5220');
      g.addColorStop(0.4, '#C79A3E');
      g.addColorStop(0.75, '#F3D98A');
      g.addColorStop(1, '#A87C2C');
      return g;
    });
    c.beginPath();
    c.moveTo(xTopIn, yTop);
    c.lineTo(xTopIn + side * thickTop, yTop);
    c.lineTo(xBotIn + side * thickBot, yBot);
    c.lineTo(xBotIn, yBot);
    c.closePath();
    c.fill();

    // Diamond inlay marching down the rail — the Najdi motif, cheaply.
    c.fillStyle = 'rgba(40, 26, 10, 0.55)';
    for (var i = 0; i < 9; i++) {
      var z = Z_LIP + (Z_FAR - Z_LIP) * (i / 9);
      var y = this.yAt(z), half = this.halfAt(z);
      var th = thickBot + (thickTop - thickBot) * ((z - Z_LIP) / (Z_FAR - Z_LIP));
      var x = cx + side * (half + th / 2);
      var r = Math.max(1.2, th * 0.3);
      c.beginPath();
      c.moveTo(x, y - r); c.lineTo(x + r, y); c.lineTo(x, y + r); c.lineTo(x - r, y);
      c.closePath(); c.fill();
    }

    if (active) {
      c.strokeStyle = 'rgba(255, 220, 150, 0.35)';
      c.lineWidth = 1;
      c.beginPath(); c.moveTo(xTopIn, yTop); c.lineTo(xBotIn, yBot); c.stroke();
    }
  };

  Renderer.prototype._judgeLine = function (c) {
    var half = this.halfAt(1), cx = this.w / 2, y = this.judgeY;
    c.fillStyle = this._g('judgeGlow', function (cc) {
      var g = cc.createLinearGradient(0, y - 16, 0, y + 16);
      g.addColorStop(0, 'rgba(255, 214, 130, 0)');
      g.addColorStop(0.5, 'rgba(255, 214, 130, 0.35)');
      g.addColorStop(1, 'rgba(255, 214, 130, 0)');
      return g;
    });
    c.fillRect(cx - half, y - 16, half * 2, 32);

    c.fillStyle = this._g('judgeBar', function (cc) {
      var g = cc.createLinearGradient(cx - half, 0, cx + half, 0);
      g.addColorStop(0, 'rgba(231, 180, 76, 0.35)');
      g.addColorStop(0.5, '#FFE7AE');
      g.addColorStop(1, 'rgba(231, 180, 76, 0.35)');
      return g;
    });
    c.fillRect(cx - half, y - 2, half * 2, 4);
  };

  /* --------------------------------- notes --------------------------------- */

  Renderer.prototype._notes = function (c, state) {
    var now = state.visualTimeMs, notes = state.judge.notes;
    for (var i = 0; i < notes.length; i++) {
      var n = notes[i];
      var lead = n.t - now;
      if (lead > APPROACH_MS) break;
      if (n.state === 'hit' || n.state === 'missed') continue;
      if (lead < -260 && n.state !== 'holding') continue;

      var z = this.zAt(lead);
      if (n.type === 'flourish') { this._flourishNote(c, z, lead); continue; }
      if (n.type === 'hold') this._holdRibbon(c, n, now);
      this._gem(c, n.lane, z, n.type === 'hold');
    }
  };

  var NOTE_SPRITE = ['note_tabl', 'note_swords', 'note_tar'];

  Renderer.prototype._gem = function (c, lane, z, isHold) {
    var x = this.xAt(lane, z), y = this.yAt(z), s = 1 / z;
    var pal = LANE[lane];
    var w = this.halfNear * 0.34 * s;

    var sprite = A.assets && A.assets.img(NOTE_SPRITE[lane]);
    if (sprite) {
      var dw = w * 2.15, dh = dw * (sprite.height / sprite.width);
      c.save();
      c.shadowColor = pal.glow;
      c.shadowBlur = 14 * s;
      c.drawImage(sprite, x - dw / 2, y - dh / 2, dw, dh);
      c.restore();
      if (isHold) {
        c.fillStyle = 'rgba(20, 14, 6, 0.4)';
        c.fillRect(x - w * 0.34, y - 1.5 * s, w * 0.68, 3 * s);
      }
      return;
    }

    c.save();
    c.shadowColor = pal.glow;
    c.shadowBlur = 18 * s;
    if (pal.kind === 'ingot') this._ingot(c, x, y, w, s, pal);
    else if (pal.kind === 'coin') this._coin(c, x, y, w, s, pal);
    else this._jewel(c, x, y, w, s, pal);
    c.restore();

    if (isHold) {
      c.fillStyle = 'rgba(20, 14, 6, 0.4)';
      c.fillRect(x - w * 0.34, y - 1.5 * s, w * 0.68, 3 * s);
    }
  };

  /* A gold bar seen slightly from above: top face, front face, highlight. */
  Renderer.prototype._ingot = function (c, x, y, w, s, pal) {
    var h = 13 * s, topInset = w * 0.22;
    var front = c.createLinearGradient(0, y, 0, y + h);
    front.addColorStop(0, pal.gem);
    front.addColorStop(1, pal.rim);
    c.fillStyle = front;
    c.beginPath();
    c.moveTo(x - w, y); c.lineTo(x + w, y);
    c.lineTo(x + w * 0.92, y + h); c.lineTo(x - w * 0.92, y + h);
    c.closePath(); c.fill();

    var top = c.createLinearGradient(x - w, 0, x + w, 0);
    top.addColorStop(0, '#FFE9B0');
    top.addColorStop(0.5, pal.glow);
    top.addColorStop(1, '#C89127');
    c.fillStyle = top;
    c.beginPath();
    c.moveTo(x - w, y); c.lineTo(x - w + topInset, y - h * 0.85);
    c.lineTo(x + w - topInset, y - h * 0.85); c.lineTo(x + w, y);
    c.closePath(); c.fill();

    c.fillStyle = 'rgba(255,255,255,0.5)';
    c.fillRect(x - w * 0.55, y - h * 0.62, w * 1.1, h * 0.2);
  };

  /* A cut jewel: an octagon with a bright crown facet. */
  Renderer.prototype._jewel = function (c, x, y, w, s, pal) {
    var r = w * 0.78, k = r * 0.42;
    var body = c.createLinearGradient(0, y - r, 0, y + r);
    body.addColorStop(0, pal.glow);
    body.addColorStop(0.55, pal.gem);
    body.addColorStop(1, pal.rim);
    c.fillStyle = body;
    c.beginPath();
    c.moveTo(x - k, y - r * 0.62); c.lineTo(x + k, y - r * 0.62);
    c.lineTo(x + r, y); c.lineTo(x + k, y + r * 0.62);
    c.lineTo(x - k, y + r * 0.62); c.lineTo(x - r, y);
    c.closePath(); c.fill();

    c.strokeStyle = 'rgba(255, 246, 221, 0.85)';
    c.lineWidth = Math.max(0.8, 1.6 * s);
    c.stroke();

    c.fillStyle = 'rgba(255,255,255,0.55)';
    c.beginPath();
    c.moveTo(x - k * 0.8, y - r * 0.5); c.lineTo(x + k * 0.8, y - r * 0.5);
    c.lineTo(x + k * 0.45, y - r * 0.16); c.lineTo(x - k * 0.45, y - r * 0.16);
    c.closePath(); c.fill();
  };

  /* A struck coin: milled rim, palm-and-sabres mark in the middle. */
  Renderer.prototype._coin = function (c, x, y, w, s, pal) {
    var r = w * 0.72;
    var face = c.createLinearGradient(x - r, y - r, x + r, y + r);
    face.addColorStop(0, '#FFFFFF');
    face.addColorStop(0.45, pal.gem);
    face.addColorStop(1, pal.rim);
    c.fillStyle = face;
    c.beginPath(); c.ellipse(x, y, r, r * 0.82, 0, 0, Math.PI * 2); c.fill();

    c.strokeStyle = 'rgba(255,255,255,0.8)';
    c.lineWidth = Math.max(0.8, 1.8 * s);
    c.beginPath(); c.ellipse(x, y, r * 0.82, r * 0.66, 0, 0, Math.PI * 2); c.stroke();

    // Struck mark: a crescent, made of two overlapping discs.
    c.fillStyle = pal.cap;
    c.beginPath(); c.arc(x - r * 0.04, y, r * 0.3, 0, Math.PI * 2); c.fill();
    c.fillStyle = pal.gem;
    c.beginPath(); c.arc(x + r * 0.14, y - r * 0.06, r * 0.27, 0, Math.PI * 2); c.fill();
  };

  Renderer.prototype._holdRibbon = function (c, n, now) {
    var z0 = this.zAt(n.t - now);
    var z1 = this.zAt((n.t + n.durMs) - now);
    if (n.state === 'holding') z0 = Math.min(z0, 1);
    var y0 = this.yAt(z0), y1 = this.yAt(z1);
    var x0 = this.xAt(n.lane, z0), x1 = this.xAt(n.lane, z1);
    var w0 = this.halfNear * 0.2 / z0, w1 = this.halfNear * 0.2 / z1;
    var pal = LANE[n.lane];

    var g = c.createLinearGradient(0, y1, 0, y0);
    g.addColorStop(0, 'rgba(255,255,255,0.12)');
    g.addColorStop(1, pal.gem);
    c.globalAlpha = n.state === 'holding' ? 0.95 : 0.6;
    c.fillStyle = g;
    c.beginPath();
    c.moveTo(x1 - w1, y1); c.lineTo(x1 + w1, y1);
    c.lineTo(x0 + w0, y0); c.lineTo(x0 - w0, y0);
    c.closePath();
    c.fill();
    c.globalAlpha = 1;
  };

  /* The flourish spans the whole runway: a banner with crossed sabres. */
  Renderer.prototype._flourishNote = function (c, z, lead) {
    var y = this.yAt(z), half = this.halfAt(z), cx = this.w / 2, s = 1 / z;
    var h = Math.max(7, 22 * s);

    var g = c.createLinearGradient(cx - half, 0, cx + half, 0);
    g.addColorStop(0, 'rgba(30, 138, 85, 0.9)');
    g.addColorStop(0.5, '#FFD978');
    g.addColorStop(1, 'rgba(30, 138, 85, 0.9)');
    c.fillStyle = g;
    this._roundRect(c, cx - half * 0.96, y - h, half * 1.92, h * 2, h);
    c.fill();

    // Crossed sabres in the middle of the banner.
    c.strokeStyle = 'rgba(40, 26, 10, 0.8)';
    c.lineWidth = Math.max(1.2, 2.6 * s);
    c.lineCap = 'round';
    var r = h * 0.9;
    c.beginPath();
    c.moveTo(cx - r, y + r * 0.5); c.quadraticCurveTo(cx, y - r * 1.1, cx + r, y + r * 0.5);
    c.moveTo(cx - r, y - r * 0.5); c.quadraticCurveTo(cx, y + r * 1.1, cx + r, y - r * 0.5);
    c.stroke();

    if (lead < 420) {
      c.globalAlpha = 0.22 + 0.22 * Math.sin(lead / 38);
      c.fillStyle = '#FFF2CC';
      this._roundRect(c, cx - half * 0.96, y - h, half * 1.92, h * 2, h);
      c.fill();
      c.globalAlpha = 1;
    }
  };

  /* -------------------------------- keycaps -------------------------------- */

  Renderer.prototype._keycaps = function (c, state) {
    var labels = (A.i18n && A.i18n.t('laneNames')) || ['ZEER', 'TAR', 'CLAP'];
    for (var lane = 0; lane < 3; lane++) {
      var x = this.xAt(lane, 1), y = this.keyY;
      var w = Math.min(this.laneW * 0.52, 46), h = 30;

      var cap = A.assets && A.assets.img(KEY_SPRITE[lane]);
      if (cap) {
        // The sprite carries its own letter; the label below stays code-drawn
        // because it has to localise.
        var ch = h * 1.5, cw = ch * (cap.width / cap.height);
        if (this.flashes[lane] > 0.05) {
          c.save();
          c.shadowColor = LANE[lane].glow;
          c.shadowBlur = 18 * this.flashes[lane];
          c.drawImage(cap, x - cw / 2, y - ch / 2, cw, ch);
          c.restore();
        } else {
          c.drawImage(cap, x - cw / 2, y - ch / 2, cw, ch);
        }
      } else {
        var g = c.createLinearGradient(0, y - h / 2, 0, y + h / 2);
        g.addColorStop(0, KEYCAP[lane][0]);
        g.addColorStop(1, KEYCAP[lane][1]);
        c.fillStyle = g;
        this._roundRect(c, x - w / 2, y - h / 2, w, h, 9);
        c.fill();
        c.strokeStyle = this.flashes[lane] > 0.05
          ? LANE[lane].glow
          : 'rgba(231, 180, 76, 0.45)';
        c.lineWidth = 1.4;
        c.stroke();

        c.textAlign = 'center';
        c.fillStyle = '#F6E7C4';
        c.font = '700 15px -apple-system, system-ui, sans-serif';
        c.fillText(state.touchUsed ? '●' : LANE_KEYS[lane], x, y + 5);
      }
      c.textAlign = 'center';

      c.fillStyle = 'rgba(231, 180, 76, 0.75)';
      c.font = '600 10px -apple-system, system-ui, sans-serif';
      c.fillText(labels[lane], x, y + h / 2 + 13);
    }
  };

  /* -------------------------------- effects -------------------------------- */

  Renderer.prototype._effects = function (c, decay, dtMs) {
    var i;

    // Radiating flash at the strike point — the thing that sells a clean hit.
    for (i = this.bursts.length - 1; i >= 0; i--) {
      var b = this.bursts[i];
      b.life -= dtMs / 420;
      if (b.life <= 0) { this.bursts.splice(i, 1); continue; }
      var grow = 1 - b.life;
      c.save();
      c.translate(b.x, b.y);
      c.rotate(b.rot + grow * 0.5);
      c.globalAlpha = b.life * 0.85;
      c.strokeStyle = b.color;
      c.lineCap = 'round';
      for (var ray = 0; ray < 8; ray++) {
        var len = (16 + grow * 46) * (ray % 2 ? 0.55 : 1);
        c.lineWidth = (ray % 2 ? 1.6 : 3) * b.life;
        c.rotate(Math.PI / 4);
        c.beginPath(); c.moveTo(0, 8); c.lineTo(0, 8 + len); c.stroke();
      }
      var core = c.createRadialGradient(0, 0, 1, 0, 0, 34 * (0.5 + grow));
      core.addColorStop(0, 'rgba(255, 252, 240, ' + b.life + ')');
      core.addColorStop(1, 'rgba(255, 210, 130, 0)');
      c.fillStyle = core;
      c.beginPath(); c.arc(0, 0, 34 * (0.5 + grow), 0, Math.PI * 2); c.fill();
      c.restore();
      c.globalAlpha = 1;
    }
    for (i = this.sparks.length - 1; i >= 0; i--) {
      var s = this.sparks[i];
      s.x += s.vx * dtMs; s.y += s.vy * dtMs;
      s.vy += 0.0012 * dtMs;
      s.life -= dtMs / 620;
      if (s.life <= 0) { this.sparks.splice(i, 1); continue; }
      c.globalAlpha = Math.max(0, s.life);
      c.fillStyle = s.color;
      c.fillRect(s.x, s.y, s.size, s.size);
    }
    c.globalAlpha = 1;

    c.textAlign = 'center';
    for (i = this.floats.length - 1; i >= 0; i--) {
      var f = this.floats[i];
      f.y -= dtMs * 0.035;
      f.life -= dtMs / 900;
      if (f.life <= 0) { this.floats.splice(i, 1); continue; }
      c.globalAlpha = Math.max(0, f.life);
      c.font = '800 18px -apple-system, system-ui, sans-serif';
      c.fillStyle = '#FFD978';
      c.fillText(f.text, f.x, f.y);
    }
    c.globalAlpha = 1;

    if (this.popup) {
      var p = this.popup;
      var pop = 1 + (1 - Math.min(1, p.life * 3)) * 0.12;
      c.save();
      c.globalAlpha = Math.max(0, Math.min(1, p.life * 1.4));
      c.translate(this.w / 2, this.judgeY - 74);
      c.scale(pop, pop);
      c.font = '800 30px -apple-system, system-ui, sans-serif';
      c.lineWidth = 4;
      c.strokeStyle = 'rgba(28, 18, 6, 0.75)';
      c.strokeText(p.text, 0, 0);
      c.fillStyle = p.tone;
      c.fillText(p.text, 0, 0);
      c.restore();
      p.life -= decay * 0.85;
      if (p.life <= 0) this.popup = null;
    }
  };

  /* ---------------------------------- HUD ---------------------------------- */

  Renderer.prototype._hud = function (c, state) {
    var j = state.judge, w = this.w;
    var top = 16;

    var self = this;
    c.fillStyle = this._g('hudScrim', function (cc) {
      var g = cc.createLinearGradient(0, 0, 0, 92);
      g.addColorStop(0, 'rgba(7, 11, 22, 0.75)');
      g.addColorStop(1, 'rgba(7, 11, 22, 0)');
      return g;
    });
    c.fillRect(0, 0, w, 92);

    // Score plate first: it is fixed-width content, and the meter has to fit
    // in whatever is left. On a 440pt-wide phone the two used to overlap.
    var label = ((A.i18n && A.i18n.t('score')) || 'SCORE').toUpperCase();
    var value = formatScore(j.score);
    c.font = '800 19px -apple-system, system-ui, sans-serif';
    var vw = c.measureText(value).width;
    c.font = '700 12px -apple-system, system-ui, sans-serif';
    var lw = c.measureText(label).width;

    var maxW = w - HUD_RIGHT - 16;
    var showLabel = vw + lw + 34 <= maxW;
    var pw = Math.min(maxW, showLabel ? vw + lw + 34 : vw + 26), ph = 30;
    var px = w - HUD_RIGHT - pw, py = top;

    c.fillStyle = 'rgba(10, 8, 14, 0.8)';
    this._roundRect(c, px, py, pw, ph, 9); c.fill();
    c.strokeStyle = 'rgba(231, 180, 76, 0.7)';
    c.lineWidth = 1.4;
    this._roundRect(c, px, py, pw, ph, 9); c.stroke();

    if (showLabel) {
      c.textAlign = 'left';
      c.fillStyle = 'rgba(246, 231, 196, 0.72)';
      c.font = '700 11px -apple-system, system-ui, sans-serif';
      c.fillText(label, px + 11, py + 19);
    }

    c.textAlign = 'right';
    c.fillStyle = '#FFD978';
    c.font = '800 19px -apple-system, system-ui, sans-serif';
    c.fillText(value, px + pw - 11, py + 21);

    // Crowd meter: the row's composure, framed like a stage gauge. It takes the
    // space the plate leaves, never less than a readable stub.
    var mx = 16, mh = 14, my = top + 6;
    var mw = Math.max(90, Math.min(250, px - mx - 14));
    c.fillStyle = 'rgba(10, 8, 14, 0.75)';
    this._roundRect(c, mx, my, mw, mh, mh / 2); c.fill();
    c.strokeStyle = 'rgba(231, 180, 76, 0.6)';
    c.lineWidth = 1.4;
    this._roundRect(c, mx, my, mw, mh, mh / 2); c.stroke();

    var pct = Math.max(0.02, j.sync / 100);
    var tone = pct > 0.45 ? 'ok' : (pct > 0.2 ? 'warn' : 'low');
    var self2 = this;
    c.fillStyle = this._g('meter_' + tone + '_' + Math.round(mw), function (cc) {
      var g = cc.createLinearGradient(mx, 0, mx + mw, 0);
      if (tone === 'ok') { g.addColorStop(0, '#2FB574'); g.addColorStop(1, '#8FE3C0'); }
      else if (tone === 'warn') { g.addColorStop(0, '#C79A3E'); g.addColorStop(1, '#FFD978'); }
      else { g.addColorStop(0, '#8A2E22'); g.addColorStop(1, '#E06B4E'); }
      return g;
    });
    this._roundRect(c, mx + 2, my + 2, Math.max(6, (mw - 4) * pct), mh - 4, (mh - 4) / 2);
    c.fill();

    c.fillStyle = '#FFE7AE';
    c.beginPath(); c.arc(mx + 2 + (mw - 4) * pct, my + mh / 2, 3.5, 0, Math.PI * 2); c.fill();

    c.textAlign = 'left';
    c.fillStyle = 'rgba(231, 180, 76, 0.8)';
    c.font = '700 10px -apple-system, system-ui, sans-serif';
    c.fillText((A.i18n && A.i18n.t('crowd')) || 'CROWD', mx + 2, my + mh + 13);

    c.textAlign = 'right';
    if (j.combo >= 2) {
      c.fillStyle = '#FFD978';
      c.font = '700 13px -apple-system, system-ui, sans-serif';
      c.fillText(((A.i18n && A.i18n.t('combo')) || 'COMBO') + ' ×' + j.combo, w - HUD_RIGHT, top + ph + 16);
    } else {
      c.fillStyle = 'rgba(243, 237, 226, 0.6)';
      c.font = '600 12px -apple-system, system-ui, sans-serif';
      c.fillText((j.accuracy() * 100).toFixed(1) + '%', w - HUD_RIGHT, top + ph + 16);
    }
  };

  Renderer.prototype.banner = function (c, text) {
    c.textAlign = 'center';
    c.font = '700 17px -apple-system, system-ui, sans-serif';
    c.lineWidth = 4;
    c.strokeStyle = 'rgba(10, 8, 14, 0.7)';
    c.strokeText(text, this.w / 2, this.stageY + 46);
    c.fillStyle = 'rgba(246, 231, 196, 0.95)';
    c.fillText(text, this.w / 2, this.stageY + 46);
  };

  function formatScore(n) {
    return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }

  Renderer.prototype._roundRect = function (c, x, y, w, h, r) {
    var rr = Math.max(0, Math.min(r, w / 2, h / 2));
    c.beginPath();
    c.moveTo(x + rr, y);
    c.arcTo(x + w, y, x + w, y + h, rr);
    c.arcTo(x + w, y + h, x, y + h, rr);
    c.arcTo(x, y + h, x, y, rr);
    c.arcTo(x, y, x + w, y, rr);
    c.closePath();
  };

  Renderer.APPROACH_MS = APPROACH_MS;
  Renderer.LANE = LANE;
  A.Renderer = Renderer;
})(window.Ardah);
