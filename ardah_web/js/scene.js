/* The stage: everything above the note runway.

   Two layers, and the split is a performance decision, not a stylistic one.
   The backdrop — sky, moon, fort, palms, banners, the tiled plaza — never
   changes between frames, so it is painted ONCE into an offscreen canvas on
   resize and blitted afterwards. Only what moves is redrawn: the braziers, the
   two rows of performers, the musicians. That is what keeps a scene this busy
   at 60 fps inside a WebView, where the page is a composited platform view.

   Everything is drawn with paths and gradients. No images, no sprite sheets.

   On the art itself: this is a stylised placeholder following the concept
   art's composition. Dignified posture, no caricature, sabres held
   ceremonially. Real artwork is commissioned and goes through cultural review
   before anything ships (concept doc §11). */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var GREEN = '#0E6B3C';
  var GOLD = '#E7B44C';

  function Scene() {
    this.backdrop = null;
    this.w = 0; this.h = 0;
    this.horizonY = 0;
    this.stageY = 0;
    this.embers = [];
    this.braziers = [];
  }

  /* ---------------------------- static backdrop ---------------------------- */

  Scene.prototype.build = function (w, h, dpr, stageY) {
    this.w = w; this.h = h;
    this.stageY = stageY;
    this.horizonY = stageY * 0.60;

    var cv = document.createElement('canvas');
    cv.width = Math.round(w * dpr);
    cv.height = Math.round(h * dpr);
    var c = cv.getContext('2d');
    c.setTransform(dpr, 0, 0, dpr, 0, 0);

    this._sky(c, w, h);
    this._fort(c, w);
    this._palms(c, w);
    this._plaza(c, w);
    this._banners(c, w);
    this.backdrop = cv;

    var floor = this.horizonY + 44;
    this.braziers = [
      { x: w * 0.055, y: floor + 16, r: 15 },
      { x: w * 0.205, y: floor + 2, r: 12 },
      { x: w * 0.795, y: floor + 2, r: 12 },
      { x: w * 0.945, y: floor + 16, r: 15 }
    ];
    this.embers.length = 0;
  };

  /** The night gradient, shared so the moon can carve its crescent out of an
      exact copy of the sky behind it. */
  Scene.prototype._skyGradient = function (c) {
    var g = c.createLinearGradient(0, 0, 0, this.stageY);
    g.addColorStop(0, '#081226');
    g.addColorStop(0.42, '#102B4E');
    g.addColorStop(0.78, '#2B3354');
    g.addColorStop(1, '#4A3A44');
    return g;
  };

  Scene.prototype._sky = function (c, w, h) {
    var g = this._skyGradient(c);
    c.fillStyle = g;
    c.fillRect(0, 0, w, this.stageY + 2);

    c.fillStyle = '#FFFFFF';
    for (var i = 0; i < 110; i++) {
      var x = Math.random() * w, y = Math.random() * this.horizonY * 0.95;
      c.globalAlpha = Math.random() * 0.55 + 0.12;
      var r = Math.random() * 1.4 + 0.3;
      c.fillRect(x, y, r, r);
    }
    c.globalAlpha = 1;

    var haze = c.createRadialGradient(w / 2, this.horizonY + 40, 10, w / 2, this.horizonY + 40, w * 0.8);
    haze.addColorStop(0, 'rgba(236, 156, 62, 0.22)');
    haze.addColorStop(1, 'rgba(236, 156, 62, 0)');
    c.fillStyle = haze;
    c.fillRect(0, 0, w, this.stageY);

    // After the haze: it would otherwise tint the moon orange.
    this._moon(c, w * 0.74, this.horizonY * 0.52, Math.max(14, w * 0.045));
  };

  /* Crescent: a lit disc with a bite taken out of it. The bite is painted in
     the sky's own gradient rather than erased — erasing would punch a hole
     through the backdrop and show the canvas base colour instead of the sky. */
  Scene.prototype._moon = function (c, x, y, r) {
    var glow = c.createRadialGradient(x, y, r * 0.2, x, y, r * 3.2);
    glow.addColorStop(0, 'rgba(255, 244, 214, 0.32)');
    glow.addColorStop(1, 'rgba(255, 244, 214, 0)');
    c.fillStyle = glow;
    c.beginPath(); c.arc(x, y, r * 3.2, 0, Math.PI * 2); c.fill();

    c.fillStyle = '#FFF6DC';
    c.beginPath(); c.arc(x, y, r, 0, Math.PI * 2); c.fill();

    c.save();
    c.beginPath(); c.arc(x, y, r, 0, Math.PI * 2); c.clip();
    c.fillStyle = this._skyGradient(c);
    c.beginPath(); c.arc(x - r * 0.46, y - r * 0.3, r * 0.94, 0, Math.PI * 2); c.fill();
    c.restore();
  };

  /* Diriyah-style mud-brick fort: crenellated towers, arched windows, a lit
     gate and a low flight of steps down to the plaza. */
  Scene.prototype._fort = function (c, w) {
    var baseY = this.horizonY + 44;
    var wallTop = this.horizonY - 40;
    var wall = c.createLinearGradient(0, wallTop - 30, 0, baseY);
    wall.addColorStop(0, '#9A6E45');
    wall.addColorStop(0.5, '#7A5433');
    wall.addColorStop(1, '#4A3220');

    c.fillStyle = wall;
    c.fillRect(w * 0.06, wallTop + 22, w * 0.88, baseY - wallTop - 22);
    this._merlons(c, w * 0.06, wallTop + 22, w * 0.88, 11, 8);

    var towers = [
      { x: w * 0.09, w: w * 0.15, top: wallTop - 6 },
      { x: w * 0.39, w: w * 0.22, top: wallTop - 34 },
      { x: w * 0.76, w: w * 0.15, top: wallTop - 6 }
    ];
    for (var i = 0; i < towers.length; i++) {
      var t = towers[i];
      c.fillStyle = wall;
      c.fillRect(t.x, t.top, t.w, baseY - t.top);
      this._merlons(c, t.x, t.top, t.w, 12, 9);
      this._archWindows(c, t.x, t.top + 24, t.w, i === 1 ? 3 : 2, i === 1 ? 2 : 2);
    }

    // Gate: a tall arch with light spilling out of it.
    var gx = w * 0.455, gw = w * 0.09, gTop = baseY - 56;
    var glow = c.createLinearGradient(0, gTop, 0, baseY);
    glow.addColorStop(0, '#FFD98A');
    glow.addColorStop(0.55, '#E79A3C');
    glow.addColorStop(1, '#8A4A1E');
    c.fillStyle = glow;
    c.beginPath();
    c.moveTo(gx, baseY);
    c.lineTo(gx, gTop + 16);
    c.quadraticCurveTo(gx + gw / 2, gTop - 12, gx + gw, gTop + 16);
    c.lineTo(gx + gw, baseY);
    c.closePath();
    c.fill();

    var spill = c.createRadialGradient(gx + gw / 2, baseY, 4, gx + gw / 2, baseY, w * 0.26);
    spill.addColorStop(0, 'rgba(255, 196, 110, 0.4)');
    spill.addColorStop(1, 'rgba(255, 196, 110, 0)');
    c.fillStyle = spill;
    c.fillRect(gx - w * 0.26, baseY - 40, w * 0.52 + gw, 80);

    // Steps
    for (var s = 0; s < 3; s++) {
      c.fillStyle = s % 2 ? 'rgba(150, 116, 78, 0.95)' : 'rgba(126, 96, 64, 0.95)';
      var sw = w * (0.30 + s * 0.05), sx = w / 2 - sw / 2;
      c.fillRect(sx, baseY + s * 7, sw, 7);
    }
  };

  Scene.prototype._merlons = function (c, x, y, width, step, mh) {
    var mw = step * 0.62;
    c.fillStyle = '#6A4A2E';
    for (var mx = x + 2; mx < x + width - mw; mx += step) {
      c.fillRect(mx, y - mh, mw, mh);
    }
  };

  Scene.prototype._archWindows = function (c, x, top, width, cols, rows) {
    for (var r = 0; r < rows; r++) {
      for (var k = 0; k < cols; k++) {
        var wx = x + width * ((k + 0.5) / cols);
        var wy = top + r * 26;
        var ww = 6, hh = 13;

        var glow = c.createRadialGradient(wx, wy + hh / 2, 1, wx, wy + hh / 2, 18);
        glow.addColorStop(0, 'rgba(255, 190, 90, 0.7)');
        glow.addColorStop(1, 'rgba(255, 190, 90, 0)');
        c.fillStyle = glow;
        c.fillRect(wx - 18, wy - 12, 36, 38);

        c.fillStyle = '#FFCE85';
        c.beginPath();
        c.moveTo(wx - ww / 2, wy + hh);
        c.lineTo(wx - ww / 2, wy + 4);
        c.quadraticCurveTo(wx, wy - 5, wx + ww / 2, wy + 4);
        c.lineTo(wx + ww / 2, wy + hh);
        c.closePath();
        c.fill();
      }
    }
  };

  /* Palms framing both edges, drawn small-to-large for depth. */
  Scene.prototype._palms = function (c, w) {
    var base = this.horizonY + 40;
    var set = [
      { x: w * 0.03, h: 128, s: 1.0 }, { x: w * 0.13, h: 96, s: 0.8 },
      { x: w * 0.30, h: 74, s: 0.62 }, { x: w * 0.70, h: 74, s: 0.62 },
      { x: w * 0.87, h: 96, s: 0.8 }, { x: w * 0.97, h: 128, s: 1.0 }
    ];
    for (var i = 0; i < set.length; i++) this._palm(c, set[i].x, base, set[i].h, set[i].s);
  };

  Scene.prototype._palm = function (c, x, baseY, height, s) {
    var topY = baseY - height;
    c.strokeStyle = 'rgba(48, 34, 22, 0.92)';
    c.lineWidth = 5 * s;
    c.lineCap = 'round';
    c.beginPath();
    c.moveTo(x, baseY);
    c.quadraticCurveTo(x - 8 * s, baseY - height * 0.55, x, topY);
    c.stroke();

    c.strokeStyle = 'rgba(26, 58, 36, 0.95)';
    c.lineWidth = 3.4 * s;
    for (var i = 0; i < 7; i++) {
      var a = -Math.PI * 0.92 + (i / 6) * Math.PI * 0.84;
      var len = (26 + Math.random() * 10) * s + height * 0.16;
      c.beginPath();
      c.moveTo(x, topY);
      c.quadraticCurveTo(
        x + Math.cos(a) * len * 0.6, topY + Math.sin(a) * len * 0.6 - 6 * s,
        x + Math.cos(a) * len, topY + Math.sin(a) * len + 10 * s
      );
      c.stroke();
    }
  };

  /* Green banners on gilded poles, with the palm-and-swords emblem. */
  Scene.prototype._banners = function (c, w) {
    var tops = this.horizonY - 62;
    var set = [
      { x: w * 0.085, s: 1 }, { x: w * 0.235, s: 0.84 },
      { x: w * 0.765, s: 0.84 }, { x: w * 0.915, s: 1 }
    ];
    for (var i = 0; i < set.length; i++) {
      var b = set[i], bw = 26 * b.s, bh = 84 * b.s;
      var px = b.x, py = tops + (1 - b.s) * 26;

      c.strokeStyle = '#C79A3E';                       // pole
      c.lineWidth = 3 * b.s;
      c.beginPath(); c.moveTo(px, py - 12); c.lineTo(px, py + bh + 28); c.stroke();
      c.fillStyle = GOLD;                              // finial
      c.beginPath(); c.arc(px, py - 14, 3.4 * b.s, 0, Math.PI * 2); c.fill();

      var g = c.createLinearGradient(px - bw / 2, 0, px + bw / 2, 0);
      g.addColorStop(0, '#0B5730');
      g.addColorStop(0.5, GREEN);
      g.addColorStop(1, '#083F24');
      c.fillStyle = g;
      c.beginPath();
      c.moveTo(px - bw / 2, py);
      c.lineTo(px + bw / 2, py);
      c.lineTo(px + bw / 2, py + bh);
      c.quadraticCurveTo(px, py + bh - 10 * b.s, px - bw / 2, py + bh);
      c.closePath();
      c.fill();

      this._emblem(c, px, py + bh * 0.42, 9 * b.s);

      c.strokeStyle = 'rgba(231, 180, 76, 0.75)';      // fringe
      c.lineWidth = 1.2;
      c.beginPath();
      c.moveTo(px - bw / 2, py + 3); c.lineTo(px + bw / 2, py + 3);
      c.stroke();
    }
  };

  /* Two crossed sabres under a palm — drawn, never a national emblem copy. */
  Scene.prototype._emblem = function (c, x, y, r) {
    c.strokeStyle = 'rgba(246, 226, 166, 0.9)';
    c.lineWidth = Math.max(1.1, r * 0.13);
    c.lineCap = 'round';
    c.beginPath();
    c.moveTo(x - r, y + r * 0.5); c.quadraticCurveTo(x, y + r * 1.15, x + r, y + r * 0.5);
    c.stroke();
    c.beginPath();
    c.moveTo(x - r * 0.95, y + r * 0.75); c.quadraticCurveTo(x, y + r * 0.2, x + r * 0.95, y + r * 0.75);
    c.stroke();

    c.strokeStyle = 'rgba(246, 226, 166, 0.85)';       // palm above them
    c.lineWidth = Math.max(1, r * 0.1);
    c.beginPath(); c.moveTo(x, y + r * 0.35); c.lineTo(x, y - r * 0.55); c.stroke();
    for (var i = 0; i < 5; i++) {
      var a = -Math.PI * 0.85 + (i / 4) * Math.PI * 0.7;
      c.beginPath();
      c.moveTo(x, y - r * 0.55);
      c.quadraticCurveTo(x + Math.cos(a) * r * 0.5, y - r * 0.55 + Math.sin(a) * r * 0.5,
                         x + Math.cos(a) * r * 0.78, y - r * 0.35 + Math.sin(a) * r * 0.78);
      c.stroke();
    }
  };

  /* Polished tiles in perspective, catching the firelight. */
  Scene.prototype._plaza = function (c, w) {
    var top = this.horizonY + 44;
    var g = c.createLinearGradient(0, top, 0, this.h);
    g.addColorStop(0, '#6A4A30');
    g.addColorStop(0.3, '#4E3524');
    g.addColorStop(1, '#1A120E');
    c.fillStyle = g;
    c.fillRect(0, top, w, this.h - top);

    // Tile grid: lines converge on the centre, rows compress toward the back.
    c.save();
    c.beginPath(); c.rect(0, top, w, this.stageY - top + 40); c.clip();
    c.strokeStyle = 'rgba(255, 214, 150, 0.10)';
    c.lineWidth = 1;
    var vpX = w / 2, vpY = top - 10;
    for (var i = -8; i <= 8; i++) {
      c.beginPath();
      c.moveTo(vpX + i * (w * 0.045), top);
      c.lineTo(vpX + i * (w * 0.30), this.stageY + 60);
      c.stroke();
    }
    for (var rIdx = 1; rIdx <= 7; rIdx++) {
      var z = 1 + rIdx * 0.55;
      var y = vpY + (this.stageY + 40 - vpY) / z;
      c.beginPath(); c.moveTo(0, y); c.lineTo(w, y); c.stroke();
    }
    c.restore();

    var pool = c.createRadialGradient(w / 2, this.stageY - 6, 12, w / 2, this.stageY - 6, w * 0.7);
    pool.addColorStop(0, 'rgba(255, 176, 88, 0.26)');
    pool.addColorStop(1, 'rgba(255, 176, 88, 0)');
    c.fillStyle = pool;
    c.fillRect(0, top, w, this.h - top);
  };

  /* ----------------------------- dynamic pass ----------------------------- */

  Scene.prototype.draw = function (c, tMs, dtMs, performers, drumPulse) {
    if (this.backdrop) c.drawImage(this.backdrop, 0, 0, this.w, this.h);
    this._braziers(c, tMs, dtMs);
    this._carpet(c);
    this._musicians(c, drumPulse);
    this._rows(c, performers);
  };

  Scene.prototype._braziers = function (c, tMs, dtMs) {
    for (var i = 0; i < this.braziers.length; i++) {
      var f = this.braziers[i];
      var flick = 0.82 + 0.18 * Math.sin(tMs / 90 + i * 2.1) + 0.08 * Math.sin(tMs / 37 + i);
      var r = f.r * flick;

      var glow = c.createRadialGradient(f.x, f.y - r * 0.4, 2, f.x, f.y, r * 5);
      glow.addColorStop(0, 'rgba(255, 200, 120, 0.5)');
      glow.addColorStop(0.35, 'rgba(240, 130, 45, 0.2)');
      glow.addColorStop(1, 'rgba(240, 130, 45, 0)');
      c.fillStyle = glow;
      c.beginPath(); c.arc(f.x, f.y, r * 5, 0, Math.PI * 2); c.fill();

      // Bowl on a stand
      c.fillStyle = '#4A3520';
      c.fillRect(f.x - 2.5, f.y + 4, 5, 26);
      c.fillRect(f.x - 9, f.y + 30, 18, 4);
      var bowl = c.createLinearGradient(0, f.y - 2, 0, f.y + 8);
      bowl.addColorStop(0, '#C79A3E');
      bowl.addColorStop(1, '#5E441C');
      c.fillStyle = bowl;
      c.beginPath();
      c.moveTo(f.x - r * 0.95, f.y - 2);
      c.lineTo(f.x + r * 0.95, f.y - 2);
      c.lineTo(f.x + r * 0.55, f.y + 9);
      c.lineTo(f.x - r * 0.55, f.y + 9);
      c.closePath(); c.fill();

      var flame = c.createLinearGradient(0, f.y - r * 1.9, 0, f.y + 2);
      flame.addColorStop(0, 'rgba(255, 240, 190, 0.95)');
      flame.addColorStop(0.45, '#F8A93F');
      flame.addColorStop(1, 'rgba(198, 74, 26, 0.85)');
      c.fillStyle = flame;
      c.beginPath();
      c.moveTo(f.x - r * 0.6, f.y);
      c.quadraticCurveTo(f.x - r * 0.7, f.y - r, f.x, f.y - r * 1.9 * flick);
      c.quadraticCurveTo(f.x + r * 0.7, f.y - r, f.x + r * 0.6, f.y);
      c.closePath(); c.fill();

      if (Math.random() < dtMs / 240) {
        this.embers.push({ x: f.x + (Math.random() - 0.5) * r, y: f.y - r, vy: -0.02 - Math.random() * 0.03, life: 1 });
      }
    }

    for (var e = this.embers.length - 1; e >= 0; e--) {
      var em = this.embers[e];
      em.y += em.vy * dtMs;
      em.x += Math.sin(em.y / 14) * 0.25;
      em.life -= dtMs / 2200;
      if (em.life <= 0) { this.embers.splice(e, 1); continue; }
      c.globalAlpha = em.life * 0.85;
      c.fillStyle = '#FFC46E';
      c.fillRect(em.x, em.y, 2, 2);
    }
    c.globalAlpha = 1;
  };

  Scene.prototype._carpet = function (c) {
    var w = this.w, cx = w / 2, y = this.stageY - 18;
    var halfNear = w * 0.24, halfFar = w * 0.17, depth = 34;

    c.fillStyle = '#8E2F2B';
    c.beginPath();
    c.moveTo(cx - halfFar, y - depth); c.lineTo(cx + halfFar, y - depth);
    c.lineTo(cx + halfNear, y); c.lineTo(cx - halfNear, y);
    c.closePath(); c.fill();

    c.strokeStyle = 'rgba(231, 180, 76, 0.8)';
    c.lineWidth = 1.6; c.stroke();

    c.beginPath();
    c.moveTo(cx - halfFar * 0.78, y - depth * 0.7); c.lineTo(cx + halfFar * 0.78, y - depth * 0.7);
    c.lineTo(cx + halfNear * 0.82, y - 5); c.lineTo(cx - halfNear * 0.82, y - 5);
    c.closePath();
    c.strokeStyle = 'rgba(231, 180, 76, 0.4)';
    c.lineWidth = 1.2; c.stroke();

    c.fillStyle = 'rgba(231, 180, 76, 0.35)';          // medallions
    for (var i = -1; i <= 1; i++) {
      c.beginPath();
      c.ellipse(cx + i * halfNear * 0.42, y - depth * 0.42, 7, 4.5, 0, 0, Math.PI * 2);
      c.fill();
    }
  };

  /* One tabl player and one oud player, seated on stools. */
  Scene.prototype._musicians = function (c, pulse) {
    var cx = this.w / 2, baseY = this.stageY - 30;
    var s = Math.min(1, this.w / 420);
    this._tablPlayer(c, cx - 34 * s, baseY, s, pulse[0] || 0);
    this._oudPlayer(c, cx + 34 * s, baseY, s, pulse[1] || 0);
  };

  Scene.prototype._stool = function (c, x, y, s) {
    var g = c.createLinearGradient(0, y - 12 * s, 0, y);
    g.addColorStop(0, '#B98A4A');
    g.addColorStop(1, '#6A4522');
    c.fillStyle = g;
    c.fillRect(x - 11 * s, y - 12 * s, 22 * s, 12 * s);
    c.fillStyle = 'rgba(231, 180, 76, 0.45)';
    c.fillRect(x - 11 * s, y - 12 * s, 22 * s, 2 * s);
  };

  Scene.prototype._seated = function (c, x, baseY, s, lift) {
    var y = baseY - lift * 2 * s, bodyH = 30 * s, headR = 7 * s;
    c.fillStyle = 'rgba(0,0,0,0.32)';
    c.beginPath(); c.ellipse(x, baseY + 3, 15 * s, 4 * s, 0, 0, Math.PI * 2); c.fill();

    var g = c.createLinearGradient(0, y - bodyH, 0, y);
    g.addColorStop(0, '#F7F3EA');
    g.addColorStop(1, '#BCAF9A');
    c.fillStyle = g;
    c.beginPath();
    c.moveTo(x - 9 * s, y - bodyH);
    c.lineTo(x + 9 * s, y - bodyH);
    c.lineTo(x + 13 * s, y);
    c.lineTo(x - 13 * s, y);
    c.closePath(); c.fill();

    this._head(c, x, y - bodyH - headR * 0.55, headR);
    return { y: y, bodyH: bodyH };
  };

  Scene.prototype._tablPlayer = function (c, x, baseY, s, pulse) {
    this._stool(c, x, baseY, s);
    var b = this._seated(c, x, baseY, s, pulse);

    // The drum sits across the lap, head turned toward the player.
    var dx = x + 10 * s, dy = b.y - 13 * s, rw = 15 * s, rh = 11 * s;
    var shell = c.createLinearGradient(dx - rw, 0, dx + rw, 0);
    shell.addColorStop(0, '#7E4A1E');
    shell.addColorStop(0.5, '#C9924A');
    shell.addColorStop(1, '#6A3C16');
    c.fillStyle = shell;
    c.beginPath(); c.ellipse(dx, dy, rw, rh, -0.28, 0, Math.PI * 2); c.fill();
    c.fillStyle = 'rgba(247, 243, 234, ' + (0.8 + pulse * 0.2) + ')';
    c.beginPath(); c.ellipse(dx - 2 * s, dy - 1 * s, rw * 0.66, rh * 0.68, -0.28, 0, Math.PI * 2); c.fill();
    c.strokeStyle = 'rgba(90, 58, 24, 0.7)';
    c.lineWidth = 1.2 * s;
    c.stroke();

    // Striking arm, following the pulse.
    c.strokeStyle = 'rgba(236, 228, 214, 0.95)';
    c.lineWidth = 3.4 * s; c.lineCap = 'round';
    c.beginPath();
    c.moveTo(x + 7 * s, b.y - b.bodyH + 6 * s);
    c.lineTo(dx + 3 * s, dy - (10 + pulse * 10) * s);
    c.stroke();
  };

  Scene.prototype._oudPlayer = function (c, x, baseY, s, pulse) {
    this._stool(c, x, baseY, s);
    var b = this._seated(c, x, baseY, s, pulse * 0.6);

    var bx = x - 8 * s, by = b.y - 13 * s;
    var body = c.createLinearGradient(bx - 11 * s, 0, bx + 11 * s, 0);
    body.addColorStop(0, '#6A3C16');
    body.addColorStop(0.5, '#C08A4A');
    body.addColorStop(1, '#5A3212');
    c.fillStyle = body;
    c.beginPath(); c.ellipse(bx, by, 14 * s, 11 * s, 0.2, 0, Math.PI * 2); c.fill();

    c.fillStyle = 'rgba(40, 24, 10, 0.75)';            // rosette
    c.beginPath(); c.arc(bx + 1 * s, by - 1 * s, 2.6 * s, 0, Math.PI * 2); c.fill();

    c.strokeStyle = '#4A2C12';                          // neck
    c.lineWidth = 3 * s;
    c.beginPath(); c.moveTo(bx + 10 * s, by - 6 * s); c.lineTo(bx + 34 * s, by - 22 * s); c.stroke();

    c.strokeStyle = 'rgba(236, 228, 214, 0.9)';         // plucking arm
    c.lineWidth = 3.2 * s;
    c.beginPath();
    c.moveTo(x + 6 * s, b.y - b.bodyH + 7 * s);
    c.lineTo(bx + 5 * s, by + (2 + pulse * 3) * s);
    c.stroke();
  };

  /* Five a side, receding from the camera, sabres up. */
  Scene.prototype._rows = function (c, performers) {
    var w = this.w, baseY = this.stageY - 2;
    var s = Math.min(1, w / 420);
    var count = performers.length / 2;

    for (var i = 0; i < count; i++) {
      var depth = i / Math.max(1, count - 1);          // 0 = far, 1 = near
      var scale = (0.7 + depth * 0.42) * s;
      var y = baseY - (1 - depth) * 34 * s;
      var spread = w * 0.15 + depth * w * 0.29;
      this._performer(c, w * 0.5 - spread, y, scale, performers[i], 1);
      this._performer(c, w * 0.5 + spread, y, scale, performers[count + i], -1);
    }
  };

  /* One performer, facing the centre. `lift` 0..1 goes from the ceremonial
     ready position to the full raise. */
  Scene.prototype._performer = function (c, x, baseY, s, lift, face) {
    var bodyH = 78 * s, headR = 9 * s;
    var shoulderY = baseY - bodyH * 0.74;

    c.save();
    c.translate(x, 0);
    c.scale(face, 1);

    c.fillStyle = 'rgba(0, 0, 0, 0.35)';
    c.beginPath(); c.ellipse(0, baseY + 2, 16 * s, 4.5 * s, 0, 0, Math.PI * 2); c.fill();

    var g = c.createLinearGradient(0, shoulderY, 0, baseY);
    g.addColorStop(0, '#FFFCF4');
    g.addColorStop(0.5, '#EDE6D8');
    g.addColorStop(1, '#B49B7E');
    c.fillStyle = g;
    c.beginPath();
    c.moveTo(-9 * s, shoulderY);
    c.quadraticCurveTo(-12 * s, shoulderY + bodyH * 0.45, -16 * s, baseY);
    c.lineTo(16 * s, baseY);
    c.quadraticCurveTo(12 * s, shoulderY + bodyH * 0.45, 9 * s, shoulderY);
    c.closePath();
    c.fill();

    c.fillStyle = 'rgba(20, 16, 12, 0.9)';              // shoes
    c.beginPath(); c.ellipse(-6 * s, baseY, 5 * s, 2.4 * s, 0, 0, Math.PI * 2); c.fill();
    c.beginPath(); c.ellipse(6 * s, baseY, 5 * s, 2.4 * s, 0, 0, Math.PI * 2); c.fill();

    c.strokeStyle = 'rgba(58, 38, 22, 0.9)';            // crossed bandolier
    c.lineWidth = 3 * s;
    c.beginPath();
    c.moveTo(-8.5 * s, shoulderY + 2 * s); c.lineTo(8 * s, shoulderY + bodyH * 0.36);
    c.moveTo(8.5 * s, shoulderY + 2 * s); c.lineTo(-8 * s, shoulderY + bodyH * 0.36);
    c.stroke();
    c.fillStyle = '#E7B44C';                            // belt medallion
    c.beginPath(); c.arc(0, shoulderY + bodyH * 0.33, 3.4 * s, 0, Math.PI * 2); c.fill();
    c.fillStyle = 'rgba(58, 38, 22, 0.9)';
    c.fillRect(-9 * s, shoulderY + bodyH * 0.30, 18 * s, 4 * s);
    c.fillStyle = '#E7B44C';
    c.beginPath(); c.arc(0, shoulderY + bodyH * 0.33, 3.2 * s, 0, Math.PI * 2); c.fill();

    this._head(c, 2 * s, shoulderY - headR * 0.85, headR);

    // Sabre: ready is already high — this is a ceremony, the blades are up.
    var angle = (-0.34 - lift * 0.2) * Math.PI;
    var arm = 30 * s;
    var sx = 7 * s, sy = shoulderY + 4 * s;
    var hx = sx + Math.cos(angle) * arm * 0.85;
    var hy = sy + Math.sin(angle) * arm * 0.85;

    c.strokeStyle = 'rgba(252, 249, 242, 0.97)';        // sleeve
    c.lineWidth = 6 * s; c.lineCap = 'round';
    c.beginPath(); c.moveTo(sx, sy); c.lineTo(hx, hy); c.stroke();

    var bl = 38 * s;
    var tipX = hx + Math.cos(angle - 0.06) * bl;
    var tipY = hy + Math.sin(angle - 0.06) * bl;
    var ctrlX = hx + Math.cos(angle - 0.26) * bl * 0.55;
    var ctrlY = hy + Math.sin(angle - 0.26) * bl * 0.55;

    c.strokeStyle = 'rgba(18, 22, 32, 0.5)';
    c.lineWidth = 4.4 * s;
    c.beginPath(); c.moveTo(hx, hy); c.quadraticCurveTo(ctrlX, ctrlY, tipX, tipY); c.stroke();

    var blade = c.createLinearGradient(hx, hy, tipX, tipY);
    blade.addColorStop(0, '#8E99A8');
    blade.addColorStop(0.45, '#FFFFFF');
    blade.addColorStop(1, '#D3DBE6');
    c.strokeStyle = blade;
    c.lineWidth = 2.8 * s;
    c.beginPath(); c.moveTo(hx, hy); c.quadraticCurveTo(ctrlX, ctrlY, tipX, tipY); c.stroke();

    if (lift > 0.04) {
      c.globalAlpha = lift * 0.6;
      c.strokeStyle = '#FFE6A8';
      c.lineWidth = 6.5 * s;
      c.stroke();
      c.globalAlpha = 1;
    }

    c.fillStyle = '#E7B44C';                            // hilt
    c.beginPath(); c.arc(hx, hy, 3 * s, 0, Math.PI * 2); c.fill();

    c.restore();
  };

  /* Head: face first, then the shemagh framing it. */
  Scene.prototype._head = function (c, x, y, r) {
    c.fillStyle = '#E3C49E';
    c.beginPath(); c.ellipse(x, y + r * 0.12, r * 0.6, r * 0.76, 0, 0, Math.PI * 2); c.fill();
    c.fillStyle = 'rgba(38, 26, 18, 0.78)';
    c.beginPath(); c.ellipse(x, y + r * 0.6, r * 0.5, r * 0.33, 0, 0, Math.PI * 2); c.fill();
    c.fillStyle = 'rgba(30, 20, 14, 0.9)';
    c.fillRect(x - r * 0.32, y - r * 0.02, r * 0.15, r * 0.13);
    c.fillRect(x + r * 0.17, y - r * 0.02, r * 0.15, r * 0.13);

    c.fillStyle = '#D9534F';
    c.beginPath();
    c.moveTo(x - r * 1.0, y + r * 0.1);
    c.quadraticCurveTo(x, y - r * 1.55, x + r * 1.0, y + r * 0.1);
    c.lineTo(x + r * 0.6, y + r * 0.2);
    c.quadraticCurveTo(x, y - r * 0.82, x - r * 0.6, y + r * 0.2);
    c.closePath(); c.fill();

    c.beginPath();
    c.moveTo(x - r * 1.0, y + r * 0.05);
    c.quadraticCurveTo(x - r * 1.18, y + r * 1.25, x - r * 0.74, y + r * 1.6);
    c.lineTo(x - r * 0.5, y + r * 0.9);
    c.quadraticCurveTo(x - r * 0.62, y + r * 0.4, x - r * 0.6, y + r * 0.1);
    c.closePath(); c.fill();
    c.beginPath();
    c.moveTo(x + r * 1.0, y + r * 0.05);
    c.quadraticCurveTo(x + r * 1.18, y + r * 1.25, x + r * 0.74, y + r * 1.6);
    c.lineTo(x + r * 0.5, y + r * 0.9);
    c.quadraticCurveTo(x + r * 0.62, y + r * 0.4, x + r * 0.6, y + r * 0.1);
    c.closePath(); c.fill();

    c.strokeStyle = 'rgba(255,255,255,0.5)';
    c.lineWidth = Math.max(0.6, r * 0.12);
    c.beginPath();
    c.moveTo(x - r * 0.95, y + r * 0.5); c.lineTo(x - r * 0.55, y + r * 0.55);
    c.moveTo(x + r * 0.55, y + r * 0.55); c.lineTo(x + r * 0.95, y + r * 0.5);
    c.moveTo(x - r * 0.76, y - r * 0.48); c.lineTo(x + r * 0.76, y - r * 0.48);
    c.stroke();

    c.strokeStyle = '#100C09';
    c.lineWidth = Math.max(1, r * 0.19);
    c.beginPath();
    c.ellipse(x, y - r * 0.7, r * 0.84, r * 0.21, 0, Math.PI * 0.04, Math.PI * 0.96, true);
    c.stroke();
  };

  A.Scene = Scene;
})(window.Ardah);
