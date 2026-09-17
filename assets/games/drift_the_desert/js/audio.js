/* Drift the Desert — procedural audio.

   All sounds are synthesised with the Web Audio API so the mini app ships
   without any binary audio assets (important for WebView bundle size and for
   offline play). The whole module is optional: if AudioContext is missing or
   blocked, every call is a silent no-op. */
(function (global) {
  'use strict';

  var Ctx = global.AudioContext || global.webkitAudioContext;
  var ctx = null;
  var master = null;
  var engine = null;          // { osc, noise, gain, filter }
  var enabled = true;
  var started = false;

  function ensure() {
    if (!Ctx || !enabled) return null;
    if (!ctx) {
      try {
        ctx = new Ctx();
        master = ctx.createGain();
        master.gain.value = 0.55;
        master.connect(ctx.destination);
      } catch (e) {
        ctx = null;
      }
    }
    if (ctx && ctx.state === 'suspended') ctx.resume();
    return ctx;
  }

  function noiseBuffer(seconds) {
    var len = Math.floor(ctx.sampleRate * seconds);
    var buf = ctx.createBuffer(1, len, ctx.sampleRate);
    var data = buf.getChannelData(0);
    for (var i = 0; i < len; i++) data[i] = Math.random() * 2 - 1;
    return buf;
  }

  function blip(freq, duration, type, volume, sweepTo) {
    if (!ensure()) return;
    var t0 = ctx.currentTime;
    var osc = ctx.createOscillator();
    var gain = ctx.createGain();
    osc.type = type || 'sine';
    osc.frequency.setValueAtTime(freq, t0);
    if (sweepTo) osc.frequency.exponentialRampToValueAtTime(Math.max(40, sweepTo), t0 + duration);
    gain.gain.setValueAtTime(0.0001, t0);
    gain.gain.exponentialRampToValueAtTime(volume == null ? 0.25 : volume, t0 + 0.012);
    gain.gain.exponentialRampToValueAtTime(0.0001, t0 + duration);
    osc.connect(gain);
    gain.connect(master);
    osc.start(t0);
    osc.stop(t0 + duration + 0.02);
  }

  function noiseHit(duration, volume, freq, q) {
    if (!ensure()) return;
    var t0 = ctx.currentTime;
    var src = ctx.createBufferSource();
    src.buffer = noiseBuffer(duration + 0.05);
    var filter = ctx.createBiquadFilter();
    filter.type = 'bandpass';
    filter.frequency.value = freq || 1400;
    filter.Q.value = q || 0.9;
    var gain = ctx.createGain();
    gain.gain.setValueAtTime(volume == null ? 0.2 : volume, t0);
    gain.gain.exponentialRampToValueAtTime(0.0001, t0 + duration);
    src.connect(filter);
    filter.connect(gain);
    gain.connect(master);
    src.start(t0);
    src.stop(t0 + duration + 0.05);
  }

  var Audio = {
    get enabled() { return enabled; },

    toggle: function () {
      enabled = !enabled;
      if (!enabled) Audio.stopEngine();
      return enabled;
    },

    /** Must be called from a user gesture on iOS / strict autoplay policies. */
    unlock: function () {
      ensure();
    },

    /** Looping engine + sand rumble; `load` (0..1) drives pitch and grit. */
    startEngine: function () {
      if (!ensure() || started) return;
      started = true;

      var osc = ctx.createOscillator();
      osc.type = 'sawtooth';
      osc.frequency.value = 78;

      var sub = ctx.createOscillator();
      sub.type = 'square';
      sub.frequency.value = 39;

      var src = ctx.createBufferSource();
      src.buffer = noiseBuffer(2);
      src.loop = true;

      var filter = ctx.createBiquadFilter();
      filter.type = 'lowpass';
      filter.frequency.value = 420;
      filter.Q.value = 3;

      var noiseGain = ctx.createGain();
      noiseGain.gain.value = 0.05;

      var gain = ctx.createGain();
      gain.gain.value = 0.0001;
      gain.gain.exponentialRampToValueAtTime(0.16, ctx.currentTime + 0.4);

      osc.connect(filter);
      sub.connect(filter);
      src.connect(noiseGain);
      noiseGain.connect(filter);
      filter.connect(gain);
      gain.connect(master);

      osc.start();
      sub.start();
      src.start();

      engine = { osc: osc, sub: sub, noise: src, gain: gain, filter: filter, noiseGain: noiseGain };
    },

    /** load: 0 = calm cruising, 1 = on the edge of tipping over. */
    setEngineLoad: function (load) {
      if (!engine || !ctx) return;
      var l = Math.max(0, Math.min(1, load));
      var now = ctx.currentTime;
      engine.osc.frequency.setTargetAtTime(74 + l * 46, now, 0.12);
      engine.sub.frequency.setTargetAtTime(37 + l * 22, now, 0.12);
      engine.filter.frequency.setTargetAtTime(380 + l * 900, now, 0.15);
      engine.noiseGain.gain.setTargetAtTime(0.04 + l * 0.1, now, 0.15);
    },

    stopEngine: function () {
      if (!engine || !ctx) { started = false; return; }
      var now = ctx.currentTime;
      var e = engine;
      engine = null;
      started = false;
      try {
        e.gain.gain.cancelScheduledValues(now);
        e.gain.gain.setValueAtTime(Math.max(0.0001, e.gain.gain.value), now);
        e.gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.25);
        e.osc.stop(now + 0.3);
        e.sub.stop(now + 0.3);
        e.noise.stop(now + 0.3);
      } catch (err) { /* already stopped */ }
    },

    tap: function () { noiseHit(0.13, 0.13, 900, 0.7); },

    coin: function (step) {
      var n = Math.min(step || 0, 8);
      blip(880 + n * 55, 0.09, 'triangle', 0.2);
      blip(1320 + n * 70, 0.14, 'sine', 0.13);
    },

    great: function () { blip(660, 0.14, 'triangle', 0.16, 990); },

    combo: function (level) {
      var n = Math.min(level || 1, 10);
      blip(520 + n * 30, 0.12, 'square', 0.1);
      blip(780 + n * 45, 0.2, 'triangle', 0.12);
    },

    warn: function () { blip(220, 0.18, 'sawtooth', 0.12, 150); },

    crash: function () {
      noiseHit(0.55, 0.35, 260, 0.5);
      blip(150, 0.5, 'sawtooth', 0.22, 48);
    },

    countdown: function (isGo) {
      if (isGo) {
        blip(880, 0.3, 'triangle', 0.25, 1320);
      } else {
        blip(440, 0.16, 'triangle', 0.2);
      }
    },

    finish: function () {
      var notes = [523, 659, 784, 1046];
      for (var i = 0; i < notes.length; i++) {
        (function (freq, idx) {
          global.setTimeout(function () { blip(freq, 0.26, 'triangle', 0.18); }, idx * 110);
        })(notes[i], i);
      }
    }
  };

  global.DriftAudio = Audio;
})(window);
