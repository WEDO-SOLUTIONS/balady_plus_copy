import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/navi_speed_event.dart';

class SpeedEventHandler {
  SpeedEventHandler();

  Stream<NaviSpeedEvent> get speedEvents => _controller.stream;

  final _controller = StreamController<NaviSpeedEvent>();

  void handleNavigationEvent(Map<dynamic, dynamic> map) {
    switch (map[NaviSpeedEvent.name]) {
      case NaviCurrentSpeedEvent.name:
        _controller.sink.add(NaviCurrentSpeedEvent(map["value"]));
        break;
      case NaviSpeedLimitEvent.name:
        _controller.sink.add(NaviSpeedLimitEvent(map["value"]));
        break;
      case NaviExceedSpeedLimitEvent.name:
        _controller.sink.add(NaviExceedSpeedLimitEvent(isExceed: map["value"] as bool));
        break;
      case NaviCameraEvent.name:
        final isControlCamera = map["value"] as bool?;
        final direction = map["direction"] as String?;
        NaviCameraDirection? cameraDirection;
        switch (direction?.toLowerCase()) {
          case "along":
            cameraDirection = NaviCameraDirection.along;
            break;
          case "against":
            cameraDirection = NaviCameraDirection.against;
            break;
          case "both":
            cameraDirection = NaviCameraDirection.both;
            break;
        }

        _controller.sink.add(NaviCameraEvent(isControlCamera: isControlCamera ?? false, direction: cameraDirection));
        break;
    }
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
