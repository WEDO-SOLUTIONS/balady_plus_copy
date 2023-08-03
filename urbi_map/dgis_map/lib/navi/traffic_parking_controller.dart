import 'dart:async';

import 'package:dgis_map/library.dart';

/// Controller for traffic and parking layers
class NaviTrafficParkingController {
  /// @nodoc
  NaviTrafficParkingController({
    required this.trafficStateEvents,
    required this.parkingStateEvents,
    required this.onAttached,
    required this.onDetached,
    required this.onTrafficClicked,
    required this.onParkingClicked,
  });

  /// All traffic events without filtering
  final Stream<TrafficStateEvent> trafficStateEvents;

  /// All parking events without filtering
  final Stream<ParkingStateEvent> parkingStateEvents;

  /// @nodoc
  Future<void> Function() onAttached;

  /// @nodoc
  Future<void> Function() onDetached;

  /// @nodoc
  Future<void> Function() onTrafficClicked;

  /// @nodoc
  Future<void> Function() onParkingClicked;
}
