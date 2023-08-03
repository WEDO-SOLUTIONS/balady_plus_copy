import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/navi_dashboard_event.dart';

class DashboardEventHandler {
  DashboardEventHandler();

  Stream<NaviDashboardEvent> get dashboardEvents => _controller.stream;

  final _controller = StreamController<NaviDashboardEvent>.broadcast();

  void handleDashboardEvent(Map<dynamic, dynamic> map) => _controller.sink.add(
        NaviDashboardEvent(
          map['duration'],
          map['distance'],
          map['arrivalTime'],
        ),
      );

  Future<void> dispose() {
    return _controller.close();
  }
}
