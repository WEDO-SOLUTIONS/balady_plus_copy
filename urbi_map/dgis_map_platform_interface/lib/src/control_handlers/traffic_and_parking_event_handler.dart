import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/parking_state_event.dart';
import 'package:dgis_map_platform_interface/src/events/traffic_state_event.dart';

class TrafficAndParkingEventHandler {
  TrafficAndParkingEventHandler();

  Stream<ParkingStateEvent> get parkingStateEvents => _parkingStateController.stream;
  Stream<TrafficStateEvent> get trafficStateEvents => _trafficStateController.stream;

  final _parkingStateController = StreamController<ParkingStateEvent>.broadcast();
  final _trafficStateController = StreamController<TrafficStateEvent>.broadcast();

  void parkingStateChanged(Map<dynamic, dynamic> map) {
    final visible = map["visible"];
    final event = ParkingStateEvent(visible: visible);

    _parkingStateController.sink.add(event);
  }

  void trafficStateChanged(Map<dynamic, dynamic> map) {
    final statusIndex = map["status"] as int;
    final score = map["score"];

    final status = TrafficControlStatus.values[statusIndex];

    final event = TrafficStateEvent(status: status, score: score);

    _trafficStateController.sink.add(event);
  }

  Future<void> dispose() async {
    await _parkingStateController.close();
    await _trafficStateController.close();
  }
}
