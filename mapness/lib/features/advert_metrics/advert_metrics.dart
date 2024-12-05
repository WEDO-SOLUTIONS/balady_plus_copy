import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advert_metrics.g.dart';

enum AdvertMetircsKeys {
  /// event: explore_landing_engage
  exploreLandingEngagement,

  /// event: explore_landing_engage
  exploreLandingRoute,

  /// event: navigation_routing_search-initiated
  exploreSearch,

  /// event: navigation_routing_started-journey
  navigationRoutingStartedJorney,

  /// event: navigation_routing_completed-journey
  navigationRoutingCompleted,

  /// event: navigation_routing_halfway-journey
  navigationRoutingHalfway,

  onboardingStoriesCompleted,
}

extension AdvertMetircsKeysEx on AdvertMetircsKeys {
  String get event => switch (this) {
        AdvertMetircsKeys.exploreLandingEngagement => 'g1f5nk',
        AdvertMetircsKeys.exploreLandingRoute => 'g1f5nk',
        AdvertMetircsKeys.exploreSearch => 'wldgmt',
        AdvertMetircsKeys.navigationRoutingStartedJorney => '5yfcni',
        AdvertMetircsKeys.navigationRoutingCompleted => '9fxp9f',
        AdvertMetircsKeys.navigationRoutingHalfway => 'dgxg78',
        AdvertMetircsKeys.onboardingStoriesCompleted => 'f54acw',
      };
}

@riverpod
class AdvertMetrics extends _$AdvertMetrics {
  @override
  void build() {}

  void sendTextEvent(String token) {
    final eventMetric = AdjustEvent(token);
    Adjust.trackEvent(eventMetric);
  }

  void sendEvent(AdvertMetircsKeys event) {
    sendTextEvent(event.event);
  }
}
