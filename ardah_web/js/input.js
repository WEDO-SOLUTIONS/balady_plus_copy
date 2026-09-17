/* Input.

   Pointer events for touch and mouse, keys for a desk check. Two details carry
   most of the feel:

   1. Queueing correction. `event.timeStamp` is stamped when the browser
      received the input; by the time the handler runs, some milliseconds have
      passed — more when a frame is busy. We hand that difference to the game
      so the judgment uses when the player ACTED, not when we got around to it.
      It is clamped, because a hostile or stale timestamp must never move the
      clock.

   2. A swipe is a flourish, not three taps. Once a pointer travels far enough
      sideways it stops being a lane press and becomes the flourish, and the
      lane it started in is released without a stray judgment. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var SWIPE_PX = 52;
  var MAX_CORRECTION_MS = 120;

  function correction(ev) {
    if (!ev || typeof ev.timeStamp !== 'number' || !ev.timeStamp) return 0;
    var lag = performance.now() - ev.timeStamp;
    if (!isFinite(lag) || lag < 0) return 0;
    return Math.min(lag, MAX_CORRECTION_MS);
  }

  function Input(target, api) {
    this.api = api;                 // { laneAt, press, release, flourish, tilt, pause, active }
    this.pointers = {};
    this.keys = {};
    this.touchUsed = false;
    this._bind(target);
  }

  Input.prototype._bind = function (el) {
    var self = this;

    el.addEventListener('pointerdown', function (ev) {
      if (!self.api.active()) return;
      if (ev.pointerType === 'touch') self.touchUsed = true;
      el.setPointerCapture && el.setPointerCapture(ev.pointerId);
      var lane = self.api.laneAt(ev.clientX, ev.clientY);
      self.pointers[ev.pointerId] = { lane: lane, x: ev.clientX, y: ev.clientY, swiped: false };
      if (lane >= 0) self.api.press(lane, correction(ev));
      ev.preventDefault();
    }, { passive: false });

    el.addEventListener('pointermove', function (ev) {
      var p = self.pointers[ev.pointerId];
      if (!p || p.swiped) return;
      if (Math.abs(ev.clientX - p.x) >= SWIPE_PX && Math.abs(ev.clientY - p.y) < SWIPE_PX * 1.4) {
        p.swiped = true;
        if (p.lane >= 0) self.api.release(p.lane, correction(ev));
        self.api.flourish(correction(ev));
      }
    }, { passive: true });

    function up(ev) {
      var p = self.pointers[ev.pointerId];
      if (!p) return;
      delete self.pointers[ev.pointerId];
      if (!p.swiped && p.lane >= 0) self.api.release(p.lane, correction(ev));
    }
    el.addEventListener('pointerup', up);
    el.addEventListener('pointercancel', up);

    window.addEventListener('keydown', function (ev) {
      var lane = keyLane(ev.key);
      if (ev.key === 'Escape') { self.api.pause(); return; }
      if (!self.api.active()) return;
      if (ev.key === ' ' || ev.code === 'Space') {
        ev.preventDefault();
        if (!self.keys.space) { self.keys.space = true; self.api.flourish(correction(ev)); }
        return;
      }
      // 1 and 2 swing the view. Not gated on api.active(): looking around the
      // stage in the menu is half the point of showing it.
      if (ev.key === '1' || ev.key === '2') {
        var dir = ev.key === '1' ? -1 : 1;
        if (self.keys['tilt' + dir]) return;
        self.keys['tilt' + dir] = true;
        self.api.tilt(dir);
        return;
      }
      // The camera-lock slider owns the arrow keys while it holds focus: they
      // are how a keyboard aims it, and they are also lane keys, so a press
      // here would be a note nobody asked for.
      if (ev.target && ev.target.id === 'tilt-lock') return;
      if (lane < 0 || self.keys[lane]) return;   // ignore auto-repeat
      self.keys[lane] = true;
      self.api.press(lane, correction(ev));
    });

    window.addEventListener('keyup', function (ev) {
      if (ev.key === ' ' || ev.code === 'Space') { self.keys.space = false; return; }
      if (ev.key === '1' || ev.key === '2') {
        var d = ev.key === '1' ? -1 : 1;
        self.keys['tilt' + d] = false;
        // Release to whichever direction is still held, so rolling from one
        // key to the other does not drop the swing to centre in between.
        self.api.tilt(self.keys['tilt-1'] ? -1 : self.keys['tilt1'] ? 1 : 0);
        return;
      }
      if (ev.target && ev.target.id === 'tilt-lock') return;
      var lane = keyLane(ev.key);
      if (lane < 0 || !self.keys[lane]) return;
      self.keys[lane] = false;
      self.api.release(lane, correction(ev));
    });
  };

  /** Releases everything — used when a run ends or the page is hidden, so a
      finger still down cannot leak a release into the next run. */
  Input.prototype.reset = function () {
    this.pointers = {};
    this.keys = {};
    if (this.api && this.api.tilt) this.api.tilt(0);
  };

  function keyLane(key) {
    switch (key) {
      case 'a': case 'A': case 'ArrowLeft': case 'ф': case 'Ф': return 0;
      case 's': case 'S': case 'ArrowDown': case 'ы': case 'Ы': return 1;
      case 'd': case 'D': case 'ArrowRight': case 'в': case 'В': return 2;
      default: return -1;
    }
  }

  A.Input = Input;
})(window.Ardah);
