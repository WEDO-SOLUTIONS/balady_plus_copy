import 'dart:developer';

import 'package:dgis_map/library.dart';

extension PolygonGeometryMessageExt on PolygonGeometryMessage {
  List<GeoPointMessage> areaContour() {
    final List<GeoPointMessage> points = [];
    if (contours.isNotEmpty) {
      if (contours.first != null && contours.first is List) {
        final p = contours.first! as List;
        try {
          for (final v in p) {
            if (v != null) {
              points.add(v as GeoPointMessage);
            }
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
    return points;
  }
}
