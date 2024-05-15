import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/shared/providers/integration_urls.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'urbi_metrics.g.dart';

enum MetricAction { tap, longPress, swipe, scroll, drag, type }

@Riverpod(keepAlive: true)
class UrbiMetrics extends _$UrbiMetrics {
  bool get isProduction =>
      ref.read(integrationUrlsProvider.notifier).isProduction;

  @override
  void build() {
    ref.watch(integrationUrlsProvider);
  }

  void logEvent(String eventName, [Map<String, dynamic>? extras]) {
    Metrics.logEvent(eventName, extras: extras);
  }

  void logEventAdvanced(
    String eventName, {
    String? group,
    Type? screen,
    String? action,
    Map<String, dynamic>? props,
  }) {
    Metrics.logEventAdvanced(eventName,
        group: group, screen: screen, action: action, props: props);
  }
}

class Metrics {
  static void logEvent(String eventName,
      {Map<String, dynamic>? extras, Type? object}) {
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
