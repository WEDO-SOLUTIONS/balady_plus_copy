import 'package:dgis_map/library.dart';

extension GeopointMapper on GeoPointWithElevationMessage {
  GeoPointMessage toGeoPointMessage() => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );
}

extension GeopointWithElevation on GeoPointMessage {
  GeoPointWithElevationMessage withElevation(double elevation) => GeoPointWithElevationMessage(
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
      );
}
