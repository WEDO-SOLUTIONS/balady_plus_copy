/* Ardah — management deck (English).

   Frames are real screenshots of the running prototype at iPhone 17 Pro Max
   size, wrapped in a drawn device shell. Nothing here is a design mockup. */
const pptxgen = require('pptxgenjs');
const path = require('path');

const M = path.join(__dirname, 'mock');
const OUT = path.join(__dirname, 'ardah-overview.pptx');

const C = {
  night:  '0A1526',
  deep:   '061019',
  green:  '0E3F28',
  greenD: '072517',
  gold:   'E7B44C',
  goldL:  'FFD978',
  sand:   'F6E7C4',
  ink:    'FFFFFF',
  muted:  '9FB0C4'
};
const HEAD = 'Cambria';
const BODY = 'Calibri';

const pres = new pptxgen();
pres.layout = 'LAYOUT_WIDE';            // 13.3 x 7.5 in — set before any slide
pres.author = 'Balady+';
pres.title = 'Ardah — rhythm game overview';

const phone = (h) => ({ h, w: +(h * 842 / 1598).toFixed(2) });

function slide(bg) {
  const s = pres.addSlide();
  s.background = { color: bg || C.night };
  return s;
}

function kicker(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.72, y: 0.22, w: 5.4, h: 0.3, fontSize: 12, bold: true, charSpacing: 3,
    fontFace: BODY, color: C.gold, isTextBox: true, margin: 0
  }, opts));
}

function title(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.7, y: 0.52, w: 6.6, h: 1.7, fontSize: 36, bold: true,
    fontFace: HEAD, color: C.ink, isTextBox: true, margin: 0
  }, opts));
}

function body(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.7, y: 2.4, w: 6.0, h: 2.2, fontSize: 16, fontFace: BODY,
    color: C.sand, lineSpacing: 24, isTextBox: true, margin: 0
  }, opts));
}

function card(s, x, y, w, h, fill) {
  s.addShape(pres.ShapeType.roundRect, {
    x, y, w, h, rectRadius: 0.12,
    fill: { color: fill || C.greenD },
    line: { color: C.gold, width: 0.75, transparency: 55 },
    shadow: { type: 'outer', angle: 90, blur: 12, offset: 3, opacity: 0.35, color: '000000' }
  });
}

function stat(s, x, y, w, value, label, color) {
  s.addText(value, {
    x, y, w, h: 0.7, fontSize: 30, bold: true, fontFace: HEAD,
    color: color || C.goldL, isTextBox: true, margin: 0
  });
  s.addText(label, {
    x, y: y + 0.62, w, h: 0.5, fontSize: 12, fontFace: BODY,
    color: C.muted, isTextBox: true, margin: 0
  });
}

function bullets(s, items, opts = {}) {
  s.addText(items.map((t, i) => ({
    text: t, options: { bullet: true, breakLine: i !== items.length - 1 }
  })), Object.assign({
    x: 0.7, y: 2.5, w: 6.0, h: 3.2, fontSize: 15, fontFace: BODY,
    color: C.sand, paraSpaceAfter: 10, isTextBox: true, margin: 0
  }, opts));
}

function device(s, name, x, y, h) {
  const p = phone(h);
  s.addImage({ path: path.join(M, name + '.png'), x, y, w: p.w, h: p.h });
  return p;
}

function caption(s, text, x, y, w) {
  s.addText(text, {
    x, y, w, h: 0.4, fontSize: 11, fontFace: BODY, color: C.muted,
    align: 'center', isTextBox: true, margin: 0
  });
}

/* ================================ 1. title ================================ */
{
  const s = slide(C.deep);
  device(s, '08-play-chorus', 8.4, 0.35, 6.8);
  s.addText('ARDAH', { x: 0.9, y: 2.0, w: 7.2, h: 1.5, fontSize: 84, bold: true,
    fontFace: HEAD, color: C.goldL, charSpacing: 6, isTextBox: true, margin: 0 });
  s.addText('A rhythm game for Balady+', { x: 0.95, y: 3.4, w: 7, h: 0.6, fontSize: 26,
    fontFace: BODY, color: C.ink, isTextBox: true, margin: 0 });
  s.addText('Playable prototype · every frame captured from the running build on iPhone 17 Pro Max',
    { x: 0.95, y: 4.1, w: 7, h: 0.6, fontSize: 14, fontFace: BODY, color: C.muted,
      isTextBox: true, margin: 0 });
  card(s, 0.95, 5.1, 6.6, 1.2, C.greenD);
  s.addText('60–120 second rounds  ·  no install  ·  works offline  ·  Arabic & English',
    { x: 1.15, y: 5.45, w: 6.2, h: 0.5, fontSize: 14, bold: true, fontFace: BODY,
      color: C.sand, isTextBox: true, margin: 0 });
  s.addNotes('Every screen in this deck is a real screenshot of the working prototype, not a design mockup.');
}

