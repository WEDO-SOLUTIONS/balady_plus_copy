import 'dart:math';

import 'package:dgis_map_platform_interface/library.dart';

enum VisibleRectEvents { visibleRectChanged, cameraPositionChanged }

class VisibleRectEvent {
  const VisibleRectEvent(this.visibleRect);

  static const name = 'visibleRectChanged';

  final VisibleRect visibleRect;
}

class VisibleRect {
  const VisibleRect({
    required this.northEastLat,
    required this.northEastLon,
    required this.southWestLat,
    required this.southWestLon,
    required this.zoom,
  });

  final double northEastLat;
  final double northEastLon;
  final double southWestLat;
  final double southWestLon;
  final double zoom;

  @override
  String toString() {
    return "North-East - $northEastLat : $northEastLon, South-West - $southWestLat : $southWestLon, Zoom - $zoom";
  }

  GeoRectMessage geoRectMessage() {
    return GeoRectMessage(
      northEast: GeoPointMessage(
        latitude: northEastLat,
        longitude: northEastLon,
      ),
      southWest: GeoPointMessage(
        latitude: southWestLat,
        longitude: southWestLon,
      ),
    );
  }

  GeoPointMessage center() {
    return GeoPointMessage(
      latitude: (northEastLat + southWestLat) / 2,
      longitude: (northEastLon + southWestLon) / 2,
    );
  }

  // Need to refactor to use sdk GeoPoint.distance
  double distanceMeters({
    required GeoPointMessage point1,
    required GeoPointMessage point2,
  }) {
    const R = 6371000; // radius of Earth in meters
    final phi1 = point1.latitude * pi / 180;
    final phi2 = point2.latitude * pi / 180;
    final deltaPhi = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLambda = (point2.longitude - point1.longitude) * pi / 180;

    final a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // distance in meters
  }

  double distanceToNW() => distanceMeters(
        point1: this.center(),
        point2: GeoPointMessage(
          latitude: northEastLat,
          longitude: southWestLon,
        ),
      );
}
