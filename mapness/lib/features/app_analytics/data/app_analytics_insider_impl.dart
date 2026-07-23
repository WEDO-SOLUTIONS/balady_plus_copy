import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_insider/flutter_insider.dart';

// ignore: implementation_imports
import 'package:flutter_insider/src/identifiers.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';

class AppAnalyticsInsiderImpl implements AppAnalyticsRepository {
  static String? _lastLoggedUserId;

  @override
  void onboardingFlowStarted() {
    FlutterInsider.Instance.tagEvent('onboarding_flow_started').build();
  }

  @override
  void onboardingFlowSkipped() {
    FlutterInsider.Instance.tagEvent('onboarding_flow_skipped').build();
  }

  @override
  void onboardingFlowCompleted() {
    FlutterInsider.Instance.tagEvent('onboarding_stories_completed').build();
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
    FlutterInsider.Instance.tagEvent('navigation_started')
        .addParameterWithString('origin', originLocation)
        .addParameterWithString('destination', destinationLocation)
        .addParameterWithString('origin_city', originCity)
        .addParameterWithString('destination_city', destinationCity)
        .addParameterWithDouble('estimated_time', estimateTime.toDouble())
        .addParameterWithDouble('estimated_distance', estimateDistance)
        .build();
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
    FlutterInsider.Instance.tagEvent('navigation_half_way')
        .addParameterWithString('origin', origin)
        .addParameterWithString('destination', destination)
        .addParameterWithString('origin_city', originCity)
        .addParameterWithString('destination_city', destinationCity)
        .addParameterWithInt('time_to_midway', spentTime.inSeconds)
        .addParameterWithString('midway_point', midPoint)
        .build();
  }

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
    final user = FlutterInsider.Instance.getCurrentUser();

    if (user == null) {
      debugPrint('[Insider] getCurrentUser() returned null. Cannot set user info.');
      return;
    }

    // Handle user logout / clear session
    if (userId == null && (email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
      if (_lastLoggedUserId != null) {
        debugPrint('[Insider] User logged out / unauthenticated. Calling logout().');
        _lastLoggedUserId = null;
        user.logout();
      }
      return;
    }

    // Deduplicate: Avoid duplicate login calls and login events for the same user session
    if (userId != null && userId == _lastLoggedUserId) {
      debugPrint('[Insider] setUserInfo called for already identified user ($userId). Skipping duplicate login event.');
      return;
    }

    _lastLoggedUserId = userId;

    final identifiers = FlutterInsiderIdentifiers();
    if (email != null && email.isNotEmpty) {
      identifiers.addEmail(email);
    }
    if (phone != null && phone.isNotEmpty) {
      identifiers.addPhoneNumber(phone);
    }
    if (userId != null && userId.isNotEmpty) {
      identifiers.addUserID(userId);
    }

    debugPrint('[Insider] Triggering login with userId: $userId, email: $email, phone: $phone');

    // Use the second variant of login with callback to avoid attribute/event race conditions
    user.login(
      identifiers,
      insiderIDResult: (insiderID) {
        debugPrint('[Insider] Login callback completed. Insider ID: $insiderID');
        final newUser = FlutterInsider.Instance.getCurrentUser();
        if (newUser == null) {
          debugPrint('[Insider] getCurrentUser() returned null inside login callback.');
          return;
        }

        if (firstName != null && firstName.isNotEmpty) {
          newUser.setName(firstName);
        }
        if (lastName != null && lastName.isNotEmpty) {
          newUser.setSurname(lastName);
        }
        if (locale != null && locale.isNotEmpty) {
          newUser.setLocale(locale);
        }

        if (deviceId != null) {
          newUser.setCustomAttributeWithString('device_id', deviceId);
        }
        if (deviceOs != null) {
          newUser.setCustomAttributeWithString('device_os', deviceOs);
        }
        if (appVersion != null) {
          newUser.setCustomAttributeWithString('app_version', appVersion);
        }

        // Fire login event inside callback after attributes are applied to new user
        debugPrint('[Insider] Tagging login event for user: $userId (Insider ID: $insiderID)');
        FlutterInsider.Instance.tagEvent('login').build();
      },
    );
  }

  @override
  void categorySelected(String category) {
    FlutterInsider.Instance.tagEvent('category_selected').addParameterWithString('category', category).build();
  }

