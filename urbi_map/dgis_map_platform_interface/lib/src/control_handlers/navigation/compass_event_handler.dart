import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/compass_bearing_events.dart';

/// Turns the native map's compass bearing updates into a Dart stream.
class CompassEventHandler {
  /// Creates the handler.
  CompassEventHandler();

  /// Every compass bearing the map has reported.
  Stream<CompassBearingEvent> get compassBearingEvents => _compassBearingController.stream;

  final _compassBearingController = StreamController<CompassBearingEvent>.broadcast();

  /// Decodes a bearing off the platform channel and publishes it on
  /// [compassBearingEvents].
  void compassBearingChangedEvent(Map<dynamic, dynamic> map) {
    final value = map["value"];
    final event = CompassBearingEvent(value: value);

    _compassBearingController.sink.add(event);
  }

  /// Closes the compass stream.
  Future<void> dispose() async {
    await _compassBearingController.close();
  }
}
