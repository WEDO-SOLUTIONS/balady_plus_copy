import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Called when an object the app added to the map is tapped.
typedef OnObjectTap = void Function();

/// Asked how to draw a cluster standing for [objectCount] markers.
typedef ClusterRenderer = SimpleClusterOptionsMessage Function(int objectCount);

/// Called when a cluster is tapped, with the markers it stands for.
typedef OnClusterTap = Future<void> Function(SimpleClusterObject clusterObject);

/// One registered tap callback together with the object manager it belongs
/// to, so a manager can drop all of its handlers at once.
class TapIdPair {
  /// Pairs a [tap] callback with its manager [id].
  TapIdPair(this.tap, this.id);

  /// What to run when the object is tapped.
  final OnObjectTap tap;

  /// Identifier of the object manager that registered this, if any.
  final String? id;
}

/// Routes every tap the native map reports: it publishes a [TapEvent] on
/// [objectTapEvents], and also runs the per-object callback the app
/// registered when it added that marker, polygon, polyline or circle.
class ObjectTapEventHandler {
  /// Creates the handler with no callbacks registered.
  ObjectTapEventHandler();

  /// Every tap the map has reported, whatever kind of object it landed on.
  Stream<TapEvent> get objectTapEvents => _objectTapController.stream;

  final _objectTapController = StreamController<TapEvent>.broadcast();

  /// Tap callbacks registered per marker, keyed by the marker's id.
  final Map<String, TapIdPair> markerHandlers = {};

  /// Tap callbacks registered per 3D model, keyed by the 3D model's id.
  final Map<String, TapIdPair> modelHandlers = {};

  /// Tap callbacks registered per polygon, keyed by the polygon's id.
  final Map<String, TapIdPair> polygonHandlers = {};

  /// Tap callbacks registered per polyline, keyed by the polyline's id.
  final Map<String, TapIdPair> polylineHandlers = {};

  /// Tap callbacks registered per circle, keyed by the circle's id.
  final Map<String, TapIdPair> circleHandlers = {};

  /// How to draw a cluster, per object manager.
  final Map<String, ClusterRenderer> clusterRenderers = {};

  /// What to run when a cluster is tapped, per object manager.
  final Map<String, OnClusterTap> clusterHandlers = {};

  /// --- CLUSTER ---
  /// Registers [onTap] for clusters belonging to the manager with this [id].
  void addClusterHandler(String id, OnClusterTap onTap) {
    clusterHandlers[id] = onTap;
  }

  /// Forgets the cluster callback registered by the manager with this [id].
  void removeClusterHandler(String id) {
    clusterHandlers.remove(id);
  }

  /// Registers how the manager with this [id] wants its clusters drawn.
  void addClusterRenderer(String id, ClusterRenderer render) {
    clusterRenderers[id] = render;
  }

  /// Forgets the cluster renderer registered by the manager with this [id].
  void removeClusterRenderer(String id) {
    clusterRenderers.remove(id);
  }

  /// Decodes a cluster tap off the platform channel, asks [api] for the
  /// markers behind the cluster and hands them to the registered callback.
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
  /// Registers [onTap] for the marker with this [id], owned by [managerId].
  void addMarkerHandler(String id, OnObjectTap onTap, String? managerId) {
    markerHandlers[id] = TapIdPair(onTap, managerId);
  }

  /// Forgets the callback registered for the marker with this [id].
  void removeMarkerHandler(String id) {
    markerHandlers.remove(id);
  }

  /// Forgets every marker callback registered by [managerId].
  void removeAllMarkerHandlers(String? managerId) {
    markerHandlers.removeWhere((key, value) => value.id == managerId);
  }

  /// Decodes a marker tap off the platform channel, publishes it on
  /// [objectTapEvents] and runs the callback registered for that marker.
  void markerTapEvent(Map<dynamic, dynamic> map) {
    markerHandlers[map["id"]]?.tap.call();
  }

  /// --- 3D MODEL ---
  /// Registers [onTap] for the 3D model with this [id], owned by [managerId].
  void addModelHandler(String id, OnObjectTap onTap, String? managerId) {
    modelHandlers[id] = TapIdPair(onTap, managerId);
  }

  /// Forgets the callback registered for the 3D model with this [id].
  void removeModelHandler(String id) {
    modelHandlers.remove(id);
  }

