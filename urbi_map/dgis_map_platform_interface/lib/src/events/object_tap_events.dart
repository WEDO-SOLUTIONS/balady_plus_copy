import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';

abstract class TapEvent {
  const TapEvent();
}

class MarkerTapEvent extends TapEvent {
  const MarkerTapEvent(this.id);

  static const name = "onMarkerTap";

  final int id;
}

class PolygonTapEvent extends TapEvent {
  const PolygonTapEvent(this.id);

  static const name = "onPolygonTap";

  final int id;
}

class PolylineTapEvent extends TapEvent {
  const PolylineTapEvent(this.id);

  static const name = "onPolylineTap";

  final int id;
}

class ObjectTapEvent extends TapEvent {
  const ObjectTapEvent(this.dgisObjectId, this.latLng);

  static const name = "onObjectTap";

  final DgisObjectId dgisObjectId;
  final LatLng latLng;
}

class DgisObjectId {
  const DgisObjectId({
    required this.objectId,
    required this.entranceId,
  });

  final int objectId;
  final int entranceId;
}

/// Tap on IO layer
class IoTapEvent extends TapEvent {
  /// @nodoc
  const IoTapEvent({
    required this.description,
    required this.area,
    required this.type,
    required this.status,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.latLng,
  });

  static const name = "onIoTap";

  final String description;
  final double area;
  final String type;
  final String status;
  final double price;
  final String startDate;
  final String endDate;
  final LatLng latLng;

  @override
  String toString() {
    return """
      description: $description,
      area: $area,
      type: $type,
      status: $status,
      price: $price,
      startDate: $startDate,
      endDate: $endDate,
      latitude: ${latLng.latitude},
      longitude: ${latLng.longitude},
    """;
  }
}

/// Tap on Idle layer
class IdleTapEvent extends TapEvent {
  /// @nodoc
  const IdleTapEvent({
    required this.landuse,
    required this.description,
    required this.area,
    required this.parcelName,
    required this.phase,
    required this.createdDate,
    required this.amanaName,
    required this.munName,
    required this.status,
    required this.streetName,
    required this.planNo,
    required this.latLng,
  });

  static const name = "onIdleTap";

  final String landuse;
  final String description;
  final double area;
  final String parcelName;
  final String phase;
  final String createdDate;
  final String amanaName;
  final String munName;
  final LatLng latLng;

  /// 0 - no fence, 1 - fenced, -1 - unknown
  final String status;
  final String streetName;
  final String planNo;

  @override
  String toString() {
    return """
      landuse: $landuse,
      description: $description,
      area: $area,
      parcelName: $parcelName,
      phase: $phase,
      createdDate: $createdDate,
      amanaName: $amanaName,
      munName: $munName,
      status: $status,
      streetName: $streetName,
      planNo: $planNo,
      latitude: ${latLng.latitude},
      longitude: ${latLng.longitude},
    """;
  }
}
