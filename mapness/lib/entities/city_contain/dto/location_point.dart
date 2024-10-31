import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';

extension LocationPointExt on LocationPoint {
  GeoPointMessage toGeoPointMessage() => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );
}

@immutable
class LocationPoint {
  final double latitude;
  final double longitude;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => 'Latitude - $latitude, Longitude - $longitude';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LocationPoint && other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