/* ================================ 2. what ================================ */
{
  const s = slide();
  kicker(s, 'WHAT IT IS');
  title(s, 'Heritage you can\nactually play');
  body(s, 'Al-Ardah is the ceremonial sword dance. The player keeps the row in time with the drums: strike on the beat, raise the sabre through a hold, answer the chorus with a flourish.\n\nA round lasts a minute or two. No tutorial needed, no sign-up, no install.',
    { y: 2.45, h: 2.4 });
  stat(s, 0.7, 5.15, 2.2, '77 sec', 'per round');
  stat(s, 3.0, 5.15, 2.2, '122', 'notes per round');
  stat(s, 5.3, 5.15, 2.2, '3', 'difficulties');
  device(s, '01-menu', 8.6, 0.6, 6.3);
  caption(s, 'Entry screen', 8.6, 6.95, 3.3);
}

/* ================================ 3. loop ================================ */
{
  const s = slide();
  kicker(s, 'THE LOOP');
  title(s, 'Clear from the first bar');
  const steps = [
    ['1', 'Listen', 'The opening bars are drums only — the row sets the tempo.'],
    ['2', 'Strike on the beat', 'The marker reaches the gold line, you tap the lane.'],
    ['3', 'Hold the row', 'Combo climbs, the crowd lifts, the multiplier runs to ×4.'],
    ['4', 'Finish', 'Accuracy, best combo, and a grade from C to S.']
  ];
  steps.forEach(([n, h, t], i) => {
    const y = 2.25 + i * 1.22;
    s.addShape(pres.ShapeType.ellipse, { x: 0.7, y, w: 0.62, h: 0.62, fill: { color: C.gold } });
    s.addText(n, { x: 0.7, y, w: 0.62, h: 0.62, fontSize: 20, bold: true, fontFace: HEAD,
      color: C.deep, align: 'center', valign: 'middle', isTextBox: true, margin: 0 });
    s.addText(h, { x: 1.55, y: y - 0.02, w: 5.6, h: 0.4, fontSize: 18, bold: true,
      fontFace: BODY, color: C.ink, isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.55, y: y + 0.36, w: 5.9, h: 0.5, fontSize: 13,
      fontFace: BODY, color: C.muted, isTextBox: true, margin: 0 });
  });
  device(s, '06-play-early', 8.9, 0.55, 6.4);
}

/* ================================ 4. lanes ================================ */
{
  const s = slide();
  kicker(s, 'CONTROLS');
  title(s, 'Three lanes, three voices');
  const lanes = [
    ['TABL', 'The deep drum — the pulse of the row', 'F2B33D'],
    ['SWORDS', 'Blades meeting on the accents', '3AA3E8'],
    ['TAR', 'The frame drum answering back', 'F5D779']
  ];
  lanes.forEach(([n, t, col], i) => {
    const y = 2.35 + i * 1.3;
    card(s, 0.7, y, 6.3, 1.1);
    s.addShape(pres.ShapeType.roundRect, { x: 0.95, y: y + 0.25, w: 0.6, h: 0.6,
      rectRadius: 0.1, fill: { color: col } });
    s.addText(n, { x: 1.75, y: y + 0.18, w: 4.8, h: 0.4, fontSize: 17, bold: true,
      fontFace: BODY, color: C.ink, isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.75, y: y + 0.56, w: 4.9, h: 0.4, fontSize: 12.5,
      fontFace: BODY, color: C.muted, isTextBox: true, margin: 0 });
  });
  s.addText('Each note is an object of its own lane: a gold ingot, a cut jewel, a struck coin.',
    { x: 0.7, y: 6.45, w: 6.4, h: 0.5, fontSize: 13, italic: true, fontFace: BODY,
      color: C.gold, isTextBox: true, margin: 0 });
  device(s, '07-play-three-lanes', 8.9, 0.55, 6.4);
}

