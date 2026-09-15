/// Base class for everything navigation reports about speed: the current
/// speed, the limit in force, whether the limit is being exceeded, and speed
/// cameras ahead.
abstract class NaviSpeedEvent {
  /// Creates the base event.
  const NaviSpeedEvent();

  /// Name of the platform channel these events arrive on.
  static const name = "speedEvent";
}

/// Reports how fast the user is currently moving.
class NaviCurrentSpeedEvent extends NaviSpeedEvent {
  /// Creates the event for the given [speed].
  const NaviCurrentSpeedEvent(this.speed);

  /// Current speed in km/h, or null when it is not known.
  final int? speed;

  /// Name of the platform channel event this is decoded from.
  static const name = "currentSpeedEvent";
}

/// Reports the speed limit in force on the road being driven.
class NaviSpeedLimitEvent extends NaviSpeedEvent {
  /// Creates the event for the given [speed] limit.
  const NaviSpeedLimitEvent(this.speed);

  /// Limit in km/h, or null when the road has no known limit.
  final int? speed;

  /// Name of the platform channel event this is decoded from.
  static const name = "speedLimitEvent";
}

/// Reports that the user started or stopped exceeding the speed limit.
class NaviExceedSpeedLimitEvent extends NaviSpeedEvent {
  /// Creates the event with the new [isExceed] state.
  const NaviExceedSpeedLimitEvent({required this.isExceed});

  /// Whether the limit is being exceeded right now.
  final bool isExceed;

  /// Name of the platform channel event this is decoded from.
  static const name = "exceedSpeedLimitEvent";
}

/// Which way a speed camera watches the traffic it is placed on.
enum NaviCameraDirection {
  /// Watches vehicles travelling in the direction of travel.
  along,

  /// Watches vehicles travelling the other way.
  against,

  /// Watches both directions.
  both,
}

/// Reports a speed camera on the road ahead.
class NaviCameraEvent extends NaviSpeedEvent {
  /// Creates the event for a camera that [isControlCamera] and watches
  /// [direction].
  const NaviCameraEvent({required this.isControlCamera, required this.direction});

  /// Whether the camera enforces the speed limit rather than only observing.
  final bool isControlCamera;

  /// Which way the camera watches, or null when that is not known.
  final NaviCameraDirection? direction;

  /// Name of the platform channel event this is decoded from.
  static const name = "cameraEvent";
}
