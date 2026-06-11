import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/entities/metrics/logger/metrics_logger.dart';

enum MetricAction { tap, longPress, swipe, scroll, drag, type }

class Metrics {
  static void logEvent(String eventName, {Map<String, dynamic>? extras, Type? object}) {
    metricsLogger.sendEvent(
      eventType: eventName,
      services: [MetricsLoggerService.uxCam],
      payload: extras != null || object != null
          ? {
              ...?extras,
              if (object != null) 'object': object.toString(),
            }
          : null,
    );

    final str = StringBuffer();

    if (object != null) {
      str.write('${object.toString()}::');
    }

    str.write(eventName);

    if (extras == null) {
      FlutterUxcam.logEvent(str.toString());
      return;
    }

    FlutterUxcam.logEventWithProperties(str.toString(), extras);
  }

  static void logEventAdvanced(
    String eventName, {
    String? group,
    Type? screen,
    String? action,
    Map<String, dynamic>? props,
  }) {
    metricsLogger.sendEvent(
      eventType: eventName,
      services: [MetricsLoggerService.uxCam],
      payload: props != null || group != null || screen != null || action != null
          ? {
              ...?props,
              if (group != null) 'group': group,
              if (screen != null) 'screen': screen,
              if (action != null) 'action': action,
            }
          : null,
    );
    final str = StringBuffer();

    if (group != null) {
      str.write('$group::');
    }
    if (screen != null) {
      str.write('${screen.toString()}::');
    }

    str.write(eventName);

    if (action != null) {
      str.write(' => $action');
    }

    if (props == null) {
      FlutterUxcam.logEvent(str.toString());
      return;
    }

    FlutterUxcam.logEventWithProperties(str.toString(), props);
  }

  static void logException([dynamic ex, StackTrace? stack]) {
    FlutterUxcam.reportExceptionEvent(ex, stack);
  }
}
