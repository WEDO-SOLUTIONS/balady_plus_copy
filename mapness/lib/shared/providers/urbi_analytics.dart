import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/analytics.dart' show Analytics;
import 'package:urbi_analytics/client.dart';
import 'package:urbi_analytics/state.dart';

part 'urbi_analytics.g.dart';

@Riverpod(keepAlive: true)
class UrbiAnalytics extends _$UrbiAnalytics {
  @override
  Analytics build() => createClient(
        Configuration('balady-metrics.urbi.ae/metrics-api'),
      );
}
