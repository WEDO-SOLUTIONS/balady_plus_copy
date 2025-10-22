import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';

class RouteParamsPoint extends Equatable {
  final double latitude;
  final double longitude;
  final int? objectId;
  final int? entranceId;
  final int? levelId;

  const RouteParamsPoint({
    required this.latitude,
    required this.longitude,
    this.objectId,
    this.entranceId,
    this.levelId,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        objectId,
        entranceId,
        levelId,
      ];
}

extension RouteParamsPointListX on List<RouteParamsPoint?> {
  RouteParamsPointList? getIntermediatePoints() =>
      length > 2 ? RouteParamsPointList(sublist(1, length - 1).nonNulls.toList()) : null;
}

class RouteParamsPointList extends Equatable {
  final List<RouteParamsPoint> points;

  const RouteParamsPointList(this.points);

  @override
  List<Object?> get props => [points];
}

class RouteParamsPointWithLabel extends Equatable {
  final String label;
  final RouteParamsPoint? value;

  const RouteParamsPointWithLabel({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [
        label,
        value,
      ];
}

extension RouteParamsPointWithLabelListX on List<RouteParamsPointWithLabel?> {
  RouteParamsPointList? getIntermediatePoints() => map((e) => e?.value).toList().getIntermediatePoints();
}

extension GeoPoint on RouteParamsPoint {
  GeoPointMessage get geoPoint => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );

  DgisObjectIdMessage? get dgisObjectId =>
      objectId != null ? DgisObjectIdMessage(objectId: objectId!, entranceId: entranceId ?? 0) : null;

  RouteEditorRoutePointMessage get pointMessage => RouteEditorRoutePointMessage(
        point: geoPoint,
        objectId: dgisObjectId,
        levelId: levelId,
      );
}