  @override
  void serviceSectionVisited() {
    FlutterInsider.Instance.tagEvent('service_section_visited').build();
  }

  @override
  void quickActionSelected(String action) {
    FlutterInsider.Instance.tagEvent('quick_action_used').addParameterWithString('action', action).build();
  }

  @override
  void appIconQuickActionSelected({
    required String action,
    required String outcome,
    String? reason,
  }) {
    final event = FlutterInsider.Instance.tagEvent(
      'app_icon_quick_action_used',
    ).addParameterWithString('action', action).addParameterWithString('outcome', outcome);
    if (reason != null) {
      event.addParameterWithString('reason', reason);
    }
    event.build();
  }

  @override
  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
  }) {
    FlutterInsider.Instance.tagEvent('navigation_completed')
        .addParameterWithString('origin', origin)
        .addParameterWithString('destination', destination)
        .addParameterWithString('origin_city', originCity)
        .addParameterWithString('destination_city', destinationCity)
        .addParameterWithInt('time_to_reach', spentTime.inSeconds)
        .build();
  }

  @override
  void carPlayConnected() {
    FlutterInsider.Instance.tagEvent('carplay_connected')
        .addParameterWithString('event_name', 'carplay_connected')
        .addParameterWithString('status', 'connected')
        .addParameterWithString('timestamp', now)
        .build();
  }

  String get now {
    final now = DateTime.now().toUtc();
    final formatted = now.toIso8601String().replaceFirst(RegExp(r'\.\d+'), '');
    return formatted;
  }

  @override
  void networkConnectionType({required String type}) {
    FlutterInsider.Instance.tagEvent('network_type_detected')
        .addParameterWithString('event_name', 'network_type_detected')
        .addParameterWithString('connection_type', type)
        .addParameterWithString('timestamp', now)
        .build();
  }

  @override
  Future<void> deviceTypeDetected() async {
    final isAndroid = Platform.isAndroid;
    final androidInfo = isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    final iOSInfo = isAndroid ? null : await DeviceInfoPlugin().iosInfo;

    final androidModel = androidInfo?.data['model'] as String? ?? 'unknown';
    final iosModel = iOSInfo?.data['machine'] as String? ?? 'unknown';

    await FlutterInsider.Instance.tagEvent('device_type_detected')
        .addParameterWithString('event_name', 'device_type_detected')
        .addParameterWithString('device_type', isAndroid ? androidModel : iosModel)
        .addParameterWithString('platform', Platform.operatingSystem)
        .addParameterWithString('timestamp', now)
        .build();
  }

  @override
  void transportModeSelected({required String type}) {
    FlutterInsider.Instance.tagEvent('transport_mode_selected')
        .addParameterWithString('event_name', 'transport_mode_selected')
        .addParameterWithString('mode', type)
        .addParameterWithString('timestamp', now)
        .build();
  }

  @override
  void userMovementDetected({required String destinationCity, required String originCity}) {
    FlutterInsider.Instance.tagEvent('user_movement_detected')
        .addParameterWithString('event_name', 'user_movement_detected')
        .addParameterWithString('origin', originCity)
        .addParameterWithString('destination', destinationCity)
        .addParameterWithString('value', originCity == destinationCity ? 'Yes' : 'No')
        .addParameterWithString('timestamp', now)
        .build();
  }

  @override
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  }) {
    FlutterInsider.Instance.tagEvent('navigation_search')
        .addParameterWithString('event_name', 'navigation_search')
        .addParameterWithString('keyword', keyword)
        .addParameterWithString('origin', originCity)
        .addParameterWithString('destination', destinationCity)
        .addParameterWithString('timestamp', now)
        .addParameterWithBoolean('results_found', isResultsFound)
        .addParameterWithInt('result_count', resultCount)
        .build();
  }

  @override
  void isNavigationUser({bool isNavUser = false}) {
    FlutterInsider.Instance.tagEvent(
      'is_navigation_user',
    ).addParameterWithString('is_navigation_user', isNavUser ? '1' : '0').build();
  }

  @override
  void poiContributionUsed({required String type}) {
    FlutterInsider.Instance.tagEvent('contribution_used')
        .addParameterWithString('event_name', 'poi_contribution_used')
        .addParameterWithString('contribution_type', type)
        .addParameterWithString('source', 'community')
        .addParameterWithString('timestamp', now)
        .build();
  }
}
