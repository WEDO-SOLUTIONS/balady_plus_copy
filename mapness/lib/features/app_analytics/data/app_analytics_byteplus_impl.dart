import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

/// BytePlus RangersAppLog implementation of [AppAnalyticsRepository].
///
/// All events are sent via [RangersApplogFlutterPlugin.onEventV3], which maps
/// directly to the BytePlus Data Intelligence console under "Event Analysis".
///
/// SDK must be initialized before this class is used. Initialization happens
/// in `setupMapness()` inside `mapness/lib/entry_point.dart`, which runs at
/// app startup before any widgets are built.
class AppAnalyticsBytePlusImpl implements AppAnalyticsRepository, DataFinderAnalyticsRepository {
  AppAnalyticsBytePlusImpl() {
    _resolveSimulator();
  }

  /// Whether the app is running on an iOS Simulator / Android emulator.
  ///
  /// The RangersAppLog XCFramework runs on the simulator, but BytePlus only
  /// shows data from real devices on the dashboard (a simulator has no real
  /// device fingerprint, fake GPS, etc.). So on simulators we run in "dry-run":
  /// events are logged locally but NOT sent — the app works for testing, and the
  /// dashboard stays clean. On a physical device, events are sent for real.
  ///
  /// `null` until [_resolveSimulator] completes (a few ms after startup); we
  /// treat that brief window as a simulator (don't send) to be safe.
  static bool? _isSimulator;

  /// Manual override: force dry-run even on a physical device (local testing).
  /// Leave `false` for normal behavior (auto-detect by device type).
  static const bool _forceDryRun = false;

