// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/public_transport_events.dart';

class PublicTransportEventHandler {
  PublicTransportEventHandler();

  Stream<PublicTransportRoutesChangedEvent> get routesChangedEvents => _routesChangedController.stream;

  Stream<PublicTransportActiveRouteChanged> get activeRouteChangedEvents => _activeRouteChangedController.stream;

  final _routesChangedController = StreamController<PublicTransportRoutesChangedEvent>.broadcast();

  final _activeRouteChangedController = StreamController<PublicTransportActiveRouteChanged>.broadcast();

  void routesChangedEvent(Map<dynamic, dynamic> map) {
    _routesChangedController.add(
      PublicTransportRoutesChangedEvent(
        List<BriefPublicTransportModel>.from(
          (map['routes'] as List<dynamic>).map((x) => BriefPublicTransportModel.fromMap(x as Map<dynamic, dynamic>)),
        ),
      ),
    );
  }

  void activeRouteChangedEvent(Map<dynamic, dynamic> map) {
    _activeRouteChangedController.add(
      PublicTransportActiveRouteChanged(
        PublicTransportModel.fromMap(map['route']),
      ),
    );
  }

  Future<void> dispose() async {
    await _routesChangedController.close();
    await _activeRouteChangedController.close();
  }
}