  /// Forgets every 3D model callback registered by [managerId].
  void removeAllModelHandlers(String? managerId) {
    modelHandlers.removeWhere((key, value) => value.id == managerId);
  }

  /// Decodes a 3D model tap off the platform channel, publishes it on
  /// [objectTapEvents] and runs the callback registered for that 3D model.
  void modelTapEvent(Map<dynamic, dynamic> map) {
    modelHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYGON ---
  /// Registers [onTap] for the polygon with this [id], owned by [managerId].
  void addPolygonHandler(String id, OnObjectTap onTap, String? managerId) {
    polygonHandlers[id] = TapIdPair(onTap, managerId);
  }

  /// Forgets the callback registered for the polygon with this [id].
  void removePolygonHandler(String id) {
    polygonHandlers.remove(id);
  }

  /// Forgets every polygon callback registered by [managerId].
  void removeAllPolygonHandlers(String? managerId) {
    polygonHandlers.removeWhere((key, value) => value.id == managerId);
  }

  /// Decodes a polygon tap off the platform channel, publishes it on
  /// [objectTapEvents] and runs the callback registered for that polygon.
  void polygonTapEvent(Map<dynamic, dynamic> map) {
    polygonHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYLINE ---
  /// Registers [onTap] for the polyline with this [id], owned by [managerId].
  void addPolylineHandler(String id, OnObjectTap onTap, String? managerId) {
    polylineHandlers[id] = TapIdPair(onTap, managerId);
  }

  /// Forgets the callback registered for the polyline with this [id].
  void removePolylineHandler(String id) {
    polylineHandlers.remove(id);
  }

  /// Forgets every polyline callback registered by [managerId].
  void removeAllPolylineHandlers(String? managerId) {
    polylineHandlers.removeWhere((key, value) => value.id == managerId);
  }

  /// Decodes a polyline tap off the platform channel, publishes it on
  /// [objectTapEvents] and runs the callback registered for that polyline.
  void polylineTapEvent(Map<dynamic, dynamic> map) {
    polylineHandlers[map["id"]]?.tap.call();
  }

  /// --- POLYLINE ---
  /// Registers [onTap] for the circle with this [id], owned by [managerId].
  void addCircleHandler(String id, OnObjectTap onTap, String? managerId) {
    circleHandlers[id] = TapIdPair(onTap, managerId);
  }

  /// Forgets the callback registered for the circle with this [id].
  void removeCircleHandler(String id) {
    circleHandlers.remove(id);
  }

  /// Forgets every circle callback registered by [managerId].
  void removeAllCircleHandlers(String? managerId) {
    circleHandlers.removeWhere((key, value) => value.id == managerId);
  }

  /// Decodes a circle tap off the platform channel, publishes it on
  /// [objectTapEvents] and runs the callback registered for that circle.
  void circleTapEvent(Map<dynamic, dynamic> map) {
    circleHandlers[map["id"]]?.tap.call();
  }

  /// --- TAP EVENTS ---
  /// Decodes a tap on a map-owned object - a building or POI - off the
  /// platform channel and publishes it on [objectTapEvents].
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

  /// Decodes a tap on the blue my-location dot off the platform channel and
  /// publishes it on [objectTapEvents].
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

  /// Decodes a tap on a road event off the platform channel and publishes it
  /// on [objectTapEvents].
  void roadEventTapEvent(Map<dynamic, dynamic> map) {
    final startTime = _ksaWallTimeFromEpoch(map["startTime"]);
    final finishTime = _ksaWallTimeFromEpoch(map["finishTime"]);
    final dgisObjectMap = map["dgisObjectId"];

    _objectTapController.sink.add(
      RoadEventTapEvent(
        DgisObjectId(objectId: dgisObjectMap["objectId"], entranceId: dgisObjectMap["entranceId"]),
        map["title"],
        map["description"],
        startTime,
        finishTime,
        LatLng(latitude: map["latitude"], longitude: map["longitude"]),
      ),
    );
  }

  /// Closes the tap stream.
  Future<void> dispose() async {
    await _objectTapController.close();
  }

  /// Decodes a tap on the investment-opportunities layer off the platform
  /// channel and publishes it on [objectTapEvents].
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

  /// Decodes a tap on the idle-land layer off the platform channel and
  /// publishes it on [objectTapEvents].
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
