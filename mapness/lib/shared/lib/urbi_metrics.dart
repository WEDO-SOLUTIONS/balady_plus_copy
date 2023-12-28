import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/shared/providers/integration_urls.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'urbi_metrics.g.dart';

@Riverpod(keepAlive: true)
class UrbiMetrics extends _$UrbiMetrics {
  bool get isProduction =>
      ref.read(integrationUrlsProvider.notifier).isProduction;

  @override
  void build() {
    ref.watch(integrationUrlsProvider);
  }

  void logEvent(String eventName, [Map<String, dynamic>? extras]) {
    // if (!isProduction) {
    //   return;
    // }
    if (extras == null) {
      FlutterUxcam.logEvent(eventName);
      return;
    }
    FlutterUxcam.logEventWithProperties(eventName, extras);
  }
}
