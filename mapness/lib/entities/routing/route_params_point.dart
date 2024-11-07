import 'package:dgis_map/library.dart';

class RouteParamsPoint {
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
}

class RouteParamsPointWithLabel {
  final String label;
  final RouteParamsPoint? value;

  const RouteParamsPointWithLabel({
    required this.value,
    required this.label,
  });
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