/* ================================ 5. the hit ================================ */
{
  const s = slide(C.deep);
  device(s, '11-combo', 0.8, 0.5, 6.6);
  kicker(s, 'THE MOMENT', { x: 7.9, w: 4.9 });
  title(s, 'A clean hit is\nseen and heard', { x: 7.9, w: 4.9, y: 0.75 });
  body(s, 'Striking on the beat flashes the lane, throws sparks, floats the points and lifts sabres in the row. The drummers on stage play exactly the part the player is hearing.',
    { x: 7.9, y: 2.75, w: 4.8, h: 2.1 });
  stat(s, 7.9, 5.15, 2.3, '±45 ms', 'Perfect window');
  stat(s, 10.4, 5.15, 2.3, '×4', 'combo multiplier');
}

/* ========================= 5b. every outcome reads ========================= */
{
  const s = slide();
  kicker(s, 'FEEDBACK');
  title(s, 'Hit, hold and miss\nall read differently', { w: 5.4 });
  body(s, 'Every outcome has its own animation, and the note tells you which one it was without reading a word.',
    { y: 2.5, w: 5.4, h: 1.2 });
  bullets(s, [
    'Break: a crystal shatters into chips of its own colour, a gem flashes and leaves nothing, a coin scatters flakes',
    'Hold: the ribbon darkens to a lit channel, a highlight runs up it and the line throws embers while the key is down',
    'Miss: the note is dropped, not deleted — it tumbles past the line and falls away under a red bloom'
  ], { y: 3.9, w: 5.6 });
  device(s, '21-break-styles', 6.5, 0.5, 6.4);
  device(s, '23-hold', 9.6, 0.5, 6.4);
  caption(s, 'Left: three break styles at once. Right: a hold running in every lane.', 6.5, 7.05, 6.2);
}

/* ================================ 6. flourish ================================ */
{
  const s = slide();
  kicker(s, 'THE PEAK');
  title(s, 'The flourish —\none shared moment', { w: 5.0 });
  body(s, 'On the chorus a ceremonial bar crosses every lane, with a glint running its length that quickens as it closes. Swipe across it and the whole row raises their blades at once.',
    { y: 2.75, w: 4.6, h: 2.2 });
  device(s, '09-flourish-incoming', 6.0, 0.55, 6.5);
  device(s, '24-flourish-sweep', 9.7, 0.55, 6.5);
  caption(s, 'The bar crosses every lane', 6.0, 7.05, 3.4);
  caption(s, 'A sweep across the whole line', 9.7, 7.05, 3.4);
}

/* ================================ 7. crowd ================================ */
{
  const s = slide(C.deep);
  kicker(s, 'THE STAKE');
  title(s, 'The crowd is the stake', { w: 4.5 });
  body(s, 'The bar at the top is not a health meter — it is the row\'s sync. Missed beats spend it, clean hits return it. Lose it all and the row breaks formation, and the run ends there.',
    { y: 2.4, w: 4.3, h: 2.0 });
  s.addText('The framing is deliberate: the player does not fail, the row loses its step. Ardah is a ceremony, not an arcade.',
    { x: 0.7, y: 4.7, w: 4.3, h: 1.4, fontSize: 13, italic: true, fontFace: BODY,
      color: C.gold, isTextBox: true, margin: 0 });
  device(s, '11-combo', 5.5, 0.6, 6.2);
  device(s, '16-crowd-low', 9.2, 0.6, 6.2);
  caption(s, 'The row holds', 5.5, 6.9, 3.3);
  caption(s, 'Sync running out', 9.2, 6.9, 3.3);
}

/* ================================ 8. result ================================ */
{
  const s = slide();
  kicker(s, 'THE FINISH');
  title(s, 'A result worth\nbeating');
  bullets(s, [
    'Graded S / A / B / C on accuracy, not on raw score',
    'Accuracy, best combo, and mean timing in milliseconds',
    'A personal best per chart, kept on the device, no account',
    'Play again is one tap — no trip back to the menu'
  ], { y: 2.7, w: 6.0 });
  device(s, '14-result', 8.9, 0.55, 6.4);
}

/* ================================ 9. languages ================================ */
{
  const s = slide();
  kicker(s, 'LOCALISATION');
  title(s, 'Arabic and English,\nRTL included', { w: 4.5 });
  body(s, 'The interface flips completely. The playfield stays LTR on purpose: a row of performers is a physical stage, not reading order.',
    { y: 2.5, w: 4.2, h: 2.2 });
  device(s, '03-menu-ar', 5.5, 0.6, 6.2);
  device(s, '01-menu', 9.2, 0.6, 6.2);
  caption(s, 'العربية', 5.5, 6.9, 3.3);
  caption(s, 'English', 9.2, 6.9, 3.3);
}

