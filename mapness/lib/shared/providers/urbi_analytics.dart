import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/analytics.dart' show Analytics;
import 'package:urbi_analytics/client.dart';
import 'package:urbi_analytics/state.dart';

part 'urbi_analytics.g.dart';

final analyticsClient = createClient(
  Configuration('balady-metrics.urbi.ae/metrics-api'),
);

@Riverpod(keepAlive: true)
class UrbiAnalytics extends _$UrbiAnalytics {
  @override
  Analytics build() => analyticsClient;

  Future<void> trackWithPrint(String event, {Map<String, dynamic>? properties}) async {
    logger.log(event);
    await state.track(event, properties: properties);
  }
}
