import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Real transport for the `ours` pipeline: PostHog Cloud EU.
///
/// Requires `com.posthog.posthog.AUTO_INIT=false` in AndroidManifest.xml and
/// Info.plist — the SDK is set up programmatically because host and key come
/// from `.env.<flavor>` (`BALADY_ANALYTICS_URL` = https://eu.i.posthog.com,
/// `BALADY_ANALYTICS_KEY` = the project's public `phc_…` write key).
class PosthogBaladyAnalyticsSink implements BaladyAnalyticsSink {
  PosthogBaladyAnalyticsSink._(String host, String apiKey) : _ready = _setup(host, apiKey);

  static PosthogBaladyAnalyticsSink? _instance;

  /// Null when the flavor has no server configured — the facade then keeps its
  /// logging sink. Singleton because `configure()` has two call sites (host
  /// shell and mapness entry point) but the SDK must be set up once.
  static PosthogBaladyAnalyticsSink? tryCreate({required String host, required String apiKey}) {
    if (host.isEmpty || apiKey.isEmpty) {
      return null;
    }
    return _instance ??= PosthogBaladyAnalyticsSink._(host, apiKey);
  }

  /// Native SDK drops calls made before `setup()` completes; queueing every
  /// call behind this future keeps submission order and loses nothing.
  final Future<bool> _ready;

  static Future<bool> _setup(String host, String apiKey) async {
    try {
      final config = PostHogConfig(apiKey)
        ..host = host
        ..debug = kDebugMode
        ..captureApplicationLifecycleEvents = true
        // Debug builds flush every event immediately so it lands in PostHog
        // right away during QA; release keeps the default batching (flushAt 20 /
        // 30s / on background) for network + battery efficiency.
        ..flushAt = kDebugMode ? 1 : 20
        ..sessionReplay = false; // PII review pending — see docs/analytics/DEVOPS_BRIEF.md

      // --- Crash reporting -------------------------------------------------
      //
      // Why this exists at all, in the stakeholder's own words (translated
      // from the original Russian; the duplication is deliberate and agreed):
      //
      //   "The idea: check, or set up right away, whether we can get alerts /
      //    notifications out of PostHog when something goes wrong — to control
      //    and verify incidents or defects, and for monitoring. If, say, we hit
      //    a render crash in Android Auto, we want to understand what caused it
      //    (BE did not answer and/or other reasons) and have alerts for that
      //    event (it probably makes sense to aggregate the notification — i.e.
      //    if the event repeats, send it once, but say that it affects 100
      //    devices, etc.). Something is off with the accesses (the teams
      //    interact oddly and do not grant our team rights/access). And we
      //    agreed on this: even if we build one more duplicating piece of
      //    functionality, that is fine — it will be entirely under our own
      //    ownership."
      //
      // Concretely: the team has no working access to Elastic or Sentry, and
      // in this app Sentry is not even initialised on prod/stg/pre (the
      // `SentryFlutter.init` blocks in `lib/main_<flavor>.dart` are commented
      // out), while UXCam's `enableCrashHandling` reports into an account
      // nobody can open. So crashes are currently visible to no one. These
      // four switches make PostHog — which we do own — the crash channel.
      //
      // Autocapture chains rather than replaces: the SDK stores the existing
      // `FlutterError.onError` (installed by `unhandledExceptionBaladyLogs`)
      // and calls it after its own handler, so the legacy pipeline keeps
      // working. Zone errors are the exception — `runZonedGuarded` cannot be
      // hooked from outside, so that one path reports through the facade
      // explicitly (see `lib/app/events_logs/balady_logs.dart`).
      //
      // Coverage limits worth knowing before reading a dashboard:
      //   - Android captures Java/Kotlin only — no native C/C++. A crash
      //     inside the map SDK's NDK layer will not appear here.
      //   - Apple native capture is experimental upstream.
      //   - Readability of release stack traces differs by layer. Dart frames
      //     are readable as-is because CI does not pass `--obfuscate`, and
      //     that covers most of what is captured here (Flutter framework,
      //     zone, isolate errors). Native frames do need symbols uploaded per
      //     build: Android Java/Kotlin is minified (`minifyEnabled true`), and
      //     iOS release binaries ship stripped, leaving bare addresses. Both
      //     are uploaded from CI — see docs/analytics/SYMBOL_UPLOAD.md.
      config.errorTrackingConfig
        ..captureNativeExceptions = true
        ..captureFlutterErrors = true
        ..capturePlatformDispatcherErrors = true
        ..captureIsolateErrors = true;

      await Posthog().setup(config);
      debugPrint('[BaladyAnalytics] PostHog ready: host=$host, flushAt=${config.flushAt}');
      return true;
    } catch (e) {
      debugPrint('[BaladyAnalytics] PostHog setup failed, events will be dropped: $e');
      return false;
    }
  }

  @override
  void track(BaladyAnalyticsEvent event) {
    try {
      detach(
        _ready
            .then((ok) {
              if (!ok) {
                return null;
              }
              if (event.kind == BaladyAnalyticsEventKind.screen) {
                final path = event.properties['path'] as String? ?? event.name;
                return Posthog().screen(screenName: path, properties: _sanitize(event.properties));
              }
              if (event.kind == BaladyAnalyticsEventKind.error && event.error != null) {
                // Not `capture('$exception')`: only captureException runs the
                // exception processor that produces `$exception_list` with frames.
                // Without it PostHog cannot group occurrences into an issue, and
                // issue-based alerts have nothing to fire on.
                return Posthog().captureException(
                  error: event.error!,
                  stackTrace: event.stackTrace,
                  properties: _sanitize(event.properties),
                );
              }
              return Posthog().capture(eventName: event.name, properties: _sanitize(event.properties));
            })
            .catchError(_swallow),
        tag: 'posthogBaladyAnalyticsSink.capture',
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// A failed send must never escape as an unhandled async error. The zone
  /// handler in `unhandledExceptionBaladyLogs` reports zone errors back into
  /// this sink, so an error escaping here would be re-reported, fail again,
  /// and loop. Losing one dropped event beats a feedback loop.
  static void _swallow(Object e) => log('[BaladyAnalytics] send failed: $e');

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    detach(
      _ready
          .then((ok) {
            if (!ok) {
              return null;
            }
            if (userId == null) {
              return Posthog().reset();
            }
            return Posthog().identify(userId: userId, userProperties: _sanitize(traits));
          })
          .catchError(_swallow),
      tag: 'posthogBaladyAnalyticsSink.identify',
    );
  }

  @override
  void setSessionProperty(String key, Object? value) {
    // No-op: the facade already merges its session properties into every
    // event's properties, which is how they reach PostHog.
  }

  /// The SDK wants `Map<String, Object>` — null values must not cross the
  /// platform channel.
  Map<String, Object> _sanitize(Map<String, dynamic> props) => {
    for (final entry in props.entries)
      if (entry.value != null) entry.key: entry.value as Object,
  };
}
