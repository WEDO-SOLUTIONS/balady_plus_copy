class NavigatorParkingState {
  final bool? autoEnableParking;
  final String? navigatorType;

  const NavigatorParkingState({
    required this.autoEnableParking,
    required this.navigatorType,
  });

  NavigatorParkingState copyWith({
    bool? autoEnableParking,
    String? navigatorType,
  }) =>
      NavigatorParkingState(
        autoEnableParking: autoEnableParking ?? this.autoEnableParking,
        navigatorType: navigatorType ?? this.navigatorType,
      );
}
