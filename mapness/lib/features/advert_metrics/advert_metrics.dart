import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advert_metrics.g.dart';

enum AdvertMetircsKeys { exploreLandingEngagement, exploreLandingRoute, exploreSearch, navigationRoutingStartedJorney }

extension AdvertMetircsKeysEx on AdvertMetircsKeys {
  String get event => switch (this) {
        AdvertMetircsKeys.exploreLandingEngagement => 'explore_landing_engagement',
        AdvertMetircsKeys.exploreLandingRoute => 'explore_landing_route',
        AdvertMetircsKeys.exploreSearch => 'explore_search',
        AdvertMetircsKeys.navigationRoutingStartedJorney => 'navigation_routing_started_jorney'
      };
}

@riverpod
class AdvertMetrics extends _$AdvertMetrics {
  @override
  void build() {}

  void sendTextEvent(String event) {
    final eventMetric = AdjustEvent(event);
    Adjust.trackEvent(eventMetric);
  }

  void sendEvent(AdvertMetircsKeys event) {
    sendTextEvent(event.event);
  }
}
