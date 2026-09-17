/* Game flow: menu → (calibration) → run → result, plus the latency lab.

   One requestAnimationFrame loop drives everything and it never stops: the
   idle scene keeps the row breathing behind the menus, so the app never looks
   frozen while audio is being unlocked. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var CALIB_LEAD = 4, CALIB_BEATS = 8, CALIB_INTERVAL_MS = 545;

  function store(key, value) {
    try {
      if (value === undefined) {
        var raw = localStorage.getItem('ardah.' + key);
        return raw === null ? null : JSON.parse(raw);
      }
      localStorage.setItem('ardah.' + key, JSON.stringify(value));
    } catch (e) {
      // Private mode, blocked storage, a WebView with data cleared — the game
      // must work without persistence, just without remembering anything.
    }
    return null;
  }

  function Game() {
    this.phase = 'menu';
    this.charts = A.charts.all();
    this.chartIndex = 1;                       // normal by default
    this.offsetMs = store('offsetMs') || 0;
    this.calibrated = store('offsetMs') !== null;
    this.debug = /[?&]debug=1/.test(location.search);
    this.muted = store('muted') === true;
    A.audio.setMuted(this.muted);
    this.conductor = new A.Conductor(A.audio);
    this.judge = null;
    this.tiltManual = 0;
    this.tiltLock = 0;
    this.tiltGyro = 0;
    this.onTiltLockReset = null;
    this.renderer = null;
    this.input = null;
    this.lastFrame = 0;
    this.fps = 0;
    this.calib = null;
  }

  /* ------------------------------ lifecycle ------------------------------ */

  Game.prototype.init = function (canvas) {
    var self = this;
    this.renderer = new A.Renderer(canvas);
    this.input = new A.Input(canvas, {
      active: function () { return self.phase === 'playing'; },
      laneAt: function (x) {
        var r = self.renderer;
        var lane = Math.floor((x - r.fieldX) / r.laneW);
        return lane >= 0 && lane <= 2 ? lane : -1;
      },
      press: function (lane, corr) { self._press(lane, corr); },
      release: function (lane, corr) { self._release(lane, corr); },
      flourish: function (corr) { self._flourish(corr); },
      tilt: function (v) { self.setTiltManual(v); },
      pause: function () { if (self.phase === 'playing') self.pause(); }
    });

    window.addEventListener('resize', function () { self.renderer.resize(); });
    window.addEventListener('orientationchange', function () {
      setTimeout(function () { self.renderer.resize(); }, 120);
    });

    // Backgrounding must never cost the player a run: the tab losing focus,
    // a call arriving, or iOS suspending the context all land here.
    document.addEventListener('visibilitychange', function () {
      if (document.hidden && self.phase === 'playing') self.pause();
    });

    this._loop(performance.now());
  };

  Game.prototype._loop = function (now) {
    var self = this;
    var dt = Math.min(64, now - (this.lastFrame || now));
    this.lastFrame = now;
    if (dt > 0) this.fps = this.fps ? this.fps * 0.9 + (1000 / dt) * 0.1 : 1000 / dt;

    if (this.phase === 'playing') {
      this.conductor.tick();
      var t = this.conductor.judgeTimeMs();
      var events = this.judge.update(t);
      for (var i = 0; i < events.length; i++) this._reactTo(events[i]);

      if (this.judge.broken) this._finish(false);
      else if (this.conductor.finished()) this._finish(true);
    } else if (this.phase === 'calibrating') {
      this._calibTick();
    }

    this._draw(dt);
    if (this.debug) this._drawDebug();

    requestAnimationFrame(function (ts) { self._loop(ts); });
  };

  Game.prototype._draw = function (dt) {
    var playing = this.phase === 'playing' || this.phase === 'paused';
    this.renderer.draw({
      chart: playing ? this.charts[this.chartIndex] : null,
      judge: playing ? this.judge : null,
      visualTimeMs: playing ? this.conductor.visualTimeMs() : 0,
      touchUsed: this.input ? this.input.touchUsed : false,
      safeTop: 0
    }, dt);

    if (playing && this.judge) {
      var firstNote = this.judge.notes.length ? this.judge.notes[0].t : 0;
      if (this.conductor.visualTimeMs() < firstNote - 900) {
        this.renderer.banner(this.renderer.ctx, A.i18n.t('countIn'));
      }
    }
  };

  /* -------------------------------- a run -------------------------------- */

  Game.prototype.play = function () {
    // Play again is one tap from the result screen, and the ending stinger
    // runs for a second and a half after the run is over.
    A.audio.cancelStinger();
    var self = this;
    A.audio.unlock().then(function () {
      var chart = self.charts[self.chartIndex];
      self.judge = new A.Judge(chart);
      self.conductor.prepare(chart, self.offsetMs);
      self.conductor.start();
      self.input.reset();
      self.renderer.keyReset();
      A.audio.holdEndAll();
      self.phase = 'playing';
      A.ui.showScreen(null);
      A.bridge.track('ardah_run_started', { chart: chart.id, calibrated: self.calibrated });
    }).catch(function (err) {
      A.ui.toast('Audio unavailable: ' + err.message);
    });
  };

  /* The view swing has three sources and they must not fight.

     A held button or key is a deliberate look, so it wins outright while it is
     held; the lock slider is the standing angle below it; the gyroscope is the
     resting state under that. Without the precedence a player on a handset
     could hold the button and watch the view drift back under their thumb.

     Zero means "not driving" for the top two, which is what lets a released
     button fall through to the lock and a centred lock fall through to the
     wrist. */
  Game.prototype.setTiltManual = function (v) {
    this.tiltManual = v;
    // Pressing left or right clears the lock rather than suspending it: the
    // player has just said where they want to look, and restoring a parked
    // angle on release would swing the stage back to a decision they made
    // some time ago. The DOM bead follows through the callback -- the game
    // owns the value, main.js owns the control.
    if (v !== 0 && this.tiltLock !== 0) {
      this.tiltLock = 0;
      if (this.onTiltLockReset) this.onTiltLockReset();
    }
    this._applyTilt();
  };

  Game.prototype.setTiltLock = function (v) {
    this.tiltLock = v < -1 ? -1 : v > 1 ? 1 : v;
    this._applyTilt();
  };

  Game.prototype.setTiltGyro = function (v) {
    this.tiltGyro = v;
    this._applyTilt();
  };

  Game.prototype._applyTilt = function () {
    var m = this.tiltManual || 0;
    this.renderer.setTilt(m !== 0 ? m : (this.tiltLock || this.tiltGyro || 0));
  };

  Game.prototype._press = function (lane, corr) {
    // The pad depresses on the input itself, not on the judgement: a stray tap
    // still moved a key, and waiting for the verdict would put the animation
    // behind the finger.
    this.renderer.keyDown(lane);
    var t = this.conductor.judgeTimeMs() - corr;
    var ev = this.judge.press(lane, t);
    if (ev) {
      this._reactTo(ev);
      // A raise that has just begun starts humming. The judge marks the note
      // `holding` and says nothing more until it ends, so this is the only
      // moment the sustain can be started from.
      if (ev.note && ev.note.type === 'hold' && ev.note.state === 'holding') {
        A.audio.holdStart(lane);
      }
    } else {
      // Silent, and deliberately: a stray tap costs nothing, and a sound for
      // it would teach the player that they did something wrong when they did
      // not. The pad still moved, which is feedback enough.
      this.renderer.hit(lane, 'stray');
    }
  };

  Game.prototype._release = function (lane, corr) {
    this.renderer.keyUp(lane);
    // Unconditional, and _reactTo does it again for the verdict: a finger
    // coming off always stops the hum, whatever the judge makes of it. A
    // sustained sound with no owner is the worst failure this file can have.
    A.audio.holdEnd(lane);
    var ev = this.judge.release(lane, this.conductor.judgeTimeMs() - corr);
    if (ev) this._reactTo(ev);
  };

  Game.prototype._flourish = function (corr) {
    var ev = this.judge.flourish(this.conductor.judgeTimeMs() - corr);
    if (ev) { this.renderer.flourishBurst(); this._reactTo(ev); }
  };

  Game.prototype._reactTo = function (ev) {
    if (!ev) return;
    var lane = ev.note ? ev.note.lane : -1;

    /* Every verdict passes through here — a press, a release, a flourish, and
       the misses the judge emits from update() when a window closes — so this
       is the one place the sound belongs. A raise ends here too, whichever way
       it ended: released on the beat, let go too early, or held all the way
       through and credited by update(). */
    if (ev.judgment === 'miss') A.audio.missed();
    else A.audio.strike(ev.judgment);
    if (ev.note && ev.note.type === 'hold' && ev.note.state !== 'holding') {
      A.audio.holdEnd(lane);
    }

    this.renderer.hit(lane, ev.judgment, ev.note ? ev.note.t : 0);
    if (ev.points) this.renderer.score(lane, ev.points);
    this.renderer.say(A.i18n.t(ev.judgment), ev.judgment === 'perfect' ? '#E7B44C'
      : ev.judgment === 'miss' ? '#C8553D' : '#6FD3A0');
    if (ev.judgment === 'perfect') A.bridge.vibrate(12);
    else if (ev.judgment === 'good') A.bridge.vibrate(8);
  };

  Game.prototype.pause = function () {
    if (this.phase !== 'playing') return;
    this.phase = 'paused';
    this.input.reset();
    this.renderer.keyReset();
    A.audio.holdEndAll();
    this.conductor.pause();
    A.ui.showScreen('screen-pause');
  };

  Game.prototype.resume = function () {
    if (this.phase !== 'paused') return;
    var self = this;
    // The context can be suspended by the OS as well as by us, so always ask
    // for a resume rather than assuming our own pause is the only reason.
    A.audio.unlock().then(function () {
      self.conductor.resume();
      self.phase = 'playing';
      A.ui.showScreen(null);
    });
  };

  Game.prototype.restart = function () {
    this.conductor.stop();
    this.play();
  };

  Game.prototype.quit = function () {
    this.conductor.stop();
    A.audio.cancelStinger();
    this.phase = 'menu';
    this.input.reset();
    this.renderer.keyReset();
    A.audio.holdEndAll();
    A.ui.showScreen('screen-menu');
  };

  Game.prototype._finish = function (completed) {
    this.conductor.stop();
    this.phase = 'result';
    this.input.reset();
    this.renderer.keyReset();
    A.audio.holdEndAll();

    var chart = this.charts[this.chartIndex];

    /* The end of a run is one gesture in two parts, and both live here rather
       than in the UI: the cadence belongs to the performance that just
       stopped, so it is written in that chart's own beat, and the grade
       arrives under the result screen a beat and a half later — long enough
       that the two do not talk over each other, short enough that the screen
       and its sound are one event. */
    var beatMs = 60000 / (chart.bpm || 96);
    A.audio.ending(completed, beatMs);

    var acc = this.judge.accuracy();
    var timing = this.judge.timing();
    var best = store('best.' + chart.id);
    var isBest = !best || acc > best.accuracy;
    if (isBest) store('best.' + chart.id, { accuracy: acc, score: this.judge.score, grade: this.judge.grade() });

    // Scheduled from the same `isBest` the screen is about to print, so the
    // sound and the text can never disagree about whether this was a best.
    if (A.audio.ctx) {
      A.audio.result(this.judge.grade(), isBest,
                     A.audio.ctx.currentTime + (beatMs * 1.5) / 1000 + 0.35);
    }

    A.bridge.track('ardah_run_finished', {
      chart: chart.id,
      completed: completed,
      accuracy: Math.round(acc * 1000) / 10,
      maxCombo: this.judge.maxCombo,
      score: this.judge.score,
      meanMs: Math.round(timing.mean),
      jitterMs: Math.round(timing.jitter)
    });

    A.ui.showResult({
      completed: completed,
      grade: this.judge.grade(),
      accuracy: acc,
      score: this.judge.score,
      maxCombo: this.judge.maxCombo,
      counts: this.judge.counts,
      timing: timing,
      best: best,
      isBest: isBest
    });
  };

  /* ----------------------------- calibration ----------------------------- */

  /* Eight clicks, tap along, take the median. The median rather than the mean
     because one distracted tap should not move the result — and this number
     then shifts every judgment for the device, so it has to be robust. */
  Game.prototype.startCalibration = function () {
    var self = this;
    A.audio.unlock().then(function () {
      var ctx = A.audio.ctx;
      var start = ctx.currentTime + 0.6;
      var total = CALIB_LEAD + CALIB_BEATS;
      for (var i = 0; i < total; i++) {
        A.audio.click(start + i * (CALIB_INTERVAL_MS / 1000), i % 4 === 0);
      }
      self.calib = { start: start, taps: [], total: total, done: false };
      self.phase = 'calibrating';
      A.ui.calibReset(CALIB_BEATS);
    });
  };

  Game.prototype.calibTap = function (corr) {
    if (this.phase !== 'calibrating' || !this.calib || this.calib.done) return;
    var ms = (A.audio.ctx.currentTime - this.calib.start) * 1000 - (corr || 0);
    var idx = Math.round(ms / CALIB_INTERVAL_MS);
    if (idx < CALIB_LEAD) return;                       // lead-in clicks: listen only
    if (idx >= this.calib.total) return;
    var delta = ms - idx * CALIB_INTERVAL_MS;
    if (Math.abs(delta) > CALIB_INTERVAL_MS * 0.45) return;   // not a tap on this beat
    this.calib.taps.push(delta);
    A.ui.calibProgress(this.calib.taps.length, CALIB_BEATS);
    if (this.calib.taps.length >= CALIB_BEATS) this._calibFinish();
  };

  Game.prototype._calibTick = function () {
    if (!this.calib || this.calib.done) return;
    var elapsed = (A.audio.ctx.currentTime - this.calib.start) * 1000;
    var beat = Math.floor(elapsed / CALIB_INTERVAL_MS);
    A.ui.calibBeat(beat - CALIB_LEAD, CALIB_BEATS);
    if (elapsed > (this.calib.total + 0.6) * CALIB_INTERVAL_MS) this._calibFinish();
  };

  Game.prototype._calibFinish = function () {
    if (!this.calib || this.calib.done) return;
    this.calib.done = true;
    this.phase = 'menu';
    var taps = this.calib.taps.slice().sort(function (a, b) { return a - b; });
    if (taps.length >= 3) {
      var mid = Math.floor(taps.length / 2);
      var median = taps.length % 2 ? taps[mid] : (taps[mid - 1] + taps[mid]) / 2;
      this.setOffset(Math.round(median));
      A.ui.calibResult(this.offsetMs, taps.length);
    } else {
      A.ui.calibResult(null, taps.length);
    }
  };

  Game.prototype.setOffset = function (ms) {
    this.offsetMs = Math.max(-300, Math.min(300, ms));
    this.calibrated = true;
    store('offsetMs', this.offsetMs);
    A.ui.refreshOffset();
  };

  Game.prototype.setMuted = function (muted) {
    this.muted = !!muted;
    store('muted', this.muted);
    A.audio.setMuted(this.muted);
    A.bridge.track('ardah_mute', { muted: this.muted });
    if (A.ui) A.ui.refreshMute();
  };

  Game.prototype.toggleMute = function () { this.setMuted(!this.muted); };

  /* ----------------------------- latency lab ----------------------------- */

  Game.prototype.toggleDebug = function () {
    this.debug = !this.debug;
    A.ui.setDebugVisible(this.debug);
  };

  Game.prototype._drawDebug = function () {
    var ctx = A.audio.ctx;
    var timing = this.judge ? this.judge.timing() : { mean: 0, jitter: 0, n: 0 };
    var lines = [
      'fps        ' + this.fps.toFixed(0) + '   dpr ' + this.renderer.dpr,
      'ctx        ' + (ctx ? ctx.state + ' @' + ctx.sampleRate + 'Hz' : 'not started'),
      'base lat   ' + (ctx ? (ctx.baseLatency * 1000).toFixed(1) : '—') + ' ms',
      'out lat    ' + (ctx ? (A.audio.outputLatency() * 1000).toFixed(1) : '—') + ' ms',
      'calib      ' + this.offsetMs + ' ms' + (this.calibrated ? '' : ' (default)'),
      'song       ' + (this.phase === 'playing' ? (this.conductor.judgeTimeMs() / 1000).toFixed(2) + ' s' : '—'),
      'mean       ' + timing.mean.toFixed(1) + ' ms  (n=' + timing.n + ')',
      'jitter σ   ' + timing.jitter.toFixed(1) + ' ms',
      'host       ' + (A.bridge.inApp ? 'superapp webview' : 'browser')
    ];
    A.ui.setDebugText(lines.join('\n'));
  };

  A.game = new Game();
})(window.Ardah);
