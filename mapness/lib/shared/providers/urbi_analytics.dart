import 'package:mapness/features/balady_analytics/balady_analytics.dart';
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

  /// Routed through the [BaladyAnalytics] facade to the Urbi legacy stream
  /// only. These events keep their legacy names, so they do NOT go to our own
  /// pipeline — PostHog gets its own events per docs/analytics-tracking-plan.md.
  /// Signature is [TrackEvent]-compatible so `AdvancedMetrics.stop*` helpers
  /// can take it.
  Future<void> trackWithPrint(String event, {Map<String, dynamic>? properties}) async {
    logger.log(event);
    BaladyAnalytics.instance.track(
      event,
      properties: properties,
      channels: const {BaladyAnalyticsChannel.urbi},
    );
  }
}
