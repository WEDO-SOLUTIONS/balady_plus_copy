enum VisibleRectEvents { visibleRectChanged }

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
}
