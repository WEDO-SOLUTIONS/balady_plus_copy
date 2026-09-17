/* Drift the Desert — host bridge.

   The game runs in three places and must behave the same in all of them:
     1. a plain browser tab (development / QA),
     2. the Balady+ mini-apps WebView (dsbridge_flutter — `window.dsBridge`),
     3. a bare flutter_inappwebview / webview_flutter host.

   Everything degrades to a console log when no host is present, so nothing
   here can break the browser build. */
(function (global) {
  'use strict';

  var doc = global.document;

  function hasDsBridge() {
    return !!(global.dsBridge && typeof global.dsBridge.call === 'function');
  }

  function hasInAppWebView() {
    return !!(global.flutter_inappwebview && global.flutter_inappwebview.callHandler);
  }

  function hasChannel() {
    return !!(global.DriftChannel && typeof global.DriftChannel.postMessage === 'function');
  }

  function log(name, payload) {
    if (global.console && console.info) {
      console.info('[DriftBridge] ' + name, payload != null ? payload : '');
    }
  }

  /** Fire-and-forget event towards the host; no-op in the browser. */
  function send(name, payload) {
    var data = payload || {};
    try {
      if (hasChannel()) {
        global.DriftChannel.postMessage(JSON.stringify({ event: name, data: data }));
        return true;
      }
      if (hasInAppWebView()) {
        global.flutter_inappwebview.callHandler(name, data);
        return true;
      }
      if (hasDsBridge()) {
        global.dsBridge.call(name, data);
        return true;
      }
    } catch (e) {
      log('send failed: ' + name, e && e.message);
    }
    log(name, data);
    return false;
  }

  var Bridge = {
    /** Language the host asked for, injected as `window.__DRIFT_LANG__`. */
    preferredLanguage: global.__DRIFT_LANG__ || null,

    isNative: function () {
      return hasDsBridge() || hasInAppWebView() || hasChannel();
    },

    /** Web app finished booting and is interactive. */
    ready: function (info) {
      return send('driftGameReady', info || {});
    },

    /** A run finished: score, duration, combo and tokens the player earned. */
    submitRun: function (run) {
      return send('driftRunFinished', run);
    },

    /** Player collected the rewards screen: persist tokens / level app-side. */
    claimRewards: function (rewards) {
      return send('driftRewardsClaimed', rewards);
    },

    /** Close the mini app and return to the map. */
    close: function () {
      if (hasDsBridge()) {
        try {
          global.dsBridge.call('closeCurrentMiniApp', {});
          return true;
        } catch (e) { /* fall through */ }
      }
      if (send('driftClose', {})) return true;
      log('close (no host) — staying in page');
      return false;
    },

    /** "VIEW IN MAP": ask the super app to focus the drift spot on the map. */
    openMap: function (place) {
      if (hasDsBridge()) {
        try {
          global.dsBridge.call('navigateToSuperAppScreen', { screen: 'map', payload: place || {} });
          return true;
        } catch (e) { /* fall through */ }
      }
      return send('driftOpenMap', place || {});
    },

    /** Analytics passthrough — mirrors the super app's trackEvent contract. */
    track: function (name, params) {
      if (hasDsBridge()) {
        try {
          global.dsBridge.call('trackEvent', { eventName: name, parameters: params || {} });
          return true;
        } catch (e) { /* fall through */ }
      }
      return send('driftTrack', { eventName: name, parameters: params || {} });
    },

    /** Light haptic; uses the Vibration API in browsers that expose it. */
    haptic: function (kind) {
      try {
        if (global.navigator && global.navigator.vibrate) {
          var pattern = kind === 'heavy' ? 28 : kind === 'medium' ? 16 : 8;
          global.navigator.vibrate(pattern);
        }
      } catch (e) { /* ignored */ }
    }
  };

  /* ------------------------------------------------------------------ */
  /* Local persistence — best score, tokens and level survive reloads and
     WebView restarts. Falls back to memory when storage is unavailable
     (private mode / WebViews with storage disabled).                    */

  var MEM = {};
  var KEY = 'drift_the_desert_v1';

  function readStore() {
    try {
      var raw = global.localStorage.getItem(KEY);
      return raw ? JSON.parse(raw) : {};
    } catch (e) {
      return MEM;
    }
  }

  function writeStore(obj) {
    MEM = obj;
    try {
      global.localStorage.setItem(KEY, JSON.stringify(obj));
    } catch (e) { /* memory-only */ }
  }

  Bridge.store = {
    get: function (key, fallback) {
      var data = readStore();
      return data[key] != null ? data[key] : fallback;
    },
    set: function (key, value) {
      var data = readStore();
      data[key] = value;
      writeStore(data);
      return value;
    },
    all: readStore
  };

  global.DriftBridge = Bridge;

  if (doc.readyState === 'loading') {
    doc.addEventListener('DOMContentLoaded', function () { Bridge.ready({ version: '1.0.0' }); });
  } else {
    Bridge.ready({ version: '1.0.0' });
  }
})(window);
