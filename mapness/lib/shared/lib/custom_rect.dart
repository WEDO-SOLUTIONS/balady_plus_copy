import 'dart:developer';
import 'dart:math' as math;

import 'package:dgis_map/library.dart';
import 'package:vector_math/vector_math.dart' as algebra;

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
    required List<GeoPointMessage?> area,
    required GeoPointMessage center,
    required double bearing,
  }) {
    final areaFirst = area[0];
    final areaSecond = area[1];
    final areaThird = area[2];
    final areaFourth = area[3];
    if (areaFirst == null || areaSecond == null || areaThird == null || areaFourth == null) {
      log('One of the area points is null. Please check the data from SDK');
      return null;
    }
    final oa = algebra.Vector2(
      areaFirst.latitude - center.latitude,
      areaFirst.longitude - center.longitude,
    );
    final ob = algebra.Vector2(
      areaSecond.latitude - center.latitude,
      areaSecond.longitude - center.longitude,
    );
    final oc = algebra.Vector2(
      areaThird.latitude - center.latitude,
      areaThird.longitude - center.longitude,
    );
    final od = algebra.Vector2(
      areaFourth.latitude - center.latitude,
      areaFourth.longitude - center.longitude,
    );
    final rad = math.pi / 180 * bearing;
    // Vector to the top side of the rectangle
    final bearingToTop = algebra.Vector2(
      -math.sin(rad),
      math.cos(rad),
    );
    // Vector to the right side of the rectangle
    final bearingToRight = algebra.Vector2(
      math.cos(rad),
      math.sin(rad),
    );

    // Corner sign after cross with
    final aCorner = (bearingToTop.cross(oa).sign < 0, bearingToRight.cross(oa).sign < 0);
    final bCorner = (bearingToTop.cross(ob).sign < 0, bearingToRight.cross(ob).sign < 0);
    final cCorner = (bearingToTop.cross(oc).sign < 0, bearingToRight.cross(oc).sign < 0);
    final dCorner = (bearingToTop.cross(od).sign < 0, bearingToRight.cross(od).sign < 0);
    final corners = [aCorner, bCorner, cCorner, dCorner];

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

    return CustomRect(
      topLeft: topLeft!,
      topRight: topRight!,
      bottomRight: bottomRight!,
      bottomLeft: bottomLeft!,
    );
  }
}
