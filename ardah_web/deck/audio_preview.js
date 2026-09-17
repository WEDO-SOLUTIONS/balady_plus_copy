/* Render the game's drum line to a WAV, offline.

   The point is that this is not a mock-up of the audio: it loads the real
   page, builds the real AudioEngine on an OfflineAudioContext, and schedules
   the real chart through the same code path the conductor uses at runtime. If
   it sounds wrong here it sounds wrong in the game, and vice versa.

   Offline rather than through a speaker for three reasons: it renders faster
   than real time, the sandbox has no audio device, and OfflineAudioContext is
   deterministic — combined with the engine's seeded PRNG, two runs produce
   byte-identical files, so a change to the synthesis can be diffed.

     node deck/audio_preview.js                 # needs the game served on 8123

   Writes deck/out/ardah_<section>.wav. */
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const path = require('path');

const OUT = path.join(__dirname, 'out');
const URL = 'http://localhost:8123/index.html';
const RATE = 44100;

/* Which stretches of the chart to render. The song is 30 bars at 96 BPM, so a
   bar is 2.5 s: bars 0-3 are the drums-only intro, 4-11 the verse, 12-15 the
   chorus with the flourish on its last bar, and the raise sits in bar 23. */
const CLIPS = [
  { name: 'intro_verse', from: 0, to: 20 },
  { name: 'chorus', from: 28, to: 44 },
  { name: 'raise', from: 55, to: 68 },
];

/* Wraps already-interleaved 16-bit PCM in a RIFF header. The interleaving and
   the float->int conversion happen in the page: shipping 1.7 million JS
   numbers per clip back over CDP is slower than rendering the audio. */
