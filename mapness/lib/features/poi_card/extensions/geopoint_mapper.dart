import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/double_ext.dart';

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

  /// Returns true if the coordinates of [this] and [point] are close enough. The points are considered close if their
  /// coordinates are equal up to 4 decimal places which corresponds to max distance of 11.112 meters between them
  bool isNearPoint(GeoPointMessage point, {int decimalPlaces = 4}) =>
      latitude.isRoughlyEqual(point.latitude, decimalPlaces: decimalPlaces) &&
      longitude.isRoughlyEqual(
        point.longitude,
        decimalPlaces: decimalPlaces,
      );
}
