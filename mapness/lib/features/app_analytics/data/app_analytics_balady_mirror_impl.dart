import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Mirrors every Insider/BytePlus event into the [BaladyAnalytics] facade so
/// our own pipeline receives the exact same stream the legacy dashboards get.
///
/// Event names and property shapes intentionally match
/// [AppAnalyticsBytePlusImpl] one-to-one, so a dashboard built on either source
/// reads the same schema. Differences by design:
/// - no `timestamp` property — the facade transport stamps events itself;
/// - [setUserInfo] is a no-op — identity goes through
///   `BaladyAnalytics.identify` in the auth flow, not per-backend;
/// - [deviceTypeDetected] does not probe DeviceInfo — the transport already
///   attaches device model/platform to every event.
class AppAnalyticsBaladyMirrorImpl implements AppAnalyticsRepository, DataFinderAnalyticsRepository {
  void _send(String name, Map<String, dynamic> props) {
    BaladyAnalytics.instance.track(name, properties: props);
  }

  @override
  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
    String? userId,
  }) {
    // Identity is handled by BaladyAnalytics.identify at the auth call sites.
  }

  @override
  void onboardingFlowStarted() => _send('onboarding_flow_started', {});

  @override
  void onboardingFlowSkipped() => _send('onboarding_flow_skipped', {});

  @override
  void onboardingFlowCompleted() => _send('onboarding_stories_completed', {});

  @override
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  }) {
    _send('navigation_search', {
      'keyword': keyword,
      'origin': originCity,
      'destination': destinationCity,
      'results_found': isResultsFound,
      'result_count': resultCount,
    });
  }

  @override
  void navigationStarted({
    required String originLocation,
    required String destinationLocation,
    required String destinationCity,
    required String originCity,
    required int estimateTime,
    required double estimateDistance,
  }) {
    _send('navigation_started', {
      'origin': originLocation,
      'destination': destinationLocation,
      'origin_city': originCity,
      'destination_city': destinationCity,
      'estimated_time': estimateTime,
      'estimated_distance': estimateDistance,
    });
  }

  @override
  void navigationHalfWay({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
    required String midPoint,
  }) {
    _send('navigation_half_way', {
      'origin': origin,
      'destination': destination,
      'origin_city': originCity,
      'destination_city': destinationCity,
      'time_to_midway': spentTime.inSeconds,
      'midway_point': midPoint,
    });
  }

  @override
  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
  }) {
    _send('navigation_completed', {
      'origin': origin,
      'destination': destination,
      'origin_city': originCity,
      'destination_city': destinationCity,
      'time_to_reach': spentTime.inSeconds,
    });
  }

  @override
  void userMovementDetected({
    required String destinationCity,
    required String originCity,
  }) {
    _send('user_movement_detected', {
      'origin': originCity,
      'destination': destinationCity,
      'same_city': originCity == destinationCity,
    });
  }

  @override
  void isNavigationUser({bool isNavUser = false}) {
    _send('is_navigation_user', {'is_navigation_user': isNavUser ? '1' : '0'});
  }

  @override
  void categorySelected(String category) => _send('category_selected', {'category': category});

  @override
  void serviceSectionVisited() => _send('service_section_visited', {});

  @override
  void quickActionSelected(String action) => _send('quick_action_used', {'action': action});

  @override
  void appIconQuickActionSelected({
    required String action,
    required String outcome,
    String? reason,
  }) {
    _send('app_icon_quick_action_used', {
      'action': action,
      'outcome': outcome,
      if (reason != null) 'reason': reason,
    });
  }

  @override
  void carPlayConnected() => _send('carplay_connected', {'status': 'connected'});

  @override
  void poiContributionUsed({required String type}) {
    _send('contribution_used', {
      'contribution_type': type,
      'source': 'community',
    });
  }

  @override
  Future<void> deviceTypeDetected() async {
    _send('device_type_detected', {});
  }

  @override
  void networkConnectionType({required String type}) {
    _send('network_type_detected', {'connection_type': type});
  }

  @override
  void transportModeSelected({required String type}) {
    _send('transport_mode_selected', {'mode': type});
  }

  // ── DataFinder search events (same flat per-POI scheme as BytePlus) ───────

  @override
  void searchBoxClick({
    required DataFinderSourcePage eventSource,
    required bool isFirstClick,
  }) {
    _send('search_box_click', {
      'event_source': eventSource.value,
      'is_first_click': isFirstClick,
    });
  }

  @override
  void searchBoxInput({
    required DataFinderInputOperation operationType,
    required String inputText,
  }) {
    _send('search_box_input', {
      'operation_type': operationType.value,
      'input_text': inputText,
    });
  }

  @override
  void searchButtonClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
    String triggerMethod = 'Keyboard',
  }) {
    _send('search_button_click', {
      'event_source': eventSource.value,
      'search_text': searchText,
      'trigger_method': triggerMethod,
    });
  }

  @override
  void quickSearchClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
  }) {
    _send('quick_search_click', {
      'event_source': eventSource.value,
      'search_text': searchText,
    });
  }

  @override
  void favoriteAdd({
    required DataFinderSourcePage eventSource,
    required DataFinderFavoriteType favoriteType,
    required DataFinderPoi poi,
  }) {
    _send('favorite_add', {
      'event_source': eventSource.value,
      'favorite_type': favoriteType.value,
      ...poi.toJson(),
    });
  }

  @override
  void suggestionExposure({
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  }) {
    for (final poi in pois) {
      _send('suggestion_exposure', {
        'request_id': requestId,
        'suggestion_session_id': sessionId,
        'search_text': searchText,
        'search_param': searchParam.toQueryString(),
        ...poi.toSuggestionJson(),
      });
    }
  }

  @override
  void suggestionClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required String suggestionType,
    required DataFinderPoi poi,
  }) {
    _send('suggestion_click', {
      'event_source': eventSource.value,
      'request_id': requestId,
      'suggestion_session_id': sessionId,
      'search_text': searchText,
      'suggestion_type': suggestionType,
      'suggestion_name': poi.name,
      'suggestion_rank': poi.rank,
      if (poi.id != null) 'poi_id': poi.id,
      if (poi.name != null) 'poi_name': poi.name,
      if (poi.address != null) 'poi_addr': poi.address,
      if (poi.type != null) 'poi_type': poi.type,
      if (poi.distanceKm != null) 'poi_distance': poi.distanceKm,
    });
  }

  @override
  void searchResultsExposure({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchType searchType,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  }) {
    for (final poi in pois) {
      _send('search_results_exposure', {
        'event_source': eventSource.value,
        'request_id': requestId,
        'search_session_id': sessionId,
        'search_text': searchText,
        'search_type': searchType.value,
        'search_param': searchParam.toQueryString(),
        ...poi.toJson(),
      });
    }
  }

  @override
  void searchResultsClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderClickAction clickAction,
    required DataFinderPoi poi,
  }) {
    _send('search_results_click', {
      'event_source': eventSource.value,
      'request_id': requestId,
      'search_session_id': sessionId,
      'search_text': searchText,
      'click_action': clickAction.value,
      ...poi.toJson(),
    });
  }
}
