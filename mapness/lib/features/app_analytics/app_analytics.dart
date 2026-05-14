import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/data/app_analytics_byteplus_impl.dart';
import 'package:mapness/features/app_analytics/data/app_analytics_insider_impl.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_analytics.g.dart';

/// Composite analytics implementation that fans out every event to both
/// Insider and BytePlus simultaneously.
///
/// Add new analytics backends here — no callers need to change.
class _CompositeAnalytics implements AppAnalyticsRepository {
  _CompositeAnalytics(this._implementations);

  final List<AppAnalyticsRepository> _implementations;

  @override
  void onboardingFlowStarted() {
    for (final impl in _implementations) {
      impl.onboardingFlowStarted();
    }
  }

  @override
  void onboardingFlowSkipped() {
    for (final impl in _implementations) {
      impl.onboardingFlowSkipped();
    }
  }

  @override
  void onboardingFlowCompleted() {
    for (final impl in _implementations) {
      impl.onboardingFlowCompleted();
    }
  }

  @override
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  }) {
    for (final impl in _implementations) {
      impl.navigationSearch(
        destinationCity: destinationCity,
        keyword: keyword,
        originCity: originCity,
        isResultsFound: isResultsFound,
        resultCount: resultCount,
      );
    }
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
    for (final impl in _implementations) {
      impl.navigationStarted(
        originLocation: originLocation,
        destinationLocation: destinationLocation,
        destinationCity: destinationCity,
        originCity: originCity,
        estimateTime: estimateTime,
        estimateDistance: estimateDistance,
      );
    }
  }

  @override
  void userMovementDetected({
    required String destinationCity,
    required String originCity,
  }) {
    for (final impl in _implementations) {
      impl.userMovementDetected(destinationCity: destinationCity, originCity: originCity);
    }
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
    for (final impl in _implementations) {
      impl.navigationHalfWay(
        origin: origin,
        destination: destination,
        destinationCity: destinationCity,
        originCity: originCity,
        spentTime: spentTime,
        midPoint: midPoint,
      );
    }
  }

  @override
  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
  }) {
    for (final impl in _implementations) {
      impl.navigationCompleted(
        origin: origin,
        destination: destination,
        destinationCity: destinationCity,
        originCity: originCity,
        spentTime: spentTime,
      );
    }
  }

  @override
  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
  }) {
    for (final impl in _implementations) {
      impl.setUserInfo(email: email, locale: locale, deviceId: deviceId, deviceOs: deviceOs, appVersion: appVersion);
    }
  }

  @override
  void categorySelected(String category) {
    for (final impl in _implementations) {
      impl.categorySelected(category);
    }
  }

  @override
  void serviceSectionVisited() {
    for (final impl in _implementations) {
      impl.serviceSectionVisited();
    }
  }

  @override
  void quickActionSelected(String action) {
    for (final impl in _implementations) {
      impl.quickActionSelected(action);
    }
  }

  @override
  void carPlayConnected() {
    for (final impl in _implementations) {
      impl.carPlayConnected();
    }
  }

  @override
  void poiContributionUsed({required String type}) {
    for (final impl in _implementations) {
      impl.poiContributionUsed(type: type);
    }
  }

  @override
  void isNavigationUser({bool isNavUser = false}) {
    for (final impl in _implementations) {
      impl.isNavigationUser(isNavUser: isNavUser);
    }
  }

  @override
  Future<void> deviceTypeDetected() async {
    for (final impl in _implementations) {
      await impl.deviceTypeDetected();
    }
  }

  @override
  void networkConnectionType({required String type}) {
    for (final impl in _implementations) {
      impl.networkConnectionType(type: type);
    }
  }

  @override
  void transportModeSelected({required String type}) {
    for (final impl in _implementations) {
      impl.transportModeSelected(type: type);
    }
  }
}

@riverpod
class AppAnalytics extends _$AppAnalytics {
  @override
  AppAnalyticsRepository build() {
    final auth = ref.watch(authProvider.future);
    final analytics = stateOrNull ??
        _CompositeAnalytics([
          AppAnalyticsInsiderImpl(),
          AppAnalyticsBytePlusImpl(),
        ]);
    final locale = ref.watch(appLanguageProvider).languageCode;
    final deviceInfo = ref.watch(deviceInfoProvider.future);
    Future(() async {
      final authValue = await auth;
      final deviceInfoValue = await deviceInfo;

      analytics.setUserInfo(
        email: authValue?.getEmail(),
        locale: locale,
        deviceId: deviceInfoValue.deviceId,
        deviceOs: deviceInfoValue.mobileOS?.name,
        appVersion: deviceInfoValue.appVersion,
      );
    });

    return analytics;
  }
}
