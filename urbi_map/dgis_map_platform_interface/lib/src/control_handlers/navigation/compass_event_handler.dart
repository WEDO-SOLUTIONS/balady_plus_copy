import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/compass_bearing_events.dart';

class CompassEventHandler {
  CompassEventHandler();

  Stream<CompassBearingEvent> get compassBearingEvents => _compassBearingController.stream;

  final _compassBearingController = StreamController<CompassBearingEvent>.broadcast();

  void compassBearingChangedEvent(Map<dynamic, dynamic> map) {
    final value = map["value"];
    final event = CompassBearingEvent(value: value);

    _compassBearingController.sink.add(event);
  }

  Future<void> dispose() async {
    await _compassBearingController.close();
  }
}
