import 'dart:async';

import 'package:dgis_map/library.dart';

/// Controller for compass bearing
class NaviCompassController {
  /// @nodoc
  NaviCompassController(this.events, this.onCompassClicked);

  /// All events without filtering
  final Stream<CompassBearingEvent> events;

  /// Run when the compass is tapped; typically points the camera north.
  final Future<void> Function() onCompassClicked;
}
