/// Parameters of the outdoor → indoor navigation transition: when and how the
/// "switch to pedestrian mode" prompt is offered during car navigation.
///
/// Parameter IDs (TP-xx) reference the product spec.
class PedestrianTransitionConfig {
  /// TP-01: Maximum distance in meters between the user and the destination
  /// building required to evaluate the transition.
  final double buildingProximityRadiusMeters;

  /// TP-02: Maximum distance in meters between the user and the selected
  /// indoor POI required to evaluate the transition.
  final double indoorPoiProximityRadiusMeters;

  /// TP-03: Maximum remaining ETA before the transition can be proposed.
  final Duration etaThreshold;

  /// TP-04: Maximum user speed in km/h allowed for displaying the prompt.
  final double maxVehicleSpeedKmh;

  /// TP-05: Minimum time before showing the prompt again after dismissal.
  final Duration promptRedisplayInterval;

  /// TP-06: Maximum number of times the prompt can be shown during a single
  /// navigation session.
  final int maxPromptDisplayCount;

  /// TP-07: Time to auto-dismiss the prompt.
  final Duration promptAutoDismissInterval;

  const PedestrianTransitionConfig({
    this.buildingProximityRadiusMeters = 150,
    this.indoorPoiProximityRadiusMeters = 250,
    this.etaThreshold = const Duration(minutes: 2),
    this.maxVehicleSpeedKmh = 5,
    this.promptRedisplayInterval = const Duration(minutes: 2),
    this.maxPromptDisplayCount = 2,
    this.promptAutoDismissInterval = const Duration(seconds: 5),
  });

  static const PedestrianTransitionConfig defaults = PedestrianTransitionConfig();

  PedestrianTransitionConfig copyWith({
    double? buildingProximityRadiusMeters,
    double? indoorPoiProximityRadiusMeters,
    Duration? etaThreshold,
    double? maxVehicleSpeedKmh,
    Duration? promptRedisplayInterval,
    int? maxPromptDisplayCount,
    Duration? promptAutoDismissInterval,
  }) => PedestrianTransitionConfig(
    buildingProximityRadiusMeters: buildingProximityRadiusMeters ?? this.buildingProximityRadiusMeters,
    indoorPoiProximityRadiusMeters: indoorPoiProximityRadiusMeters ?? this.indoorPoiProximityRadiusMeters,
    etaThreshold: etaThreshold ?? this.etaThreshold,
    maxVehicleSpeedKmh: maxVehicleSpeedKmh ?? this.maxVehicleSpeedKmh,
    promptRedisplayInterval: promptRedisplayInterval ?? this.promptRedisplayInterval,
    maxPromptDisplayCount: maxPromptDisplayCount ?? this.maxPromptDisplayCount,
    promptAutoDismissInterval: promptAutoDismissInterval ?? this.promptAutoDismissInterval,
  );
}
