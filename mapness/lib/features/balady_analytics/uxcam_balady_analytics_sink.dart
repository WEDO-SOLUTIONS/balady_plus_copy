import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';

/// UXCam session recording, back under the facade as the `uxcam` channel.
///
/// Removed in July 2026 as a dead vendor stream; restored on 2026-09-06 —
/// marketing works with the session recordings and asked for them back.
///
/// UXCam used to be wired into feature code directly (`FlutterUxcam.logEvent`,
/// `tagScreenName`, `setUserIdentity`, …). It is now a sink like any other:
/// the events the facade already collects are mirrored here, so the recordings
/// carry the same event/screen timeline as before without a second set of call
/// sites to keep in sync.
///
/// Two things that were wrong before the removal and are not restored:
/// - mapness started UXCam with the **production** app key hard-coded, so
///   dev/stg sessions landed in the prod UXCam app. The key now always comes
///   from `RemoteConfig.uxCamKey` (empty on dev/urbiPre → SDK never starts).
/// - the SDK was started twice (host shell + mapness entry point) with two
///   different configs. [tryCreate] is a singleton, so it starts once.
class UxcamBaladyAnalyticsSink implements BaladyAnalyticsSink {
  UxcamBaladyAnalyticsSink._(String appKey) : _ready = _start(appKey);

  static UxcamBaladyAnalyticsSink? _instance;

  /// Null when the flavor has no UXCam app key — the channel is then not
  /// registered and nothing is recorded.
  static UxcamBaladyAnalyticsSink? tryCreate({required String appKey}) {
    if (appKey.isEmpty) {
      return null;
    }
    return _instance ??= UxcamBaladyAnalyticsSink._(appKey);
  }

  /// Crash reporting stays with PostHog Error Tracking (see
  /// [PosthogBaladyAnalyticsSink]): that is the channel the team can actually
  /// open and alert on, and two native crash handlers installed over each
  /// other is the usual way to lose reports. Handled exceptions still reach
  /// UXCam through [BaladyAnalytics.error] as `reportExceptionEvent`. Flip
  /// this one flag if UXCam should own crashes again.
  static const _enableCrashHandling = false;

  /// The native SDK drops calls made before `startWithConfiguration`
  /// completes; queueing behind this future keeps order and loses nothing.
  final Future<bool> _ready;

  static Future<bool> _start(String appKey) async {
    try {
      final config = FlutterUxConfig(
        userAppKey: appKey,
        enableAdvancedGestureRecognition: true,
        enableCrashHandling: _enableCrashHandling,
        enableMultiSessionRecord: true,
        enableNetworkLogging: kDebugMode,
        // Screens are tagged from the facade (`screen()` → `tagScreenName`),
        // which knows the real route paths; automatic tagging would name them
        // after widget classes and fight the manual tags.
        enableAutomaticScreenNameTagging: false,
      );
      await FlutterUxcam.optIntoSchematicRecordings();
      await FlutterUxcam.startWithConfiguration(config);
      debugPrint('[BaladyAnalytics] UXCam started');
      return true;
    } catch (e) {
      debugPrint('[BaladyAnalytics] UXCam start failed, events will be dropped: $e');
      return false;
    }
  }

  @override
  void track(BaladyAnalyticsEvent event) {
    unawaited(_send(event).catchError(_swallow));
  }

  Future<void> _send(BaladyAnalyticsEvent event) async {
    if (!await _ready) {
      return;
    }
    switch (event.kind) {
      case BaladyAnalyticsEventKind.screen:
        await FlutterUxcam.tagScreenName(event.properties['path'] as String? ?? event.name);
      case BaladyAnalyticsEventKind.error:
        await FlutterUxcam.reportExceptionEvent(
          event.error ?? event.properties['exception'],
          event.stackTrace,
        );
      case BaladyAnalyticsEventKind.track:
        final properties = _sanitize(event.properties);
        if (properties.isEmpty) {
          await FlutterUxcam.logEvent(event.name);
        } else {
          await FlutterUxcam.logEventWithProperties(event.name, properties);
        }
    }
  }

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    unawaited(_identify(userId, traits).catchError(_swallow));
  }

  Future<void> _identify(String? userId, Map<String, dynamic> traits) async {
    if (!await _ready) {
      return;
    }
    await FlutterUxcam.setUserIdentity(userId);
    if (userId == null) {
      // Logout: no identity, no traits to attach.
      return;
    }
    for (final trait in traits.entries) {
      await FlutterUxcam.setUserProperty(trait.key, trait.value?.toString() ?? '');
    }
  }

  @override
  void setSessionProperty(String key, Object? value) {
    if (value == null) {
      return;
    }
    unawaited(
      _ready
          .then((ok) => ok ? FlutterUxcam.setSessionProperty(key, value.toString()) : null)
          .catchError(_swallow),
    );
  }

  /// A failed send must never escape as an unhandled async error: the zone
  /// handler reports zone errors back into the facade, which would re-enter
  /// this sink and loop. Losing one event beats a feedback loop.
  static void _swallow(Object e) => log('[BaladyAnalytics] UXCam send failed: $e');

  /// UXCam's platform channel takes primitives only — nulls are dropped and
  /// anything exotic goes over as its string form.
  Map<String, dynamic> _sanitize(Map<String, dynamic> properties) => {
    for (final entry in properties.entries)
      if (entry.value != null)
        entry.key: switch (entry.value) {
          String() || num() || bool() => entry.value,
          _ => entry.value.toString(),
        },
  };
}
