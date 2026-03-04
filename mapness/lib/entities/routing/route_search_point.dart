import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

@immutable
class RouteSearchPoint {
  final GeoPointMessage coordinates;
  final BearingMessage? course;
  final DgisObjectIdMessage dgisObjectId;
  final LevelIdMessage? levelId;

  const RouteSearchPoint({
    required this.coordinates,
    required this.dgisObjectId,
    this.course,
    this.levelId,
  });

  @override
  int get hashCode => Object.hash(
        dgisObjectId.objectId,
        coordinates.latitude,
        coordinates.longitude,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is RouteSearchPoint &&
        other.dgisObjectId.objectId == dgisObjectId.objectId &&
        other.coordinates.latitude == coordinates.latitude &&
        other.coordinates.longitude == coordinates.longitude;
  }
}
