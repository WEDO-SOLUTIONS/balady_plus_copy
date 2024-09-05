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
  static CustomRect fromArea({
    required List<GeoPointMessage?> area,
    required GeoPointMessage center,
    required double bearing,
  }) {
    final OA = algebra.Vector2(
      area[0]!.latitude - center.latitude,
      area[0]!.longitude - center.longitude,
    );
    final OB = algebra.Vector2(
      area[1]!.latitude - center.latitude,
      area[1]!.longitude - center.longitude,
    );
    final OC = algebra.Vector2(
      area[2]!.latitude - center.latitude,
      area[2]!.longitude - center.longitude,
    );
    final OD = algebra.Vector2(
      area[3]!.latitude - center.latitude,
      area[3]!.longitude - center.longitude,
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
    final Acorner = (bearingToTop.cross(OA).sign < 0, bearingToRight.cross(OA).sign < 0);
    final Bcorner = (bearingToTop.cross(OB).sign < 0, bearingToRight.cross(OB).sign < 0);
    final Ccorner = (bearingToTop.cross(OC).sign < 0, bearingToRight.cross(OC).sign < 0);
    final Dcorner = (bearingToTop.cross(OD).sign < 0, bearingToRight.cross(OD).sign < 0);
    final corncers = [Acorner, Bcorner, Ccorner, Dcorner];

    GeoPointMessage? topLeft;
    GeoPointMessage? topRight;
    GeoPointMessage? bottomLeft;
    GeoPointMessage? bottomRight;

    for (var i = 0; i < corncers.length; i++) {
      final corner = corncers[i];
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