/* ================================ 10. onboarding ================================ */
{
  const s = slide();
  kicker(s, 'GETTING IN');
  title(s, 'Onboarding is three screens', { w: 5.1 });
  bullets(s, [
    'Strike, raise, flourish — one screen per mechanic',
    'Shown once, then it stays out of the way',
    'One tap from the entry screen to the first note'
  ], { y: 2.4, w: 5.2 });
  device(s, '02-howto', 6.0, 0.55, 6.4);
  device(s, '05-countin', 9.6, 0.55, 6.4);
  caption(s, 'How to play', 6.0, 7.0, 3.3);
  caption(s, 'Count-in: listen first', 9.6, 7.0, 3.3);
}

/* ================================ 11. calibration ================================ */
{
  const s = slide(C.deep);
  kicker(s, 'FAIRNESS');
  title(s, 'Fair on any\nhandset');
  body(s, 'Every device delays its audio differently — anywhere from 20 to 200 ms. Eight clicks, the player taps along, and the median becomes that device\'s offset.\n\nWithout it the game feels broken through no fault of the player.',
    { y: 2.5, w: 5.4, h: 2.4 });
  stat(s, 0.7, 5.35, 2.6, '8 clicks', 'the whole calibration');
  stat(s, 3.6, 5.35, 2.8, 'median', 'robust to a stray tap');
  device(s, '04-calibration', 8.9, 0.55, 6.4);
}

/* ================================ 12. interruptions ================================ */
{
  const s = slide();
  kicker(s, 'ROBUSTNESS');
  title(s, 'Calls, backgrounding,\nsilent mode', { w: 5.2 });
  bullets(s, [
    'Backgrounding auto-pauses — the run is not lost',
    'Coming back re-opens the audio; the clock does not drift',
    'A sound toggle on every screen; timing never depends on it',
    'Calibration clicks stay audible: that screen measures the device'
  ], { y: 2.6, w: 5.3 });
  device(s, '15-pause', 6.1, 0.55, 6.4);
  device(s, '17-muted', 9.7, 0.55, 6.4);
  caption(s, 'Paused', 6.1, 7.0, 3.3);
  caption(s, 'Sound off', 9.7, 7.0, 3.3);
}

/* ================================ 13. delivery ================================ */
{
  const s = slide(C.deep);
  kicker(s, 'DELIVERY');
  title(s, 'The channel is already\nin production');
  body(s, 'The game ships as a Balady+ mini-app: an archive downloads, unpacks and is served by a local server inside the app. The same mini-app engine that runs today.',
    { y: 2.4, w: 6.4, h: 1.5 });
  const items = [
    ['448 KB', 'all of the artwork'],
    ['835 KB', 'the game as one file'],
    ['0', 'installs for the player'],
    ['offline', 'after the first download']
  ];
  items.forEach(([v, l], i) => {
    const x = 0.7 + (i % 2) * 3.5, y = 4.1 + Math.floor(i / 2) * 1.55;
    card(s, x, y, 3.2, 1.35);
    stat(s, x + 0.25, y + 0.2, 2.7, v, l);
  });
  s.addText('Updates without a store release: charts, audio and tuning can change on the day of the event.',
    { x: 7.4, y: 5.6, w: 5.2, h: 1.0, fontSize: 14, bold: true, fontFace: BODY,
      color: C.goldL, isTextBox: true, margin: 0 });
  device(s, '13-late-run', 7.6, 0.5, 4.9);
}

/* ================================ 14. art ================================ */
{
  const s = slide();
  kicker(s, 'ART DIRECTION');
  title(s, 'Built on the concept art', { w: 5.6 });
  body(s, 'The stage is cut from the approved concept image. Everything that moves — notes, pads, the runway deck, the effects — is rendered from geometry against the same lighting.',
    { y: 2.4, w: 5.6, h: 1.5 });
  bullets(s, [
    'Colour comes from physics: a stone\'s hue is what it absorbs',
    'Production art is commissioned in layers, not one flat render',
    'Cultural review signs off performers, banners and the fort',
    'No text is baked into artwork — every string localises at runtime'
  ], { y: 4.1, w: 5.8, h: 2.9 });
  device(s, '08-play-chorus', 8.9, 0.55, 6.4);
}

