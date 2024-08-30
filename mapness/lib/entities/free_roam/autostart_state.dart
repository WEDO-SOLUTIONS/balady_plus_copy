enum AutostartState {
  /// FreeRoam is automatically start when speed exceeds 30km/s
  /// Sets after user seen `Go to Navigator` label and didn't cancel it.
  always,

  /// FreeRoam does not automatically start
  declined,

  /// User is prompted with the `Go to Navigator` message
  unknown,
}
