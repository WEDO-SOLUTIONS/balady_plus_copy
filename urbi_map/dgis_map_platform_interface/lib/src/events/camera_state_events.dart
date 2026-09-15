/// What the map camera is doing right now.
enum CameraState {
  /// Moving under someone else's control, e.g. a gesture is in progress.
  busy,

  /// Playing an animated move towards a target position.
  fly,

  /// Tracking the user's location.
  follow,

  /// Idle and under no one's control.
  free,
}

/// Reports a change in what the map camera is doing.
class CameraStateEvent {
  /// Creates the event for the given camera [state].
  CameraStateEvent(this.state);

  /// Name of the platform channel event this is decoded from.
  static const name = 'cameraStateChanged';

  /// The state the camera has moved into.
  final CameraState state;
}
