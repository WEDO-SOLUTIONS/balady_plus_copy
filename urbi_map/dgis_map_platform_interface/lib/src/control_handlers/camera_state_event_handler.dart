import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Turns the native map's camera-state notifications into a Dart stream.
class CameraStateEventHandler {
  /// Every camera state the map has moved into since this handler was made.
  Stream<CameraStateEvent> get cameraStateEvents => _cameraStateController.stream;

  final _cameraStateController = StreamController<CameraStateEvent>.broadcast();

  /// Maps the state name the native side sends onto a [CameraState],
  /// falling back to [CameraState.free] for anything unrecognised.
  CameraState mapCameraState(String state) {
    switch (state) {
      case 'busy':
        return CameraState.busy;
      case 'fly':
        return CameraState.fly;
      case 'follow':
        return CameraState.follow;
      default:
        return CameraState.free;
    }
  }

  /// Decodes a camera-state payload off the platform channel and publishes it
  /// on [cameraStateEvents].
  void cameraStateEvent(Map<dynamic, dynamic> map) {
    final state = mapCameraState(map['state'] as String);
    final event = CameraStateEvent(state);

    _cameraStateController.sink.add(event);
  }

  /// Closes the camera state stream.
  Future<void> dispose() async {
    await _cameraStateController.close();
  }
}
