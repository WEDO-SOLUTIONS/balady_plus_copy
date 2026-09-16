/* Canvas renderer.

   Everything is drawn, nothing is loaded: no sprites, no DOM nodes per note.
   That is the rule that keeps a rhythm game smooth inside a WebView, where the
   page is a composited platform view and every layout pass costs frames.

   The stage is deliberately LTR in both locales — a row of performers is a
   physical arrangement, not reading order. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var APPROACH_MS = 1500;      // how long a marker is on screen before its beat
  var LANE_COLORS = ['#E7B44C', '#6FD3A0', '#9BC4E2'];
  var LANE_KEYS = ['A', 'S', 'D'];
  var PERFORMERS = 7;

  function Renderer(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d', { alpha: false });
    this.w = 0; this.h = 0; this.dpr = 1;
    this.flashes = [0, 0, 0];
    this.raise = new Array(PERFORMERS);
    for (var i = 0; i < PERFORMERS; i++) this.raise[i] = 0;
    this.popup = null;
    this.stars = [];
    this.shake = 0;
    this.resize();
  }

  Renderer.prototype.resize = function () {
    // Cap the pixel ratio: a 3x buffer on a low-end phone costs more than it
    // shows, and this game lives or dies on frame pacing.
    this.dpr = Math.min(window.devicePixelRatio || 1, 2);
    this.w = window.innerWidth;
    this.h = window.innerHeight;
    this.canvas.width = Math.round(this.w * this.dpr);
    this.canvas.height = Math.round(this.h * this.dpr);
    this.canvas.style.width = this.w + 'px';
    this.canvas.style.height = this.h + 'px';
    this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);

    this.fieldW = Math.min(this.w * 0.92, 520);
    this.fieldX = (this.w - this.fieldW) / 2;
    this.laneW = this.fieldW / 3;
    this.judgeY = Math.round(this.h * 0.68);

    if (!this.stars.length) {
      for (var i = 0; i < 70; i++) {
        this.stars.push({ x: Math.random(), y: Math.random() * 0.55, r: Math.random() * 1.2 + 0.3, a: Math.random() * 0.5 + 0.2 });
      }
    }
  };

  Renderer.prototype.laneCenter = function (lane) {
    return this.fieldX + this.laneW * (lane + 0.5);
  };

  /** Feedback hook: a lane was hit, so flash it and raise a sword. */
  Renderer.prototype.hit = function (lane, judgment) {
    if (lane >= 0 && lane < 3) this.flashes[lane] = judgment === 'stray' ? 0.35 : 1;
    // A stray tap gets a faint lane flash and nothing else: no sword rises for
    // a beat that was not there.
    if (judgment === 'stray') return;
    var who = Math.floor(Math.random() * PERFORMERS);
    this.raise[who] = 1;
    if (judgment === 'perfect') {
      var other = (who + 3) % PERFORMERS;
      this.raise[other] = 1;
    }
    if (judgment === 'miss') this.shake = 1;
  };

  Renderer.prototype.say = function (text, tone) {
    this.popup = { text: text, tone: tone || '#E7B44C', life: 1 };
  };

  Renderer.prototype.flourishBurst = function () {
    for (var i = 0; i < PERFORMERS; i++) this.raise[i] = 1;
    this.flashes[0] = this.flashes[1] = this.flashes[2] = 1;
  };

  Renderer.prototype.draw = function (state, dtMs) {
    var c = this.ctx, w = this.w, h = this.h;
    var decay = Math.min(1, dtMs / 220);

    c.save();
    if (this.shake > 0.01) {
      c.translate((Math.random() - 0.5) * 6 * this.shake, (Math.random() - 0.5) * 6 * this.shake);
      this.shake -= decay;
    }

    this._sky(c, w, h);
    if (state.chart) {
      this._lanes(c, state);
      this._notes(c, state);
      this._judgeLine(c);
    }
    this._row(c, w, h, decay);
    if (state.chart) {
      this._hud(c, state);
      this._popup(c, decay);
    }

    for (var i = 0; i < 3; i++) this.flashes[i] = Math.max(0, this.flashes[i] - decay);
    c.restore();
  };

  /* ------------------------------ scenery ------------------------------ */

  Renderer.prototype._sky = function (c, w, h) {
    var g = c.createLinearGradient(0, 0, 0, h);
    g.addColorStop(0, '#0B1428');
    g.addColorStop(0.55, '#0A0F1E');
    g.addColorStop(1, '#070B16');
    c.fillStyle = g;
    c.fillRect(0, 0, w, h);

    c.fillStyle = '#FFFFFF';
    for (var i = 0; i < this.stars.length; i++) {
      var s = this.stars[i];
      c.globalAlpha = s.a;
      c.fillRect(s.x * w, s.y * h, s.r, s.r);
    }
    c.globalAlpha = 1;

    // Sand horizon behind the row.
    var horizon = this.judgeY + (this.h - this.judgeY) * 0.42;
    var sg = c.createLinearGradient(0, horizon - 40, 0, h);
    sg.addColorStop(0, 'rgba(217, 191, 154, 0.05)');
    sg.addColorStop(1, 'rgba(217, 191, 154, 0.13)');
    c.fillStyle = sg;
    c.beginPath();
    c.moveTo(0, horizon);
    c.quadraticCurveTo(w * 0.5, horizon - 26, w, horizon);
    c.lineTo(w, h); c.lineTo(0, h); c.closePath(); c.fill();
  };

  Renderer.prototype._lanes = function (c, state) {
    var x = this.fieldX, top = 0, bottom = this.judgeY + 26;
    for (var i = 0; i < 3; i++) {
      var lx = x + this.laneW * i;
      var g = c.createLinearGradient(0, top, 0, bottom);
      g.addColorStop(0, 'rgba(255,255,255,0.012)');
      g.addColorStop(1, 'rgba(255,255,255,0.05)');
      c.fillStyle = g;
      c.fillRect(lx, top, this.laneW, bottom - top);

      if (this.flashes[i] > 0) {
        c.globalAlpha = this.flashes[i] * 0.35;
        var fg = c.createLinearGradient(0, bottom - 220, 0, bottom);
        fg.addColorStop(0, 'rgba(0,0,0,0)');
        fg.addColorStop(1, LANE_COLORS[i]);
        c.fillStyle = fg;
        c.fillRect(lx, bottom - 220, this.laneW, 220);
        c.globalAlpha = 1;
      }

      c.strokeStyle = 'rgba(217, 191, 154, 0.12)';
      c.lineWidth = 1;
      c.beginPath(); c.moveTo(lx + 0.5, top); c.lineTo(lx + 0.5, bottom); c.stroke();
    }
    c.beginPath();
    c.moveTo(x + this.fieldW - 0.5, top); c.lineTo(x + this.fieldW - 0.5, bottom); c.stroke();

    // Key hints help when the game is being checked on a desktop browser.
    if (!state.touchUsed) {
      c.fillStyle = 'rgba(147, 160, 184, 0.45)';
      c.font = '600 12px ui-monospace, Menlo, monospace';
      c.textAlign = 'center';
      for (var k = 0; k < 3; k++) c.fillText(LANE_KEYS[k], this.laneCenter(k), this.judgeY + 46);
    }
  };

  Renderer.prototype._judgeLine = function (c) {
    var y = this.judgeY;
    c.strokeStyle = 'rgba(231, 180, 76, 0.75)';
    c.lineWidth = 2;
    c.beginPath(); c.moveTo(this.fieldX, y); c.lineTo(this.fieldX + this.fieldW, y); c.stroke();
    c.fillStyle = 'rgba(231, 180, 76, 0.16)';
    c.fillRect(this.fieldX, y - 3, this.fieldW, 6);
  };

  /* ------------------------------- notes ------------------------------- */

  Renderer.prototype._notes = function (c, state) {
    var now = state.visualTimeMs;
    var notes = state.judge.notes;
    var travel = this.judgeY + 40;

    for (var i = 0; i < notes.length; i++) {
      var n = notes[i];
      var lead = n.t - now;
      if (lead > APPROACH_MS) break;                       // sorted: rest are further out
      if (n.state === 'hit' || n.state === 'missed') continue;
      if (lead < -300 && n.state !== 'holding') continue;

      var progress = 1 - lead / APPROACH_MS;
      var y = -40 + travel * progress;

      if (n.type === 'flourish') { this._flourish(c, y, lead); continue; }

      var cx = this.laneCenter(n.lane);
      var color = LANE_COLORS[n.lane];

      if (n.type === 'hold') {
        var endLead = (n.t + n.durMs) - now;
        var endY = -40 + travel * (1 - endLead / APPROACH_MS);
        var topY = Math.min(y, endY), botY = Math.max(y, endY);
        if (n.state === 'holding') topY = Math.min(topY, this.judgeY);
        c.globalAlpha = n.state === 'holding' ? 0.85 : 0.45;
        c.fillStyle = color;
        this._roundRect(c, cx - this.laneW * 0.16, topY, this.laneW * 0.32, Math.max(8, botY - topY), 10);
        c.fill();
        c.globalAlpha = 1;
      }

      this._marker(c, cx, y, color, n.type === 'hold');
    }
  };

  Renderer.prototype._marker = function (c, cx, y, color, isHold) {
    var wHalf = this.laneW * 0.34, hHalf = 9;
    c.save();
    c.shadowColor = color;
    c.shadowBlur = 14;
    c.fillStyle = color;
    this._roundRect(c, cx - wHalf, y - hHalf, wHalf * 2, hHalf * 2, 7);
    c.fill();
    c.restore();
    if (isHold) {
      c.fillStyle = 'rgba(7, 11, 22, 0.55)';
      c.fillRect(cx - wHalf * 0.5, y - 2, wHalf, 4);
    }
  };

  Renderer.prototype._flourish = function (c, y, lead) {
    var x = this.fieldX, w = this.fieldW;
    var g = c.createLinearGradient(x, 0, x + w, 0);
    g.addColorStop(0, 'rgba(30, 138, 85, 0.85)');
    g.addColorStop(0.5, 'rgba(231, 180, 76, 0.95)');
    g.addColorStop(1, 'rgba(30, 138, 85, 0.85)');
    c.fillStyle = g;
    this._roundRect(c, x + 6, y - 11, w - 12, 22, 11);
    c.fill();

    c.fillStyle = 'rgba(7, 11, 22, 0.8)';
    c.font = '700 12px -apple-system, system-ui, sans-serif';
    c.textAlign = 'center';
    c.fillText('⟶', this.laneCenter(1), y + 4);
    if (lead < 500) {
      c.globalAlpha = 0.25 + 0.25 * Math.sin(lead / 40);
      c.fillStyle = '#E7B44C';
      this._roundRect(c, x + 6, y - 11, w - 12, 22, 11);
      c.fill();
      c.globalAlpha = 1;
    }
  };

  /* ---------------------------- the row itself ---------------------------- */

  Renderer.prototype._row = function (c, w, h, decay) {
    var baseY = this.h - Math.max(28, this.h * 0.06);
    // Inset so the outer figures are never clipped by the screen edge.
    var count = w < 340 ? 5 : PERFORMERS;
    var span = Math.min(w - 64, 560);
    var startX = (w - span) / 2;
    var step = span / (count - 1);
    var scale = Math.min(1, this.h / 780);
    var bodyH = 86 * scale;

    for (var i = 0; i < count; i++) {
      var x = startX + step * i;
      var lift = this.raise[i];
      this.raise[i] = Math.max(0, lift - decay * 0.7);
      this._performer(c, x, baseY, bodyH, lift, i);
    }
  };

  /* One figure: a thobe silhouette with a raised sword arm. Stylised on
     purpose — dignified posture, no caricature. Real artwork replaces this,
     and goes through cultural review first. */
  Renderer.prototype._performer = function (c, x, baseY, bodyH, lift, idx) {
    var headR = bodyH * 0.13;
    var shoulderY = baseY - bodyH * 0.72;
    var hipY = baseY;

    c.fillStyle = 'rgba(12, 18, 33, 0.95)';
    c.strokeStyle = 'rgba(217, 191, 154, 0.35)';
    c.lineWidth = 1.5;

    // Thobe
    c.beginPath();
    c.moveTo(x - bodyH * 0.13, shoulderY);
    c.lineTo(x + bodyH * 0.13, shoulderY);
    c.lineTo(x + bodyH * 0.2, hipY);
    c.lineTo(x - bodyH * 0.2, hipY);
    c.closePath();
    c.fill(); c.stroke();

    // Head and headcloth
    c.beginPath();
    c.arc(x, shoulderY - headR * 1.25, headR, 0, Math.PI * 2);
    c.fill(); c.stroke();
    c.beginPath();
    c.moveTo(x - headR * 1.15, shoulderY - headR * 1.35);
    c.quadraticCurveTo(x, shoulderY - headR * 2.6, x + headR * 1.15, shoulderY - headR * 1.35);
    c.stroke();

    // Sword arm: rests lowered at the side, lifts to the ceremonial vertical
    // on a hit. The shoulder is offset from the body centre so a raised blade
    // passes beside the head rather than through it.
    var angle = (0.2 - lift * 0.7) * Math.PI;
    var armLen = bodyH * 0.34;
    var sx = x + bodyH * 0.15, sy = shoulderY + bodyH * 0.05;
    var hx = sx + Math.cos(angle) * armLen * 0.55;
    var hy = sy + Math.sin(angle) * armLen * 0.55;

    c.beginPath();
    c.moveTo(sx, sy); c.lineTo(hx, hy);
    c.strokeStyle = 'rgba(217, 191, 154, ' + (0.4 + lift * 0.5) + ')';
    c.lineWidth = 2.4;
    c.stroke();

    var bladeLen = bodyH * 0.42;
    var tipX = hx + Math.cos(angle) * bladeLen;
    var tipY = hy + Math.sin(angle) * bladeLen;
    c.beginPath();
    c.moveTo(hx, hy); c.lineTo(tipX, tipY);
    c.strokeStyle = 'rgba(243, 237, 226, ' + (0.4 + lift * 0.6) + ')';
    c.lineWidth = 2.6;
    c.stroke();
    if (lift > 0.05) {
      c.globalAlpha = lift * 0.55;
      c.strokeStyle = '#E7B44C';
      c.lineWidth = 5;
      c.stroke();
      c.globalAlpha = 1;
    }
  };

  /* -------------------------------- HUD -------------------------------- */

  Renderer.prototype._hud = function (c, state) {
    var j = state.judge, w = this.w;
    var top = 14 + (state.safeTop || 0);

    // Sync meter — the row's composure, not the player's health.
    var mw = Math.min(w * 0.7, 380), mx = (w - mw) / 2, my = top + 26;
    c.fillStyle = 'rgba(255,255,255,0.08)';
    this._roundRect(c, mx, my, mw, 8, 4); c.fill();
    var pct = j ? j.sync / 100 : 0.7;
    c.fillStyle = pct > 0.5 ? '#2BA06A' : (pct > 0.25 ? '#E7B44C' : '#C8553D');
    this._roundRect(c, mx, my, Math.max(4, mw * pct), 8, 4); c.fill();

    if (!j) { return; }

    c.fillStyle = '#F3EDE2';
    c.font = '700 20px -apple-system, system-ui, sans-serif';
    c.textAlign = 'left';
    c.fillText(String(j.score), 18, top + 16);

    c.textAlign = 'right';
    c.fillStyle = 'rgba(243, 237, 226, 0.75)';
    c.font = '600 14px -apple-system, system-ui, sans-serif';
    c.fillText((j.accuracy() * 100).toFixed(1) + '%', w - 18, top + 15);

    if (j.combo >= 3) {
      c.textAlign = 'center';
      c.fillStyle = '#E7B44C';
      c.font = '800 34px -apple-system, system-ui, sans-serif';
      c.fillText(j.combo + '', w / 2, my + 52);
      c.font = '600 11px -apple-system, system-ui, sans-serif';
      c.fillStyle = 'rgba(231, 180, 76, 0.7)';
      c.fillText('×' + j.multiplier(), w / 2, my + 68);
    }
  };

  Renderer.prototype._popup = function (c, decay) {
    if (!this.popup) return;
    var p = this.popup;
    c.globalAlpha = Math.max(0, p.life);
    c.textAlign = 'center';
    c.fillStyle = p.tone;
    c.font = '700 22px -apple-system, system-ui, sans-serif';
    c.fillText(p.text, this.w / 2, this.judgeY - 46 - (1 - p.life) * 18);
    c.globalAlpha = 1;
    p.life -= decay * 0.9;
    if (p.life <= 0) this.popup = null;
  };

  Renderer.prototype.banner = function (c, text) {
    c.textAlign = 'center';
    c.fillStyle = 'rgba(243, 237, 226, 0.85)';
    c.font = '600 18px -apple-system, system-ui, sans-serif';
    c.fillText(text, this.w / 2, this.h * 0.3);
  };

  Renderer.prototype._roundRect = function (c, x, y, w, h, r) {
    var rr = Math.min(r, w / 2, h / 2);
    c.beginPath();
    c.moveTo(x + rr, y);
    c.arcTo(x + w, y, x + w, y + h, rr);
    c.arcTo(x + w, y + h, x, y + h, rr);
    c.arcTo(x, y + h, x, y, rr);
    c.arcTo(x, y, x + w, y, rr);
    c.closePath();
  };

  Renderer.APPROACH_MS = APPROACH_MS;
  Renderer.LANE_COLORS = LANE_COLORS;
  A.Renderer = Renderer;
})(window.Ardah);
