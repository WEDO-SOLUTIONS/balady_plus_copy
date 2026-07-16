import 'dart:async';

import 'package:mapness/features/balady_analytics/balady_analytics_sink.dart';
import 'package:urbi_analytics/analytics.dart' show Analytics;

/// Adapter that lets the facade fan events out to the legacy Urbi Analytics
/// stream (`balady-metrics.urbi.ae`) as [BaladyAnalyticsChannel.urbi] — first
/// legacy stream moved under the facade umbrella (see ANALYTICS_MIGRATION_PLAN.md).
class UrbiBaladyAnalyticsSink implements BaladyAnalyticsSink {
  UrbiBaladyAnalyticsSink(this._client);

  final Analytics _client;

  @override
  void track(BaladyAnalyticsEvent event) {
    // Screen views are NOT routed here: RoutesObserver still calls the Urbi
    // client's screen() directly, doubling them would corrupt the stream.
    unawaited(_client.track(event.name, properties: event.properties.isEmpty ? null : event.properties));
  }

  @override
  void identify(String? userId, Map<String, dynamic> traits) {
    // The Urbi stream is anonymous; identity stays with the `ours` sink.
  }
}
