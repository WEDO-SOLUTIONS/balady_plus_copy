/* Ardah — management deck. Frames are real screenshots of the running
   prototype at iPhone 17 Pro Max size, wrapped in a drawn device shell. */
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
  muted:  '9FB0C4',
  red:    'E06B4E'
};
const HEAD = 'Cambria';
const BODY = 'Calibri';

const pres = new pptxgen();
pres.layout = 'LAYOUT_WIDE';            // 13.3 x 7.5 in — set before any slide
pres.author = 'Balady+';
pres.title = 'Ardah — rhythm game overview';

const W = 13.3, H = 7.5;
const phone = (h) => ({ h, w: +(h * 842 / 1598).toFixed(2) });

function slide(bg) {
  const s = pres.addSlide();
  s.background = { color: bg || C.night };
  return s;
}

function title(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.7, y: 0.52, w: 6.6, h: 1.7, fontSize: 36, bold: true,
    fontFace: HEAD, color: C.ink, isTextBox: true, margin: 0
  }, opts));
}

function kicker(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.72, y: 0.22, w: 5.4, h: 0.3, fontSize: 12, bold: true, charSpacing: 3,
    fontFace: BODY, color: C.gold, isTextBox: true, margin: 0
  }, opts));
}

function body(s, text, opts = {}) {
  s.addText(text, Object.assign({
    x: 0.7, y: 1.6, w: 6.2, h: 2.2, fontSize: 16, fontFace: BODY,
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
    x: 0.7, y: 2.2, w: 6.0, h: 3.2, fontSize: 15, fontFace: BODY,
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

/* ============================== 1. title ============================== */
{
  const s = slide(C.deep);
  device(s, '08-play-chorus', 8.4, 0.35, 6.8);
  s.addText('ARDAH', { x: 0.9, y: 2.0, w: 7.2, h: 1.5, fontSize: 84, bold: true,
    fontFace: HEAD, color: C.goldL, charSpacing: 6, isTextBox: true, margin: 0 });
  s.addText('Ритм-игра для Balady+', { x: 0.95, y: 3.4, w: 7, h: 0.6, fontSize: 26,
    fontFace: BODY, color: C.ink, isTextBox: true, margin: 0 });
  s.addText('Играющий прототип · кадры сняты с работающей сборки на iPhone 17 Pro Max',
    { x: 0.95, y: 4.1, w: 7, h: 0.6, fontSize: 14, fontFace: BODY, color: C.muted,
      isTextBox: true, margin: 0 });
  card(s, 0.95, 5.1, 6.6, 1.2, C.greenD);
  s.addText('60–120 секунд на раунд  ·  0 установок  ·  работает офлайн  ·  AR / EN',
    { x: 1.15, y: 5.45, w: 6.2, h: 0.5, fontSize: 14, bold: true, fontFace: BODY,
      color: C.sand, isTextBox: true, margin: 0 });
  s.addNotes('Все кадры в колоде — реальные скриншоты работающего прототипа, не мокапы дизайнера.');
}

/* ============================== 2. what ============================== */
{
  const s = slide();
  kicker(s, 'ЧТО ЭТО');
  title(s, 'Наследие,\nв которое играют');
  body(s, 'Аль-Арда — церемониальный танец с саблями. Игрок держит ряд в такт барабанам: попадает по долям, поднимает саблю на удержании, отвечает вокфой на припеве.\n\nРаунд — минута-две. Заходит без обучения, без регистрации и без установки.',
    { y: 2.45, h: 2.4 });
  stat(s, 0.7, 5.15, 2.2, '77 с', 'длина раунда');
  stat(s, 3.0, 5.15, 2.2, '122', 'ноты за раунд');
  stat(s, 5.3, 5.15, 2.2, '3', 'сложности');
  device(s, '01-menu', 8.6, 0.6, 6.3);
  caption(s, 'Экран входа', 8.6, 6.95, 3.3);
}

/* ============================== 3. loop ============================== */
{
  const s = slide();
  kicker(s, 'ЦИКЛ');
  title(s, 'Понятно с первого такта');
  const steps = [
    ['1', 'Слушай', 'Первые такты играют только барабаны — ряд задаёт темп.'],
    ['2', 'Бей по доле', 'Маркер доходит до золотой линии — тап по дорожке.'],
    ['3', 'Держи ряд', 'Комбо растёт, толпа заводится, множитель до ×4.'],
    ['4', 'Финал', 'Точность, лучшее комбо, оценка от C до S.']
  ];
  steps.forEach(([n, h, t], i) => {
    const y = 2.25 + i * 1.22;
    s.addShape(pres.ShapeType.ellipse, { x: 0.7, y, w: 0.62, h: 0.62,
      fill: { color: C.gold } });
    s.addText(n, { x: 0.7, y, w: 0.62, h: 0.62, fontSize: 20, bold: true,
      fontFace: HEAD, color: C.deep, align: 'center', valign: 'middle', isTextBox: true, margin: 0 });
    s.addText(h, { x: 1.55, y: y - 0.02, w: 5.6, h: 0.4, fontSize: 18, bold: true,
      fontFace: BODY, color: C.ink, isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.55, y: y + 0.36, w: 5.6, h: 0.5, fontSize: 13,
      fontFace: BODY, color: C.muted, isTextBox: true, margin: 0 });
  });
  device(s, '06-play-early', 8.9, 0.55, 6.4);
}

/* ============================== 4. lanes ============================== */
{
  const s = slide();
  kicker(s, 'УПРАВЛЕНИЕ');
  title(s, 'Три дорожки — три голоса');
  const lanes = [
    ['TABL', 'Большой барабан — пульс ряда', 'F2B33D'],
    ['SWORDS', 'Звон клинков на акцентах', '3AA3E8'],
    ['TAR', 'Рамочный барабан в ответ', 'F5D779']
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
  s.addText('Каждая нота — предмет своей дорожки: слиток, самоцвет, чеканная монета.',
    { x: 0.7, y: 6.45, w: 6.4, h: 0.5, fontSize: 13, italic: true, fontFace: BODY,
      color: C.gold, isTextBox: true, margin: 0 });
  device(s, '07-play-three-lanes', 8.9, 0.55, 6.4);
}

/* ============================== 5. perfect ============================== */
{
  const s = slide(C.deep);
  device(s, '11-combo', 0.8, 0.5, 6.6);
  kicker(s, 'МОМЕНТ', { x: 7.9, w: 4.9 });
  title(s, 'Чистое попадание\nвидно и слышно', { x: 7.9, w: 4.9, y: 0.75 });
  body(s, 'Удар в доле даёт вспышку по линии, искры, всплывающие очки и подъём сабель в ряду. Барабанщики на сцене бьют ровно ту партию, которую слышит игрок.',
    { x: 7.9, y: 2.75, w: 4.8, h: 2.1 });
  stat(s, 7.9, 5.15, 2.3, '±45 мс', 'окно Perfect');
  stat(s, 10.4, 5.15, 2.3, '×4', 'множитель комбо');
}

/* ============================== 6. flourish ============================== */
{
  const s = slide();
  kicker(s, 'КУЛЬМИНАЦИЯ');
  title(s, 'Вокфа — общий момент', { w: 5.0 });
  body(s, 'На припеве через все дорожки идёт знамя со скрещёнными саблями. Свайп поперёк — и весь ряд поднимает клинки разом.',
    { y: 2.35, w: 4.5, h: 2.2 });
  device(s, '09-flourish-incoming', 6.0, 0.55, 6.5);
  device(s, '12-hold', 9.7, 0.55, 6.5);
  caption(s, 'Знамя идёт через все дорожки', 6.0, 7.05, 3.4);
  caption(s, 'Удержание — подъём сабли', 9.7, 7.05, 3.4);
}

/* ============================== 7. hold ============================== */
{
  const s = slide();
  kicker(s, 'РИТМ');
  title(s, 'Удержание: подъём сабли');
  bullets(s, [
    'Нажать на долю, держать, отпустить на последнем ударе такта',
    'Под удержанием барабаны идут дробью — игрок слышит, сколько держать',
    'Отпустил рано — ряд сбился, шкала толпы проседает'
  ], { y: 2.5, w: 6.0 });
  device(s, '13-late-run', 8.9, 0.55, 6.4);
}

/* ============================== 8. crowd ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'СТАВКА');
  title(s, 'Толпа — это ставка', { w: 4.5 });
  body(s, 'Шкала наверху — не «здоровье игрока», а синхрон ряда. Промахи его тратят, чистые попадания возвращают. Если ряд потеряет синхрон — раунд заканчивается досрочно.',
    { y: 2.4, w: 4.3, h: 2.0 });
  s.addText('Формулировка намеренная: проигрывает не человек, а ряд теряет строй. Ардха — церемония, а не аркада.',
    { x: 0.7, y: 4.7, w: 4.3, h: 1.4, fontSize: 13, italic: true, fontFace: BODY,
      color: C.gold, isTextBox: true, margin: 0 });
  device(s, '11-combo', 5.5, 0.6, 6.2);
  device(s, '16-crowd-low', 9.2, 0.6, 6.2);
  caption(s, 'Ряд держит строй', 5.5, 6.9, 3.3);
  caption(s, 'Синхрон на исходе', 9.2, 6.9, 3.3);
}

/* ============================== 9. result ============================== */
{
  const s = slide();
  kicker(s, 'ФИНАЛ');
  title(s, 'Результат, который\nхочется побить');
  bullets(s, [
    'Оценка S / A / B / C по точности, а не по очкам',
    'Точность, лучшее комбо, среднее отклонение в миллисекундах',
    'Личный рекорд по каждому чарту — локально, без аккаунта',
    'Кнопка «Играть снова» — сразу, без возврата в меню'
  ], { y: 2.7, w: 6.0 });
  device(s, '14-result', 8.9, 0.55, 6.4);
}

/* ============================== 10. languages ============================== */
{
  const s = slide();
  kicker(s, 'ЛОКАЛИЗАЦИЯ');
  title(s, 'Арабский и английский,\nс RTL', { w: 4.5 });
  body(s, 'Интерфейс переворачивается целиком. Игровое поле остаётся LTR намеренно: ряд исполнителей — это физическая сцена, а не порядок чтения.',
    { y: 2.5, w: 4.2, h: 2.2 });
  device(s, '03-menu-ar', 5.5, 0.6, 6.2);
  device(s, '01-menu', 9.2, 0.6, 6.2);
  caption(s, 'العربية', 5.5, 6.9, 3.3);
  caption(s, 'English', 9.2, 6.9, 3.3);
}

/* ============================== 11. onboarding ============================== */
{
  const s = slide();
  kicker(s, 'ВХОД');
  title(s, 'Обучение — три экрана', { w: 5.1 });
  bullets(s, [
    'Удар, подъём, вокфа — по одному экрану на механику',
    'Показывается один раз, дальше не мешает',
    'До первой ноты — один тап от главного экрана'
  ], { y: 2.4, w: 5.2 });
  device(s, '02-howto', 6.0, 0.55, 6.4);
  device(s, '05-countin', 9.6, 0.55, 6.4);
  caption(s, 'Как играть', 6.0, 7.0, 3.3);
  caption(s, 'Отсчёт: сначала слушаем', 9.6, 7.0, 3.3);
}

/* ============================== 12. calibration ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'ЧЕСТНОСТЬ');
  title(s, 'Игра честная\nна любом телефоне');
  body(s, 'Каждое устройство задерживает звук по-своему — от 20 до 200 мс. Восемь кликов, игрок тапает в такт, медиана становится поправкой устройства.\n\nБез этого игра ощущается сломанной не по вине игрока.',
    { y: 2.5, w: 5.4, h: 2.4 });
  stat(s, 0.7, 5.35, 2.6, '8 кликов', 'вся калибровка');
  stat(s, 3.6, 5.35, 2.8, 'медиана', 'устойчива к промаху');
  device(s, '04-calibration', 8.9, 0.55, 6.4);
}

/* ============================== 13. interruptions ============================== */
{
  const s = slide();
  kicker(s, 'НАДЁЖНОСТЬ');
  title(s, 'Звонок, сворачивание,\nбез звука', { w: 5.2 });
  bullets(s, [
    'Сворачивание — авто-пауза, раунд не теряется',
    'Возврат — звук поднимается заново, время не уплывает',
    'Кнопка звука на всех экранах; тайминг от неё не зависит',
    'Клики калибровки не глушатся: этот экран измеряет устройство'
  ], { y: 2.6, w: 5.3 });
  device(s, '15-pause', 6.1, 0.55, 6.4);
  device(s, '17-muted', 9.7, 0.55, 6.4);
  caption(s, 'Пауза', 6.1, 7.0, 3.3);
  caption(s, 'Звук выключен', 9.7, 7.0, 3.3);
}

/* ============================== 14. delivery ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'ДОСТАВКА');
  title(s, 'Канал уже есть в проде');
  body(s, 'Игра собирается как мини-приложение Balady+: архив скачивается, распаковывается и отдаётся локальным сервером внутри приложения. Тот же движок мини-апп, что работает сегодня.',
    { y: 2.4, w: 6.4, h: 1.5 });
  const items = [
    ['180 КБ', 'весь арт игры'],
    ['345 КБ', 'игра одним файлом'],
    ['0', 'установок для игрока'],
    ['офлайн', 'после первой загрузки']
  ];
  items.forEach(([v, l], i) => {
    const x = 0.7 + (i % 2) * 3.5, y = 4.1 + Math.floor(i / 2) * 1.55;
    card(s, x, y, 3.2, 1.35);
    stat(s, x + 0.25, y + 0.2, 2.7, v, l);
  });
  s.addText('Обновления без релиза в сторы: чарты, звук и тюнинг меняются в день события.',
    { x: 7.4, y: 5.6, w: 5.2, h: 1.0, fontSize: 14, bold: true, fontFace: BODY,
      color: C.goldL, isTextBox: true, margin: 0 });
  device(s, '19-drawn-menu', 7.6, 0.5, 4.9);
}

/* ============================== 15. performance ============================== */
{
  const s = slide();
  kicker(s, 'ИНЖЕНЕРИЯ');
  title(s, 'Замерено, а не обещано');
  const stats = [
    ['60 fps', 'с артом и без', C.goldL],
    ['0,31 мс', 'работа рендера на кадр', C.goldL],
    ['±45 мс', 'окно Perfect', C.goldL],
    ['96 BPM', 'вся анимация привязана к доле', C.goldL]
  ];
  stats.forEach(([v, l, col], i) => {
    const x = 0.7 + (i % 2) * 3.4, y = 2.0 + Math.floor(i / 2) * 1.9;
    card(s, x, y, 3.1, 1.5);
    stat(s, x + 0.25, y + 0.2, 2.7, v, l, col);
  });
  s.addText('Часы игры — аудиоклок, а не кадры: барабаны планируются на 180 мс вперёд, поэтому ритм не уплывает даже при подвисании интерфейса.',
    { x: 0.7, y: 6.15, w: 6.5, h: 1.0, fontSize: 13, italic: true, fontFace: BODY,
      color: C.sand, isTextBox: true, margin: 0 });
  device(s, '18-latency-lab', 8.9, 0.55, 6.4);
  caption(s, 'Встроенная лаборатория задержки', 8.9, 7.0, 3.4);
}

/* ============================== 16. art ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'ГРАФИКА');
  title(s, 'Два режима одной игры', { w: 4.5 });
  body(s, 'Слева — всё нарисовано кодом: ни одной картинки, мгновенный запуск. Справа — та же игра на вырезанных из концепта ассетах.\n\nБоевой арт заказывается слоями: фон готовым кадром, исполнители — отдельными анимируемыми элементами.',
    { y: 2.4, w: 4.2, h: 3.0 });
  device(s, '20-drawn-play', 5.5, 0.6, 6.2);
  device(s, '08-play-chorus', 9.2, 0.6, 6.2);
  caption(s, 'Код, 0 ассетов', 5.5, 6.9, 3.3);
  caption(s, 'С артом, 180 КБ', 9.2, 6.9, 3.3);
}

/* ============================== 17. status ============================== */
{
  const s = slide();
  kicker(s, 'СТАТУС');
  title(s, 'Где мы сейчас');
  const rows = [
    ['Готово', 'Играбельный прототип: кондуктор, судья, чарты, калибровка, два языка, звук, результат', C.gold],
    ['Готово', 'Канал доставки подтверждён — мини-апп движок Balady+ уже в проде', C.gold],
    ['Осталось', 'Замеры задержки на живых устройствах: слабый Android и iPhone, с играющим радио', C.sand],
    ['Осталось', 'Боевой арт и лицензированное аудио — по брифу, через культурное ревью', C.sand],
    ['Осталось', 'Продакшен-контур: лидерборд, сезонное окно, аналитика', C.sand]
  ];
  rows.forEach(([tag, text, col], i) => {
    const y = 2.35 + i * 0.98;
    card(s, 0.7, y, 11.9, 0.86, i < 2 ? C.green : C.greenD);
    s.addText(tag, { x: 0.95, y: y + 0.22, w: 1.4, h: 0.42, fontSize: 13, bold: true,
      fontFace: BODY, color: col, isTextBox: true, margin: 0 });
    s.addText(text, { x: 2.5, y: y + 0.2, w: 9.8, h: 0.5, fontSize: 14,
      fontFace: BODY, color: C.sand, isTextBox: true, margin: 0 });
  });
}

/* ============================== 18. risks ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'РИСКИ');
  title(s, 'Что уже учтено');
  const risks = [
    ['Культурная рамка', 'Ардха — наследие. Формулировки, позы и знамёна проходят ревью до продакшена арта.'],
    ['Лицензия аудио', 'Сейчас перкуссия синтезируется в браузере. Боевой трек лицензируется или заказывается.'],
    ['Задержка Android', 'Калибровка снимает постоянное смещение. Джиттер меряем на устройствах до старта работ.'],
    ['Вес и сеть', 'Событие — плохая связь. Потолок загрузки 4 МБ, сейчас укладываемся в 0,2.']
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

/* ============================== 19. gallery ============================== */
{
  const s = slide();
  kicker(s, 'ГАЛЕРЕЯ');
  title(s, 'Ещё кадры с устройства', { w: 10, h: 1.0 });
  const names = ['01-menu', '05-countin', '07-play-three-lanes', '08-play-chorus',
                 '11-combo', '09-flourish-incoming', '17-muted', '14-result'];
  names.forEach((n, i) => {
    const x = 0.55 + (i % 4) * 3.2, y = 2.05 + Math.floor(i / 4) * 2.65;
    device(s, n + '_sm', x, y, 2.6);
  });
}

/* ============================== 20. ask ============================== */
{
  const s = slide(C.deep);
  kicker(s, 'ЧТО НУЖНО ОТ ВАС');
  title(s, 'Три решения —\nи игра в событии');
  const asks = [
    ['1', 'Канал', 'Подтвердить мини-апп: serviceKey, хостинг архива, релиз-процесс.'],
    ['2', 'Арт', 'Бюджет и подрядчик по брифу: фон кадром, исполнители — слоями.'],
    ['3', 'Дата', 'Событие и окно показа: Founding Day, National Day или оба.']
  ];
  asks.forEach(([n, h, t], i) => {
    const y = 2.6 + i * 1.35;
    s.addShape(pres.ShapeType.ellipse, { x: 0.8, y, w: 0.7, h: 0.7, fill: { color: C.gold } });
    s.addText(n, { x: 0.8, y, w: 0.7, h: 0.7, fontSize: 22, bold: true, fontFace: HEAD,
      color: C.deep, align: 'center', valign: 'middle', isTextBox: true, margin: 0 });
    s.addText(h, { x: 1.8, y: y - 0.02, w: 5.6, h: 0.45, fontSize: 20, bold: true,
      fontFace: HEAD, color: C.ink, isTextBox: true, margin: 0 });
    s.addText(t, { x: 1.8, y: y + 0.45, w: 6.0, h: 0.6, fontSize: 13.5,
      fontFace: BODY, color: C.muted, isTextBox: true, margin: 0 });
  });
  device(s, '08-play-chorus', 9.0, 0.5, 6.5);
}

pres.writeFile({ fileName: OUT }).then(() => console.log('written', OUT));
