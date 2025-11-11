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
}
