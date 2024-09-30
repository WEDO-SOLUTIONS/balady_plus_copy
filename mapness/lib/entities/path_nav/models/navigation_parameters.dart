final class NavigationParameters {
  final bool avoidTollRoads;
  final bool avoidUnpavedRoads;
  final bool suggestRouteBetter;

  const NavigationParameters({
    this.avoidTollRoads = false,
    this.avoidUnpavedRoads = false,
    this.suggestRouteBetter = false,
  });

  NavigationParameters copyWith({
    bool? avoidTollRoads,
    bool? avoidUnpavedRoads,
    bool? suggestRouteBetter,
  }) =>
      NavigationParameters(
        avoidTollRoads: avoidTollRoads ?? this.avoidTollRoads,
        avoidUnpavedRoads: avoidUnpavedRoads ?? this.avoidUnpavedRoads,
        suggestRouteBetter: suggestRouteBetter ?? this.suggestRouteBetter,
      );
}
