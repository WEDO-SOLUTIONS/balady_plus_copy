import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/navi_dashboard_event.dart';

/// Turns navigation's dashboard updates - distance and time left, and the
/// estimated arrival - into a Dart stream.
class DashboardEventHandler {
  /// Creates the handler.
  DashboardEventHandler();

  /// Every dashboard update navigation has reported.
  Stream<NaviDashboardEvent> get dashboardEvents => _controller.stream;

  final _controller = StreamController<NaviDashboardEvent>.broadcast();

  /// Decodes a dashboard payload off the platform channel and publishes it on
  /// [dashboardEvents].
  void handleDashboardEvent(Map<dynamic, dynamic> map) =>
      _controller.sink.add(NaviDashboardEvent(map['duration'], map['distance'], map['arrivalTime']));

  /// Closes the dashboard stream.
  Future<void> dispose() {
    return _controller.close();
  }
}
