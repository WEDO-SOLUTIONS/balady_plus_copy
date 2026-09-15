import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Turns the native map's traffic and parking layer notifications into Dart
/// streams.
class TrafficAndParkingEventHandler {
  /// Creates the handler.
  TrafficAndParkingEventHandler();

  /// Every change in the parking layer's state.
  Stream<ParkingStateEvent> get parkingStateEvents => _parkingStateController.stream;

  /// Every change in the traffic layer's state and congestion score.
  Stream<TrafficStateEvent> get trafficStateEvents => _trafficStateController.stream;

  final _parkingStateController = StreamController<ParkingStateEvent>.broadcast();
  final _trafficStateController = StreamController<TrafficStateEvent>.broadcast();

  /// Decodes the parking layer's state off the platform channel and publishes
  /// it on [parkingStateEvents].
  void parkingStateChanged(Map<dynamic, dynamic> map) {
    final visible = map["visible"];
    final filter = ParkingFilter.fromAttribute(map["filterAttribute"]);
    final event = ParkingStateEvent(visible: visible, filter: filter);

    _parkingStateController.sink.add(event);
  }

  /// Decodes the traffic layer's state off the platform channel and publishes
  /// it on [trafficStateEvents].
  void trafficStateChanged(Map<dynamic, dynamic> map) {
    final statusIndex = map["status"] as int;
    final score = map["score"];

    final status = TrafficControlStatus.values[statusIndex];

    final event = TrafficStateEvent(status: status, score: score);

    _trafficStateController.sink.add(event);
  }

  /// Closes both layer streams.
  Future<void> dispose() async {
    await _parkingStateController.close();
    await _trafficStateController.close();
  }
}
