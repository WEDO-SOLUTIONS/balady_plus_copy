import 'dart:developer';
import 'dart:math' as math;

import 'package:dgis_map/library.dart';
import 'package:vector_math/vector_math.dart' as algebra;

/// Custom rectangle with named points.
/// The main idea is to have a rectangle with named points to make the code more readable.
class CustomRect {
  final GeoPointMessage topLeft;
  final GeoPointMessage topRight;
  final GeoPointMessage bottomLeft;
  final GeoPointMessage bottomRight;

  const CustomRect({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  CustomRect copyWith({
    GeoPointMessage? topLeft,
    GeoPointMessage? topRight,
    GeoPointMessage? bottomLeft,
    GeoPointMessage? bottomRight,
  }) =>
      CustomRect(
        topLeft: topLeft ?? this.topLeft,
        topRight: topRight ?? this.topRight,
        bottomLeft: bottomLeft ?? this.bottomLeft,
        bottomRight: bottomRight ?? this.bottomRight,
      );

  /// With different bearings we have different points, so we need to set the orientation of the
  /// rectangle from points. The main idea is to set basis vectors in the directions of bearing and perpendicular to ir.
  /// So if the point in the left top quarter => this is topLeft point and etc.
  // ignore: prefer_constructors_over_static_methods
  static CustomRect? fromArea({
    required List<GeoPointMessage> area,
    required GeoPointMessage center,
    required double bearing,
  }) {
    if (area.length != 4) {
      log('Area must contain 4 points');
      return null;
    }

    // 1. Calculate the vectors from the center to the area points
    final oa = algebra.Vector2(
      area[0].latitude - center.latitude,
      area[0].longitude - center.longitude,
    );
    final ob = algebra.Vector2(
      area[1].latitude - center.latitude,
      area[1].longitude - center.longitude,
    );
    final oc = algebra.Vector2(
      area[2].latitude - center.latitude,
      area[2].longitude - center.longitude,
    );
    final od = algebra.Vector2(
      area[3].latitude - center.latitude,
      area[3].longitude - center.longitude,
    );

    // 2. Calculate the basis vectors
    final rad = math.pi / 180 * bearing;
    // Vector to the top side of the rectangle (aka Oy)
    final bearingToTop = algebra.Vector2(
      -math.sin(rad),
      math.cos(rad),
    );
    // Vector to the right side of the rectangle (aka Ox)
    final bearingToRight = algebra.Vector2(
      math.cos(rad),
      math.sin(rad),
    );

    // 3. Calculate the signs of the cross product of the vectors to determine the quarter
    // First part of the record is the "is above the Ox" (top/bottom quarter),
    // the second part is "is on the left of the Oy" (the right/left quarter)
    final aCorner = (bearingToTop.cross(oa).sign < 0, bearingToRight.cross(oa).sign < 0);
    final bCorner = (bearingToTop.cross(ob).sign < 0, bearingToRight.cross(ob).sign < 0);
    final cCorner = (bearingToTop.cross(oc).sign < 0, bearingToRight.cross(oc).sign < 0);
    final dCorner = (bearingToTop.cross(od).sign < 0, bearingToRight.cross(od).sign < 0);
    final corners = [aCorner, bCorner, cCorner, dCorner];

    // 4. Find the points of the rectangle with human-readable and space-oriented names
    GeoPointMessage? topLeft;
    GeoPointMessage? topRight;
    GeoPointMessage? bottomLeft;
    GeoPointMessage? bottomRight;

    for (var i = 0; i < corners.length; i++) {
      final corner = corners[i];
      if (corner == (true, true)) {
        topLeft = area[i];
      }
      if (corner == (true, false)) {
        topRight = area[i];
      }
      if (corner == (false, false)) {
        bottomRight = area[i];
      }
      if (corner == (false, true)) {
        bottomLeft = area[i];
      }
    }

    // If one of the points is null, then the center is not in the center of the rectangle.
    // Therefor the calculation does not have any sense.
    if (topLeft == null || topRight == null || bottomRight == null || bottomLeft == null) {
      log('One of the area points is null. Please check the data from SDK');
      return null;
    }

    return CustomRect(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );
  }
}
