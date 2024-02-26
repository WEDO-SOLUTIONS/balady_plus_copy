import 'package:dgis_map/library.dart';

class RouteParamsPoint {

  RouteParamsPoint({
    required this.latitude,
    required this.longitude,
    this.objectId,
    this.entraceId,
  });
  final double latitude;
  final double longitude;
  final int? objectId;
  final int? entraceId;
}

extension GeoPoint on RouteParamsPoint {
  GeoPointMessage get geoPoint => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );
}
