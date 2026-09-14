import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

class CameraStateEventHandler {
  Stream<CameraStateEvent> get cameraStateEvents => _cameraStateController.stream;

  final _cameraStateController = StreamController<CameraStateEvent>.broadcast();

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
