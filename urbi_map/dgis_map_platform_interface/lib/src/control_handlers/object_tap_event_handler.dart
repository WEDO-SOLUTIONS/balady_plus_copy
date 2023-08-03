import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

typedef void OnObjectTap();
typedef SimpleClusterOptionsMessage ClusterRenderer(int objectCount);
typedef void OnClusterTap(SimpleClusterObject clusterObject);

class ObjectTapEventHandler {
  ObjectTapEventHandler();

  Stream<TapEvent> get objectTapEvents => _objectTapController.stream;

  final _objectTapController = StreamController<TapEvent>();

  final Map<String, OnObjectTap> markerHandlers = {};
  final Map<String, OnObjectTap> polygonHandlers = {};
  final Map<String, OnObjectTap> polylineHandlers = {};
  final Map<String, ClusterRenderer> clusterRenderers = {};
  final Map<String, OnClusterTap> clusterHandlers = {};

  void addMarkerHandler(String id, OnObjectTap onTap) {
    markerHandlers[id] = onTap;
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

  void clusterTapEvent(Map<dynamic, dynamic> map) {
    final id = map["id"] as String;
    final cluster = map["cluster"];
    final clusterObject = SimpleClusterObject(
      GeoPointWithElevationMessage(
        latitude: cluster["position"]["latitude"],
        longitude: cluster["position"]["longitude"],
        elevation: cluster["position"]["elevation"],
      ),
      cluster["objectCount"],
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
    clusterHandlers[id]?.call(clusterObject);
  }

  void removeAllMarkerHandlers() {
    markerHandlers.clear();
  }

  void markerTapEvent(Map<dynamic, dynamic> map) {
    markerHandlers[map["id"]]?.call();
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