function wav(pcm, chans, rate) {
  const n = pcm.length / 2 / chans;
  const buf = Buffer.alloc(44 + pcm.length);
  buf.write('RIFF', 0);
  buf.writeUInt32LE(36 + pcm.length, 4);
  buf.write('WAVEfmt ', 8);
  buf.writeUInt32LE(16, 16);
  buf.writeUInt16LE(1, 20);
  buf.writeUInt16LE(chans, 22);
  buf.writeUInt32LE(rate, 24);
  buf.writeUInt32LE(rate * chans * 2, 28);
  buf.writeUInt16LE(chans * 2, 32);
  buf.writeUInt16LE(16, 34);
  buf.write('data', 36);
  buf.writeUInt32LE(pcm.length, 40);
  pcm.copy(buf, 44);
  return buf;
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(URL);
  await page.waitForTimeout(600);

  fs.mkdirSync(OUT, { recursive: true });

  for (const clip of CLIPS) {
    const res = await page.evaluate(async (c) => {
      const A = window.Ardah;
      const dur = c.to - c.from;
      const ctx = new OfflineAudioContext(2, Math.ceil(c.rate * dur), c.rate);
      const eng = new A.AudioEngine();
      eng.build(ctx);

      const chart = A.charts.build('normal');
      let n = 0;
      for (const hit of chart.drums) {
        const t = hit.t / 1000 - c.from;
        // A lead-in of 0.05 s keeps a hit at exactly `from` from being
        // scheduled at time 0, where its attack would be clipped.
        if (t < -0.05 || t > dur) continue;
        eng.play(hit.voice, Math.max(0, t) + 0.05, hit.gain);
        n++;
      }

      const rendered = await ctx.startRendering();
      const chans = rendered.numberOfChannels, len = rendered.length;
      const data = [];
      for (let ch = 0; ch < chans; ch++) data.push(rendered.getChannelData(ch));

      let peak = 0, sum = 0;
      const pcm = new Int16Array(len * chans);
      for (let i = 0, k = 0; i < len; i++) {
        for (let ch = 0; ch < chans; ch++, k++) {
          const v = Math.max(-1, Math.min(1, data[ch][i]));
          pcm[k] = Math.round(v * 32767);
          const a = Math.abs(data[ch][i]);
          if (a > peak) peak = a;
          sum += v * v;
        }
      }
      const rms = Math.sqrt(sum / (len * chans));
      let bin = '';
      const bytes = new Uint8Array(pcm.buffer);
      for (let i = 0; i < bytes.length; i += 8192) {
        bin += String.fromCharCode.apply(null, bytes.subarray(i, i + 8192));
      }
      // Voice census, so the report says what is actually in the clip.
      const voices = {};
      for (const hit of chart.drums) {
        const t = hit.t / 1000 - c.from;
        if (t < -0.05 || t > dur) continue;
        voices[hit.voice] = (voices[hit.voice] || 0) + 1;
      }
      return { b64: btoa(bin), chans, hits: n, peak, rms, voices };
    }, { from: clip.from, to: clip.to, rate: RATE });

    const file = path.join(OUT, `ardah_${clip.name}.wav`);
    fs.writeFileSync(file, wav(Buffer.from(res.b64, 'base64'), res.chans, RATE));
    const dbfs = (v) => (20 * Math.log10(Math.max(1e-9, v))).toFixed(1);
    console.log(
      `${clip.name.padEnd(12)} ${clip.from}-${clip.to}s  ${String(res.hits).padStart(4)} hits  ` +
      `peak ${dbfs(res.peak).padStart(6)} dBFS  rms ${dbfs(res.rms).padStart(6)} dBFS  ` +
      (res.peak >= 1 ? 'CLIPPED  ' : '         ') +
      JSON.stringify(res.voices)
    );
  }

  /* Each voice alone, twice — once soft, once full. Two things come out of
     it: a clip you can actually listen to one drum at a time, and numbers
     that say whether the drums are distinct rather than three settings of
     one drum. Decay is measured to -40 dB of the hit's own peak; the
     centroid is the spectral centre of mass over the first 120 ms, which is
     roughly "how bright does it read". */
  const VOICES = ['tabl', 'thakir', 'tar', 'tak', 'clap', 'swords'];
  const one = await page.evaluate(async (v) => {
    const A = window.Ardah, rate = 44100, gap = 0.9;
    const ctx = new OfflineAudioContext(2, Math.ceil(rate * (v.length * 2 * gap + 1.4)), rate);
    const eng = new A.AudioEngine();
    eng.build(ctx);
    const marks = [];
    v.forEach((voice, i) => {
      const t0 = 0.15 + i * 2 * gap;
      eng.play(voice, t0, 0.55);
      eng.play(voice, t0 + gap, 1);
      marks.push({ voice, t: t0 + gap });
    });
    const out = await ctx.startRendering();
    const d = out.getChannelData(0);

    const report = marks.map((m) => {
      const s0 = Math.floor(m.t * rate);
      const n = Math.floor(0.8 * rate);
      let peak = 0;
      for (let i = s0; i < s0 + n; i++) peak = Math.max(peak, Math.abs(d[i]));
      // decay: last sample above -40 dB of this hit's peak, in a 20 ms window
      // envelope so a zero crossing does not read as silence
      const win = Math.floor(rate * 0.02);
      let decay = 0;
      for (let i = s0; i < s0 + n; i += win) {
        let m2 = 0;
        for (let j = i; j < Math.min(s0 + n, i + win); j++) m2 = Math.max(m2, Math.abs(d[j]));
        if (m2 > peak * 0.01) decay = (i - s0) / rate + 0.02;
      }
      // crude centroid over 120 ms via a Goertzel sweep on log-spaced bins
      const N = Math.floor(rate * 0.12);
      let num = 0, den = 0;
      for (let b = 0; b < 28; b++) {
        const f = 50 * Math.pow(2, b / 4);
        if (f > rate / 2) break;
        const w = 2 * Math.PI * f / rate;
        let re = 0, im = 0;
        for (let i = 0; i < N; i++) { re += d[s0 + i] * Math.cos(w * i); im += d[s0 + i] * Math.sin(w * i); }
        const mag = Math.sqrt(re * re + im * im);
        num += f * mag; den += mag;
      }
      return { voice: m.voice, peak, decay, centroid: den ? num / den : 0 };
    });

    const chans = out.numberOfChannels, len = out.length;
    const pcm = new Int16Array(len * chans);
    for (let i = 0, k = 0; i < len; i++) {
      for (let c = 0; c < chans; c++, k++) {
        const x = Math.max(-1, Math.min(1, out.getChannelData(c)[i]));
        pcm[k] = Math.round(x * 32767);
      }
    }
    let bin = '';
    const bytes = new Uint8Array(pcm.buffer);
    for (let i = 0; i < bytes.length; i += 8192) {
      bin += String.fromCharCode.apply(null, bytes.subarray(i, i + 8192));
    }
    return { b64: btoa(bin), chans, report };
  }, VOICES);

  fs.writeFileSync(path.join(OUT, 'ardah_voices.wav'),
                   wav(Buffer.from(one.b64, 'base64'), one.chans, RATE));
  console.log('\nvoice     peak dBFS   decay to -40dB   centroid');
  for (const r of one.report) {
    console.log(`${r.voice.padEnd(9)} ${(20 * Math.log10(r.peak)).toFixed(1).padStart(7)}` +
                `   ${(r.decay * 1000).toFixed(0).padStart(10)} ms` +
                `   ${r.centroid.toFixed(0).padStart(7)} Hz`);
  }

  await browser.close();
})();
