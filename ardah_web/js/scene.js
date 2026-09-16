/* The stage: everything above the note runway.

   Two layers, and the split is a performance decision, not a stylistic one.
   The backdrop — sky, stars, the fort, bunting, the plaza — never changes
   between frames, so it is painted ONCE into an offscreen canvas on resize and
   blitted afterwards. Only what actually moves is redrawn: firelight, the two
   rows of performers, the drummers. That is what keeps a scene this busy at
   60 fps inside a WebView, where the page is a composited platform view.

   Everything is drawn with paths and gradients. No images, no sprite sheets —
   the whole game still fits in one file you can mail to someone.

   On the art itself: this is a stylised placeholder, not the shipping look.
   Dignified posture, no caricature, swords held ceremonially. Real artwork is
   commissioned and goes through cultural review first (concept doc §11). */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var FLAG_COLORS = ['#C8553D', '#E7B44C', '#2E8B57', '#3E6D9C', '#D9BF9A'];

  function Scene() {
    this.backdrop = null;
    this.w = 0; this.h = 0;
    this.horizonY = 0;
    this.stageY = 0;
    this.embers = [];
    this.fires = [];
  }

  /* ---------------------------- static backdrop ---------------------------- */

  Scene.prototype.build = function (w, h, dpr, stageY) {
    this.w = w; this.h = h;
    this.stageY = stageY;                 // where the runway begins
    this.horizonY = stageY * 0.62;

    var cv = document.createElement('canvas');
    cv.width = Math.round(w * dpr);
    cv.height = Math.round(h * dpr);
    var c = cv.getContext('2d');
    c.setTransform(dpr, 0, 0, dpr, 0, 0);

    this._sky(c, w, h);
    this._fort(c, w);
    this._plaza(c, w);
    this._bunting(c, w);

    this.backdrop = cv;

    // Fire positions, reused by the dynamic pass.
    this.fires = [
      { x: w * 0.09, y: this.horizonY + 26, r: 34 },
      { x: w * 0.26, y: this.horizonY + 18, r: 26 },
      { x: w * 0.74, y: this.horizonY + 18, r: 26 },
      { x: w * 0.91, y: this.horizonY + 26, r: 34 }
    ];
    this.embers.length = 0;
  };

  Scene.prototype._sky = function (c, w, h) {
    var g = c.createLinearGradient(0, 0, 0, this.stageY);
    g.addColorStop(0, '#0A1430');
    g.addColorStop(0.45, '#13203F');
    g.addColorStop(0.8, '#2A2A44');
    g.addColorStop(1, '#3A2B33');
    c.fillStyle = g;
    c.fillRect(0, 0, w, this.stageY + 2);

    c.fillStyle = '#FFFFFF';
    for (var i = 0; i < 90; i++) {
      var x = Math.random() * w, y = Math.random() * this.horizonY * 0.9;
      c.globalAlpha = Math.random() * 0.5 + 0.15;
      var r = Math.random() * 1.3 + 0.3;
      c.fillRect(x, y, r, r);
    }
    c.globalAlpha = 1;

    // Warm haze rising off the fires, behind everything else.
    var haze = c.createRadialGradient(w / 2, this.horizonY + 30, 10, w / 2, this.horizonY + 30, w * 0.7);
    haze.addColorStop(0, 'rgba(231, 150, 60, 0.20)');
    haze.addColorStop(1, 'rgba(231, 150, 60, 0)');
    c.fillStyle = haze;
    c.fillRect(0, 0, w, this.stageY);
  };

  /* Diriyah-style mud-brick wall: crenellated towers with lit windows. */
  Scene.prototype._fort = function (c, w) {
    var baseY = this.horizonY + 34;
    var wallTop = this.horizonY - 44;
    var wall = c.createLinearGradient(0, wallTop, 0, baseY);
    wall.addColorStop(0, '#6B4A33');
    wall.addColorStop(1, '#3B2A22');

    // Main wall
    c.fillStyle = wall;
    c.fillRect(w * 0.07, wallTop + 26, w * 0.86, baseY - wallTop - 26);

    // Towers
    var towers = [
      { x: w * 0.10, w: w * 0.13, top: wallTop - 10 },
      { x: w * 0.42, w: w * 0.16, top: wallTop - 26 },
      { x: w * 0.77, w: w * 0.13, top: wallTop - 10 }
    ];
    for (var i = 0; i < towers.length; i++) {
      var t = towers[i];
      c.fillStyle = wall;
      c.fillRect(t.x, t.top, t.w, baseY - t.top);
      this._merlons(c, t.x, t.top, t.w);
      this._windows(c, t.x, t.top, t.w, baseY);
    }
    this._merlons(c, w * 0.07, wallTop + 26, w * 0.86);

    // Door of the central tower, lit from inside.
    var dx = w * 0.46, dw = w * 0.07, dy = baseY - 42;
    var door = c.createLinearGradient(0, dy, 0, baseY);
    door.addColorStop(0, '#F4B860');
    door.addColorStop(1, '#8A4A1E');
    c.fillStyle = door;
    c.beginPath();
    c.moveTo(dx, baseY);
    c.lineTo(dx, dy + 10);
    c.quadraticCurveTo(dx + dw / 2, dy - 8, dx + dw, dy + 10);
    c.lineTo(dx + dw, baseY);
    c.closePath();
    c.fill();
  };

  Scene.prototype._merlons = function (c, x, y, width) {
    var step = 13, mw = 8, mh = 9;
    c.fillStyle = '#5A3E2B';
    for (var mx = x + 2; mx < x + width - mw; mx += step) {
      c.beginPath();
      c.moveTo(mx, y);
      c.lineTo(mx + mw / 2, y - mh);
      c.lineTo(mx + mw, y);
      c.closePath();
      c.fill();
    }
  };

  Scene.prototype._windows = function (c, x, top, width, baseY) {
    var rows = 2, cols = 2;
    for (var r = 0; r < rows; r++) {
      for (var k = 0; k < cols; k++) {
        var wx = x + width * (0.25 + k * 0.42) - 3;
        var wy = top + 26 + r * 30;
        if (wy > baseY - 28) continue;
        var glow = c.createRadialGradient(wx + 3, wy + 6, 1, wx + 3, wy + 6, 16);
        glow.addColorStop(0, 'rgba(255, 190, 90, 0.75)');
        glow.addColorStop(1, 'rgba(255, 190, 90, 0)');
        c.fillStyle = glow;
        c.fillRect(wx - 13, wy - 10, 32, 32);
        c.fillStyle = '#FFC978';
        c.fillRect(wx, wy, 6, 12);
      }
    }
  };

  /* The plaza the row stands on. */
  Scene.prototype._plaza = function (c, w) {
    var top = this.horizonY + 30;
    var g = c.createLinearGradient(0, top, 0, this.h);
    g.addColorStop(0, '#4A3428');
    g.addColorStop(0.35, '#3A2920');
    g.addColorStop(1, '#17100D');
    c.fillStyle = g;
    c.fillRect(0, top, w, this.h - top);

    // Firelight pooling on the ground.
    var pool = c.createRadialGradient(w / 2, this.stageY - 10, 12, w / 2, this.stageY - 10, w * 0.62);
    pool.addColorStop(0, 'rgba(240, 160, 70, 0.22)');
    pool.addColorStop(1, 'rgba(240, 160, 70, 0)');
    c.fillStyle = pool;
    c.fillRect(0, top, w, this.h - top);
  };

  Scene.prototype._bunting = function (c, w) {
    for (var line = 0; line < 2; line++) {
      var y0 = 16 + line * 26, sag = 26 + line * 10;
      c.strokeStyle = 'rgba(217, 191, 154, 0.5)';
      c.lineWidth = 1.2;
      c.beginPath();
      c.moveTo(-10, y0);
      c.quadraticCurveTo(w / 2, y0 + sag, w + 10, y0 - 4);
      c.stroke();

      var n = 13;
      for (var i = 0; i <= n; i++) {
        var t = i / n;
        // Point on the same quadratic as the string.
        var x = (1 - t) * (1 - t) * -10 + 2 * (1 - t) * t * (w / 2) + t * t * (w + 10);
        var y = (1 - t) * (1 - t) * y0 + 2 * (1 - t) * t * (y0 + sag) + t * t * (y0 - 4);
        c.fillStyle = FLAG_COLORS[(i + line) % FLAG_COLORS.length];
        c.globalAlpha = 0.85;
        c.beginPath();
        c.moveTo(x - 7, y);
        c.lineTo(x + 7, y);
        c.lineTo(x, y + 17);
        c.closePath();
        c.fill();
      }
      c.globalAlpha = 1;
    }
  };

  /* ----------------------------- dynamic pass ----------------------------- */

  Scene.prototype.draw = function (c, tMs, dtMs, performers, drumPulse) {
    if (this.backdrop) {
      c.drawImage(this.backdrop, 0, 0, this.w, this.h);
    }
    this._fires(c, tMs, dtMs);
    this._carpet(c);
    this._drummers(c, drumPulse);
    this._rows(c, performers);
  };

  Scene.prototype._fires = function (c, tMs, dtMs) {
    for (var i = 0; i < this.fires.length; i++) {
      var f = this.fires[i];
      // Two out-of-phase sines read as a flicker without any randomness cost.
      var flick = 0.82 + 0.18 * Math.sin(tMs / 90 + i * 2.1) + 0.08 * Math.sin(tMs / 37 + i);
      var r = f.r * flick;

      var glow = c.createRadialGradient(f.x, f.y - r * 0.3, 2, f.x, f.y, r * 3.4);
      glow.addColorStop(0, 'rgba(255, 196, 110, 0.55)');
      glow.addColorStop(0.35, 'rgba(240, 130, 45, 0.22)');
      glow.addColorStop(1, 'rgba(240, 130, 45, 0)');
      c.fillStyle = glow;
      c.beginPath(); c.arc(f.x, f.y, r * 3.4, 0, Math.PI * 2); c.fill();

      // Flame body
      var flame = c.createLinearGradient(0, f.y - r * 1.6, 0, f.y + 6);
      flame.addColorStop(0, 'rgba(255, 236, 170, 0.95)');
      flame.addColorStop(0.5, '#F6A33C');
      flame.addColorStop(1, 'rgba(198, 74, 26, 0.9)');
      c.fillStyle = flame;
      c.beginPath();
      c.moveTo(f.x - r * 0.42, f.y + 6);
      c.quadraticCurveTo(f.x - r * 0.5, f.y - r * 0.8, f.x, f.y - r * 1.6 * flick);
      c.quadraticCurveTo(f.x + r * 0.5, f.y - r * 0.8, f.x + r * 0.42, f.y + 6);
      c.closePath();
      c.fill();

      if (Math.random() < dtMs / 260) {
        this.embers.push({ x: f.x + (Math.random() - 0.5) * r, y: f.y - r, vy: -0.02 - Math.random() * 0.03, life: 1 });
      }
    }

    for (var e = this.embers.length - 1; e >= 0; e--) {
      var em = this.embers[e];
      em.y += em.vy * dtMs;
      em.x += Math.sin(em.y / 14) * 0.25;
      em.life -= dtMs / 2200;
      if (em.life <= 0) { this.embers.splice(e, 1); continue; }
      c.globalAlpha = em.life * 0.8;
      c.fillStyle = '#FFC46E';
      c.fillRect(em.x, em.y, 2, 2);
    }
    c.globalAlpha = 1;
  };

  Scene.prototype._carpet = function (c) {
    var w = this.w, cx = w / 2, y = this.stageY - 34;
    var halfNear = w * 0.20, halfFar = w * 0.145, depth = 30;
    c.fillStyle = '#7E2B2B';
    c.beginPath();
    c.moveTo(cx - halfFar, y - depth);
    c.lineTo(cx + halfFar, y - depth);
    c.lineTo(cx + halfNear, y);
    c.lineTo(cx - halfNear, y);
    c.closePath();
    c.fill();

    c.strokeStyle = 'rgba(231, 180, 76, 0.65)';
    c.lineWidth = 1.4;
    c.stroke();
    c.beginPath();
    c.moveTo(cx - halfFar * 0.75, y - depth * 0.62);
    c.lineTo(cx + halfFar * 0.75, y - depth * 0.62);
    c.lineTo(cx + halfNear * 0.78, y - 6);
    c.lineTo(cx - halfNear * 0.78, y - 6);
    c.closePath();
    c.strokeStyle = 'rgba(231, 180, 76, 0.35)';
    c.stroke();
  };

  /* Two seated drummers on the carpet; each drum hit gives them a small bounce. */
  Scene.prototype._drummers = function (c, pulse) {
    var cx = this.w / 2, baseY = this.stageY - 46;
    var s = Math.min(1, this.w / 420);
    this._drummer(c, cx - 30 * s, baseY, s, pulse[0] || 0, true);
    this._drummer(c, cx + 30 * s, baseY, s, pulse[1] || 0, false);
  };

  Scene.prototype._drummer = function (c, x, baseY, s, pulse, left) {
    var lift = pulse * 2.5 * s;
    var bodyH = 34 * s, headR = 7 * s;
    var y = baseY - lift;

    c.fillStyle = 'rgba(0,0,0,0.3)';
    c.beginPath(); c.ellipse(x, baseY + 3, 15 * s, 4 * s, 0, 0, Math.PI * 2); c.fill();

    // Thobe (seated: a wide, low shape)
    var g = c.createLinearGradient(0, y - bodyH, 0, y);
    g.addColorStop(0, '#F2EDE3');
    g.addColorStop(1, '#BFB5A4');
    c.fillStyle = g;
    c.beginPath();
    c.moveTo(x - 9 * s, y - bodyH);
    c.lineTo(x + 9 * s, y - bodyH);
    c.lineTo(x + 14 * s, y);
    c.lineTo(x - 14 * s, y);
    c.closePath();
    c.fill();

    this._head(c, x, y - bodyH - headR * 0.5, headR);

    // Drum in the lap, tilted toward the player.
    var dx = x + (left ? 9 : -9) * s, dy = y - 12 * s;
    var dg = c.createLinearGradient(dx - 9 * s, 0, dx + 9 * s, 0);
    dg.addColorStop(0, '#8A5A2B');
    dg.addColorStop(0.5, '#C08A4A');
    dg.addColorStop(1, '#6E441F');
    c.fillStyle = dg;
    c.beginPath();
    c.ellipse(dx, dy, 10 * s, 12 * s, left ? -0.35 : 0.35, 0, Math.PI * 2);
    c.fill();
    c.fillStyle = 'rgba(243, 237, 226, ' + (0.75 + pulse * 0.25) + ')';
    c.beginPath();
    c.ellipse(dx, dy - 1 * s, 6.5 * s, 8 * s, left ? -0.35 : 0.35, 0, Math.PI * 2);
    c.fill();
  };

  /* The two facing rows. Left row faces right, right row mirrors it. */
  Scene.prototype._rows = function (c, performers) {
    var w = this.w, baseY = this.stageY - 6;
    var s = Math.min(1, w / 420);
    var count = performers.length / 2;

    for (var i = 0; i < count; i++) {
      // Nearer figures sit lower and larger — a cheap depth cue.
      var depth = i / Math.max(1, count - 1);
      var scale = (0.78 + depth * 0.32) * s;
      var y = baseY - (1 - depth) * 26 * s;
      var xL = w * 0.5 - (w * 0.19 + depth * w * 0.235);
      var xR = w * 0.5 + (w * 0.19 + depth * w * 0.235);
      this._performer(c, xL, y, scale, performers[i], 1);
      this._performer(c, xR, y, scale, performers[count + i], -1);
    }
  };

  /* One performer. `face` is +1 for the left row (facing right) and -1 for the
     right row. `lift` 0..1 raises the sword from rest to the ceremonial high. */
  Scene.prototype._performer = function (c, x, baseY, s, lift, face) {
    var bodyH = 74 * s, headR = 8.5 * s;
    var shoulderY = baseY - bodyH * 0.74;

    c.save();
    c.translate(x, 0);
    c.scale(face, 1);

    c.fillStyle = 'rgba(0, 0, 0, 0.32)';
    c.beginPath(); c.ellipse(0, baseY + 2, 15 * s, 4 * s, 0, 0, Math.PI * 2); c.fill();

    // Thobe: white, warmed from below by the fires.
    var g = c.createLinearGradient(0, shoulderY, 0, baseY);
    g.addColorStop(0, '#F7F3EA');
    g.addColorStop(0.55, '#E4DDCF');
    g.addColorStop(1, '#B49B7E');
    c.fillStyle = g;
    c.beginPath();
    c.moveTo(-9 * s, shoulderY);
    c.quadraticCurveTo(-11 * s, shoulderY + bodyH * 0.4, -15 * s, baseY);
    c.lineTo(15 * s, baseY);
    c.quadraticCurveTo(11 * s, shoulderY + bodyH * 0.4, 9 * s, shoulderY);
    c.closePath();
    c.fill();

    // Crossed bandolier
    c.strokeStyle = 'rgba(74, 48, 30, 0.85)';
    c.lineWidth = 2.4 * s;
    c.beginPath();
    c.moveTo(-8 * s, shoulderY + 2 * s); c.lineTo(7 * s, shoulderY + bodyH * 0.34);
    c.moveTo(8 * s, shoulderY + 2 * s); c.lineTo(-7 * s, shoulderY + bodyH * 0.34);
    c.stroke();
    c.fillStyle = '#C89A3C';
    c.fillRect(-2.5 * s, shoulderY + bodyH * 0.3, 5 * s, 4 * s);

    this._head(c, 2 * s, shoulderY - headR * 0.9, headR);

    // Sword arm. Rest is lowered; a hit lifts the sabre high and forward.
    var angle = (0.3 - lift * 0.82) * Math.PI;
    var arm = 26 * s;
    var sx = 7 * s, sy = shoulderY + 5 * s;
    var hx = sx + Math.cos(angle) * arm * 0.6;
    var hy = sy + Math.sin(angle) * arm * 0.6;

    c.strokeStyle = 'rgba(236, 228, 214, 0.95)';
    c.lineWidth = 4.5 * s;
    c.lineCap = 'round';
    c.beginPath(); c.moveTo(sx, sy); c.lineTo(hx, hy); c.stroke();

    // Curved sabre: a quadratic with a highlight along the spine.
    var bl = 34 * s;
    var tipX = hx + Math.cos(angle) * bl;
    var tipY = hy + Math.sin(angle) * bl;
    var ctrlX = hx + Math.cos(angle - 0.42) * bl * 0.62;
    var ctrlY = hy + Math.sin(angle - 0.42) * bl * 0.62;

    c.strokeStyle = 'rgba(20, 24, 34, 0.55)';
    c.lineWidth = 4.2 * s;
    c.beginPath(); c.moveTo(hx, hy); c.quadraticCurveTo(ctrlX, ctrlY, tipX, tipY); c.stroke();

    var blade = c.createLinearGradient(hx, hy, tipX, tipY);
    blade.addColorStop(0, '#9AA4B2');
    blade.addColorStop(0.5, '#FFFFFF');
    blade.addColorStop(1, '#C9D2DD');
    c.strokeStyle = blade;
    c.lineWidth = 2.6 * s;
    c.beginPath(); c.moveTo(hx, hy); c.quadraticCurveTo(ctrlX, ctrlY, tipX, tipY); c.stroke();

    if (lift > 0.04) {
      c.globalAlpha = lift * 0.55;
      c.strokeStyle = '#FFD98A';
      c.lineWidth = 6 * s;
      c.stroke();
      c.globalAlpha = 1;
    }

    c.fillStyle = '#E7B44C';                    // hilt
    c.beginPath(); c.arc(hx, hy, 2.6 * s, 0, Math.PI * 2); c.fill();

    c.restore();
  };

  /* Head: face first, then the shemagh framing it — otherwise the cloth reads
     as a blank blob at this size. */
  Scene.prototype._head = function (c, x, y, r) {
    // Face
    c.fillStyle = '#E3C49E';
    c.beginPath(); c.ellipse(x, y + r * 0.12, r * 0.62, r * 0.78, 0, 0, Math.PI * 2); c.fill();
    // Beard, suggested rather than drawn
    c.fillStyle = 'rgba(38, 26, 18, 0.75)';
    c.beginPath(); c.ellipse(x, y + r * 0.62, r * 0.52, r * 0.34, 0, 0, Math.PI * 2); c.fill();
    c.fillStyle = 'rgba(38, 26, 18, 0.9)';
    c.fillRect(x - r * 0.34, y, r * 0.16, r * 0.14);
    c.fillRect(x + r * 0.18, y, r * 0.16, r * 0.14);

    // Shemagh: crown plus a panel down each side of the face.
    c.fillStyle = '#D9534F';
    c.beginPath();
    c.moveTo(x - r * 1.0, y + r * 0.1);
    c.quadraticCurveTo(x, y - r * 1.6, x + r * 1.0, y + r * 0.1);
    c.lineTo(x + r * 0.62, y + r * 0.2);
    c.quadraticCurveTo(x, y - r * 0.85, x - r * 0.62, y + r * 0.2);
    c.closePath();
    c.fill();

    c.beginPath();                                  // left fall
    c.moveTo(x - r * 1.0, y + r * 0.05);
    c.quadraticCurveTo(x - r * 1.15, y + r * 1.2, x - r * 0.72, y + r * 1.55);
    c.lineTo(x - r * 0.5, y + r * 0.9);
    c.quadraticCurveTo(x - r * 0.62, y + r * 0.4, x - r * 0.62, y + r * 0.1);
    c.closePath();
    c.fill();
    c.beginPath();                                  // right fall
    c.moveTo(x + r * 1.0, y + r * 0.05);
    c.quadraticCurveTo(x + r * 1.15, y + r * 1.2, x + r * 0.72, y + r * 1.55);
    c.lineTo(x + r * 0.5, y + r * 0.9);
    c.quadraticCurveTo(x + r * 0.62, y + r * 0.4, x + r * 0.62, y + r * 0.1);
    c.closePath();
    c.fill();

    c.strokeStyle = 'rgba(255,255,255,0.5)';        // the woven check
    c.lineWidth = Math.max(0.6, r * 0.13);
    c.beginPath();
    c.moveTo(x - r * 0.95, y + r * 0.45); c.lineTo(x - r * 0.55, y + r * 0.5);
    c.moveTo(x + r * 0.55, y + r * 0.5); c.lineTo(x + r * 0.95, y + r * 0.45);
    c.moveTo(x - r * 0.78, y - r * 0.5); c.lineTo(x + r * 0.78, y - r * 0.5);
    c.stroke();

    c.strokeStyle = '#100C09';                      // agal, on the crown
    c.lineWidth = Math.max(1, r * 0.2);
    c.beginPath();
    c.ellipse(x, y - r * 0.72, r * 0.86, r * 0.22, 0, Math.PI * 0.04, Math.PI * 0.96, true);
    c.stroke();
  };

  A.Scene = Scene;
})(window.Ardah);
