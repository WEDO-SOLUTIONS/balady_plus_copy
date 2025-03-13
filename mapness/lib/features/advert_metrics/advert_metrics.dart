import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advert_metrics.g.dart';

enum AdvertMetricsKeys {
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

  /// event: add_poi_banner
  addPoiBanner,

  /// event: add_poi_stories
  addPoiStories,

  /// event: add_poi_search
  addPoiSearch,

  /// event: poi_submitted
  poiSubmitted,

  /// event: journey_search
  journeySearch,

  /// event: journey_started_unique
  journeyStartedUnique,

  /// event: journey_halfway_unique
  journeyHalfwayUnique,

  /// event: journey_complete_unique
  journeyCompleteUnique,
}

extension AdvertMetricsKeysEx on AdvertMetricsKeys {
  String get event => switch (this) {
        AdvertMetricsKeys.exploreLandingEngagement => 'g1f5nk',
        AdvertMetricsKeys.exploreLandingRoute => 'g1f5nk',
        AdvertMetricsKeys.exploreSearch => 'wldgmt',
        AdvertMetricsKeys.navigationRoutingStartedJorney => '5yfcni',
        AdvertMetricsKeys.navigationRoutingCompleted => '9fxp9f',
        AdvertMetricsKeys.navigationRoutingHalfway => 'dgxg78',
        AdvertMetricsKeys.onboardingStoriesCompleted => 'f54acw',
        AdvertMetricsKeys.addPoiBanner => 'unqoza',
        AdvertMetricsKeys.addPoiStories => '5s2ddu',
        AdvertMetricsKeys.addPoiSearch => 'n0d96o',
        AdvertMetricsKeys.poiSubmitted => 'vkqfwl',
        AdvertMetricsKeys.journeySearch => 'pysar1',
        AdvertMetricsKeys.journeyStartedUnique => 'pjpkj9',
        AdvertMetricsKeys.journeyHalfwayUnique => 'uj1ybw',
        AdvertMetricsKeys.journeyCompleteUnique => 'vps1sz',
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

  void sendEvent(AdvertMetricsKeys event, {bool isUniquePerSession = false}) {
    if (isUniquePerSession && _checkIfUnique(event)) {
      sendTextEvent(event.event);
    } else {
      sendTextEvent(event.event);
    }
  }

  bool _checkIfUnique(AdvertMetricsKeys event) {
    final currentSessionId = AdvancedMetrics.instance.sessionId;
    final prevSessionId = ref.read(sharedPrefsProvider).getString(event.name);
    if (currentSessionId != prevSessionId) {
      ref.read(sharedPrefsProvider).setString(event.name, currentSessionId);
      return true;
    }
    return false;
  }
}
