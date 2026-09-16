/* The conductor — the clock everything else obeys.

   Rule one of a rhythm game: never accumulate frame deltas. `requestAnimation-
   Frame` drifts by tens of milliseconds a minute and stalls whenever the page
   does. The audio clock does not, so `AudioContext.currentTime` is the master
   and every frame simply asks it what time it is.

   Rule two: schedule sound AHEAD of the playhead, never on the frame it should
   play. Each tick looks a little into the future and hands the drums to the
   audio thread with an exact start time, which is why the groove stays steady
   even when the main thread hitches.

   Two clocks come out of this, and they are not the same number:

     judgeTimeMs  — what the PLAYER is judged against. Carries the measured
                    calibration offset, which absorbs output latency, input
                    latency and everything else between the speaker and the
                    touch event.
     visualTimeMs — what is DRAWN. Carries only the browser's reported output
                    latency, so a marker crosses the line at the moment the
                    drum is actually heard rather than when it was scheduled. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var SCHEDULE_AHEAD_MS = 180;   // how far past the playhead we hand sound over
  var LEAD_IN_S = 0.35;          // gap between "start" and bar one

  function Conductor(audio) {
    this.audio = audio;
    this.chart = null;
    this.calibrationMs = 0;
    this.startCtxTime = 0;
    this.drumCursor = 0;
    this.running = false;
    this.paused = false;
  }

  Conductor.prototype.prepare = function (chart, calibrationMs) {
    this.chart = chart;
    this.calibrationMs = calibrationMs || 0;
    this.drumCursor = 0;
    this.running = false;
    this.paused = false;
  };

  Conductor.prototype.start = function () {
    this.startCtxTime = this.audio.ctx.currentTime + LEAD_IN_S;
    this.drumCursor = 0;
    this.running = true;
    this.paused = false;
  };

  /** Audio-clock milliseconds since bar one, before any offset is applied. */
  Conductor.prototype.rawTimeMs = function () {
    if (!this.running) return 0;
    return (this.audio.ctx.currentTime - this.startCtxTime) * 1000;
  };

  Conductor.prototype.judgeTimeMs = function () {
    return this.rawTimeMs() - this.calibrationMs;
  };

  Conductor.prototype.visualTimeMs = function () {
    return this.rawTimeMs() - this.audio.outputLatency() * 1000;
  };

  /** Hands every drum hit inside the lookahead window to the audio thread. */
  Conductor.prototype.tick = function () {
    if (!this.running || this.paused || !this.chart) return;
    var horizonMs = this.rawTimeMs() + SCHEDULE_AHEAD_MS;
    var drums = this.chart.drums;
    while (this.drumCursor < drums.length && drums[this.drumCursor].t <= horizonMs) {
      var hit = drums[this.drumCursor];
      var when = this.startCtxTime + hit.t / 1000;
      // A hit whose moment already passed (a long stall, a resumed tab) is
      // dropped rather than played late — late drums are worse than missing
      // ones, because the player is following them.
      if (when >= this.audio.ctx.currentTime) this.audio.play(hit.voice, when, hit.gain);
      this.drumCursor++;
    }
  };

  Conductor.prototype.finished = function () {
    return this.running && this.chart && this.rawTimeMs() > this.chart.durationMs;
  };

  /* Suspending the context freezes `currentTime`, so the song resumes exactly
     where it stopped with no bookkeeping. Drums already handed to the audio
     thread (at most one lookahead window) will fire right after the resume —
     acceptable for a prototype, worth cancelling properly before release. */
  Conductor.prototype.pause = function () {
    if (!this.running || this.paused) return Promise.resolve();
    this.paused = true;
    return this.audio.ctx.suspend();
  };

  Conductor.prototype.resume = function () {
    if (!this.running || !this.paused) return Promise.resolve();
    this.paused = false;
    return this.audio.ctx.resume();
  };

  Conductor.prototype.stop = function () {
    this.running = false;
    this.paused = false;
    if (this.audio.ctx && this.audio.ctx.state === 'suspended') this.audio.ctx.resume();
  };

  A.Conductor = Conductor;
})(window.Ardah);
