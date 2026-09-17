/* Drift the Desert — game model.

   Pure logic: balance physics, scoring, combo, coins and run lifecycle. It
   owns no DOM; it emits events that main.js turns into HUD updates and FX, so
   the rules can be unit-tested or replayed headlessly. */
(function (global) {
  'use strict';

  var CONFIG = {
    runSeconds: 60,

    // Balance model. `tilt` is -1 (about to flip onto its side, "too far
    // left") .. +1 (dropping back onto four wheels, "too far right"); 0 is the
    // sweet spot of a two-wheel drift.
    zoneGreat: 0.30,
    zoneGood: 0.58,
    tiltFail: 1.0,

    instabilityStart: 1.05,   // how hard the car pushes away from balance
    instabilityEnd: 2.15,     // …at the end of the run
    gustStart: 0.10,
    gustEnd: 0.42,
    damping: 1.55,
    tapImpulse: 0.62,
    tapMaxVel: 1.45,

    // Scoring — tuned so a clean 60 s run lands in the 4 000–4 500 range,
    // matching the numbers shown in the design.
    scoreBase: 36,
    scorePerCombo: 2,
    goodZoneFactor: 0.55,
    comboEvery: 2.0,          // seconds inside the safe zone per combo step
    greatPopEvery: 1.6,

    coinEvery: 1.45,
    coinTravel: 2.6,          // seconds from horizon to the car
    coinValue: 1,
    coinScore: 25,

    speedBase: 260,
    speedPerCombo: 9,
    speedMax: 700,

    tokensPerScore: 1 / 60,
    tokensPerCoin: 2,
    xpPerLevel: 500,
    badgeScore: 1500,
    skinLevel: 3
  };

  function clamp(v, a, b) { return v < a ? a : (v > b ? b : v); }

  function Game(opts) {
    this.on = (opts && opts.onEvent) || function () {};
    this.config = CONFIG;
    this.reset();
  }

  Game.prototype.reset = function () {
    this.state = 'idle';        // idle | countdown | running | paused | over
    this.time = 0;
    this.score = 0;
    this.combo = 0;
    this.maxCombo = 0;
    this.coins = 0;
    this.tilt = 0;
    this.vel = 0;
    this.zone = 'great';
    this.danger = 0;
    this.safeTimer = 0;
    this.popTimer = 0;
    this.coinTimer = 0.9;
    this.countdownLeft = 0;
    this.countdownShown = -1;
    this.crashed = false;
    this.items = [];            // live coins travelling towards the camera
    this.gustPhase = [Math.random() * 10, Math.random() * 10, Math.random() * 10];
    this.lastZone = 'great';
  };

  Game.prototype.emit = function (name, payload) {
    this.on(name, payload || {});
  };

  /* ------------------------------------------------------------- input */

  Game.prototype.tap = function (dir) {
    if (this.state !== 'running') return false;
    // Tapping LEFT pushes the car back to the right and vice versa.
    this.vel += (dir === 'left' ? 1 : -1) * CONFIG.tapImpulse;
    this.vel = clamp(this.vel, -CONFIG.tapMaxVel, CONFIG.tapMaxVel);
    this.emit('tap', { dir: dir });
    return true;
  };

  /** Optional accelerometer steering: value in -1..1. */
  Game.prototype.steer = function (value) {
    if (this.state !== 'running') return;
    this.vel += clamp(value, -1, 1) * 1.6 * (1 / 60);
  };

  /* --------------------------------------------------------- lifecycle */

  Game.prototype.startCountdown = function (from) {
    this.reset();
    this.state = 'countdown';
    this.countdownLeft = (from == null ? 3 : from);
    this.emit('countdown', { value: Math.ceil(this.countdownLeft) });
    this.countdownShown = Math.ceil(this.countdownLeft);
  };

  Game.prototype.pause = function () {
    if (this.state !== 'running') return false;
    this.state = 'paused';
    this.emit('pause', {});
    return true;
  };

  Game.prototype.resume = function () {
    if (this.state !== 'paused') return false;
    this.state = 'running';
    this.emit('resume', {});
    return true;
  };

  Game.prototype.finish = function (crashed) {
    if (this.state === 'over') return;
    this.state = 'over';
    this.crashed = !!crashed;
    this.emit('finish', this.result());
  };

  Game.prototype.result = function () {
    var tokens = Math.round(this.score * CONFIG.tokensPerScore) + this.coins * CONFIG.tokensPerCoin;
    return {
      score: Math.round(this.score),
      time: this.time,
      combo: this.maxCombo,
      coins: this.coins,
      tokens: tokens,
      crashed: this.crashed,
      completed: !this.crashed
    };
  };

  /* ------------------------------------------------------------ update */

  Game.prototype.difficulty = function () {
    return clamp(this.time / CONFIG.runSeconds, 0, 1);
  };

  Game.prototype.speed = function () {
    return Math.min(
      CONFIG.speedMax,
      CONFIG.speedBase + this.combo * CONFIG.speedPerCombo + this.difficulty() * 140
    );
  };

  Game.prototype.update = function (dt) {
    if (this.state === 'countdown') {
      this.countdownLeft -= dt;
      var shown = Math.ceil(this.countdownLeft);
      if (shown !== this.countdownShown) {
        this.countdownShown = shown;
        if (shown > 0) {
          this.emit('countdown', { value: shown });
        } else {
          this.state = 'running';
          this.emit('countdown', { value: 0 });
          this.emit('start', {});
        }
      }
      return;
    }

    if (this.state !== 'running') return;

    this.time += dt;
    var diff = this.difficulty();

    /* --- balance physics ------------------------------------------------ */
    var k = CONFIG.instabilityStart + (CONFIG.instabilityEnd - CONFIG.instabilityStart) * diff;
    var gustAmp = CONFIG.gustStart + (CONFIG.gustEnd - CONFIG.gustStart) * diff;
    var g =
      Math.sin(this.time * 0.83 + this.gustPhase[0]) * 0.55 +
      Math.sin(this.time * 1.97 + this.gustPhase[1]) * 0.30 +
      Math.sin(this.time * 3.41 + this.gustPhase[2]) * 0.15;

    // Unstable equilibrium: the further off balance, the harder it pulls.
    this.vel += (k * this.tilt + gustAmp * g) * dt;
    this.vel -= this.vel * CONFIG.damping * dt;
    this.tilt += this.vel * dt;

    if (Math.abs(this.tilt) >= CONFIG.tiltFail) {
      this.tilt = clamp(this.tilt, -1.15, 1.15);
      this.emit('crash', { side: this.tilt < 0 ? 'left' : 'right' });
      this.finish(true);
      return;
    }

    /* --- zones ---------------------------------------------------------- */
    var a = Math.abs(this.tilt);
    var zone = a < CONFIG.zoneGreat ? 'great' : (a < CONFIG.zoneGood ? 'good' : 'danger');
    this.zone = zone;
    this.danger = clamp((a - CONFIG.zoneGood) / (CONFIG.tiltFail - CONFIG.zoneGood), 0, 1);

    if (zone !== this.lastZone) {
      this.emit('zone', { zone: zone, side: this.tilt < 0 ? 'left' : 'right' });
      this.lastZone = zone;
    }

    /* --- scoring & combo ------------------------------------------------ */
    if (zone === 'danger') {
      if (this.combo !== 0) {
        this.combo = 0;
        this.emit('comboLost', {});
      }
      this.safeTimer = 0;
      this.popTimer = 0;
    } else {
      var factor = zone === 'great' ? 1 : CONFIG.goodZoneFactor;
      this.score += (CONFIG.scoreBase + this.combo * CONFIG.scorePerCombo) * factor * dt;

      // Only a tight drift builds the combo; merely staying upright holds it.
      if (zone === 'great') this.safeTimer += dt;
      if (this.safeTimer >= CONFIG.comboEvery) {
        this.safeTimer -= CONFIG.comboEvery;
        this.combo += 1;
        this.maxCombo = Math.max(this.maxCombo, this.combo);
        this.emit('combo', { combo: this.combo });
      }

      if (zone === 'great') {
        this.popTimer += dt;
        if (this.popTimer >= CONFIG.greatPopEvery) {
          this.popTimer = 0;
          var bonus = 10 + this.combo;
          this.score += bonus;
          this.emit('great', { points: bonus, perfect: a < CONFIG.zoneGreat * 0.4 });
        }
      } else {
        this.popTimer = 0;
      }
    }

    /* --- coins ---------------------------------------------------------- */
    this.coinTimer -= dt;
    if (this.coinTimer <= 0) {
      this.coinTimer = CONFIG.coinEvery * (0.75 + Math.random() * 0.6);
      var lane = [-1, 0, 1][Math.floor(Math.random() * 3)];
      this.items.push({ d: 0.02, lane: lane, spin: Math.random() * 6, taken: false });
    }

    for (var i = this.items.length - 1; i >= 0; i--) {
      var it = this.items[i];
      it.d += dt / CONFIG.coinTravel;
      it.spin += dt * 4.2;

      if (!it.taken && it.d >= 0.86) {
        // You collect a coin by leaning towards it — which is exactly what
        // pulls you out of balance. That tension is the game.
        var reach = it.lane === 0 ? Math.abs(this.tilt) < 0.2 : (it.lane < 0 ? this.tilt < -0.18 : this.tilt > 0.18);
        if (reach) {
          it.taken = true;
          this.coins += CONFIG.coinValue;
          this.score += CONFIG.coinScore;
          this.emit('coin', { lane: it.lane, total: this.coins, score: CONFIG.coinScore });
        }
      }

      if (it.d >= 1.0) this.items.splice(i, 1);
    }

    /* --- end of run ------------------------------------------------------ */
    if (this.time >= CONFIG.runSeconds) {
      this.time = CONFIG.runSeconds;
      this.finish(false);
    }
  };

  /* ------------------------------------------------------- persistence */

  Game.progress = {
    load: function () {
      var store = global.DriftBridge && global.DriftBridge.store;
      return {
        best: store ? store.get('best', 0) : 0,
        tokens: store ? store.get('tokens', 0) : 0,
        xp: store ? store.get('xp', 0) : 0,
        level: store ? store.get('level', 1) : 1,
        badge: store ? store.get('badge', false) : false,
        skin: store ? store.get('skin', false) : false,
        runs: store ? store.get('runs', 0) : 0
      };
    },

    /** Applies a finished run and reports what is newly unlocked. */
    apply: function (run) {
      var store = global.DriftBridge && global.DriftBridge.store;
      var p = Game.progress.load();

      var newBest = run.score > p.best;
      var xp = p.xp + run.tokens;
      var level = p.level;
      var leveledUp = false;
      while (xp >= CONFIG.xpPerLevel) {
        xp -= CONFIG.xpPerLevel;
        level += 1;
        leveledUp = true;
      }

      var badgeUnlocked = !p.badge && run.score >= CONFIG.badgeScore;
      var skinUnlocked = !p.skin && level >= CONFIG.skinLevel;

      var next = {
        best: Math.max(p.best, run.score),
        tokens: p.tokens + run.tokens,
        xp: xp,
        level: level,
        badge: p.badge || badgeUnlocked,
        skin: p.skin || skinUnlocked,
        runs: p.runs + 1
      };

      if (store) {
        for (var key in next) {
          if (Object.prototype.hasOwnProperty.call(next, key)) store.set(key, next[key]);
        }
      }

      return {
        progress: next,
        newBest: newBest,
        leveledUp: leveledUp,
        badgeUnlocked: badgeUnlocked,
        skinUnlocked: skinUnlocked,
        xpMax: CONFIG.xpPerLevel
      };
    }
  };

  Game.CONFIG = CONFIG;
  global.DriftGame = Game;
})(window);
