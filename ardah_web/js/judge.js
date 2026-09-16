/* Judgment, scoring and the sync meter.

   Pure logic, no canvas and no audio: it takes a time in milliseconds and
   returns what happened. That is deliberate — this is the part that has to be
   unit-testable against a fake clock, and the part a native rewrite would port
   line for line.

   Framing note, and it is not cosmetic: nothing here calls the player a
   failure. The meter is the ROW's sync, and when it empties the row breaks
   formation. Ardah is ceremonial heritage — the tone stays respectful even in
   the loss state. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var WINDOW = { perfect: 45, good: 90, late: 140 };
  var BASE = { perfect: 300, good: 200, early: 100, late: 100, miss: 0 };
  var WEIGHT = { perfect: 1, good: 0.7, early: 0.4, late: 0.4, miss: 0 };
  var SYNC = { perfect: 4, good: 2, early: 1, late: 1, miss: -12, broken: -14 };
  var SYNC_START = 70, SYNC_MAX = 100;

  function judgmentFor(deltaMs) {
    var d = Math.abs(deltaMs);
    if (d <= WINDOW.perfect) return 'perfect';
    if (d <= WINDOW.good) return 'good';
    if (d <= WINDOW.late) return deltaMs < 0 ? 'early' : 'late';
    return null;
  }

  function Judge(chart) {
    this.notes = chart.notes.map(function (n, i) {
      return { i: i, t: n.t, lane: n.lane, type: n.type, durMs: n.durMs || 0, state: 'pending' };
    });
    this.cursor = 0;                 // first note that could still be judged
    this.score = 0;
    this.combo = 0;
    this.maxCombo = 0;
    this.sync = SYNC_START;
    this.counts = { perfect: 0, good: 0, early: 0, late: 0, miss: 0 };
    this.weighted = 0;
    this.judgments = 0;
    this.deltas = [];
    this.total = this.notes.reduce(function (sum, n) { return sum + (n.type === 'hold' ? 2 : 1); }, 0);
    this.broken = false;
  }

  Judge.prototype.multiplier = function () {
    if (this.combo >= 50) return 4;
    if (this.combo >= 25) return 3;
    if (this.combo >= 10) return 2;
    return 1;
  };

  Judge.prototype._record = function (judgment, deltaMs, note) {
    this.counts[judgment]++;
    this.judgments++;
    this.weighted += WEIGHT[judgment];
    if (judgment !== 'miss') {
      this.deltas.push(deltaMs);
      this.combo++;
      if (this.combo > this.maxCombo) this.maxCombo = this.combo;
      var base = BASE[judgment] * (note && note.type === 'flourish' ? 2 : 1);
      this.score += base * this.multiplier();
    } else {
      this.combo = 0;
    }
    this.sync = Math.max(0, Math.min(SYNC_MAX, this.sync + SYNC[judgment]));
    if (this.sync <= 0) this.broken = true;
    return { judgment: judgment, deltaMs: deltaMs, note: note, combo: this.combo, sync: this.sync };
  };

  /** Nearest still-playable note in a lane, within the widest window. */
  Judge.prototype._find = function (lane, tMs, type) {
    var best = null, bestD = WINDOW.late + 1;
    for (var i = this.cursor; i < this.notes.length; i++) {
      var n = this.notes[i];
      if (n.t - tMs > WINDOW.late) break;          // sorted: nothing further can match
      if (n.state !== 'pending') continue;
      if (type === 'flourish' ? n.type !== 'flourish' : (n.lane !== lane || n.type === 'flourish')) continue;
      var d = Math.abs(n.t - tMs);
      if (d < bestD) { bestD = d; best = n; }
    }
    return best;
  };

  /** A lane was pressed. Returns a judgment, or null for a stray tap.
      Stray taps cost nothing: punishing them turns nerves into a death spiral,
      and the sync meter already punishes what matters. */
  Judge.prototype.press = function (lane, tMs) {
    var note = this._find(lane, tMs, 'tap');
    if (!note) return null;
    var delta = tMs - note.t;
    var judgment = judgmentFor(delta);
    if (!judgment) return null;

    if (note.type === 'hold') {
      note.state = 'holding';
      note.holdJudgment = judgment;
      return this._record(judgment, delta, note);
    }
    note.state = 'hit';
    return this._record(judgment, delta, note);
  };

  /** A lane was released — only meaningful while a raise is in progress. */
  Judge.prototype.release = function (lane, tMs) {
    for (var i = this.cursor; i < this.notes.length; i++) {
      var n = this.notes[i];
      if (n.state !== 'holding' || n.lane !== lane) continue;
      var end = n.t + n.durMs;
      var delta = tMs - end;
      var judgment = judgmentFor(delta);
      if (!judgment) {
        // Let go far too early: the raise is broken.
        n.state = 'hit';
        this.counts.miss++;
        this.judgments++;
        this.combo = 0;
        this.sync = Math.max(0, this.sync + SYNC.broken);
        if (this.sync <= 0) this.broken = true;
        return { judgment: 'miss', deltaMs: delta, note: n, combo: 0, sync: this.sync, holdBroken: true };
      }
      n.state = 'hit';
      return this._record(judgment, delta, n);
    }
    return null;
  };

  Judge.prototype.flourish = function (tMs) {
    var note = this._find(-1, tMs, 'flourish');
    if (!note) return null;
    var delta = tMs - note.t;
    var judgment = judgmentFor(delta);
    if (!judgment) return null;
    note.state = 'hit';
    return this._record(judgment, delta, note);
  };

  /** Time moved on: retire notes whose window has closed. */
  Judge.prototype.update = function (tMs) {
    var events = [];
    for (var i = this.cursor; i < this.notes.length; i++) {
      var n = this.notes[i];

      if (n.state === 'pending' && tMs - n.t > WINDOW.late) {
        n.state = 'missed';
        events.push(this._record('miss', tMs - n.t, n));
      } else if (n.state === 'holding' && tMs - (n.t + n.durMs) > WINDOW.late) {
        // Held all the way through without letting go — credit it and move on.
        n.state = 'hit';
        events.push(this._record('good', 0, n));
      }

      if (i === this.cursor && (n.state === 'hit' || n.state === 'missed')) this.cursor++;
    }
    return events;
  };

  Judge.prototype.accuracy = function () {
    if (!this.total) return 0;
    return this.weighted / this.total;
  };

  Judge.prototype.grade = function () {
    var a = this.accuracy() * 100;
    if (a >= 95) return 'S';
    if (a >= 88) return 'A';
    if (a >= 78) return 'B';
    return 'C';
  };

  /** Mean signed offset and its spread — the numbers the latency lab lives on.
      A mean of −70 ms says the device is late, which calibration fixes; a wide
      spread says jitter, which calibration cannot fix. */
  Judge.prototype.timing = function () {
    var n = this.deltas.length;
    if (!n) return { mean: 0, jitter: 0, n: 0 };
    var sum = 0, i;
    for (i = 0; i < n; i++) sum += this.deltas[i];
    var mean = sum / n, varSum = 0;
    for (i = 0; i < n; i++) varSum += (this.deltas[i] - mean) * (this.deltas[i] - mean);
    return { mean: mean, jitter: Math.sqrt(varSum / n), n: n };
  };

  Judge.WINDOW = WINDOW;
  A.Judge = Judge;
})(window.Ardah);
