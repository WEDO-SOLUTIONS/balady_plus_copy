import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

/// BytePlus RangersAppLog implementation of [AppAnalyticsRepository].
///
/// All events are sent via [RangersApplogFlutterPlugin.onEventV3], which maps
/// directly to the BytePlus Data Intelligence console under "Event Analysis".
///
/// SDK must be initialized before this class is used. Initialization happens
/// in `setupMapness()` inside `mapness/lib/entry_point.dart`, which runs at
/// app startup before any widgets are built.
class AppAnalyticsBytePlusImpl implements AppAnalyticsRepository {
  // ── User identity ─────────────────────────────────────────────────────────

  @override
  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
  }) {
    if (deviceId != null) RangersApplogFlutterPlugin.setUserUniqueId(deviceId);

    final profile = <String, dynamic>{};
    if (email != null) profile['email'] = email;
    if (locale != null) profile['locale'] = locale;
    if (deviceOs != null) profile['device_os'] = deviceOs;
    if (appVersion != null) profile['app_version'] = appVersion;

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

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _now {
    final now = DateTime.now().toUtc();
    return now.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '');
  }
}