  Future<void> _resolveSimulator() async {
    if (_isSimulator != null) {
      return;
    }
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isIOS) {
        _isSimulator = !(await info.iosInfo).isPhysicalDevice;
      } else if (Platform.isAndroid) {
        _isSimulator = !(await info.androidInfo).isPhysicalDevice;
      } else {
        _isSimulator = true;
      }
    } catch (_) {
      _isSimulator = true; // unknown → safest is dry-run
    }
  }

  // ── User identity ─────────────────────────────────────────────────────────

  @override
  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
    String? userId,
    String? phone,
    String? firstName,
    String? lastName,
  }) {
    // Always call: a non-null [userId] (the SSO `sub`) logs the user in; `null`
    // logs them OUT. The RangersAppLog plugin explicitly treats
    // `setUserUniqueId(null)` as logout, so this must NOT be guarded by a
    // null-check — otherwise the previous user stays "logged in" to DataFinder
    // after sign-out / account switch.
    // TEMP debug (physical-device testing of the DataFinder user identity):
    // grep the device console for [DataFinder] to trace login/logout/sub.
    debugPrint('[DataFinder] setUserUniqueId(${userId ?? 'null → LOGOUT'})');
    RangersApplogFlutterPlugin.setUserUniqueId(userId);

    final profile = <String, dynamic>{};
    if (email != null) {
      profile['email'] = email;
    }
    if (locale != null) {
      profile['locale'] = locale;
    }
    if (deviceOs != null) {
      profile['device_os'] = deviceOs;
    }
    if (appVersion != null) {
      profile['app_version'] = appVersion;
    }

    if (profile.isNotEmpty) {
      RangersApplogFlutterPlugin.profileSet(profile);
    }
  }

  // ── Onboarding ────────────────────────────────────────────────────────────

  @override
  void onboardingFlowStarted() {
    RangersApplogFlutterPlugin.onEventV3('onboarding_flow_started', {});
  }

  @override
  void onboardingFlowSkipped() {
    RangersApplogFlutterPlugin.onEventV3('onboarding_flow_skipped', {});
  }

  @override
  void onboardingFlowCompleted() {
    RangersApplogFlutterPlugin.onEventV3('onboarding_stories_completed', {});
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  @override
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  }) {
    RangersApplogFlutterPlugin.onEventV3('navigation_search', {
      'keyword': keyword,
      'origin': originCity,
      'destination': destinationCity,
      'results_found': isResultsFound,
      'result_count': resultCount,
      'timestamp': _now,
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
    RangersApplogFlutterPlugin.onEventV3('navigation_started', {
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
    RangersApplogFlutterPlugin.onEventV3('navigation_half_way', {
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
    RangersApplogFlutterPlugin.onEventV3('navigation_completed', {
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
    RangersApplogFlutterPlugin.onEventV3('user_movement_detected', {
      'origin': originCity,
      'destination': destinationCity,
      'same_city': originCity == destinationCity,
      'timestamp': _now,
    });
  }

  @override
  void isNavigationUser({bool isNavUser = false}) {
    RangersApplogFlutterPlugin.onEventV3('is_navigation_user', {
      'is_navigation_user': isNavUser ? '1' : '0',
    });
  }

  // ── App interactions ──────────────────────────────────────────────────────

  @override
  void categorySelected(String category) {
    RangersApplogFlutterPlugin.onEventV3('category_selected', {'category': category});
  }

  @override
  void serviceSectionVisited() {
    RangersApplogFlutterPlugin.onEventV3('service_section_visited', {});
  }

  @override
  void quickActionSelected(String action) {
    RangersApplogFlutterPlugin.onEventV3('quick_action_used', {'action': action});
  }

  @override
  void appIconQuickActionSelected({
    required String action,
    required String outcome,
    String? reason,
  }) {
    RangersApplogFlutterPlugin.onEventV3('app_icon_quick_action_used', {
      'action': action,
      'outcome': outcome,
      if (reason != null) 'reason': reason,
    });
  }

  @override
  void carPlayConnected() {
    RangersApplogFlutterPlugin.onEventV3('carplay_connected', {
      'status': 'connected',
      'timestamp': _now,
    });
  }

  @override
  void poiContributionUsed({required String type}) {
    RangersApplogFlutterPlugin.onEventV3('contribution_used', {
      'contribution_type': type,
      'source': 'community',
      'timestamp': _now,
    });
  }

  // ── Device & network ─────────────────────────────────────────────────────

  @override
  Future<void> deviceTypeDetected() async {
    final isAndroid = Platform.isAndroid;
    final androidInfo = isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    final iOSInfo = isAndroid ? null : await DeviceInfoPlugin().iosInfo;

    final model = isAndroid ? androidInfo?.model : iOSInfo?.utsname.machine;

    RangersApplogFlutterPlugin.onEventV3('device_type_detected', {
      'device_type': model ?? 'unknown',
      'platform': Platform.operatingSystem,
      'timestamp': _now,
    });
  }

  @override
  void networkConnectionType({required String type}) {
    RangersApplogFlutterPlugin.onEventV3('network_type_detected', {
      'connection_type': type,
      'timestamp': _now,
    });
  }

  @override
  void transportModeSelected({required String type}) {
    RangersApplogFlutterPlugin.onEventV3('transport_mode_selected', {
      'mode': type,
      'timestamp': _now,
    });
  }

  // ── DataFinder Phase-1 search events ──────────────────────────────────────

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
    // BRD: "10 recommendation items → 10 individual tracking events, one for
    // each item". One flat event per suggestion (not a `suggestions` array —
    // the dashboard cannot parse arrays). Each event carries the shared context
    // + that one item's flat `suggestion_*` fields.
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
    // BRD wants both `suggestion_name` + `poi_name`, and `suggestion_rank`
    // (not `poi_rank`) on this event.
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
    // BRD: "10 result items → 10 separate tracking events". One flat event per
    // POI (not a single event with a `results` array — the dashboard cannot
    // parse arrays). Each event carries the shared search context + that one
    // POI's flat `poi_*` fields.
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// True when events should be logged but NOT sent to BytePlus:
  /// on a simulator/emulator (auto-detected), or when [_forceDryRun] is set.
  /// While device detection is still resolving (`_isSimulator == null`) we also
  /// dry-run, so nothing leaks before we know the device type.
  bool get _dryRun => _forceDryRun || (_isSimulator ?? true);

  /// Sends a DataFinder event. In debug builds the payload is logged with a
  /// `[DataFinder]` prefix for grepping. When [_dryRun] is true the event is
  /// NOT forwarded to BytePlus — it only prints locally (simulator/emulator).
  void _send(String eventName, Map<String, dynamic> params) {
    final dryRun = _dryRun;
    assert(() {
      final tag = dryRun ? '[DataFinder][DRY-RUN]' : '[DataFinder]';
      // ignore: avoid_print
      print('$tag $eventName -> ${jsonEncode(params)}');
      return true;
    }(), 'debug-only log');

    if (dryRun) {
      return; // simulator/emulator (or forced): do not send to BytePlus.
    }
    RangersApplogFlutterPlugin.onEventV3(eventName, params);
  }

  String get _now {
    final now = DateTime.now().toUtc();
    return now.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '');
  }
}
