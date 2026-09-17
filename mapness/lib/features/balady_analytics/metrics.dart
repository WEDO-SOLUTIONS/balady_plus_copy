import 'package:mapness/features/balady_analytics/balady_analytics.dart';

enum MetricAction { tap, longPress, swipe, scroll, drag, type }

/// The mapness UI event stream marketing works with in UXCam — ~145 call sites
/// (`Metrics.logEventAdvanced(MetricsConstants…)`) covering taps, swipes and
/// sheet opens across the map, search, routing, POI cards and the landing
/// dashboard.
///
/// History: these calls fed UXCam directly, were retargeted to
/// [BaladyAnalytics] when UXCam was removed in July 2026, and were then dropped
/// with the SDK. On 2026-09-06 marketing asked for UXCam back — they use these
/// recordings — so the wrapper is restored, this time as a thin adapter over
/// the facade instead of a second analytics API.
///
/// Routing: [BaladyAnalyticsChannel.uxcam] only. This is deliberate — our own
/// PostHog pipeline keeps exactly the event set it has today (deliberate
/// tracking-plan events, see `docs/analytics-tracking-plan.md`), and these 145
/// legacy UI events would multiply its volume for no analytical gain.
class Metrics {
  static void logEvent(String eventName, {Map<String, dynamic>? extras, Type? object}) {
    _track(eventName, {
      if (object != null) 'object': object.toString(),
      ...?extras,
    });
  }

  static void logEventAdvanced(
    String eventName, {
    String? group,
    Type? screen,
    String? action,
    Map<String, dynamic>? props,
  }) {
    _track(eventName, {
      if (group != null) 'group': group,
      if (screen != null) 'screen': screen.toString(),
      if (action != null) 'action': action,
      ...?props,
    });
  }

  /// UXCam used to flatten all of this into one `group::screen::name => action`
  /// string; the context travels as structured properties instead, which UXCam
  /// shows as event properties and can filter on.
  static void _track(String eventName, Map<String, dynamic> properties) {
    BaladyAnalytics.instance.track(
      eventName,
      properties: properties,
      channels: const {BaladyAnalyticsChannel.uxcam},
    );
  }

  /// Exceptions are not marketing data: they go through the facade's error
  /// path, which reaches PostHog Error Tracking and — as an always-on channel —
  /// UXCam's `reportExceptionEvent` as well.
  static void logException([Object? ex, StackTrace? stack]) {
    BaladyAnalytics.instance.error(ex, stack);
  }
}
