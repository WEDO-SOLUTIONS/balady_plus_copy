import 'dart:async';

import '../library.dart';

/// Controller for navigation speed events
class NaviSpeedController {
  /// @nodoc
  NaviSpeedController(this.events);

  /// All events without filtering
  final Stream<NaviSpeedEvent> events;

  /// Current speed in km/h, null while it is unknown.
  Stream<int?> get currentSpeedEvents =>
      events.where((it) => it is NaviCurrentSpeedEvent).cast<NaviCurrentSpeedEvent>().map((it) => it.speed);

  /// Speed limit in km/h, null on roads with no known limit.
  Stream<int?> get speedLimitEvents =>
      events.where((it) => it is NaviSpeedLimitEvent).cast<NaviSpeedLimitEvent>().map((it) => it.speed);

  /// Whether the limit is being exceeded right now.
  Stream<bool> get exceedSpeedLimitEvents =>
      events.where((it) => it is NaviExceedSpeedLimitEvent).cast<NaviExceedSpeedLimitEvent>().map((it) => it.isExceed);

  /// Speed cameras reported on the road ahead.
  Stream<NaviCameraEvent> get cameraEvents => events.where((it) => it is NaviCameraEvent).cast<NaviCameraEvent>();
}