/* ================================ 15. status ================================ */
{
  const s = slide();
  kicker(s, 'STATUS');
  title(s, 'Where we are');
  const rows = [
    ['Done', 'Playable prototype: conductor, judging, charts, calibration, two languages, sound, results', C.gold],
    ['Done', 'Delivery channel confirmed — the Balady+ mini-app engine is already in production', C.gold],
    ['Next', 'Latency measured on live devices: a low-end Android and an iPhone, with the radio playing', C.sand],
    ['Next', 'Production art and licensed audio — per the brief, through cultural review', C.sand],
    ['Next', 'Production scope: leaderboard, seasonal window, analytics', C.sand]
  ];
  rows.forEach(([tag, text, col], i) => {
    const y = 2.35 + i * 0.98;
    card(s, 0.7, y, 11.9, 0.86, i < 2 ? C.green : C.greenD);
    s.addText(tag, { x: 0.95, y: y + 0.22, w: 1.2, h: 0.42, fontSize: 13, bold: true,
      fontFace: BODY, color: col, isTextBox: true, margin: 0 });
    s.addText(text, { x: 2.3, y: y + 0.2, w: 10.0, h: 0.5, fontSize: 14,
      fontFace: BODY, color: C.sand, isTextBox: true, margin: 0 });
  });
}

/* ================================ 16. risks ================================ */
{
  const s = slide(C.deep);
  kicker(s, 'RISKS');
  title(s, 'Already accounted for');
  const risks = [
    ['Cultural framing', 'Ardah is heritage. Wording, posture and banners go through review before art production starts.'],
    ['Audio licensing', 'Percussion is synthesised in the browser today. The shipping track is licensed or commissioned.'],
    ['Android latency', 'Calibration removes the constant offset. Jitter is measured on devices before the work starts.'],
    ['Weight and network', 'Events mean poor connectivity. The ceiling is 4 MB; we are at 0.62 today.']
  ];
  risks.forEach(([h, t], i) => {
    const x = 0.7 + (i % 2) * 6.2, y = 2.4 + Math.floor(i / 2) * 2.3;
    card(s, x, y, 5.8, 2.0);
    s.addText(h, { x: x + 0.35, y: y + 0.28, w: 5.1, h: 0.45, fontSize: 18, bold: true,
      fontFace: HEAD, color: C.goldL, isTextBox: true, margin: 0 });
    s.addText(t, { x: x + 0.35, y: y + 0.85, w: 5.1, h: 1.0, fontSize: 13,
      fontFace: BODY, color: C.sand, isTextBox: true, margin: 0 });
  });
}

/* ================================ 17. gallery ================================ */
{
  const s = slide();
  kicker(s, 'GALLERY');
  title(s, 'More frames from the device', { w: 10, h: 1.0 });
  const names = ['01-menu', '05-countin', '07-play-three-lanes', '08-play-chorus',
                 '11-combo', '09-flourish-incoming', '17-muted', '14-result'];
  names.forEach((n, i) => {
    const x = 0.55 + (i % 4) * 3.2, y = 2.05 + Math.floor(i / 4) * 2.65;
    device(s, n + '_sm', x, y, 2.6);
  });
}

/* ================================ 18. ask ================================ */
{
  const s = slide(C.deep);
  kicker(s, 'WHAT WE NEED FROM YOU');
  title(s, 'Three decisions and\nthe game is in the event');
  const asks = [
    ['1', 'Channel', 'Confirm the mini-app: serviceKey, archive hosting, release process.'],
    ['2', 'Art', 'Budget and vendor per the brief: backdrop as a frame, performers in layers.'],
    ['3', 'Date', 'The event and the window: Founding Day, National Day, or both.']
  ];
  asks.forEach(([n, h, t], i) => {
    const y = 2.6 + i * 1.35;
    s.addShape(pres.ShapeType.ellipse, { x: 0.8, y, w: 0.7, h: 0.7, fill: { color: C.gold } });
    s.addText(n, { x: 0.8, y, w: 0.7, h: 0.7, fontSize: 22, bold: true, fontFace: HEAD,
      color: C.deep, align: 'center', valign: 'middle', isTextBox: true, margin: 0 });
    s.addText(h, { x: 1.8, y: y - 0.02, w: 5.6, h: 0.45, fontSize: 20, bold: true,
      fontFace: HEAD, color: C.ink, isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.8, y: y + 0.45, w: 6.2, h: 0.6, fontSize: 13.5,
      fontFace: BODY, color: C.muted, isTextBox: true, margin: 0 });
  });
  device(s, '08-play-chorus', 9.0, 0.5, 6.5);
}

pres.writeFile({ fileName: OUT }).then(() => console.log('written', OUT));
