/* Charts.

   A chart is plain data — exactly the shape written down in the concept doc:
     { id, version, bpm, offsetMs, difficulty, durationMs, drums[], notes[] }
   `drums` is the backing groove (what you hear), `notes` is the subset the
   player has to hit. Both are scheduled on the same audio clock, so what you
   see, what you hear and what you are judged against can never drift apart.

   Charts are BUILT here rather than loaded from JSON on purpose: a `fetch` of
   a local .json fails under `file://`, and half the point of this prototype is
   that it opens by double-click. The generator emits the same structure a
   hand-authored JSON file would, and `validate()` is what the real loader will
   run on parsed data. */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var LANE_TABL = 0, LANE_SWORDS = 1, LANE_TAR = 2;
  var VOICE_OF_LANE = ['tabl', 'swords', 'tar'];

  /* Groove, written on a 16th-note grid: one entry per bar slot.
     slot 0 = beat 1, slot 4 = beat 2, slot 8 = beat 3, slot 12 = beat 4. */
  var GROOVE = {
    // Stately opening pulse: the big drum carries beats 1 and 3.
    verse:  [ [0, LANE_TABL, 1], [4, LANE_TAR, 0.9], [8, LANE_TABL, 0.95],
              [12, LANE_TAR, 0.9], [14, LANE_SWORDS, 0.7] ],
    // The row picks up: the drums answer each other twice as often.
    chorus: [ [0, LANE_TABL, 1], [3, LANE_SWORDS, 0.6], [4, LANE_TAR, 0.95],
              [6, LANE_SWORDS, 0.7], [8, LANE_TABL, 1], [11, LANE_SWORDS, 0.6],
              [12, LANE_TAR, 0.95], [14, LANE_SWORDS, 0.8] ]
  };

  /* Which groove hits become playable notes, per difficulty. */
  var PLAYABLE = {
    easy:   { verse: [LANE_TABL], chorus: [LANE_TABL, LANE_TAR] },
    normal: { verse: [LANE_TABL, LANE_TAR], chorus: [LANE_TABL, LANE_TAR] },
    hard:   { verse: [LANE_TABL, LANE_SWORDS, LANE_TAR], chorus: [LANE_TABL, LANE_SWORDS, LANE_TAR] }
  };

  /* Bar plan. 30 bars at 96 BPM ≈ 75 s — a run you can repeat without fatigue.
     The intro is drums only: the player listens before anything is asked. */
  var SECTIONS = [
    { kind: 'verse',  bars: 4,  playable: false },
    { kind: 'verse',  bars: 8,  playable: true  },
    { kind: 'chorus', bars: 4,  playable: true, flourishOnLastBar: true },
    { kind: 'verse',  bars: 8,  playable: true, holdOnLastBar: true },
    { kind: 'chorus', bars: 4,  playable: true, flourishOnLastBar: true },
    { kind: 'verse',  bars: 2,  playable: false }
  ];

  function build(difficulty) {
    var bpm = 96;
    var beatMs = 60000 / bpm;
    var slotMs = beatMs / 4;
    var barMs = beatMs * 4;
    var playableLanes = PLAYABLE[difficulty] || PLAYABLE.normal;

    var drums = [], notes = [];
    var bar = 0;

    for (var s = 0; s < SECTIONS.length; s++) {
      var section = SECTIONS[s];
      var groove = GROOVE[section.kind];

      for (var b = 0; b < section.bars; b++, bar++) {
        var barStart = bar * barMs;
        var isLastBar = b === section.bars - 1;
        var wantsHold = section.playable && section.holdOnLastBar && isLastBar;
        var wantsFlourish = section.playable && section.flourishOnLastBar && isLastBar;

        for (var g = 0; g < groove.length; g++) {
          var slot = groove[g][0], lane = groove[g][1], gain = groove[g][2];
          var t = barStart + slot * slotMs;

          // The hold bar swaps its second half for a sustained roll, so the
          // drums keep speaking while the player holds the raise.
          if (wantsHold && slot >= 8) continue;

          drums.push({ t: Math.round(t), voice: VOICE_OF_LANE[lane], gain: gain });

          if (!section.playable) continue;
          if (wantsFlourish && slot >= 8) continue;   // cleared for the flourish
          if (playableLanes[section.kind].indexOf(lane) === -1) continue;
          notes.push({ t: Math.round(t), lane: lane, type: 'tap' });
        }

        if (wantsHold) {
          // Two beats of raise. The roll underneath is 8th notes on the tar,
          // quiet enough that the zeer hit at the end still reads as the target.
          var holdStart = barStart + 8 * slotMs;
          var holdDur = beatMs * 2;
          notes.push({ t: Math.round(holdStart), lane: LANE_TABL, type: 'hold', durMs: Math.round(holdDur) });
          for (var r = 0; r < 4; r++) {
            drums.push({ t: Math.round(holdStart + r * (beatMs / 2)), voice: 'tar', gain: 0.35 });
          }
          drums.push({ t: Math.round(holdStart + holdDur), voice: 'tabl', gain: 1 });
        }

        if (wantsFlourish) {
          var fT = barStart + 8 * slotMs;
          // The flourish rides the middle lane — the swords line.
          notes.push({ t: Math.round(fT), lane: LANE_SWORDS, type: 'flourish' });
          drums.push({ t: Math.round(fT), voice: 'tabl', gain: 1 });
          drums.push({ t: Math.round(fT), voice: 'swords', gain: 1 });
          drums.push({ t: Math.round(fT + beatMs), voice: 'swords', gain: 0.5 });
        }
      }
    }

    drums.sort(byTime);
    notes.sort(byTime);

    var chart = {
      id: 'ardah_najdi_' + difficulty,
      version: 1,
      bpm: bpm,
      offsetMs: 0,          // synthesised percussion starts exactly on time
      difficulty: difficulty,
      bars: bar,
      durationMs: bar * barMs + 1500,
      titleEn: 'Najdi groove',
      titleAr: 'إيقاع نجدي',
      drums: drums,
      notes: notes
    };
    validate(chart);
    return chart;
  }

  function byTime(a, b) { return a.t - b.t; }

  /* A malformed chart must fail loudly at load, never halfway through a run. */
  function validate(chart) {
    if (!chart || !chart.notes || !chart.drums) throw new Error('chart: missing tracks');
    if (!(chart.bpm > 0)) throw new Error('chart: bad bpm');

    var lastHoldEnd = [-1, -1, -1];
    var prevT = -1;

    for (var i = 0; i < chart.notes.length; i++) {
      var n = chart.notes[i];
      if (!(n.t >= 0)) throw new Error('chart: note ' + i + ' has no time');
      if (n.t < prevT) throw new Error('chart: notes are not sorted at ' + i);
      prevT = n.t;
      if (n.lane < 0 || n.lane > 2) throw new Error('chart: note ' + i + ' lane out of range');
      if (n.type !== 'tap' && n.type !== 'hold' && n.type !== 'flourish') {
        throw new Error('chart: note ' + i + ' unknown type ' + n.type);
      }
      if (n.type === 'hold') {
        if (!(n.durMs > 0)) throw new Error('chart: hold ' + i + ' has no duration');
        if (n.t < lastHoldEnd[n.lane]) throw new Error('chart: overlapping holds in lane ' + n.lane);
        lastHoldEnd[n.lane] = n.t + n.durMs;
      }
    }
    return chart;
  }

  A.charts = {
    LANE_TABL: LANE_TABL, LANE_SWORDS: LANE_SWORDS, LANE_TAR: LANE_TAR,
    VOICE_OF_LANE: VOICE_OF_LANE,
    build: build,
    validate: validate,
    all: function () { return [build('easy'), build('normal'), build('hard')]; }
  };
})(window.Ardah);
