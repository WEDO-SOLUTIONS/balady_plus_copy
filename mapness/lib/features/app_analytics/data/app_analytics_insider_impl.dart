import 'package:flutter_insider/flutter_insider.dart';
// ignore: implementation_imports
import 'package:flutter_insider/src/identifiers.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';

class AppAnalyticsInsiderImpl implements AppAnalyticsRepository {
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
    required int estimateTime,
    required double estimateDistance,
  }) {
    FlutterInsider.Instance.tagEvent('navigation_started')
        .addParameterWithString('origin', originLocation)
        .addParameterWithString('destination', destinationLocation)
        .addParameterWithDouble('estimated_time', estimateTime.toDouble())
        .addParameterWithDouble('estimated_distance', estimateDistance)
        .build();
  }

  @override
  void navigationHalfWay({
    required String origin,
    required String destination,
    required Duration spentTime,
    required String midPoint,
  }) {
    FlutterInsider.Instance.tagEvent('navigation_half_way')
        .addParameterWithString('origin', origin)
        .addParameterWithString('destination', destination)
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
  }) {
    final user = FlutterInsider.Instance.getCurrentUser();

    if (user == null) {
      return;
    }

    if (deviceId != null) {
      user.setCustomAttributeWithString('device_id', deviceId);
    }

    if (deviceOs != null) {
      user.setCustomAttributeWithString('device_os', deviceOs);
    }

    if (appVersion != null) {
      user.setCustomAttributeWithString('app_version', appVersion);
    }

    if (locale != null) {
      user.setLocale(locale);
    }

    final identifiers = FlutterInsiderIdentifiers();
    if (email != null) {
      identifiers.addEmail(email);
    }

    user.login(identifiers);
  }

  @override
  void categorySelected(String category) {
    FlutterInsider.Instance.tagEvent('category_selected')
        .addParameterWithString('category', category)
        .build();
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
  void navigationCompleted({
    required String origin,
    required String destination,
    required Duration spentTime,
  }) {
    FlutterInsider.Instance.tagEvent('navigation_completed')
        .addParameterWithString('origin', origin)
        .addParameterWithString('destination', destination)
        .addParameterWithInt('time_to_reach', spentTime.inSeconds)
        .build();
  }
}
