import 'package:dgis_map/library.dart';

class RouteParamsPoint {
  RouteParamsPoint({
    required this.latitude,
    required this.longitude,
    this.objectId,
    this.entraceId,
    this.levelId,
  });
  final double latitude;
  final double longitude;
  final int? objectId;
  final int? entraceId;
  final int? levelId;
}

extension GeoPoint on RouteParamsPoint {
  GeoPointMessage get geoPoint => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );

  DgisObjectIdMessage? get dgisObjectId => objectId != null
      ? DgisObjectIdMessage(objectId: objectId!, entranceId: entraceId ?? 0)
      : null;

  RouteEditorRoutePointMessage get pointMessage => RouteEditorRoutePointMessage(
        point: geoPoint,
        objectId: dgisObjectId,
        levelId: levelId,
      );
}
