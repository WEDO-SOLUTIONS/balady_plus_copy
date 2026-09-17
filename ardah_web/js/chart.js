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

  /* The rest of the drum line — heard, never played.

     The three lanes are three voices, which is a game decision, not a musical
     one: a real Najdi Ardah section is the big takhmir carrying a slow pulse
     while the small thakir fill every gap between them, and it is that second
     layer that makes the thing feel fast while the big drums stay slow. Put
     the fills in the lanes and the chart becomes a 16th-note wall nobody can
     play. Leave them out and three drums a bar is a march, not an Ardah.

     So they live here instead: scheduled with everything else, on the same
     clock, and never turned into a note. `tak` is the tar's rim stroke, which
     is what stops a frame drum from repeating itself. The claps are the row's
     own hands and belong to the chorus — they are the moment the crowd joins
     in, so the verse does not get them. */
  var ORNAMENT = {
    verse: [
      ['thakir', 2, 0.52], ['thakir', 6, 0.64], ['tak', 7, 0.5],
      ['thakir', 10, 0.5], ['thakir', 13, 0.4], ['thakir', 14, 0.66]
    ],
    chorus: [
      ['thakir', 2, 0.56], ['tak', 3, 0.45], ['clap', 4, 0.75],
      ['thakir', 5, 0.42], ['thakir', 6, 0.72], ['thakir', 7, 0.38],
      ['thakir', 10, 0.56], ['tak', 11, 0.45], ['clap', 12, 0.8],
      ['thakir', 13, 0.46], ['thakir', 14, 0.74], ['thakir', 15, 0.4]
    ]
  };

  /* Which groove hits become playable notes, per difficulty: lane -> `true`
     for every slot the groove plays, or a list of slots.

     The slot lists exist because of the swords lane. Selecting it wholesale
     hands the player four clashes a bar in the chorus, which is a hard chart;
     leaving it out entirely leaves a lane that shows nothing for the first
     forty seconds and reads as broken. A couple of accents a bar is the middle
     ground, and every difficulty now uses all three lanes. */
  var PLAYABLE = {
    easy: {
      verse:  { 0: true, 1: [14] },
      chorus: { 0: true, 1: [14], 2: true }
    },
    normal: {
      verse:  { 0: true, 1: [14], 2: true },
      chorus: { 0: true, 1: [6, 14], 2: true }
    },
    hard: {
      verse:  { 0: true, 1: true, 2: true },
      chorus: { 0: true, 1: true, 2: true }
    }
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

  /* Deterministic scatter for the ornament layer.

     Drummers are not sample-accurate and a section that is sounds like a drum
     machine — but the scatter is baked into the chart here rather than applied
     at playback, so the audio stays exactly what the chart says and "the
     drums cannot drift from the chart" stays literally true.

     It is applied ONLY to ornaments. The groove hits are the cue a player is
     judged against: move one of those by 5 ms and the judging is wrong by
     5 ms, which is a bug wearing a musician's hat. */
  function human(seed) {
    var st = (seed * 2654435761) % 2147483647;
    return function (spread) {
      st = (st * 1103515245 + 12345) & 0x7fffffff;
      return (st / 0x7fffffff - 0.5) * 2 * spread;
    };
  }

  /* Adds a drum, merging anything that lands on top of it.

     Two hits of the same voice inside 12 ms are not two hits — they are one
     hit at double amplitude, perfectly in phase, 6 dB up. Three places in this
     builder used to do exactly that without meaning to: the flourish's own
     takhmir on top of the groove's slot-8 hit, its closing accent on the next
     bar's downbeat, and the hold's release marker on the same. Every chorus
     and every raise had a 6 dB spike in it that read as "loud" rather than as
     the mistake it was, and it was riding the safety limiter.

     So accents are written where they belong musically and this decides what
     that means when the groove is already there: the louder of the two, once. */
  function pushDrum(drums, t, voice, gain) {
    t = Math.round(t);
    for (var i = drums.length - 1, n = 0; i >= 0 && n < 64; i--, n++) {
      var d = drums[i];
      if (d.voice === voice && Math.abs(d.t - t) <= 12) {
        if (gain > d.gain) d.gain = gain;
        return;
      }
    }
    drums.push({ t: t, voice: voice, gain: gain });
  }

  function build(difficulty) {
    var bpm = 96;
    var beatMs = 60000 / bpm;
    var slotMs = beatMs / 4;
    var barMs = beatMs * 4;
    var playableLanes = PLAYABLE[difficulty] || PLAYABLE.normal;

    var drums = [], notes = [];
    var bar = 0;
    var jitter = human(7919);

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

          pushDrum(drums, t, VOICE_OF_LANE[lane], gain);

          if (!section.playable) continue;
          if (wantsFlourish && slot >= 8) continue;   // cleared for the flourish
          var allowed = playableLanes[section.kind][lane];
          if (!allowed) continue;
          if (allowed !== true && allowed.indexOf(slot) === -1) continue;
          notes.push({ t: Math.round(t), lane: lane, type: 'tap' });
        }

        // The fills. Cleared out of the second half of a flourish bar for the
        // same reason the groove is: the sweep needs air around it.
        var orn = ORNAMENT[section.kind];
        for (var o = 0; o < orn.length; o++) {
          var oSlot = orn[o][1];
          if (wantsHold && oSlot >= 8) continue;
          if (wantsFlourish && oSlot >= 8) continue;
          pushDrum(drums, barStart + oSlot * slotMs + jitter(5), orn[o][0],
                   +(orn[o][2] * (1 + jitter(0.09))).toFixed(3));
        }

        if (wantsHold) {
          // Two beats of raise. Underneath it the small drums roll — 8ths that
          // tighten to 16ths in the second beat, which is what a section does
          // under a held gesture. Quiet, so the takhmir hit that ends the raise
          // still reads as the target.
          var holdStart = barStart + 8 * slotMs;
          var holdDur = beatMs * 2;
          notes.push({ t: Math.round(holdStart), lane: LANE_TABL, type: 'hold', durMs: Math.round(holdDur) });
          var roll = [0, 2, 4, 5, 6, 7];               // in 16ths from the raise
          for (var r = 0; r < roll.length; r++) {
            pushDrum(drums, holdStart + roll[r] * slotMs + jitter(4), 'thakir',
                     +(0.3 + r * 0.035).toFixed(3));   // a slow crescendo
          }
          pushDrum(drums, holdStart + holdDur, 'tabl', 1);
        }

        if (wantsFlourish) {
          var fT = barStart + 8 * slotMs;
          // The flourish rides the middle lane — the swords line.
          notes.push({ t: Math.round(fT), lane: LANE_SWORDS, type: 'flourish' });
          // The row answers: the big drum under it, blades, hands, and a
          // second takhmir two beats later to close the phrase. Both takhmir
          // land where the groove is already playing one — slot 8 here, the
          // next bar's downbeat there — and pushDrum() is what keeps that from
          // becoming two drums on one sample.
          pushDrum(drums, fT, 'tabl', 1);
          pushDrum(drums, fT, 'swords', 0.9);
          pushDrum(drums, fT, 'clap', 0.8);
          pushDrum(drums, fT + beatMs, 'swords', 0.5);
          pushDrum(drums, fT + beatMs * 2, 'tabl', 0.7);
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
