import 'package:flutter_uxcam/flutter_uxcam.dart';

enum MetricAction { tap, longPress, swipe, scroll, drag, type }

class Metrics {
  static void logEvent(String eventName, {Map<String, dynamic>? extras, Type? object}) {
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
}
