class ZoneItem {
  final String? guid;
  final Polygon? polygon;

  ZoneItem({
    this.guid,
    this.polygon,
  });
}

class Polygon {
  final List<List<List<double>>>? rings;

  Polygon({
    this.rings,
  });
}
