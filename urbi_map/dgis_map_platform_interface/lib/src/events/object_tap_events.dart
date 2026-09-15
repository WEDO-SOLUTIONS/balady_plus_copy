import 'package:dgis_map_platform_interface/library.dart';
import 'package:flutter/material.dart';

/// Base class for every tap the map reports back to Flutter, one subclass
/// per kind of thing that can be tapped.
abstract class TapEvent {
  /// Creates the base event.
  const TapEvent();
}

/// A marker added by the app was tapped.
class MarkerTapEvent extends TapEvent {
  /// Creates the event for the marker with this [id].
  const MarkerTapEvent(this.id);

  /// Name of the platform channel event this is decoded from.
  static const name = "onMarkerTap";

  /// Identifier the app gave the marker when adding it.
  final int id;
}

/// A 3D model on the map was tapped.
class ModelTapEvent extends TapEvent {
  /// Creates the event for the model with this [id].
  const ModelTapEvent(this.id);

  /// Name of the platform channel event this is decoded from.
  static const name = "onModelTap";

  /// Identifier the app gave the model when adding it.
  final String id;
}

/// A cluster of markers was tapped. The cluster itself carries no id, so the
/// app decides what to do from the camera position.
class ClusterTapEvent extends TapEvent {
  /// Name of the platform channel event this is decoded from.
  static const name = "onClusterTap";
}

/// A polygon added by the app was tapped.
class PolygonTapEvent extends TapEvent {
  /// Creates the event for the polygon with this [id].
  const PolygonTapEvent(this.id);

  /// Name of the platform channel event this is decoded from.
  static const name = "onPolygonTap";

  /// Identifier the app gave the polygon when adding it.
  final int id;
}

/// A polyline added by the app was tapped.
class PolylineTapEvent extends TapEvent {
  /// Creates the event for the polyline with this [id].
  const PolylineTapEvent(this.id);

  /// Name of the platform channel event this is decoded from.
  static const name = "onPolylineTap";

  /// Identifier the app gave the polyline when adding it.
  final int id;
}

/// A circle added by the app was tapped.
class CircleTapEvent extends TapEvent {
  /// Creates the event for the circle with this [id].
  const CircleTapEvent(this.id);

  /// Name of the platform channel event this is decoded from.
  static const name = "onCircleTap";

  /// Identifier the app gave the circle when adding it.
  final int id;
}

/// An object belonging to the map itself - a building, a POI - was tapped.
class ObjectTapEvent extends TapEvent {
  /// Creates the event for the object that was tapped.
  const ObjectTapEvent(this.dgisObjectId, this.latLng, this.levelId);

  /// Name of the platform channel event this is decoded from.
  static const name = "onObjectTap";

  /// Identifies the object in the map SDK's own catalogue.
  final DgisObjectId dgisObjectId;

  /// Indoor floor the object sits on, or null when it is outdoors.
  final int? levelId;

  /// Where the tap landed.
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

/// A road event - roadworks, a closure, an incident - was tapped.
class RoadEventTapEvent extends TapEvent {
  /// Creates the event from what the map knows about the road event.
  RoadEventTapEvent(this.id, this.title, this.description, this.startTime, this.finishTime, this.latLng);

  /// Name of the platform channel event this is decoded from.
  static const name = "onRoadEventTap";

  /// Identifies the road event in the map SDK's own catalogue.
  final DgisObjectId id;

  /// Short headline, e.g. the kind of works.
  final String title;

  /// Longer description of what is happening.
  final String description;

  /// When the event starts, when that is known.
  final DateTime? startTime;

  /// When the event is expected to end, when that is known.
  final DateTime? finishTime;

  /// Where the tap landed.
  final LatLng latLng;
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

  /// Name of the platform channel event this is decoded from.
  static const name = "onIoTap";

  /// Description of the investment opportunity.
  final String description;

  /// Plot area in square metres.
  final double area;

  /// Kind of opportunity being offered.
  final String type;

  /// Where the opportunity stands, e.g. whether it is still open.
  final String status;

  /// Asking price.
  final double price;

  /// Date the offer opens, as the layer formatted it.
  final String startDate;

  /// Date the offer closes, as the layer formatted it.
  final String endDate;

  /// Where the tap landed.
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

  /// Name of the platform channel event this is decoded from.
  static const name = "onIdleTap";

  /// What the land is zoned for.
  final String landuse;

  /// Description of the plot.
  final String description;

  /// Plot area in square metres.
  final double area;

  /// Name of the parcel in the cadastre.
  final String parcelName;

  /// Development phase the plot belongs to.
  final String phase;

  /// Date the record was created, as the layer formatted it.
  final String createdDate;

  /// Amana the plot falls under.
  final String amanaName;

  /// Municipality the plot falls under.
  final String munName;

  /// Where the tap landed.
  final LatLng latLng;

  /// 0 - no fence, 1 - fenced, -1 - unknown
  final String status;

  /// Street the plot fronts onto.
  final String streetName;

  /// Number of the subdivision plan the plot belongs to.
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
