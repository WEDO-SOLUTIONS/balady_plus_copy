/* DOM layer and bootstrap.

   Menus are plain DOM (cheap, accessible, easy to restyle); the run itself is
   canvas only. Nothing DOM-shaped is touched during a run — that is what keeps
   frame pacing predictable inside a WebView. */
(function (A) {
  'use strict';

  var $ = function (id) { return document.getElementById(id); };
  var screens = ['screen-menu', 'screen-howto', 'screen-calib', 'screen-pause', 'screen-result'];

  A.ui = {
    showScreen: function (id) {
      for (var i = 0; i < screens.length; i++) {
        var el = $(screens[i]);
        if (el) el.hidden = screens[i] !== id;
      }
    },

    toast: function (msg) {
      var el = $('offset-readout');
      if (el) el.textContent = msg;
    },

    refreshOffset: function () {
      var g = A.game;
      $('offset-readout').textContent = A.i18n.t('offsetLabel') + ': ' +
        (g.calibrated ? (g.offsetMs > 0 ? '+' : '') + g.offsetMs + ' ms' : A.i18n.t('notCalibrated'));
      var v = $('calib-value');
      if (v) v.textContent = g.calibrated ? (g.offsetMs > 0 ? '+' : '') + g.offsetMs + ' ms' : '—';
    },

    renderCharts: function () {
      var list = $('chart-list');
      list.innerHTML = '';
      A.game.charts.forEach(function (chart, i) {
        var card = document.createElement('button');
        card.className = 'chart-card';
        card.setAttribute('aria-selected', String(i === A.game.chartIndex));
        var title = A.i18n.lang === 'ar' ? chart.titleAr : chart.titleEn;
        var best = null;
        try {
          var raw = localStorage.getItem('ardah.best.' + chart.id);
          best = raw ? JSON.parse(raw) : null;
        } catch (e) { /* storage unavailable */ }
        var label = document.createElement('div');
        label.innerHTML = '<b></b><span></span>';
        label.querySelector('b').textContent = A.i18n.t('difficulty')[chart.difficulty];
        label.querySelector('span').textContent =
          title + ' · ' + chart.notes.length + ' · ' + Math.round(chart.durationMs / 1000) + 's';
        var badge = document.createElement('em');
        badge.textContent = best ? best.grade + ' · ' + (best.accuracy * 100).toFixed(1) + '%' : '—';
        card.appendChild(label);
        card.appendChild(badge);
        card.addEventListener('click', function () {
          A.game.chartIndex = i;
          A.ui.renderCharts();
        });
        list.appendChild(card);
      });
    },

    showResult: function (r) {
      $('result-kicker').textContent = A.i18n.t(r.completed ? 'resultKept' : 'resultBroke');
      $('result-grade').textContent = r.grade;
      $('stat-acc').textContent = (r.accuracy * 100).toFixed(1) + '%';
      $('stat-combo').textContent = r.maxCombo;
      $('stat-score').textContent = r.score;
      $('stat-timing').textContent = (r.timing.mean >= 0 ? '+' : '') + r.timing.mean.toFixed(0) +
        ' ms ± ' + r.timing.jitter.toFixed(0);
      $('result-breakdown').textContent =
        A.i18n.t('perfect') + ' ' + r.counts.perfect + '   ' +
        A.i18n.t('good') + ' ' + r.counts.good + '   ' +
        A.i18n.t('early') + ' ' + r.counts.early + '   ' +
        A.i18n.t('late') + ' ' + r.counts.late + '   ' +
        A.i18n.t('miss') + ' ' + r.counts.miss;
      $('result-best').textContent = r.isBest
        ? A.i18n.t('newBest')
        : (r.best ? A.i18n.t('best') + ': ' + (r.best.accuracy * 100).toFixed(1) + '% (' + r.best.grade + ')' : '');
      A.ui.showScreen('screen-result');
    },

    calibReset: function (n) {
      var dots = $('calib-dots');
      dots.innerHTML = '';
      for (var i = 0; i < n; i++) dots.appendChild(document.createElement('i'));
      $('calib-value').textContent = '…';
      $('btn-calib-start').textContent = A.i18n.t('calibStart');
    },
    calibBeat: function (index, n) {
      var dots = $('calib-dots').children;
      for (var i = 0; i < dots.length; i++) {
        if (!dots[i].classList.contains('hit')) dots[i].classList.toggle('on', i === index);
      }
    },
    calibProgress: function (count) {
      var dots = $('calib-dots').children;
      if (dots[count - 1]) dots[count - 1].classList.add('hit');
    },
    calibResult: function (offsetMs, taps) {
      $('btn-calib-start').textContent = A.i18n.t('calibAgain');
      if (offsetMs === null) {
        $('calib-value').textContent = taps + '/8';
        return;
      }
      $('calib-value').textContent = (offsetMs > 0 ? '+' : '') + offsetMs + ' ms';
      A.ui.refreshOffset();
      A.bridge.track('ardah_calibrated', { offsetMs: offsetMs });
    },

    setDebugVisible: function (on) { $('debug').hidden = !on; },
    setDebugText: function (text) { $('debug').textContent = text; }
  };

  /* -------------------------------- wiring -------------------------------- */

  function wire() {
    $('btn-play').addEventListener('click', function () { A.game.play(); });
    $('btn-howto').addEventListener('click', function () { A.ui.showScreen('screen-howto'); });
    $('btn-calibrate').addEventListener('click', function () {
      A.ui.showScreen('screen-calib');
      A.ui.calibReset(8);
      A.ui.refreshOffset();
    });
    $('btn-lang').addEventListener('click', function () { A.i18n.toggle(); });
    $('btn-debug').addEventListener('click', function () { A.game.toggleDebug(); });

    var closers = document.querySelectorAll('[data-close]');
    for (var i = 0; i < closers.length; i++) {
      closers[i].addEventListener('click', function () { A.ui.showScreen('screen-menu'); });
    }

    $('btn-calib-start').addEventListener('click', function () { A.game.startCalibration(); });
    $('btn-offset-minus').addEventListener('click', function () { A.game.setOffset(A.game.offsetMs - 5); });
    $('btn-offset-plus').addEventListener('click', function () { A.game.setOffset(A.game.offsetMs + 5); });

    $('btn-resume').addEventListener('click', function () { A.game.resume(); });
    $('btn-restart').addEventListener('click', function () { A.game.restart(); });
    $('btn-quit').addEventListener('click', function () { A.game.quit(); });
    $('btn-retry').addEventListener('click', function () { A.game.play(); });
    $('btn-menu').addEventListener('click', function () {
      A.ui.renderCharts();
      A.ui.showScreen('screen-menu');
    });

    // Calibration taps: anywhere on that screen, by touch or by key.
    var calib = $('screen-calib');
    calib.addEventListener('pointerdown', function (ev) {
      if (ev.target.closest('button')) return;      // buttons stay buttons
      A.game.calibTap(Math.max(0, Math.min(120, performance.now() - ev.timeStamp)));
    });
    window.addEventListener('keydown', function (ev) {
      if (A.game.phase !== 'calibrating') return;
      if (ev.key === ' ' || ev.code === 'Space') {
        ev.preventDefault();
        A.game.calibTap(Math.max(0, Math.min(120, performance.now() - ev.timeStamp)));
      }
    });
  }

  function boot() {
    A.i18n.apply();
    A.game.init($('stage'));
    A.game.onLanguageChanged = function () {
      A.ui.renderCharts();
      A.ui.refreshOffset();
    };
    wire();
    A.ui.renderCharts();
    A.ui.refreshOffset();
    A.ui.setDebugVisible(A.game.debug);
    A.ui.showScreen('screen-menu');
    A.bridge.track('ardah_opened', { inApp: A.bridge.inApp });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot);
  else boot();
})(window.Ardah);
