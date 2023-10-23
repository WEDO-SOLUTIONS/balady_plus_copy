class NavigationState {
  NavigationState({
    required this.isRunning,
    this.isFreeRoamMode = false,
  });

  final bool isRunning;
  final bool isFreeRoamMode;

  factory NavigationState.idle() => NavigationState(isRunning: false);
}
