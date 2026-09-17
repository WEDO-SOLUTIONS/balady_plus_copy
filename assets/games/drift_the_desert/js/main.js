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
  var I18n = global.I18n;

  var GAUGE_ARC = 214;     // path length of the balance arc in the SVG
  var $ = function (id) { return doc.getElementById(id); };

  var el = {
    app: $('app'),
    scene: $('scene'),
    tint: $('sceneTint'),
    fx: $('fx'),

    loaderFill: $('loaderFill'),
    langToggle: $('langToggle'),
    langToggleLabel: $('langToggleLabel'),

    howtoArt: $('howtoArt'),
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

  /* ------------------------------------------------------- car preview */

  /** Reuses the scene's car renderer on a small standalone canvas so the
      how-to and results screens show the same vehicle as the game. */
  function makePreview(host, tilt, heightRatio, scale) {
    var canvas = doc.createElement('canvas');
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    canvas.style.display = 'block';
    host.appendChild(canvas);

    function draw() {
      var rect = host.getBoundingClientRect();
      if (rect.width < 4 || rect.height < 4) return;
      var dpr = Math.min(global.devicePixelRatio || 1, 2);
      canvas.width = Math.round(rect.width * dpr);
      canvas.height = Math.round(rect.height * dpr);
      var ctx = canvas.getContext('2d');
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.clearRect(0, 0, rect.width, rect.height);

      // Warm glow behind the car, as in the mockup.
      var glow = ctx.createRadialGradient(
        rect.width * 0.5, rect.height * 0.62, 4,
        rect.width * 0.5, rect.height * 0.62, rect.width * 0.6
      );
      glow.addColorStop(0, 'rgba(233, 197, 121, 0.22)');
      glow.addColorStop(1, 'rgba(233, 197, 121, 0)');
      ctx.fillStyle = glow;
      ctx.fillRect(0, 0, rect.width, rect.height);

      var saveCtx = Scene.ctx, saveW = Scene.w, saveH = Scene.h, saveDpr = Scene.dpr;
      Scene.ctx = ctx; Scene.w = rect.width; Scene.h = rect.height; Scene.dpr = dpr;
      Scene.drawCar(
        rect.width * 0.5,
        rect.height * (heightRatio || 0.6),
        // The rotated car (roof to tyres, arms out) needs ~1.3x its size in
        // both axes, so fit against whichever dimension is tighter.
        Math.min(rect.width * 0.72, rect.height * 0.68) * (scale || 1),
        tilt,
        Date.now() / 110,
        0
      );
      Scene.ctx = saveCtx; Scene.w = saveW; Scene.h = saveH; Scene.dpr = saveDpr;
    }

    return draw;
  }

  var previews = [];

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

    if (showScene) {
      Scene.render({
        tilt: game.state === 'idle' || game.state === 'over' ? Math.sin(now / 900) * 0.12 : game.tilt,
        speed: game.state === 'running' ? game.speed() : 200,
        coins: game.state === 'running' ? game.items : [],
        danger: game.danger,
        running: game.state === 'running' || game.state === 'countdown'
      }, dt);
    }

    for (var p = 0; p < previews.length; p++) previews[p]();
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

    previews.push(makePreview(el.howtoArt, -0.18, 0.56));
    previews.push(makePreview($('resultsArt'), 0.1, 0.5, 0.95));

    var best = global.DriftGame.progress.load().best;
    el.resBest.textContent = fmtNum(best);

    global.requestAnimationFrame(frame);

    // Splash loader, then straight into the instructions.
    var t0 = Date.now();
    var duration = 1700;
    var timer = global.setInterval(function () {
      var p = Math.min(1, (Date.now() - t0) / duration);
      el.loaderFill.style.width = (p * 100) + '%';
      if (p >= 1) {
        global.clearInterval(timer);
        global.setTimeout(function () { show('howto'); }, 220);
      }
    }, 60);
  }

  /* Debug handle — used by the QA harness (and handy in the WebView
     inspector) to drive the game without touching the UI. */
  global.DriftApp = {
    game: game,
    show: show,
    startRun: startRun,
    openRewards: openRewards,
    scene: Scene
  };

  if (doc.readyState === 'loading') doc.addEventListener('DOMContentLoaded', boot);
  else boot();
})(window);
