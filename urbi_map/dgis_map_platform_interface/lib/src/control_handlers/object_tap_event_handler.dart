import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';
import 'package:dgis_map_platform_interface/src/events/object_tap_events.dart';

typedef void OnObjectTap();
typedef SimpleClusterOptionsMessage ClusterRenderer(int objectCount);
typedef Future<void> OnClusterTap(SimpleClusterObject clusterObject);

class TapIdPair {
  TapIdPair(this.tap, this.id);

  final OnObjectTap tap;
  final String? id;
}

class ObjectTapEventHandler {
  ObjectTapEventHandler();

  Stream<TapEvent> get objectTapEvents => _objectTapController.stream;

  final _objectTapController = StreamController<TapEvent>.broadcast();

  final Map<String, TapIdPair> markerHandlers = {};
  final Map<String, OnObjectTap> polygonHandlers = {};
  final Map<String, OnObjectTap> polylineHandlers = {};
  final Map<String, ClusterRenderer> clusterRenderers = {};
  final Map<String, OnClusterTap> clusterHandlers = {};

  void addMarkerHandler(String id, OnObjectTap onTap, String? managerId) {
    markerHandlers[id] = TapIdPair(onTap, managerId);
  }

  void removeMarkerHandler(String id) {
    markerHandlers.remove(id);
  }

  void addClusterHandler(String id, OnClusterTap onTap) {
    clusterHandlers[id] = onTap;
  }

  void removeClusterHandler(String id) {
    clusterHandlers.remove(id);
  }

  void addClusterRenderer(String id, ClusterRenderer onTap) {
    clusterRenderers[id] = onTap;
  }

  void removeClusterRenderer(String id) {
    clusterRenderers.remove(id);
  }

  Future<void> clusterTapEvent(Map<dynamic, dynamic> map, MapApi api) async {
    final id = map["id"] as String;
    final cluster = map["cluster"];

    final clusterObject = SimpleClusterObject(
      api,
      cluster["id"],
      GeoPointWithElevationMessage(
        latitude: cluster["position"]["latitude"],
        longitude: cluster["position"]["longitude"],
        elevation: cluster["position"]["elevation"],
      ),
      cluster["objectCount"],
      (cluster["objects"] as List<Object?>).map((x) => x as String).toList(),
      MarkerAnchorMessage(
        x: cluster["anchor"]["x"],
        y: cluster["anchor"]["y"],
      ),
      cluster["iconOpacity"],
      MarkerTextStyleMessage(
        fontSize: cluster["textStyle"]["fontSize"],
        color: cluster["textStyle"]["color"],
        strokeWidth: cluster["textStyle"]["strokeWidth"],
        strokeColor: cluster["textStyle"]["strokeColor"],
        textPlacement: MarkerTextPlacementMessage(
          placement: TextPlacementMessage
              .values[cluster["textStyle"]["textPlacement"]],
        ),
        textOffset: cluster["textStyle"]["textOffset"],
        fontName: cluster["textStyle"]["fontName"],
      ),
      cluster["iconWidth"],
      cluster["iconMapDirection"] != null
          ? MarkerAzimuthMessage(degree: cluster["iconMapDirection"])
          : null,
      cluster["text"],
    );
    await clusterHandlers[id]?.call(clusterObject);
  }

  void removeAllMarkerHandlers(String? managerId) {
    markerHandlers.removeWhere((key, value) => value.id == managerId);
  }

  void markerTapEvent(Map<dynamic, dynamic> map) {
    markerHandlers[map["id"]]?.tap.call();
  }

  void addPolygonHandler(String id, OnObjectTap onTap) {
    polygonHandlers[id] = onTap;
  }

  void removePolygonHandler(String id) {
    polygonHandlers.remove(id);
  }

  void removeAllPolygonHandlers() {
    polygonHandlers.clear();
  }

  void polygonTapEvent(Map<dynamic, dynamic> map) {
    polygonHandlers[map["id"]]?.call();
  }

  void addPolylineHandler(String id, OnObjectTap onTap) {
    polylineHandlers[id] = onTap;
  }

  void removePolylineHandler(String id) {
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
      map["levelId"],
    ));
  }

  void myLocationTapEvent(Map<dynamic, dynamic> map) {
    final latLngMap = map["latlng"];

    _objectTapController.sink.add(MyLocationTapEvent(
      LatLng(
        latitude: latLngMap["latitude"],
        longitude: latLngMap["longitude"],
      ),
    ));
  }

  void roadEventTapEvent(Map<dynamic, dynamic> map) {
    final startTime = DateTime.fromMillisecondsSinceEpoch(map["startTime"]);
    final finishTime = DateTime.fromMillisecondsSinceEpoch(map["finishTime"]);
    final dgisObjectMap = map["dgisObjectId"];

    _objectTapController.sink.add(
      RoadEventTapEvent(
        DgisObjectId(
          objectId: dgisObjectMap["objectId"],
          entranceId: dgisObjectMap["entranceId"],
        ),
        map["title"],
        map["description"],
        startTime,
        finishTime,
        LatLng(
          latitude: map["latitude"],
          longitude: map["longitude"],
        ),
      ),
    );
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
