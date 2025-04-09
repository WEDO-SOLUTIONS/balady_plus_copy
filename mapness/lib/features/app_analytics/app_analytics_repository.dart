abstract interface class AppAnalyticsRepository {
  void onboardingFlowStarted();

  void onboardingFlowSkipped();

  void onboardingFlowCompleted();

  void navigationStarted({
    required String originLocation,
    required String destinationLocation,
    required int estimateTime,
    required double estimateDistance,
  });

  void navigationHalfWay({
    required String origin,
    required String destination,
    required Duration spentTime,
    required String midPoint,
  });

  void navigationCompleted({
    required String origin,
    required String destination,
    required Duration spentTime,
  });

  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
  });

  void categorySelected(String category);

  void serviceSectionVisited();

  void quickActionSelected(String action);
}
