/* Strings. Two locales, no framework.
   In the superapp the host will pass the active language down; standalone we
   read the browser's. Gameplay stays LTR in both (see index.html). */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var STRINGS = {
    en: {
      eyebrow: 'Balady+ · heritage',
      title: 'Ardah',
      titleSub: 'Rhythm',
      lede: 'Keep the row in time with the drums.',
      play: 'Take the stage',
      crowd: 'CROWD',
      muteOn: 'Mute music',
      muteOff: 'Unmute music',
      mutedHint: 'Music is muted — the calibration clicks still play.',
      combo: 'COMBO',
      laneNames: ['TABL', 'SWORDS', 'TAR'],
      bars: 'bars',
      calibrate: 'Calibrate timing',
      howto: 'How to play',
      debugToggle: 'Latency lab',
      back: 'Back',
      keyboardHint: 'Keys: A S D · Space flourish · 1 2 look · Esc pause · M mute',

      // Icon-only look-around controls: their only name is the aria-label.
      tiltLeft: 'Look left',
      tiltRight: 'Look right',
      tiltLock: 'Hold the view at an angle',

      howtoTitle: 'How to play',
      tapName: 'Strike',
      tapDesc: 'Tap the lane as the marker crosses the line.',
      holdName: 'Raise',
      holdDesc: 'Press on the beat, hold while the bar runs, release at its end.',
      flourishName: 'Flourish',
      flourishDesc: 'Swipe across the lanes on the accent — or press Space.',
      syncExplain: 'Misses cost the row its sync. Lose it all and the row breaks formation — the run ends there.',

      calibTitle: 'Calibrate timing',
      calibHint: 'Tap on each beat you hear. Eight beats, then we take the median. Every device delays its audio differently; this measures yours.',
      calibStart: 'Start',
      calibAgain: 'Measure again',
      calibDone: 'Offset saved',
      offsetLabel: 'Audio offset',
      notCalibrated: 'not measured yet',

      paused: 'Paused',
      resume: 'Resume',
      restart: 'Restart',
      quit: 'Quit',

      accuracy: 'Accuracy',
      maxCombo: 'Best combo',
      score: 'Score',
      timing: 'Mean timing',
      retry: 'Play again',
      menu: 'Back to menu',
      resultKept: 'The row held together',
      resultBroke: 'The row lost its sync',
      best: 'Best so far',
      newBest: 'New best',

      countIn: 'Listen…',
      perfect: 'Perfect',
      good: 'Good',
      early: 'Early',
      late: 'Late',
      miss: 'Missed',
      difficulty: { easy: 'Easy', normal: 'Normal', hard: 'Hard' }
    },
    ar: {
      eyebrow: 'بلدي+ · التراث',
      title: 'العرضة',
      titleSub: 'إيقاع',
      lede: 'حافظ على انسجام الصف مع الطبول.',
      play: 'ابدأ العرضة',
      crowd: 'الجمهور',
      muteOn: 'كتم الموسيقى',
      muteOff: 'تشغيل الموسيقى',
      mutedHint: 'الموسيقى مكتومة — نقرات المعايرة تعمل كالمعتاد.',
      combo: 'تتابع',
      laneNames: ['طبل', 'سيوف', 'طار'],
      bars: 'مازورة',
      calibrate: 'معايرة التوقيت',
      howto: 'طريقة اللعب',
      debugToggle: 'مختبر التأخير',
      back: 'رجوع',
      keyboardHint: 'المفاتيح: A S D · مسافة للوقفة · 1 2 للنظر حولك · Esc إيقاف · M كتم',

      tiltLeft: 'انظر يسارًا',
      tiltRight: 'انظر يمينًا',
      tiltLock: 'تثبيت المشهد على زاوية',

      howtoTitle: 'طريقة اللعب',
      tapName: 'ضربة',
      tapDesc: 'انقر المسار عند عبور العلامة للخط.',
      holdName: 'رفع',
      holdDesc: 'اضغط مع النقرة، واستمر حتى نهاية الشريط ثم ارفع إصبعك.',
      flourishName: 'وقفة',
      flourishDesc: 'مرّر إصبعك عبر المسارات عند النبرة — أو اضغط مسافة.',
      syncExplain: 'كل ضربة ضائعة تُفقد الصف انسجامه. إذا نفد الانسجام ينفرط الصف وتنتهي الجولة.',

      calibTitle: 'معايرة التوقيت',
      calibHint: 'انقر مع كل نبضة تسمعها. ثماني نبضات ثم نأخذ الوسيط. كل جهاز يؤخّر الصوت بشكل مختلف، وهذه المعايرة تقيس جهازك.',
      calibStart: 'ابدأ',
      calibAgain: 'أعد القياس',
      calibDone: 'تم حفظ التعويض',
      offsetLabel: 'تعويض الصوت',
      notCalibrated: 'لم يُقس بعد',

      paused: 'إيقاف مؤقت',
      resume: 'متابعة',
      restart: 'إعادة',
      quit: 'خروج',

      accuracy: 'الدقة',
      maxCombo: 'أفضل تتابع',
      score: 'النقاط',
      timing: 'متوسط التوقيت',
      retry: 'العب مرة أخرى',
      menu: 'القائمة',
      resultKept: 'بقي الصف منسجمًا',
      resultBroke: 'فقد الصف انسجامه',
      best: 'أفضل نتيجة',
      newBest: 'أفضل نتيجة جديدة',

      countIn: 'أنصت…',
      perfect: 'ممتاز',
      good: 'جيد',
      early: 'مبكر',
      late: 'متأخر',
      miss: 'ضائعة',
      difficulty: { easy: 'سهل', normal: 'متوسط', hard: 'صعب' }
    }
  };

  var lang = (navigator.language || 'en').toLowerCase().indexOf('ar') === 0 ? 'ar' : 'en';
  try {
    var saved = localStorage.getItem('ardah.lang');
    if (saved && STRINGS[saved]) lang = saved;
  } catch (e) { /* private mode — fall back to the detected language */ }

  A.i18n = {
    get lang() { return lang; },
    get dir() { return lang === 'ar' ? 'rtl' : 'ltr'; },
    t: function (key) {
      var v = STRINGS[lang][key];
      return v === undefined ? key : v;
    },
    set: function (next) {
      if (!STRINGS[next]) return;
      lang = next;
      try { localStorage.setItem('ardah.lang', next); } catch (e) { /* ignore */ }
      A.i18n.apply();
    },
    toggle: function () { A.i18n.set(lang === 'ar' ? 'en' : 'ar'); },
    /** Paints every [data-i18n] node and flips document direction. */
    apply: function () {
      document.documentElement.lang = lang;
      document.documentElement.dir = A.i18n.dir;
      var nodes = document.querySelectorAll('[data-i18n]');
      for (var i = 0; i < nodes.length; i++) {
        nodes[i].textContent = A.i18n.t(nodes[i].getAttribute('data-i18n'));
      }
      // Icon-only controls carry their name in aria-label, which has to
      // localise as well: a screen reader announcing "Look left" in an Arabic
      // interface is the same bug as untranslated body text.
      var aria = document.querySelectorAll('[data-i18n-aria]');
      for (var k = 0; k < aria.length; k++) {
        aria[k].setAttribute('aria-label', A.i18n.t(aria[k].getAttribute('data-i18n-aria')));
      }
      if (A.game && A.game.onLanguageChanged) A.game.onLanguageChanged();
    }
  };
})(window.Ardah);
