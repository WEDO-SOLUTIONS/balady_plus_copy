/* Audio engine — the Ardah drum line, synthesised.

   Every sound here is SYNTHESISED in the browser — no files, no licensing, no
   download. That is a prototype decision, not a shipping one: real Ardah
   percussion has to be licensed or commissioned (concept doc §11.2). It buys
   three things that matter right now:
     * the chart and the drums cannot drift apart — both are scheduled on the
       same audio clock, ahead of time, sample-accurately;
     * the whole game is a few hundred KB, so the mini-app archive downloads
       instantly at an event;
     * nothing to preload means nothing to fail on a cold start.

   WHAT IS BEING IMITATED

   The Najdi Ardah drum line is not one drum. It is a section, and the sound is
   the interplay between two sizes:

     takhmir  the big double-headed drums, struck with a curved stick on one
              head and the hand on the other. They carry the slow, heavy pulse
              and almost nothing else. This is the sound you hear from across
              the square.
     thakir   the smaller, tighter, higher drums. They fill everything between
              the big hits with a rolling figure, and they are what makes the
              tempo feel fast while the takhmir stays slow.
     tar      the frame drum, with its two strokes: a round `dum` in the centre
              of the skin and a dry `tak` at the rim.

   And it is a CROWD: a row of men, outdoors, in a courtyard. Three things in
   here exist for that alone and matter as much as the drums — the ensemble
   spread on the claps, the courtyard reverb, and the fact that no two hits are
   quite identical.

   WHAT IS NOT IMITATED, ON PURPOSE

   The chanted poem. It is the heart of a real Ardah and it is exactly what the
   concept doc flags twice: the chant needs explicit rights (§11.2), and a
   mis-scanned chant is a PR incident rather than a bug (§11.1). A synthetic
   voice singing approximate Arabic would be the worst of both. The percussion
   is synthesised; the voice gets licensed or commissioned, or it does not
   appear. Hand-claps are in, because a clap has no scansion.

   HOW THE DRUMS ARE MADE

   Not oscillators with an envelope — that is what a drum machine sounds like.
   A struck skin is:

     * a set of INHARMONIC modes. A circular membrane rings at 1, 1.594, 2.136,
       2.296, 2.653, ... times its fundamental (the zeros of a Bessel function),
       not at 1, 2, 3. That ratio set is why a drum has a pitch you can almost
       name but never quite;
     * a PITCH DROP at the strike. The blow stretches the skin, so it starts
       sharp and settles within a few tens of milliseconds. Take this out and
       the biggest drum in the world sounds like a sine wave;
     * a TRANSIENT that is not the skin at all — stick on hide, hand on rim —
       which is most of what tells you how it was hit;
     * a BODY: the shell and the air inside it, ringing around one frequency.

   `_skin()` below is those four things and every drum is a call to it. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  /* Bessel ratios for a circular membrane (0,1), (1,1), (2,1), (0,2), (3,1).
     A real drum has a shell and a column of air behind the skin, both of which
     pull the upper modes down — hence the mild flattening, not the textbook
     numbers. */
  var MODES = [1, 1.57, 2.09, 2.24, 2.58];

  function AudioEngine() {
    this.ctx = null;
    this.master = null;
    this.musicGain = null;
    this.dry = null;
    this.wet = null;
    this._noise = null;
    this._muted = false;
    this._seed = 0x2f6e2b1;
  }

  /* A deterministic PRNG. Every "human" variation in here — the spread on a
     clap, the detune on a skin — comes from this and not from Math.random, so
     a bug reproduces and two runs of the offline renderer are byte-identical. */
  AudioEngine.prototype._rnd = function () {
    this._seed = (this._seed * 1103515245 + 12345) & 0x7fffffff;
    return this._seed / 0x7fffffff;
  };

  /** Must be called from a user gesture: iOS starts every context suspended. */
  AudioEngine.prototype.unlock = function () {
    if (!this.ctx) {
      var Ctor = window.AudioContext || window.webkitAudioContext;
      if (!Ctor) return Promise.reject(new Error('WebAudio unavailable'));
      this.build(new Ctor());
    }
    // A context can be suspended again at any time — an incoming call, the app
    // going to background, iOS reclaiming the session (concept doc §6.3.1).
    return this.ctx.state === 'suspended' ? this.ctx.resume() : Promise.resolve();
  };

  /* Builds the bus on a context handed in from outside. Separated from
     unlock() so an OfflineAudioContext can render the same engine to a file
     (deck/audio_preview.js) — the renderer has to be the real thing or it is
     not evidence of anything.

       voice ──┬── dry ──────────────────────┐
               └── send ── courtyard ── wet ─┴── music ── glue ── master ── stop ── out

     The glue compressor sits AFTER the music bus so muting still silences
     everything, and the calibration click hangs off master so it bypasses it —
     that screen measures the device and must not be mixed.

     `stop` is a safety limiter and the last thing in the chain, click
     included. Drums, a clap and a courtyard tail can line up on a flourish,
     and a phone speaker turns a sample over 0 dBFS into a crackle the player
     hears as a broken game.

     It is a net, not a mixing tool, and the gain staging is set so it hangs
     unused: the loudest moment in the song (the flourish, measured offline
     with the limiter bypassed) peaks at -2.1 dBFS against a -1 dBFS
     threshold. Anything that does engage it is a bug upstream — that is how
     the doubled takhmir in chart.js was found. */
  AudioEngine.prototype.build = function (ctx) {
    this.ctx = ctx;

    var stop = ctx.createDynamicsCompressor();
    stop.threshold.value = -1;
    stop.knee.value = 0;
    stop.ratio.value = 20;
    stop.attack.value = 0.002;
    stop.release.value = 0.12;
    stop.connect(ctx.destination);

    this.master = ctx.createGain();
    this.master.gain.value = 0.62;

    // Gentle and slow: this is glue, not loudness. A fast compressor would
    // duck the thakir fills under every takhmir hit and flatten the section
    // into one drum, which is the opposite of the point.
    var comp = ctx.createDynamicsCompressor();
    comp.threshold.value = -16;
    comp.knee.value = 26;
    comp.ratio.value = 2.6;
    comp.attack.value = 0.012;
    comp.release.value = 0.28;
    comp.connect(this.master);
    this.master.connect(stop);

    this.musicGain = ctx.createGain();
    this.musicGain.gain.value = this._muted ? 0.0001 : 1;
    this.musicGain.connect(comp);

    this.dry = ctx.createGain();
    this.dry.gain.value = 1;
    this.dry.connect(this.musicGain);

    var conv = ctx.createConvolver();
    conv.buffer = this._courtyard();
    this.wet = ctx.createGain();
    this.wet.gain.value = 0.34;         // send level; the IR itself is quiet
    this.wet.connect(conv);
    conv.connect(this.musicGain);

    this._buildNoise();
    return this;
  };

  /* The courtyard. An Ardah happens outdoors between stone walls, and a drum
     line recorded dry sounds like a drum line in a booth — the space is part of
     what people recognise.

     Synthesised rather than sampled, for the same reason as everything else
     here: an impulse response is a file. Noise under an exponential decay is
     the standard cheap IR, and two details make it a courtyard rather than a
     hall: a handful of discrete early reflections in the first 60 ms (walls
     close enough to hear individually) and a tail that darkens as it decays,
     because air and stone eat treble first. 1.1 s, which is a square, not a
     cathedral. */
  AudioEngine.prototype._courtyard = function () {
    var ctx = this.ctx, sr = ctx.sampleRate;
    var len = Math.floor(sr * 1.1);
    var buf = ctx.createBuffer(2, len, sr);
    for (var c = 0; c < 2; c++) {
      var d = buf.getChannelData(c);
      var lp = 0;
      for (var i = 0; i < len; i++) {
        var t = i / len;
        // Darken with time: the one-pole coefficient closes as the tail decays.
        var a = 0.62 - 0.45 * t;
        lp += a * ((this._rnd() * 2 - 1) - lp);
        d[i] = lp * Math.pow(1 - t, 2.7) * 0.5;
      }
      // Early reflections — the near walls, a few milliseconds apart and
      // different per channel so the space has width.
      var taps = [0.011, 0.019, 0.028, 0.041, 0.057];
      for (var k = 0; k < taps.length; k++) {
        var idx = Math.floor(sr * (taps[k] + c * 0.0035));
        if (idx < len) d[idx] += (k % 2 ? -1 : 1) * (0.55 - k * 0.08);
      }
    }
    return buf;
  };

  AudioEngine.prototype._buildNoise = function () {
    var len = Math.floor(this.ctx.sampleRate * 0.5);
    var buf = this.ctx.createBuffer(1, len, this.ctx.sampleRate);
    var d = buf.getChannelData(0);
    for (var i = 0; i < len; i++) d[i] = this._rnd() * 2 - 1;
    this._noise = buf;
  };

  AudioEngine.prototype._noiseSource = function () {
    var s = this.ctx.createBufferSource();
    s.buffer = this._noise;
    s.loop = true;
    return s;
  };

  /* Starts a noise source somewhere else in the buffer every time. Half a
     second of noise played from the top on every hit is a half-second loop,
     and a loop that lands on the beat is a tone. */
  AudioEngine.prototype._noiseAt = function (n, when, dur) {
    n.start(when, this._rnd() * 0.4);
    n.stop(when + dur);
  };

  /* Routes a source to both the dry bus and the courtyard send. `send` is per
     voice: the big drums carry the room, the tar sits closer, the stick
     transients stay dry or the whole thing turns to mush. */
  AudioEngine.prototype._out = function (node, send) {
    node.connect(this.dry);
    if (send > 0) {
      var s = this.ctx.createGain();
      s.gain.value = send;
      node.connect(s);
      s.connect(this.wet);
    }
  };

  /* One struck skin. See the header for why it is built this way.

       f0     fundamental of the membrane, Hz
       glide  how far above f0 the strike starts (1.6 = a major sixth sharp)
       glideT how long it takes to settle, seconds
       modes  how many Bessel modes to run, and how fast each one dies
       decay  decay of the fundamental, seconds; upper modes die faster, which
              is what a skin does and why a drum darkens as it rings */
  AudioEngine.prototype._skin = function (o) {
    var ctx = this.ctx, when = o.when, level = o.level;
    for (var i = 0; i < o.modes; i++) {
      var ratio = MODES[i];
      var osc = ctx.createOscillator(), g = ctx.createGain();
      osc.type = 'sine';
      // Each mode is detuned by a hair. Real skins are not perfectly circular
      // and no two hits land in the same place; without this, three drums on
      // the same beat phase-lock and sound like one loud drum.
      var det = 1 + (this._rnd() - 0.5) * 0.012;
      osc.frequency.setValueAtTime(o.f0 * ratio * o.glide * det, when);
      osc.frequency.exponentialRampToValueAtTime(o.f0 * ratio * det, when + o.glideT);

      var amp = level * Math.pow(0.52, i);           // upper modes quieter
      var dec = o.decay * Math.pow(0.44, i);         // ... and shorter
      g.gain.setValueAtTime(0.0001, when);
      g.gain.exponentialRampToValueAtTime(amp, when + 0.003);
      g.gain.exponentialRampToValueAtTime(0.0001, when + dec);
      osc.connect(g);
      this._out(g, o.send);
      osc.start(when);
      osc.stop(when + dec + 0.02);
    }

    // The strike itself: stick on hide, or a palm. Short, band-limited, and
    // most of what identifies the drum.
    if (o.hit > 0) {
      var n = this._noiseSource(), f = ctx.createBiquadFilter(), ng = ctx.createGain();
      f.type = 'bandpass';
      f.frequency.value = o.hitHz;
      f.Q.value = o.hitQ || 0.7;
      ng.gain.setValueAtTime(level * o.hit, when);
      ng.gain.exponentialRampToValueAtTime(0.0001, when + o.hitT);
      n.connect(f); f.connect(ng);
      this._out(ng, o.send * 0.5);
      this._noiseAt(n, when, o.hitT + 0.02);
    }

    // The shell and the air inside it.
    if (o.body > 0) {
      var bn = this._noiseSource(), bf = ctx.createBiquadFilter(), bg = ctx.createGain();
      bf.type = 'bandpass';
      bf.frequency.value = o.bodyHz;
      bf.Q.value = 3.2;
      bg.gain.setValueAtTime(level * o.body, when);
      bg.gain.exponentialRampToValueAtTime(0.0001, when + o.bodyT);
      bn.connect(bf); bf.connect(bg);
      this._out(bg, o.send);
      this._noiseAt(bn, when, o.bodyT + 0.02);
    }
  };

  /** Takhmir — the big double-headed drum, stick on one head, hand on the
      other. Slow, heavy, and almost the only thing audible from a distance.

      The wide pitch drop (starts a fifth and a half sharp, settles over 55 ms)
      is the whole character: it is why a big drum sounds struck rather than
      played. */
  AudioEngine.prototype.tabl = function (when, gain) {
    var level = (gain === undefined ? 1 : gain) * 0.82;
    this._skin({
      when: when, level: level, f0: 63, glide: 2.4, glideT: 0.055,
      modes: 3, decay: 0.62,
      hit: 0.55, hitHz: 1150, hitQ: 0.55, hitT: 0.016,   // the stick
      body: 0.26, bodyHz: 96, bodyT: 0.20,               // the shell
      send: 0.85
    });
  };

  /** Thakir — the small tight drum that fills between the takhmir. High,
      dry and quick; it is the reason an Ardah feels fast while the big drums
      stay slow. */
  AudioEngine.prototype.thakir = function (when, gain) {
    var level = (gain === undefined ? 1 : gain) * 0.42;
    this._skin({
      when: when, level: level, f0: 196, glide: 1.7, glideT: 0.018,
      modes: 4, decay: 0.15,
      hit: 0.75, hitHz: 2300, hitQ: 0.85, hitT: 0.010,
      body: 0.12, bodyHz: 420, bodyT: 0.05,
      send: 0.5
    });
  };

  /** Tar — the frame drum, centre stroke (`dum`): round, short, no shell to
      speak of, so almost all skin. */
  AudioEngine.prototype.tar = function (when, gain) {
    var level = (gain === undefined ? 1 : gain) * 0.5;
    this._skin({
      when: when, level: level, f0: 142, glide: 1.9, glideT: 0.026,
      modes: 3, decay: 0.26,
      hit: 0.5, hitHz: 1500, hitQ: 0.7, hitT: 0.013,
      body: 0.10, bodyHz: 260, bodyT: 0.07,
      send: 0.6
    });
  };

  /** Tar — rim stroke (`tak`): the same frame hit at the edge, where the skin
      barely moves. Nearly all transient, a flick of pitch, and dry in about
      60 ms -- what you hear after that is the courtyard, not the drum. The
      pair is what makes a frame drum speak rather than repeat. */
  AudioEngine.prototype.tak = function (when, gain) {
    var level = (gain === undefined ? 1 : gain) * 0.4;
    this._skin({
      when: when, level: level * 0.45, f0: 330, glide: 1.4, glideT: 0.010,
      modes: 2, decay: 0.055,
      hit: 1.5, hitHz: 3100, hitQ: 0.5, hitT: 0.012,
      body: 0, bodyHz: 0, bodyT: 0,
      send: 0.42
    });
  };

  /** The row's hands. A clap is easy; twenty people clapping is the point.

      One clap is a short band of noise. A row is that same clap fired a dozen
      times across ~28 ms with scattered levels and filter centres — the spread
      IS the crowd, and it is why this cannot just be one loud clap. Tight
      enough to still land on a beat, loose enough that nobody is a machine.

      The level looks high next to the drums and is not: eleven scattered claps
      are summed with a 1/sqrt(n) normalisation, because they do not add
      coherently the way two drums on one sample do. Measured alone the row
      lands well under the takhmir, which is where a row's hands belong. */
  AudioEngine.prototype.clap = function (when, gain) {
    var ctx = this.ctx, level = (gain === undefined ? 1 : gain) * 1.15;
    var hands = 11;
    for (var i = 0; i < hands; i++) {
      var t = when + Math.pow(this._rnd(), 1.5) * 0.028;
      var n = this._noiseSource(), f = ctx.createBiquadFilter(), g = ctx.createGain();
      f.type = 'bandpass';
      f.frequency.value = 1250 + this._rnd() * 1500;
      f.Q.value = 0.9 + this._rnd() * 0.7;
      var amp = level * (0.35 + this._rnd() * 0.65) / Math.sqrt(hands);
      g.gain.setValueAtTime(amp, t);
      g.gain.exponentialRampToValueAtTime(0.0001, t + 0.035 + this._rnd() * 0.03);
      n.connect(f); f.connect(g);
      this._out(g, 0.8);               // claps carry the room more than anything
      this._noiseAt(n, t, 0.08);
    }
  };

  /** Sabres. Raised and touched on the accent, never clashed — the dance is
      ceremonial and the sound has to stay that side of the line, so this is a
      blade tapped, not a fight.

      Struck steel is inharmonic in a way no ratio describes, so the partials
      are deliberately unrelated, and two of them sit close enough to beat
      against each other — that slow throb is what says metal. */
  AudioEngine.prototype.swords = function (when, gain) {
    var ctx = this.ctx, level = (gain === undefined ? 1 : gain) * 0.26;

    var n = this._noiseSource(), f = ctx.createBiquadFilter(), ng = ctx.createGain();
    f.type = 'highpass'; f.frequency.value = 3200;
    ng.gain.setValueAtTime(level * 0.8, when);
    ng.gain.exponentialRampToValueAtTime(0.0001, when + 0.045);
    n.connect(f); f.connect(ng);
    this._out(ng, 0.5);
    this._noiseAt(n, when, 0.07);

    var partials = [2570, 2612, 3890, 5310, 6740];
    for (var i = 0; i < partials.length; i++) {
      var osc = ctx.createOscillator(), g = ctx.createGain();
      osc.type = 'sine';
      osc.frequency.value = partials[i] * (1 + (this._rnd() - 0.5) * 0.004);
      var amp = level * (i < 2 ? 0.5 : 0.26 / i);
      g.gain.setValueAtTime(0.0001, when);
      g.gain.exponentialRampToValueAtTime(amp, when + 0.003);
      g.gain.exponentialRampToValueAtTime(0.0001, when + 0.9 - i * 0.13);
      osc.connect(g);
      this._out(g, 0.7);
      osc.start(when); osc.stop(when + 1.0);
    }
  };

  /** Mutes the music bus — the drums and everything else the chart plays.
      Deliberately NOT the master: the calibration metronome hangs off the
      master directly, because that screen exists to measure the device's audio
      and silencing it would make the measurement impossible.

      Timing is untouched either way. The conductor runs off the audio clock and
      keeps scheduling on mute, so a muted run is judged exactly like a loud
      one. */
  AudioEngine.prototype.setMuted = function (muted) {
    this._muted = !!muted;
    if (!this.musicGain) return;                 // applied when the context opens
    var g = this.musicGain.gain, t = this.ctx.currentTime;
    g.cancelScheduledValues(t);
    g.setValueAtTime(Math.max(0.0001, g.value), t);
    // A ramp, not a jump: cutting a gain to zero mid-sample clicks.
    g.exponentialRampToValueAtTime(this._muted ? 0.0001 : 1, t + 0.09);
  };

  AudioEngine.prototype.isMuted = function () { return this._muted; };

  /** Metronome click for the calibration screen — dry and unmistakable. Not a
      drum on purpose: the player is being asked to tap an edge, and every
      quality that makes a drum sound like a drum (the pitch drop, the room,
      the soft attack) blurs exactly that edge. */
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
    else if (voice === 'thakir') this.thakir(when, gain);
    else if (voice === 'tar') this.tar(when, gain);
    else if (voice === 'tak') this.tak(when, gain);
    else if (voice === 'clap') this.clap(when, gain);
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

  A.AudioEngine = AudioEngine;
  A.audio = new AudioEngine();
})(window.Ardah);
