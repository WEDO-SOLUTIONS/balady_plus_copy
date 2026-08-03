import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

typedef OnObjectTap = void Function();
typedef ClusterRenderer = SimpleClusterOptionsMessage Function(int objectCount);
typedef OnClusterTap = Future<void> Function(SimpleClusterObject clusterObject);

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
  final Map<String, TapIdPair> polygonHandlers = {};
  final Map<String, TapIdPair> polylineHandlers = {};
  final Map<String, TapIdPair> circleHandlers = {};
  final Map<String, ClusterRenderer> clusterRenderers = {};
  final Map<String, OnClusterTap> clusterHandlers = {};

  /// --- CLUSTER ---
  void addClusterHandler(String id, OnClusterTap onTap) {
    clusterHandlers[id] = onTap;
  }

  void removeClusterHandler(String id) {
    clusterHandlers.remove(id);
  }

  void addClusterRenderer(String id, ClusterRenderer render) {
    clusterRenderers[id] = render;
  }

  void removeClusterRenderer(String id) {
    clusterRenderers.remove(id);
  }

  Future<void> clusterTapEvent(Map<dynamic, dynamic> map, MapApi api) async {
    final id = map["id"] as String;
    final cluster = map["cluster"];

    final textStyle = cluster["textStyle"];
    final position = cluster["position"];

    final List<SimpleMapObjectModel> objects = ((cluster['objects'] as List?) ?? const [])
        .map((e) => SimpleMapObjectModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();

    final clusterObject = SimpleClusterObject(
      api,
      cluster["id"],
      GeoPointWithElevationMessage(
        latitude: position["latitude"],
        longitude: position["longitude"],
        elevation: position["elevation"],
      ),
      cluster["objectCount"],
      objects,
      MarkerAnchorMessage(x: cluster["anchor"]["x"], y: cluster["anchor"]["y"]),
      cluster["iconOpacity"],
      MarkerTextStyleMessage(
        fontSize: textStyle["fontSize"],
        color: textStyle["color"],
        strokeWidth: textStyle["strokeWidth"],
        strokeColor: textStyle["strokeColor"],
        textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.values[textStyle["textPlacement"]]),
        textOffset: textStyle["textOffset"],
        fontName: textStyle["fontName"],
      ),
      cluster["iconWidth"],
      cluster["iconMapDirection"] != null ? MapDirectionMessage(degree: cluster["iconMapDirection"]) : null,
      cluster["text"],
    );
    await clusterHandlers[id]?.call(clusterObject);
  }

  /// --- MARKER ---
  void addMarkerHandler(String id, OnObjectTap onTap, String? managerId) {
    markerHandlers[id] = TapIdPair(onTap, managerId);
  }

  void removeMarkerHandler(String id) {
    markerHandlers.remove(id);
  }

  void removeAllMarkerHandlers(String? managerId) {
    markerHandlers.removeWhere((key, value) => value.id == managerId);
  }

  void markerTapEvent(Map<dynamic, dynamic> map) {
    markerHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYGON ---
  void addPolygonHandler(String id, OnObjectTap onTap, String? managerId) {
    polygonHandlers[id] = TapIdPair(onTap, managerId);
  }

  void removePolygonHandler(String id) {
    polygonHandlers.remove(id);
  }

  void removeAllPolygonHandlers() {
    polygonHandlers.clear();
  }

  void polygonTapEvent(Map<dynamic, dynamic> map) {
    polygonHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYLINE ---
  void addPolylineHandler(String id, OnObjectTap onTap, String? managerId) {
    polylineHandlers[id] = TapIdPair(onTap, managerId);
  }

  void removePolylineHandler(String id) {
    polylineHandlers.remove(id);
  }

  void removeAllPolylineHandlers() {
    polylineHandlers.clear();
  }

  void polylineTapEvent(Map<dynamic, dynamic> map) {
    polylineHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYLINE ---
  void addCircleHandler(String id, OnObjectTap onTap, String? managerId) {
    circleHandlers[id] = TapIdPair(onTap, managerId);
  }

  void removeCircleHandler(String id) {
    circleHandlers.remove(id);
  }

  void removeAllCircleHandlers() {
    circleHandlers.clear();
  }

  void circleTapEvent(Map<dynamic, dynamic> map) {
    circleHandlers[map["id"]]?.tap.call();
  }

  /// --- TAP EVENTS ---
  void objectTapEvent(Map<dynamic, dynamic> map) {
    final dgisObjectMap = map["dgisObjectId"];
    final latLngMap = map["latlng"];

    _objectTapController.sink.add(
      ObjectTapEvent(
        DgisObjectId(objectId: dgisObjectMap["objectId"], entranceId: dgisObjectMap["entranceId"]),
        LatLng(latitude: latLngMap["latitude"], longitude: latLngMap["longitude"]),
        map["levelId"],
      ),
    );
  }

  void myLocationTapEvent(Map<dynamic, dynamic> map) {
    final latLngMap = map["latlng"];

    _objectTapController.sink.add(
      MyLocationTapEvent(LatLng(latitude: latLngMap["latitude"], longitude: latLngMap["longitude"])),
    );
  }

  // Asia/Riyadh has no DST; Hajj closure schedules are authored in KSA wall time
  // and must be displayed in KSA regardless of the device locale (BALADY-21).
  static const Duration _ksaOffset = Duration(hours: 3);

  DateTime? _ksaWallTimeFromEpoch(Object? millis) {
    if (millis is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).add(_ksaOffset);
  }

  // RoadEvent.timestamp is a system-generated instant (when the record was
  // created/updated), unlike the human-authored KSA-wall-time schedule
  // boundaries above — so no KSA offset is applied here.
  DateTime? _dateTimeFromEpoch(Object? millis) {
    if (millis is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  void roadEventTapEvent(Map<dynamic, dynamic> map) {
    final startTime = _ksaWallTimeFromEpoch(map["startTime"]);
    final finishTime = _ksaWallTimeFromEpoch(map["finishTime"]);
    final updatedAt = _dateTimeFromEpoch(map["timestamp"]);
    final dgisObjectMap = map["dgisObjectId"];

    _objectTapController.sink.add(
      RoadEventTapEvent(
        DgisObjectId(objectId: dgisObjectMap["objectId"], entranceId: dgisObjectMap["entranceId"]),
        map["title"],
        map["description"],
        startTime,
        finishTime,
        LatLng(latitude: map["latitude"], longitude: map["longitude"]),
        RoadEventType.fromValue(map["type"] as int?),
        RoadEventLane.fromBitmask(map["lanes"] as int?),
        RoadEventActionType.fromBitmask(map["availableActionTypes"] as int?),
        updatedAt,
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
      latLng: LatLng(latitude: map["latitude"], longitude: map["longitude"]),
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
      latLng: LatLng(latitude: map["latitude"], longitude: map["longitude"]),
    );

    _objectTapController.sink.add(event);
  }
}
