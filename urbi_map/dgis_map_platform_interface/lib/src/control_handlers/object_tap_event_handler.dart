import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';
import 'package:dgis_map_platform_interface/src/events/object_tap_events.dart';

typedef void OnObjectTap();

class ObjectTapEventHandler {
  ObjectTapEventHandler();

  Stream<TapEvent> get objectTapEvents => _objectTapController.stream;

  final _objectTapController = StreamController<TapEvent>();

  final Map<int, OnObjectTap> markerHandlers = {};
  final Map<int, OnObjectTap> polygonHandlers = {};
  final Map<int, OnObjectTap> polylineHandlers = {};

  void addMarkerHandler(int id, OnObjectTap onTap) {
    markerHandlers[id] = onTap;
  }

  void removeMarkerHandler(int id) {
    markerHandlers.remove(id);
  }

  void removeAllMarkerHandlers() {
    markerHandlers.clear();
  }

  void markerTapEvent(Map<dynamic, dynamic> map) {
    markerHandlers[map["id"]]?.call();
  }

  void addPolygonHandler(int id, OnObjectTap onTap) {
    polygonHandlers[id] = onTap;
  }

  void removePolygonHandler(int id) {
    polygonHandlers.remove(id);
  }

  void removeAllPolygonHandlers() {
    polygonHandlers.clear();
  }

  void polygonTapEvent(Map<dynamic, dynamic> map) {
    polygonHandlers[map["id"]]?.call();
  }

  void addPolylineHandler(int id, OnObjectTap onTap) {
    polylineHandlers[id] = onTap;
  }

  void removePolylineHandler(int id) {
    polylineHandlers.remove(id);
  }

  void removeAllPolylineHandlers() {
    polylineHandlers.clear();
  }

  void polylineTapEvent(Map<dynamic, dynamic> map) {
    polylineHandlers[map["id"]]?.call();
  }

  void objectTapEvent(Map<dynamic, dynamic> map) {
    final dgisObjectMap = map["dgisObjectId"];
    final latLngMap = map["latlng"];

    _objectTapController.sink.add(ObjectTapEvent(
      DgisObjectId(
        objectId: dgisObjectMap["objectId"],
        entranceId: dgisObjectMap["entranceId"],
      ),
      LatLng(
        latitude: latLngMap["latitude"],
        longitude: latLngMap["longitude"],
      ),
    ));
  }

  Future<void> dispose() async {
    await _objectTapController.close();
  }

  void onIoTap(Map<dynamic, dynamic> map) {
    final event = IoTapEvent(
      description: map["description"],
      area: map["area"],
      type: map["type"],
      status: map["status"],
      price: map["price"],
      startDate: map["startDate"],
      endDate: map["endDate"],
      latLng: LatLng(
        latitude: map["latitude"],
        longitude: map["longitude"],
      ),
    );

    _objectTapController.sink.add(event);
  }

  void onIdleTap(Map<dynamic, dynamic> map) {
    final event = IdleTapEvent(
      landuse: map["landuse"],
      description: map["description"],
      area: map["area"],
      parcelName: map["parcelName"],
      phase: map["phase"],
      createdDate: map["createdDate"],
      amanaName: map["amanaName"],
      munName: map["munName"],
      status: map["status"],
      streetName: map["streetName"],
      planNo: map["planNo"],
      latLng: LatLng(
        latitude: map["latitude"],
        longitude: map["longitude"],
      ),
    );

    _objectTapController.sink.add(event);
  }
}
