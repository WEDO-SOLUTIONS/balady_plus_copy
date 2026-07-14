import 'package:mapness/features/balady_analytics/balady_analytics.dart';

enum MetricAction { tap, longPress, swipe, scroll, drag, type }

/// Legacy event wrapper kept for its ~145 call sites across mapness.
/// Used to feed UXCam; now feeds [BaladyAnalytics]. UXCam flattened everything
/// into a `group::screen::name => action` string — here the context travels as
/// structured properties instead, so the backend can filter/group natively.
class Metrics {
  static void logEvent(String eventName, {Map<String, dynamic>? extras, Type? object}) {
    BaladyAnalytics.instance.track(
      eventName,
      properties: {
        if (object != null) 'object': object.toString(),
        ...?extras,
      },
    );
  }

  static void logEventAdvanced(
    String eventName, {
    String? group,
    Type? screen,
    String? action,
    Map<String, dynamic>? props,
  }) {
    BaladyAnalytics.instance.track(
      eventName,
      properties: {
        if (group != null) 'group': group,
        if (screen != null) 'screen': screen.toString(),
        if (action != null) 'action': action,
        ...?props,
      },
    );
  }

  static void logException([Object? ex, StackTrace? stack]) {
    BaladyAnalytics.instance.error(ex, stack);
  }
}
