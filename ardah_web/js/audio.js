/* Audio engine.

   Every sound here is SYNTHESISED in the browser — no files, no licensing, no
   download. That is a prototype decision, not a shipping one: real Ardah
   percussion and chant have to be licensed or commissioned (concept doc §11).
   It does buy three things that matter right now:
     * the chart and the drums cannot drift apart — both are scheduled on the
       same audio clock, ahead of time, sample-accurately;
     * the whole game is a few hundred KB, so the mini-app archive downloads
       instantly at an event;
     * nothing to preload means nothing to fail on a cold start.

   Three voices stand in for the Ardah percussion section:
     tabl   — the big deep drum, the pulse of the row
     swords — the ring of blades meeting on the accents
     tar    — the mid frame drum answering the tabl */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  function AudioEngine() {
    this.ctx = null;
    this.master = null;
    this.musicGain = null;
    this._noise = null;
  }

  /** Must be called from a user gesture: iOS starts every context suspended. */
  AudioEngine.prototype.unlock = function () {
    if (!this.ctx) {
      var Ctor = window.AudioContext || window.webkitAudioContext;
      if (!Ctor) return Promise.reject(new Error('WebAudio unavailable'));
      this.ctx = new Ctor();
      this.master = this.ctx.createGain();
      this.master.gain.value = 0.9;
      this.master.connect(this.ctx.destination);
      this.musicGain = this.ctx.createGain();
      this.musicGain.gain.value = 1;
      this.musicGain.connect(this.master);
      this._buildNoise();
    }
    // A context can be suspended again at any time — an incoming call, the app
    // going to background, iOS reclaiming the session (concept doc §6.3.1).
    return this.ctx.state === 'suspended' ? this.ctx.resume() : Promise.resolve();
  };

  AudioEngine.prototype._buildNoise = function () {
    var len = Math.floor(this.ctx.sampleRate * 0.5);
    var buf = this.ctx.createBuffer(1, len, this.ctx.sampleRate);
    var d = buf.getChannelData(0);
    for (var i = 0; i < len; i++) d[i] = Math.random() * 2 - 1;
    this._noise = buf;
  };

  AudioEngine.prototype._noiseSource = function () {
    var s = this.ctx.createBufferSource();
    s.buffer = this._noise;
    s.loop = true;
    return s;
  };

  /** Deep frame drum. Pitch drops fast, body rings a little. */
  AudioEngine.prototype.tabl = function (when, gain) {
    var ctx = this.ctx, g = ctx.createGain(), osc = ctx.createOscillator();
    var level = (gain === undefined ? 1 : gain) * 0.9;
    osc.type = 'sine';
    osc.frequency.setValueAtTime(128, when);
    osc.frequency.exponentialRampToValueAtTime(44, when + 0.11);
    g.gain.setValueAtTime(0.0001, when);
    g.gain.exponentialRampToValueAtTime(level, when + 0.004);
    g.gain.exponentialRampToValueAtTime(0.0001, when + 0.46);
    osc.connect(g); g.connect(this.musicGain);
    osc.start(when); osc.stop(when + 0.5);

    // A short filtered noise thump gives the skin its attack.
    var n = this._noiseSource(), nf = ctx.createBiquadFilter(), ng = ctx.createGain();
    nf.type = 'lowpass'; nf.frequency.value = 220;
    ng.gain.setValueAtTime(level * 0.5, when);
    ng.gain.exponentialRampToValueAtTime(0.0001, when + 0.09);
    n.connect(nf); nf.connect(ng); ng.connect(this.musicGain);
    n.start(when); n.stop(when + 0.12);
  };

  /** Mid frame drum — the answer to the zeer. */
  AudioEngine.prototype.tar = function (when, gain) {
    var ctx = this.ctx, level = (gain === undefined ? 1 : gain) * 0.55;
    var osc = ctx.createOscillator(), g = ctx.createGain();
    osc.type = 'triangle';
    osc.frequency.setValueAtTime(235, when);
    osc.frequency.exponentialRampToValueAtTime(120, when + 0.07);
    g.gain.setValueAtTime(0.0001, when);
    g.gain.exponentialRampToValueAtTime(level, when + 0.003);
    g.gain.exponentialRampToValueAtTime(0.0001, when + 0.2);
    osc.connect(g); g.connect(this.musicGain);
    osc.start(when); osc.stop(when + 0.22);

    var n = this._noiseSource(), nf = ctx.createBiquadFilter(), ng = ctx.createGain();
    nf.type = 'bandpass'; nf.frequency.value = 900; nf.Q.value = 0.8;
    ng.gain.setValueAtTime(level * 0.55, when);
    ng.gain.exponentialRampToValueAtTime(0.0001, when + 0.07);
    n.connect(nf); nf.connect(ng); ng.connect(this.musicGain);
    n.start(when); n.stop(when + 0.09);
  };

  /** Sword clash: a bright strike plus two detuned partials ringing out, which
      is what gives struck metal its shimmer. */
  AudioEngine.prototype.swords = function (when, gain) {
    var ctx = this.ctx, level = (gain === undefined ? 1 : gain) * 0.34;

    var n = this._noiseSource(), f = ctx.createBiquadFilter(), ng = ctx.createGain();
    f.type = 'highpass'; f.frequency.value = 2600;
    ng.gain.setValueAtTime(level * 0.9, when);
    ng.gain.exponentialRampToValueAtTime(0.0001, when + 0.07);
    n.connect(f); f.connect(ng); ng.connect(this.musicGain);
    n.start(when); n.stop(when + 0.1);

    var partials = [2410, 3170, 4630];
    for (var i = 0; i < partials.length; i++) {
      var osc = ctx.createOscillator(), g = ctx.createGain();
      osc.type = 'triangle';
      osc.frequency.value = partials[i] * (1 + (Math.random() - 0.5) * 0.01);
      g.gain.setValueAtTime(0.0001, when);
      g.gain.exponentialRampToValueAtTime(level * (i === 0 ? 0.6 : 0.3), when + 0.004);
      g.gain.exponentialRampToValueAtTime(0.0001, when + 0.55 - i * 0.12);
      osc.connect(g); g.connect(this.musicGain);
      osc.start(when); osc.stop(when + 0.6);
    }
  };

  /** Metronome click for the calibration screen — dry and unmistakable. */
  AudioEngine.prototype.click = function (when, accent) {
    var ctx = this.ctx, osc = ctx.createOscillator(), g = ctx.createGain();
    osc.type = 'square';
    osc.frequency.value = accent ? 1400 : 950;
    g.gain.setValueAtTime(0.0001, when);
    g.gain.exponentialRampToValueAtTime(0.22, when + 0.002);
    g.gain.exponentialRampToValueAtTime(0.0001, when + 0.05);
    osc.connect(g); g.connect(this.master);
    osc.start(when); osc.stop(when + 0.06);
  };

  AudioEngine.prototype.play = function (voice, when, gain) {
    if (!this.ctx) return;
    if (voice === 'tabl') this.tabl(when, gain);
    else if (voice === 'tar') this.tar(when, gain);
    else if (voice === 'swords') this.swords(when, gain);
  };

  /** Seconds between "we scheduled it" and "the player hears it", as reported
      by the browser. Used for DRAWING only — judging uses the measured
      calibration offset instead, because that also carries input latency. */
  AudioEngine.prototype.outputLatency = function () {
    if (!this.ctx) return 0;
    var l = this.ctx.outputLatency;
    if (typeof l === 'number' && isFinite(l) && l >= 0) return l;
    return this.ctx.baseLatency || 0;
  };

  A.audio = new AudioEngine();
})(window.Ardah);
