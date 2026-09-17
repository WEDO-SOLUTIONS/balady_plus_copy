/* Drift the Desert — localisation (EN / AR). Classic script, no modules, so
   the bundle loads identically from file://, a local asset server or http. */
(function (global) {
  'use strict';

  var STRINGS = {
    en: {
      'splash.line1': 'DRIFT',
      'splash.line2': 'THE DESERT',
      'splash.tag1': 'BALANCE',
      'splash.tag2': 'EXPLORE',
      'splash.tag3': 'EARN',
      'splash.loading': 'LOADING…',

      'howto.title': 'HOW TO PLAY',
      'howto.subtitle': 'Keep the car on two wheels for as long as you can!',
      'howto.left': 'TAP LEFT',
      'howto.leftHint': 'when the car tilts left',
      'howto.right': 'TAP RIGHT',
      'howto.rightHint': 'when the car tilts right',
      'howto.start': 'START',

      'countdown.ready': 'GET READY',
      'countdown.go': 'GO!',

      'hud.score': 'SCORE',
      'hud.time': 'TIME',
      'hud.combo': 'COMBO',
      'hud.tapLeft': 'TAP LEFT',
      'hud.tapRight': 'TAP RIGHT',
      'hud.keepBalance': 'KEEP BALANCE',
      'hud.goodBalance': 'GOOD BALANCE',
      'hud.perfect': 'PERFECT!',
      'hud.correctIt': 'CORRECT IT!',
      'hud.tooFarLeft': 'TOO FAR LEFT!',
      'hud.tooFarRight': 'TOO FAR RIGHT!',

      'fx.great': 'GREAT!',
      'fx.nice': 'NICE!',
      'fx.perfect': 'PERFECT!',
      'fx.combo': 'COMBO',

      'results.title': 'GREAT RUN!',
      'results.titleCrash': 'WIPE OUT!',
      'results.maxCombo': 'MAX COMBO',
      'results.tokens': 'TOKENS EARNED',
      'results.playAgain': 'PLAY AGAIN',
      'results.rewards': 'COLLECT REWARDS',
      'results.best': 'BEST',
      'results.quote': 'SAUDI DRIFT CULTURE LIVES ON',

      'rewards.title': 'REWARDS',
      'rewards.tokens': 'Tokens',
      'rewards.newBadge': 'New Badge',
      'rewards.badgeDesertDrifter': 'Desert Drifter',
      'rewards.badgeLocked': 'Score 1,500 to unlock',
      'rewards.newSkin': 'New Skin',
      'rewards.skinSandEdition': 'Sand Edition',
      'rewards.skinLocked': 'Reach level 3 to unlock',
      'rewards.progress': 'YOUR PROGRESS',
      'rewards.level': 'Level',
      'rewards.continue': 'CONTINUE',
      'rewards.viewInMap': 'VIEW IN MAP',

      'pause.title': 'PAUSED',
      'pause.resume': 'RESUME',
      'pause.restart': 'RESTART',
      'pause.sound': 'SOUND: ON',
      'pause.soundOff': 'SOUND: OFF',

      'common.backToMap': 'BACK TO MAP'
    },

    ar: {
      'splash.line1': 'هجولة',
      'splash.line2': 'الصحراء',
      'splash.tag1': 'توازن',
      'splash.tag2': 'استكشف',
      'splash.tag3': 'اربح',
      'splash.loading': 'جارٍ التحميل…',

      'howto.title': 'كيف تلعب',
      'howto.subtitle': 'حافظ على السيارة على عجلتين لأطول فترة ممكنة!',
      'howto.left': 'اضغط يسار',
      'howto.leftHint': 'عندما تميل السيارة يسارًا',
      'howto.right': 'اضغط يمين',
      'howto.rightHint': 'عندما تميل السيارة يمينًا',
      'howto.start': 'ابدأ',

      'countdown.ready': 'استعد',
      'countdown.go': 'انطلق!',

      'hud.score': 'النقاط',
      'hud.time': 'الوقت',
      'hud.combo': 'تتابع',
      'hud.tapLeft': 'اضغط يسار',
      'hud.tapRight': 'اضغط يمين',
      'hud.keepBalance': 'حافظ على التوازن',
      'hud.goodBalance': 'توازن جيد',
      'hud.perfect': 'ممتاز!',
      'hud.correctIt': 'صحّح الوضع!',
      'hud.tooFarLeft': 'ميلان زائد لليسار!',
      'hud.tooFarRight': 'ميلان زائد لليمين!',

      'fx.great': 'رائع!',
      'fx.nice': 'جميل!',
      'fx.perfect': 'ممتاز!',
      'fx.combo': 'تتابع',

      'results.title': 'جولة رائعة!',
      'results.titleCrash': 'انقلبت!',
      'results.maxCombo': 'أعلى تتابع',
      'results.tokens': 'النقاط المكتسبة',
      'results.playAgain': 'العب مرة أخرى',
      'results.rewards': 'استلم المكافآت',
      'results.best': 'الأفضل',
      'results.quote': 'ثقافة الهجولة السعودية باقية',

      'rewards.title': 'المكافآت',
      'rewards.tokens': 'رصيد',
      'rewards.newBadge': 'شارة جديدة',
      'rewards.badgeDesertDrifter': 'هاوي الصحراء',
      'rewards.badgeLocked': 'اجمع ١٥٠٠ نقطة للفتح',
      'rewards.newSkin': 'شكل جديد',
      'rewards.skinSandEdition': 'إصدار الرمال',
      'rewards.skinLocked': 'وصول المستوى ٣ للفتح',
      'rewards.progress': 'تقدمك',
      'rewards.level': 'المستوى',
      'rewards.continue': 'متابعة',
      'rewards.viewInMap': 'عرض على الخريطة',

      'pause.title': 'إيقاف مؤقت',
      'pause.resume': 'استئناف',
      'pause.restart': 'إعادة',
      'pause.sound': 'الصوت: مفعل',
      'pause.soundOff': 'الصوت: متوقف',

      'common.backToMap': 'العودة للخريطة'
    }
  };

  var lang = 'en';

  function detect() {
    // Priority: ?lang= query → native bridge preference → browser locale.
    try {
      var q = new URLSearchParams(global.location.search).get('lang');
      if (q && STRINGS[q]) return q;
    } catch (e) { /* older WebViews */ }

    var native = global.DriftBridge && global.DriftBridge.preferredLanguage;
    if (native && STRINGS[native]) return native;

    var nav = (global.navigator.language || 'en').slice(0, 2).toLowerCase();
    return STRINGS[nav] ? nav : 'en';
  }

  function t(key) {
    var table = STRINGS[lang] || STRINGS.en;
    return table[key] != null ? table[key] : (STRINGS.en[key] != null ? STRINGS.en[key] : key);
  }

  function apply(root) {
    var host = root || global.document;
    var nodes = host.querySelectorAll('[data-i18n]');
    for (var i = 0; i < nodes.length; i++) {
      nodes[i].textContent = t(nodes[i].getAttribute('data-i18n'));
    }
    global.document.documentElement.lang = lang;
    global.document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
  }

  function set(next) {
    if (!STRINGS[next]) return;
    lang = next;
    apply();
    global.dispatchEvent(new CustomEvent('drift:lang', { detail: { lang: lang } }));
  }

  global.I18n = {
    get lang() { return lang; },
    detect: detect,
    set: set,
    t: t,
    apply: apply,
    available: Object.keys(STRINGS)
  };
})(window);
