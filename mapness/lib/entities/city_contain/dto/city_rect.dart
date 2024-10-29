import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';

extension CityRectExt on CityRect {
  GeoRectMessage toGeoRectMessage() => GeoRectMessage(
        northEast: northEast.toGeoPointMessage(),
        southWest: southWest.toGeoPointMessage(),
      );
}

@immutable
class CityRect {
  final LocationPoint northEast;
  final LocationPoint southWest;

  const CityRect({
    required this.northEast,
    required this.southWest,
  });

  @override
  String toString() => 'North-East - $northEast, South-West - $southWest';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CityRect && other.northEast == northEast && other.southWest == southWest;
  }

  @override
  int get hashCode => northEast.hashCode ^ southWest.hashCode;
}
