/* Host bridge.
   Inside the Balady+ superapp the page is served from the mini-app engine's
   localhost server and `window.dsBridge` is injected (dsbridge_flutter, see
   lib/super_app_js_bridge/). In a plain browser none of that exists, so every
   call degrades to a no-op or a web equivalent — which is what makes the same
   build testable at a desk.

   Deliberately tiny surface: the game needs no SSO token, no location, no
   camera. Keeping it that way is also the answer to the bridge's permission
   scoping problem noted in the concept doc (§6.3). */
window.Ardah = window.Ardah || {};
(function (A) {
  'use strict';

  var ds = window.dsBridge || null;

  function call(name, payload) {
    if (!ds || typeof ds.call !== 'function') return null;
    try {
      return ds.call(name, payload === undefined ? '' : JSON.stringify(payload));
    } catch (e) {
      // A missing host method must never take the game down with it.
      if (window.console) console.warn('[ardah-bridge] ' + name + ' failed', e);
      return null;
    }
  }

  A.bridge = {
    /** True when running inside the superapp WebView. */
    inApp: !!ds,

    /** Analytics. Host-side this lands in balady_analytics via `trackEvent`. */
    track: function (event, params) {
      if (ds) call('trackEvent', { eventName: event, parameters: params || {} });
      else if (window.console && A.debugEvents) console.log('[ardah-event]', event, params || {});
    },

    /** Hit feedback. WKWebView has no Vibration API and the host bridge has no
        `vibrate` method yet (concept doc §6.3.4) — so this is best-effort by
        design and the game never depends on it. */
    vibrate: function (ms) {
      if (navigator.vibrate) { try { navigator.vibrate(ms); } catch (e) { /* ignore */ } }
    },

    /** Closes the mini-app. In a browser there is nothing to close. */
    close: function () {
      if (ds) call('closeCurrentMiniApp');
    }
  };
})(window.Ardah);
