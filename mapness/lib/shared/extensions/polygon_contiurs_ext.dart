import 'package:dgis_map/library.dart';

extension PolygonGeometryMessageExt on PolygonGeometryMessage {
  List<GeoPointMessage> areaContour() {
    if (contours.isEmpty) {
      return [];
    }

    final List<GeoPointMessage> vertices = [];
    final firstContour = contours.first;
    if (firstContour != null && firstContour is List) {
      for (final vertex in firstContour) {
        if (vertex != null && vertex is GeoPointMessage) {
          vertices.add(vertex);
        } else {
          return [];
        }
      }
    }

    return vertices;
  }
}
