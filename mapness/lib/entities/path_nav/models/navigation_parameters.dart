final class NavigationParameters {
  final bool avoidTollRoads;
  final bool avoidUnpavedRoads;

  const NavigationParameters({
    this.avoidTollRoads = false,
    this.avoidUnpavedRoads = false,
  });

  NavigationParameters copyWith({
    bool? avoidTollRoads,
    bool? avoidUnpavedRoads,
  }) =>
      NavigationParameters(
        avoidTollRoads: avoidTollRoads ?? this.avoidTollRoads,
        avoidUnpavedRoads: avoidUnpavedRoads ?? this.avoidUnpavedRoads,
      );
}
