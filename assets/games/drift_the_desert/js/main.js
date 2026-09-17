/* Drift the Desert — app shell.

   Owns the screen flow (splash → how to play → countdown → run → results →
   rewards), the HUD bindings, the FX layer and every input path (tap, key,
   pointer, accelerometer). */
(function (global) {
  'use strict';

  var doc = global.document;
  var Bridge = global.DriftBridge;
  var Audio = global.DriftAudio;
  var Scene = global.DriftScene;
  var Sky = global.DriftSky;
  var I18n = global.I18n;

  var GAUGE_ARC = 214;     // path length of the balance arc in the SVG
  var $ = function (id) { return doc.getElementById(id); };

  var el = {
    app: $('app'),
    scene: $('scene'),
    glscene: $('glscene'),
    tint: $('sceneTint'),
    fx: $('fx'),

    loaderFill: $('loaderFill'),
    langToggle: $('langToggle'),
    langToggleLabel: $('langToggleLabel'),

    btnStart: $('btnStart'),
    btnBackFromHowto: $('btnBackFromHowto'),

    countdownNum: $('countdownNum'),

    btnPause: $('btnPause'),
    hudCoins: $('hudCoins'),
    hudScore: $('hudScore'),
    hudCombo: $('hudCombo'),
    hudTime: $('hudTime'),
    hudTimeBar: $('hudTimeBar'),
    alert: $('alert'),
    alertText: $('alertText'),
    btnLeft: $('btnLeft'),
    btnRight: $('btnRight'),
    gaugeFill: $('gaugeFill'),
    gaugeCar: $('gaugeCar'),
    gaugeCaption: $('gaugeCaption'),

    resultsTitle: $('resultsTitle'),
    resScore: $('resScore'),
    resTime: $('resTime'),
    resCombo: $('resCombo'),
    resTokens: $('resTokens'),
    resBest: $('resBest'),
    btnPlayAgain: $('btnPlayAgain'),
    btnRewards: $('btnRewards'),

    rewTokens: $('rewTokens'),
    rewardBadge: $('rewardBadge'),
    rewardSkin: $('rewardSkin'),
    rewBadgeName: $('rewBadgeName'),
    rewSkinName: $('rewSkinName'),
    progLevel: $('progLevel'),
    progXp: $('progXp'),
    progXpMax: $('progXpMax'),
    progFill: $('progFill'),
    btnContinue: $('btnContinue'),
    btnViewInMap: $('btnViewInMap'),

    pauseModal: $('pauseModal'),
    btnResume: $('btnResume'),
    btnRestart: $('btnRestart'),
    btnQuit: $('btnQuit'),
    btnSound: $('btnSound')
  };

  var screens = {};
  var nodes = doc.querySelectorAll('[data-screen]');
  for (var i = 0; i < nodes.length; i++) screens[nodes[i].getAttribute('data-screen')] = nodes[i];

  var current = 'splash';
  var lastRun = null;
  var lastAward = null;
  var comboStat = doc.querySelector('.stat--combo');
  var coinPill = doc.querySelector('.coin-pill');

  /* -------------------------------------------------------------- utils */

  function show(name) {
    if (screens[current]) screens[current].classList.remove('is-active');
    current = name;
    if (screens[name]) screens[name].classList.add('is-active');
  }

  function fmtTime(seconds) {
    var s = Math.max(0, Math.floor(seconds));
    var m = Math.floor(s / 60);
    return (m < 10 ? '0' : '') + m + ':' + ((s % 60) < 10 ? '0' : '') + (s % 60);
  }

  function fmtNum(n) {
    return Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }

  function pop(html, className, xPct, yPct) {
    var node = doc.createElement('div');
    node.className = 'pop ' + className;
    node.innerHTML = html;
    node.style.left = (xPct * 100) + '%';
    node.style.top = (yPct * 100) + '%';
    el.fx.appendChild(node);
    global.setTimeout(function () {
      if (node.parentNode) node.parentNode.removeChild(node);
    }, 950);
  }

  /* ----------------------------------------------------------- the game */

  var game = new global.DriftGame({ onEvent: onGameEvent });

  function onGameEvent(name, data) {
    switch (name) {
      case 'countdown':
        if (data.value > 0) {
          el.countdownNum.textContent = data.value;
          el.countdownNum.classList.remove('is-tick');
          void el.countdownNum.offsetWidth;   // restart the CSS animation
          el.countdownNum.classList.add('is-tick');
          Audio.countdown(false);
        } else {
          el.countdownNum.textContent = I18n.t('countdown.go');
          Audio.countdown(true);
        }
        break;

      case 'start':
        show('play');
        Audio.startEngine();
        Bridge.track('drift_run_started', {});
        break;

      case 'tap':
        Audio.tap();
        Bridge.haptic('light');
        var btn = data.dir === 'left' ? el.btnLeft : el.btnRight;
        btn.classList.add('is-hit');
        global.setTimeout(function () { btn.classList.remove('is-hit'); }, 130);
        break;

      case 'great':
        pop(
          '<b>+' + data.points + '</b><span>' + I18n.t(data.perfect ? 'fx.perfect' : 'fx.great') + '</span>',
          'pop--great',
          0.72,
          0.46
        );
        Audio.great();
        break;

      case 'coin':
        var lane = data.lane;
        pop('<b>+' + data.score + '</b>', 'pop--coin', 0.5 + lane * 0.22, 0.58);
        Audio.coin(game.coins);
        Bridge.haptic('light');
        coinPill.classList.add('is-bump');
        global.setTimeout(function () { coinPill.classList.remove('is-bump'); }, 320);
        Scene.addSparks(
          Scene.w * (0.5 + lane * 0.24),
          Scene.h * 0.6,
          12,
          '#F7E2A8'
        );
        break;

      case 'combo':
        comboStat.classList.add('is-bump');
        global.setTimeout(function () { comboStat.classList.remove('is-bump'); }, 180);
        comboStat.classList.toggle('is-hot', data.combo >= 10);
        if (data.combo % 5 === 0) {
          pop('<b>x' + data.combo + '</b><span>' + I18n.t('fx.combo') + '</span>', 'pop--combo', 0.28, 0.42);
        }
        Audio.combo(data.combo);
        break;

      case 'comboLost':
        comboStat.classList.remove('is-hot');
        break;

      case 'zone':
        if (data.zone === 'danger') {
          Audio.warn();
          Bridge.haptic('medium');
        }
        break;

      case 'crash':
        Audio.crash();
        Audio.stopEngine();
        Bridge.haptic('heavy');
        Scene.kick(1);
        Scene.addDust(Scene.w * 0.5, Scene.h * 0.7, 40, 1);
        break;

      case 'finish':
        Audio.stopEngine();
        if (!data.crashed) Audio.finish();
        onRunFinished(data);
        break;

      default:
        break;
    }
  }

  function onRunFinished(run) {
    lastRun = run;
    lastAward = global.DriftGame.progress.apply(run);

    el.resultsTitle.textContent = I18n.t(run.crashed ? 'results.titleCrash' : 'results.title');
    el.resScore.textContent = fmtNum(run.score);
    el.resTime.textContent = fmtTime(run.time);
    el.resCombo.textContent = 'x' + run.combo;
    el.resTokens.textContent = '+' + run.tokens;
    el.resBest.textContent = fmtNum(lastAward.progress.best);

    Bridge.submitRun(run);
    Bridge.track('drift_run_finished', {
      score: run.score,
      combo: run.combo,
      coins: run.coins,
      tokens: run.tokens,
      crashed: run.crashed
    });

    // Let the crash / finish beat land before swapping screens.
    global.setTimeout(function () {
      el.tint.classList.remove('is-danger');
      show('results');
    }, run.crashed ? 900 : 700);
  }

  function openRewards() {
    var award = lastAward || global.DriftGame.progress.apply({ score: 0, tokens: 0, time: 0, combo: 0, coins: 0 });
    var p = award.progress;

    el.rewTokens.textContent = '+' + (lastRun ? lastRun.tokens : 0);

    el.rewardBadge.classList.toggle('is-locked', !p.badge);
    el.rewBadgeName.textContent = p.badge
      ? I18n.t('rewards.badgeDesertDrifter')
      : I18n.t('rewards.badgeLocked');

    el.rewardSkin.classList.toggle('is-locked', !p.skin);
    el.rewSkinName.textContent = p.skin
      ? I18n.t('rewards.skinSandEdition')
      : I18n.t('rewards.skinLocked');

    el.progLevel.textContent = p.level;
    el.progXp.textContent = fmtNum(p.xp);
    el.progXpMax.textContent = fmtNum(award.xpMax);
    el.progFill.style.width = '0%';

    show('rewards');
    global.setTimeout(function () {
      el.progFill.style.width = Math.min(100, (p.xp / award.xpMax) * 100) + '%';
    }, 120);

    Bridge.claimRewards({
      tokens: lastRun ? lastRun.tokens : 0,
      level: p.level,
      xp: p.xp,
      badgeUnlocked: award.badgeUnlocked,
      skinUnlocked: award.skinUnlocked
    });
  }

  /* --------------------------------------------------------------- HUD */

  function syncHud() {
    el.hudScore.textContent = fmtNum(game.score);
    el.hudCombo.textContent = 'x' + game.combo;
    el.hudCoins.textContent = game.coins;
    el.hudTime.textContent = fmtTime(game.time);
    el.hudTimeBar.style.width = (game.time / global.DriftGame.CONFIG.runSeconds * 100) + '%';

    var tilt = game.tilt;
    var absTilt = Math.abs(tilt);
    var zone = game.zone;

    // Balance arc reads like a fuel gauge: full while balanced, draining as
    // the car tips towards either failure.
    el.gaugeFill.style.strokeDashoffset = (GAUGE_ARC * Math.min(1, absTilt)).toFixed(1);
    el.gaugeFill.style.stroke =
      zone === 'great' ? 'var(--mint)' : (zone === 'good' ? '#E9C579' : 'var(--danger)');
    el.gaugeCar.style.transform = 'rotate(' + (tilt * 34).toFixed(1) + 'deg)';

    el.gaugeCaption.textContent = I18n.t(
      zone === 'danger' ? 'hud.correctIt' : (zone === 'good' ? 'hud.goodBalance' : (absTilt < 0.12 ? 'hud.perfect' : 'hud.keepBalance'))
    );

    var danger = zone === 'danger';
    el.alert.classList.toggle('is-on', danger);
    if (danger) {
      el.alertText.textContent = I18n.t(tilt < 0 ? 'hud.tooFarLeft' : 'hud.tooFarRight');
    }
    el.tint.classList.toggle('is-danger', danger);

    // Nudge the player towards the correcting button.
    el.btnLeft.classList.toggle('is-urgent', danger && tilt < 0);
    el.btnRight.classList.toggle('is-urgent', danger && tilt > 0);

    Audio.setEngineLoad(absTilt);
  }

  function clearHudFlags() {
    el.alert.classList.remove('is-on');
    el.tint.classList.remove('is-danger');
    el.btnLeft.classList.remove('is-urgent');
    el.btnRight.classList.remove('is-urgent');
    comboStat.classList.remove('is-hot');
  }

  /* -------------------------------------------------------------- loop */

  var lastFrame = 0;

  /** 0 = golden hour at the start of a run, 1 = dusk at the end of it. */
  function duskLevel() {
    if (game.state === 'running' || game.state === 'paused' || game.state === 'over') {
      return Math.min(1, game.time / global.DriftGame.CONFIG.runSeconds);
    }
    return 0;
  }

  function frame(now) {
    global.requestAnimationFrame(frame);

    var dt = lastFrame ? Math.min((now - lastFrame) / 1000, 0.05) : 0.016;
    lastFrame = now;

    if (game.state === 'running' || game.state === 'countdown') {
      game.update(dt);
      if (game.state === 'running') syncHud();
    }

    var showScene = current === 'splash' || current === 'countdown' || current === 'play';
    el.scene.style.opacity = showScene ? '1' : '0';
    if (Sky.active) el.glscene.style.opacity = showScene ? '1' : '0';

    if (showScene) {
      var speed = game.state === 'running' ? game.speed() : 200;
      var dusk = duskLevel();

      Scene.render({
        tilt: game.state === 'idle' || game.state === 'over' ? Math.sin(now / 900) * 0.12 : game.tilt,
        speed: speed,
        coins: game.state === 'running' ? game.items : [],
        danger: game.danger,
        dusk: dusk,
        running: game.state === 'running' || game.state === 'countdown'
      }, dt);

      Sky.observe(dt * 1000);

      // Same scroll and horizon as the 2D layer, so the parallax lines up.
      Sky.render({
        scroll: Scene.scroll,
        horizon: Scene.horizon,
        dusk: dusk,
        speed: Math.max(0, Math.min(1, (speed - 240) / 460))
      });
    }

  }

  /* ------------------------------------------------------------ inputs */

  function tap(dir) {
    Audio.unlock();
    game.tap(dir);
  }

  function bindTap(node, handler) {
    node.addEventListener('pointerdown', function (e) {
      e.preventDefault();
      handler(e);
    });
    // Safari < 13 in older WebViews has no PointerEvent.
    if (!global.PointerEvent) {
      node.addEventListener('touchstart', function (e) { e.preventDefault(); handler(e); }, { passive: false });
      node.addEventListener('click', handler);
    }
  }

  bindTap(el.btnLeft, function () { tap('left'); });
  bindTap(el.btnRight, function () { tap('right'); });

  // Tapping anywhere on the left / right half of the play area works too.
  screens.play.addEventListener('pointerdown', function (e) {
    if (game.state !== 'running') return;
    if (e.target.closest && e.target.closest('button, .gauge')) return;
    var rect = el.app.getBoundingClientRect();
    tap(e.clientX - rect.left < rect.width / 2 ? 'left' : 'right');
  });
  screens.play.style.pointerEvents = 'auto';

  doc.addEventListener('keydown', function (e) {
    if (e.repeat) return;
    var key = e.key;
    if (key === 'ArrowLeft' || key === 'a' || key === 'A') { e.preventDefault(); tap('left'); }
    else if (key === 'ArrowRight' || key === 'd' || key === 'D') { e.preventDefault(); tap('right'); }
    else if (key === 'Escape' || key === 'p' || key === 'P') { togglePause(); }
    else if (key === 'Enter' || key === ' ') {
      if (current === 'howto') startRun();
      else if (current === 'results') startRun();
    }
  });

  el.btnStart.addEventListener('click', startRun);
  el.btnPlayAgain.addEventListener('click', startRun);
  el.btnRewards.addEventListener('click', openRewards);
  el.btnBackFromHowto.addEventListener('click', quit);
  el.btnQuit.addEventListener('click', quit);
  el.btnViewInMap.addEventListener('click', function () {
    Bridge.openMap({ source: 'drift_the_desert' });
  });
  el.btnContinue.addEventListener('click', function () {
    clearHudFlags();
    show('howto');
  });

  el.btnPause.addEventListener('click', togglePause);
  el.btnResume.addEventListener('click', togglePause);
  el.btnRestart.addEventListener('click', function () {
    el.pauseModal.classList.remove('is-open');
    startRun();
  });
  el.btnSound.addEventListener('click', function () {
    var on = Audio.toggle();
    el.btnSound.textContent = I18n.t(on ? 'pause.sound' : 'pause.soundOff');
    if (on && game.state === 'running') Audio.startEngine();
  });

  el.langToggle.addEventListener('click', function () {
    var next = I18n.lang === 'ar' ? 'en' : 'ar';
    I18n.set(next);
  });

  global.addEventListener('drift:lang', function () {
    el.langToggleLabel.textContent = I18n.lang === 'ar' ? 'English' : 'العربية';
    el.btnSound.textContent = I18n.t(Audio.enabled ? 'pause.sound' : 'pause.soundOff');
  });

  doc.addEventListener('visibilitychange', function () {
    if (doc.hidden && game.state === 'running') {
      game.pause();
      el.pauseModal.classList.add('is-open');
    }
  });

  function togglePause() {
    if (game.state === 'running') {
      game.pause();
      Audio.stopEngine();
      el.pauseModal.classList.add('is-open');
    } else if (game.state === 'paused') {
      el.pauseModal.classList.remove('is-open');
      game.resume();
      Audio.startEngine();
    }
  }

  function startRun() {
    Audio.unlock();
    clearHudFlags();
    el.pauseModal.classList.remove('is-open');
    el.hudScore.textContent = '0';
    el.hudCombo.textContent = 'x0';
    el.hudCoins.textContent = '0';
    el.hudTime.textContent = '00:00';
    el.hudTimeBar.style.width = '0%';
    show('countdown');
    game.startCountdown(3);
  }

  function quit() {
    Audio.stopEngine();
    Bridge.track('drift_closed', { screen: current });
    if (!Bridge.close()) {
      // Standalone browser: there is nowhere to go, so restart the loop.
      clearHudFlags();
      game.reset();
      show('howto');
    }
  }

  /* --------------------------------------------------------------- boot */

  function boot() {
    I18n.set(I18n.detect());
    el.langToggleLabel.textContent = I18n.lang === 'ar' ? 'English' : 'العربية';

    Scene.init(el.scene);
    el.scene.style.transition = 'opacity 320ms ease';

    // The shader background is an enhancement: when it cannot start, the 2D
    // scene keeps drawing its own sky, mesas and dunes exactly as before.
    Sky.onFallback = function () {
      Scene.glBackground = false;
      el.glscene.style.display = 'none';
    };
    if (Sky.start(el.glscene)) {
      Scene.glBackground = true;
      el.glscene.style.transition = 'opacity 320ms ease';
      global.addEventListener('resize', function () { Sky.resize(); });
      global.addEventListener('orientationchange', function () { Sky.resize(); });
    } else {
      el.glscene.style.display = 'none';
    }

    var best = global.DriftGame.progress.load().best;
    el.resBest.textContent = fmtNum(best);

    global.requestAnimationFrame(frame);

    // The splash bar tracks the real artwork load, with a floor so it never
    // flashes past on a warm cache and a ceiling so a stalled image cannot
    // strand the player on the splash screen.
    var t0 = Date.now();
    var minMs = 1500;
    var loaded = 0;
    var entered = false;

    function enter() {
      if (entered) return;
      entered = true;
      el.loaderFill.style.width = '100%';
      global.setTimeout(function () { show('howto'); }, 220);
    }

    Scene.loadImages([
      ['car', 'img/car.png'],
      ['coin', 'img/coin.png'],
      ['sky', 'img/sky.jpg'],
      ['ridge', 'img/ridge.png'],
      ['sand', 'img/sand.jpg']
    ], function (p) { loaded = p; });

    var timer = global.setInterval(function () {
      var elapsed = (Date.now() - t0) / minMs;
      el.loaderFill.style.width = (Math.min(1, Math.min(elapsed, 0.15 + loaded * 0.85)) * 100) + '%';
      if ((loaded >= 1 && elapsed >= 1) || elapsed >= 4) {
        global.clearInterval(timer);
        enter();
      }
    }, 60);
  }

  /* Debug handle — used by the QA harness (and handy in the WebView
     inspector) to drive the game without touching the UI. */
  global.DriftApp = {
    game: game,
    sky: Sky,
    show: show,
    startRun: startRun,
    openRewards: openRewards,
    scene: Scene
  };

  if (doc.readyState === 'loading') doc.addEventListener('DOMContentLoaded', boot);
  else boot();
})(window);
