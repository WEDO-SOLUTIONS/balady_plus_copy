import 'dart:math';

import 'package:dgis_map_platform_interface/library.dart';

/// Camera events the map can report about what is on screen.
enum VisibleRectEvents {
  /// The rectangle the map is showing changed.
  visibleRectChanged,

  /// The camera position changed without necessarily changing the rectangle.
  cameraPositionChanged,
}

/// Reports the new rectangle the map is showing.
class VisibleRectEvent {
  /// Creates the event for the area now on screen.
  const VisibleRectEvent(this.visibleRect);

  /// Name of the platform channel event this is decoded from.
  static const name = 'visibleRectChanged';

  /// The area the map is showing.
  final VisibleRect visibleRect;
}

/// The geographic rectangle the map is showing, plus the zoom it is showing
/// it at.
class VisibleRect {
  /// Creates the rectangle from its two opposite corners and the [zoom].
  const VisibleRect({
    required this.northEastLat,
    required this.northEastLon,
    required this.southWestLat,
    required this.southWestLon,
    required this.zoom,
  });

  /// Latitude of the north-east corner.
  final double northEastLat;

  /// Longitude of the north-east corner.
  final double northEastLon;

  /// Latitude of the south-west corner.
  final double southWestLat;

  /// Longitude of the south-west corner.
  final double southWestLon;

  /// Zoom level the rectangle was measured at.
  final double zoom;

  @override
  String toString() {
    return "North-East - $northEastLat : $northEastLon, South-West - $southWestLat : $southWestLon, Zoom - $zoom";
  }

  /// The same rectangle in the shape the platform channel expects.
  GeoRectMessage geoRectMessage() {
    return GeoRectMessage(
      northEast: GeoPointMessage(latitude: northEastLat, longitude: northEastLon),
      southWest: GeoPointMessage(latitude: southWestLat, longitude: southWestLon),
    );
  }

  /// The point halfway between the two corners.
  GeoPointMessage center() {
    return GeoPointMessage(latitude: (northEastLat + southWestLat) / 2, longitude: (northEastLon + southWestLon) / 2);
  }

  // Need to refactor to use sdk GeoPoint.distance
  /// Great-circle distance between two points, in metres.
  double distanceMeters({required GeoPointMessage point1, required GeoPointMessage point2}) {
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

  /// Distance in metres from the centre to the north-west corner, i.e. half
  /// the diagonal of the visible area.
  double distanceToNW() => distanceMeters(
    point1: this.center(),
    point2: GeoPointMessage(latitude: northEastLat, longitude: southWestLon),
  );
}
