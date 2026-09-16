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
  var PERFORMERS = 8;       // four a side

  var LANE = [
    { gem: '#F2B33D', rim: '#8A5A12', glow: '#FFD978' },   // zeer  — amber
    { gem: '#2FB574', rim: '#0E5234', glow: '#7BF0B7' },   // tar   — emerald
    { gem: '#4C8FD6', rim: '#173C66', glow: '#9CCBFF' }    // clap  — sapphire
  ];
  var LANE_KEYS = ['A', 'S', 'D'];

  function Renderer(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d', { alpha: false });
    this.scene = new A.Scene();
    this.performers = [];
    for (var i = 0; i < PERFORMERS; i++) this.performers.push(0);
    this.drumPulse = [0, 0];
    this.drumCursor = 0;
    this.sparks = [];
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
    this.scene.draw(c, this.tMs, dtMs, this.performers, this.drumPulse);
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
      this.drumPulse[voice === 'zeer' ? 0 : 1] = 1;
      this.drumCursor++;
    }
  };

  /* -------------------------------- runway -------------------------------- */

  Renderer.prototype._runway = function (c, active) {
    var wTop = this.halfAt(Z_FAR), yTop = this.yAt(Z_FAR);
    var wBot = this.halfAt(Z_LIP), yBot = this.yAt(Z_LIP);
    var cx = this.w / 2;

    // Deck
    var deck = c.createLinearGradient(0, yTop, 0, yBot);
    deck.addColorStop(0, 'rgba(18, 26, 44, 0.35)');
    deck.addColorStop(0.55, 'rgba(24, 20, 30, 0.75)');
    deck.addColorStop(1, 'rgba(12, 10, 16, 0.92)');
    c.fillStyle = deck;
    c.beginPath();
    c.moveTo(cx - wTop, yTop); c.lineTo(cx + wTop, yTop);
    c.lineTo(cx + wBot, yBot); c.lineTo(cx - wBot, yBot);
    c.closePath();
    c.fill();

    // Lane flashes, in perspective
    for (var lane = 0; lane < 3; lane++) {
      if (this.flashes[lane] <= 0) continue;
      var yEnd = this.judgeY;
      var offTop = (this.halfNear * 2 / 3) / Z_FAR, offEnd = (this.halfNear * 2 / 3);
      var ctTop = cx + (lane - 1) * offTop, ctEnd = cx + (lane - 1) * offEnd;
      var g = c.createLinearGradient(0, yTop, 0, yEnd);
      g.addColorStop(0, 'rgba(0,0,0,0)');
      g.addColorStop(1, LANE[lane].glow);
      c.globalAlpha = this.flashes[lane] * 0.26;
      c.fillStyle = g;
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
    var g = c.createLinearGradient(0, yTop, 0, yBot);
    g.addColorStop(0, '#6B5220');
    g.addColorStop(0.4, '#C79A3E');
    g.addColorStop(0.75, '#F3D98A');
    g.addColorStop(1, '#A87C2C');
    c.fillStyle = g;
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
    var glow = c.createLinearGradient(0, y - 16, 0, y + 16);
    glow.addColorStop(0, 'rgba(255, 214, 130, 0)');
    glow.addColorStop(0.5, 'rgba(255, 214, 130, 0.35)');
    glow.addColorStop(1, 'rgba(255, 214, 130, 0)');
    c.fillStyle = glow;
    c.fillRect(cx - half, y - 16, half * 2, 32);

    var bar = c.createLinearGradient(cx - half, 0, cx + half, 0);
    bar.addColorStop(0, 'rgba(231, 180, 76, 0.35)');
    bar.addColorStop(0.5, '#FFE7AE');
    bar.addColorStop(1, 'rgba(231, 180, 76, 0.35)');
    c.fillStyle = bar;
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

  Renderer.prototype._gem = function (c, lane, z, isHold) {
    var x = this.xAt(lane, z), y = this.yAt(z), s = 1 / z;
    var w = this.halfNear * 0.40 * s, h = Math.max(5, 19 * s);
    var pal = LANE[lane];

    c.save();
    c.shadowColor = pal.glow;
    c.shadowBlur = 16 * s;

    var rim = c.createLinearGradient(0, y - h, 0, y + h);
    rim.addColorStop(0, '#F6DFA4');
    rim.addColorStop(0.5, pal.rim);
    rim.addColorStop(1, '#8A6A22');
    c.fillStyle = rim;
    this._roundRect(c, x - w, y - h, w * 2, h * 2, h * 0.55);
    c.fill();
    c.restore();

    var gem = c.createLinearGradient(0, y - h, 0, y + h);
    gem.addColorStop(0, pal.glow);
    gem.addColorStop(0.55, pal.gem);
    gem.addColorStop(1, pal.rim);
    c.fillStyle = gem;
    this._roundRect(c, x - w * 0.82, y - h * 0.62, w * 1.64, h * 1.24, h * 0.4);
    c.fill();

    c.fillStyle = 'rgba(255,255,255,0.45)';
    this._roundRect(c, x - w * 0.6, y - h * 0.46, w * 1.2, h * 0.3, h * 0.15);
    c.fill();

    if (isHold) {
      c.fillStyle = 'rgba(20, 14, 6, 0.45)';
      c.fillRect(x - w * 0.34, y - h * 0.1, w * 0.68, h * 0.2);
    }
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

      var g = c.createLinearGradient(0, y - h / 2, 0, y + h / 2);
      g.addColorStop(0, 'rgba(60, 48, 30, 0.95)');
      g.addColorStop(1, 'rgba(26, 20, 14, 0.95)');
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

      c.fillStyle = 'rgba(231, 180, 76, 0.75)';
      c.font = '600 10px -apple-system, system-ui, sans-serif';
      c.fillText(labels[lane], x, y + h / 2 + 13);
    }
  };

  /* -------------------------------- effects -------------------------------- */

  Renderer.prototype._effects = function (c, decay, dtMs) {
    var i;
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

    var scrim = c.createLinearGradient(0, 0, 0, 92);
    scrim.addColorStop(0, 'rgba(7, 11, 22, 0.75)');
    scrim.addColorStop(1, 'rgba(7, 11, 22, 0)');
    c.fillStyle = scrim;
    c.fillRect(0, 0, w, 92);

    // Crowd meter: the row's composure, framed like a stage gauge.
    var mw = Math.min(w * 0.52, 250), mx = 16, my = top + 6, mh = 14;
    c.fillStyle = 'rgba(10, 8, 14, 0.75)';
    this._roundRect(c, mx, my, mw, mh, mh / 2); c.fill();
    c.strokeStyle = 'rgba(231, 180, 76, 0.6)';
    c.lineWidth = 1.4;
    this._roundRect(c, mx, my, mw, mh, mh / 2); c.stroke();

    var pct = Math.max(0.02, j.sync / 100);
    var fill = c.createLinearGradient(mx, 0, mx + mw, 0);
    if (pct > 0.45) { fill.addColorStop(0, '#2FB574'); fill.addColorStop(1, '#8FE3C0'); }
    else if (pct > 0.2) { fill.addColorStop(0, '#C79A3E'); fill.addColorStop(1, '#FFD978'); }
    else { fill.addColorStop(0, '#8A2E22'); fill.addColorStop(1, '#E06B4E'); }
    c.fillStyle = fill;
    this._roundRect(c, mx + 2, my + 2, Math.max(6, (mw - 4) * pct), mh - 4, (mh - 4) / 2);
    c.fill();

    c.fillStyle = '#FFE7AE';
    c.beginPath(); c.arc(mx + 2 + (mw - 4) * pct, my + mh / 2, 3.5, 0, Math.PI * 2); c.fill();

    c.textAlign = 'left';
    c.fillStyle = 'rgba(231, 180, 76, 0.8)';
    c.font = '700 10px -apple-system, system-ui, sans-serif';
    c.fillText((A.i18n && A.i18n.t('crowd')) || 'CROWD', mx + 2, my + mh + 13);

    // Score plate
    c.textAlign = 'right';
    c.fillStyle = '#F6E7C4';
    c.font = '800 22px -apple-system, system-ui, sans-serif';
    c.fillText(formatScore(j.score), w - 16, top + 18);

    if (j.combo >= 2) {
      c.fillStyle = '#FFD978';
      c.font = '700 13px -apple-system, system-ui, sans-serif';
      c.fillText(((A.i18n && A.i18n.t('combo')) || 'COMBO') + ' ×' + j.combo, w - 16, top + 36);
    } else {
      c.fillStyle = 'rgba(243, 237, 226, 0.6)';
      c.font = '600 12px -apple-system, system-ui, sans-serif';
      c.fillText((j.accuracy() * 100).toFixed(1) + '%', w - 16, top + 36);
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
