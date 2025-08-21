abstract interface class AppAnalyticsRepository {
  void onboardingFlowStarted();

  void onboardingFlowSkipped();

  void onboardingFlowCompleted();

  void navigationStarted({
    required String originLocation,
    required String destinationLocation,
    required String destinationCity,
    required String originCity,
    required int estimateTime,
    required double estimateDistance,
  });

  void userMovementDetected({
    required String destinationCity,
    required String originCity,
  });

  void navigationHalfWay({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
    required String midPoint,
  });

  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
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

  void carPlayConnected();

  Future<void> deviceTypeDetected();

  void networkConnectionType({required String type});

  void transportModeSelected({required String type});

}
