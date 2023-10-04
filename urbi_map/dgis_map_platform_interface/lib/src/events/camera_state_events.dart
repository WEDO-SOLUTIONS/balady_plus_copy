enum CameraState {
  busy,
  fly,
  follow,
  free,
}

class CameraStateEvent {
  CameraStateEvent(this.state);

  static const name = 'cameraStateChanged';

  final CameraState state;
}
