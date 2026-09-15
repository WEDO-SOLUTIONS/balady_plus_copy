abstract class NaviSpeedEvent {
  const NaviSpeedEvent();

  static const name = "speedEvent";
}

class NaviCurrentSpeedEvent extends NaviSpeedEvent {
  const NaviCurrentSpeedEvent(this.speed);

  final int? speed;

  static const name = "currentSpeedEvent";
}

class NaviSpeedLimitEvent extends NaviSpeedEvent {
  const NaviSpeedLimitEvent(this.speed);

  final int? speed;

  static const name = "speedLimitEvent";
}

class NaviExceedSpeedLimitEvent extends NaviSpeedEvent {
  const NaviExceedSpeedLimitEvent({required this.isExceed});

  final bool isExceed;

  static const name = "exceedSpeedLimitEvent";
}

enum NaviCameraDirection { along, against, both }

class NaviCameraEvent extends NaviSpeedEvent {
  const NaviCameraEvent({required this.isControlCamera, required this.direction});

  final bool isControlCamera;
  final NaviCameraDirection? direction;

  static const name = "cameraEvent";
}
