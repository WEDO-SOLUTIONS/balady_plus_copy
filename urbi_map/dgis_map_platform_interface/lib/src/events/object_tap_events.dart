import 'package:dgis_map_platform_interface/library.dart';
import 'package:flutter/material.dart';

abstract class TapEvent {
  const TapEvent();
}

class MarkerTapEvent extends TapEvent {
  const MarkerTapEvent(this.id);

  static const name = "onMarkerTap";

  final int id;
}

class ClusterTapEvent extends TapEvent {
  static const name = "onClusterTap";
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

class CircleTapEvent extends TapEvent {
  const CircleTapEvent(this.id);

  static const name = "onCircleTap";

  final int id;
}

class ObjectTapEvent extends TapEvent {
  const ObjectTapEvent(this.dgisObjectId, this.latLng, this.levelId);

  static const name = "onObjectTap";

  final DgisObjectId dgisObjectId;
  final int? levelId;
  final LatLng latLng;
}

/// Event for tap on my location blue point
/// iOS: [MyLocationMapObject] received on tap and
/// [sendDgisMyLocationEvent] send event to Flutter app
/// Android: WIP
class MyLocationTapEvent extends TapEvent {
  /// Constructor
  const MyLocationTapEvent(this.latLng);

  /// Event name
  static const name = "onMyLocationTap";

  /// Location of my location
  final LatLng latLng;
}

class RoadEventTapEvent extends TapEvent {
  RoadEventTapEvent(
    this.id,
    this.title,
    this.description,
    this.startTime,
    this.finishTime,
    this.latLng,
    this.type,
    this.lanes,
    this.availableActionTypes,
    this.updatedAt,
  );

  static const name = "onRoadEventTap";

  final DgisObjectId id;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final LatLng latLng;
  final RoadEventType? type;
  final Set<RoadEventLane> lanes;
  final Set<RoadEventActionType> availableActionTypes;

  /// Mirrors the native `RoadEvent.timestamp` — when the event record itself was
  /// created/last updated. Distinct from [startTime]/[finishTime], which are the
  /// road-restriction/road-works *schedule* (when the closure is in effect).
  final DateTime? updatedAt;
}

/// Mirrors the native `ru.dgis.sdk.road_events.RoadEventType` / `DGis.RoadEventType` enum.
/// Wire value matches both platforms' raw/value ordinal (0-5).
/// We map these types to BRD as follows:
/// comment => police
/// roadRestriction => warning
/// other => congestion
enum RoadEventType {
  accident,
  roadWorks,
  camera,
  comment,
  roadRestriction,
  other;

  static RoadEventType? fromValue(int? value) => switch (value) {
    0 => RoadEventType.accident,
    1 => RoadEventType.roadWorks,
    2 => RoadEventType.camera,
    3 => RoadEventType.comment,
    4 => RoadEventType.roadRestriction,
    5 => RoadEventType.other,
    _ => null,
  };
}

extension RoadEventTypeCreateExt on RoadEventType {
  /// Mirrors which native `RoadEventManager.createX` overload accepts a lanes
  /// parameter (accident/roadWorks/other) vs not (camera/roadRestriction/comment).
  bool get supportsLanes => switch (this) {
    RoadEventType.accident || RoadEventType.roadWorks || RoadEventType.other => true,
    RoadEventType.camera || RoadEventType.roadRestriction || RoadEventType.comment => false,
  };
}

/// Mirrors the native `ru.dgis.sdk.road_events.Lane` / `DGis.Lane` bitmask
/// (`LaneOptionSet` on iOS, `EnumSet<Lane>` on Android — both use the same bit values).
enum RoadEventLane {
  left(1),
  center(2),
  right(4);

  const RoadEventLane(this.bitmask);

  final int bitmask;

  static Set<RoadEventLane> fromBitmask(int? mask) {
    if (mask == null) {
      return const {};
    }
    return {
      for (final lane in RoadEventLane.values)
        if (mask & lane.bitmask != 0) lane,
    };
  }
}

/// Mirrors the native `ru.dgis.sdk.road_events.RoadEventActionType` / `DGis.RoadEventActionType`
/// enum — one of the actions available on a tapped road event (`RoadEvent.availableActions` in
/// the native SDK), invoked via `DgisMapController.setRoadEventAction`. Bit position in the wire
/// bitmask matches the enum's declaration index, which mirrors both platforms' raw/value ordinal
/// (0-3).
enum RoadEventActionType {
  like,
  dislike,
  confirmation,
  disproof;

  static Set<RoadEventActionType> fromBitmask(int? mask) {
    if (mask == null) {
      return const {};
    }
    return {
      for (final type in RoadEventActionType.values)
        if (mask & (1 << type.index) != 0) type,
    };
  }
}

/// DgisObjectId model
@immutable
class DgisObjectId {
  /// Constructor
  const DgisObjectId({required this.objectId, required this.entranceId});

  /// Dgis object id
  final int objectId;

  /// Entrance id
  final int entranceId;

  /// Convert DgisObjectId to DgisObjectIdMessage
  DgisObjectIdMessage toMessage() {
    return DgisObjectIdMessage(objectId: objectId, entranceId: entranceId);
  }

  @override
  int get hashCode => objectId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DgisObjectId && other.objectId == objectId;
  }
}

/// Extension for DgisObjectIdMessage
extension DgisObjectIdMessageExt on DgisObjectIdMessage {
  /// Convert DgisObjectIdMessage to DgisObjectId
  DgisObjectId toObjectId() => DgisObjectId(objectId: objectId, entranceId: entranceId);
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
