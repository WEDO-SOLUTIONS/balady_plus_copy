import 'package:dgis_map/library.dart';

extension PolygonGeometryMessageExt on PolygonGeometryMessage {
  /// Returns the area contour of the polygon. Area must be 4 points rectangle.
  /// Here we do not check that this is a rectangle but the result list must contain 4 points.
  /// If the result is empty, then the polygon is not a quadrilateral.
  List<GeoPointMessage> areaContour() {
    if (contours.isEmpty) {
      return [];
    }

    final List<GeoPointMessage> vertices = [];

    // We take only first contour because the SDK should return only one contour of the visible area
    // and we are interested in the first one.
    final firstContour = contours.firstOrNull;
    if (firstContour != null && firstContour is List) {
      for (final vertex in firstContour) {
        if (vertex != null && vertex is GeoPointMessage) {
          vertices.add(vertex);
        } else {
          // If one of the vertices is null, then the polygon is not a quadrilateral.
          return [];
        }
      }
    }

    return vertices;
  }
}
