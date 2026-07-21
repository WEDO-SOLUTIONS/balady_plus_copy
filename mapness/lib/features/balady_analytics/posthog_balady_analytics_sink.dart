import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';
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
      unawaited(
        _ready.then((ok) {
          if (!ok) {
            return null;
          }
          if (event.kind == BaladyAnalyticsEventKind.screen) {
            final path = event.properties['path'] as String? ?? event.name;
            return Posthog().screen(screenName: path, properties: _sanitize(event.properties));
          }
          return Posthog().capture(eventName: event.name, properties: _sanitize(event.properties));
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    unawaited(
      _ready.then((ok) {
        if (!ok) {
          return null;
        }
        if (userId == null) {
          return Posthog().reset();
        }
        return Posthog().identify(userId: userId, userProperties: _sanitize(traits));
      }),
    );
  }

  /// The SDK wants `Map<String, Object>` — null values must not cross the
  /// platform channel.
  Map<String, Object> _sanitize(Map<String, dynamic> props) => {
    for (final entry in props.entries)
      if (entry.value != null) entry.key: entry.value as Object,
  };
}
