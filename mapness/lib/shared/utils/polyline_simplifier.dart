import 'dart:math';

/// Utilities for simplifying and smoothing polyline coordinate lists.
///
/// Coordinates are represented as `List<double>` where index 0 = longitude,
/// index 1 = latitude (GeoJSON convention).
class PolylineSimplifier {
  const PolylineSimplifier._();

  // ---------------------------------------------------------------------------
  // Douglas-Peucker simplification
  // ---------------------------------------------------------------------------

  /// Simplifies a polyline using the Ramer-Douglas-Peucker algorithm.
  ///
  /// [coordinates] – list of `[lng, lat]` points.
  /// [epsilon] – maximum perpendicular distance (in degrees) a point may
  ///   deviate from the simplified line before it is kept.
  ///   A good default for road-level data is ~0.00002 (~2 m).
  ///
  /// Returns a new list that is a subset of the original points.
  static List<List<double>> simplify(
    List<List<double>> coordinates, {
    double epsilon = 0.00002,
  }) {
    if (coordinates.length <= 2) return coordinates;

    // Find the point with the maximum distance from the line
    // formed by the first and last points.
    double maxDist = 0;
    int maxIndex = 0;

    final first = coordinates.first;
    final last = coordinates.last;

    for (int i = 1; i < coordinates.length - 1; i++) {
      final d = _perpendicularDistance(coordinates[i], first, last);
      if (d > maxDist) {
        maxDist = d;
        maxIndex = i;
      }
    }

    if (maxDist > epsilon) {
      // Recursively simplify both halves.
      final left = simplify(
        coordinates.sublist(0, maxIndex + 1),
        epsilon: epsilon,
      );
      final right = simplify(
        coordinates.sublist(maxIndex),
        epsilon: epsilon,
      );

      // Combine, removing the duplicate junction point.
      return [...left.sublist(0, left.length - 1), ...right];
    } else {
      // All intermediate points are within tolerance – keep only endpoints.
      return [first, last];
    }
  }

  /// Perpendicular distance from [point] to the line defined by
  /// [lineStart] and [lineEnd].  All values in degrees.
  static double _perpendicularDistance(
    List<double> point,
    List<double> lineStart,
    List<double> lineEnd,
  ) {
    final dx = lineEnd[0] - lineStart[0];
    final dy = lineEnd[1] - lineStart[1];

    if (dx == 0 && dy == 0) {
      // lineStart == lineEnd – just return the Euclidean distance.
      return sqrt(
        pow(point[0] - lineStart[0], 2) + pow(point[1] - lineStart[1], 2),
      );
    }

    final t = ((point[0] - lineStart[0]) * dx + (point[1] - lineStart[1]) * dy) /
        (dx * dx + dy * dy);
    final tClamped = t.clamp(0.0, 1.0);

    final projX = lineStart[0] + tClamped * dx;
    final projY = lineStart[1] + tClamped * dy;

    return sqrt(pow(point[0] - projX, 2) + pow(point[1] - projY, 2));
  }

  // ---------------------------------------------------------------------------
  // Catmull-Rom spline interpolation (optional smoothing)
  // ---------------------------------------------------------------------------

  /// Smooths a polyline by inserting additional points via Catmull-Rom
  /// spline interpolation between each pair of original control points.
  ///
  /// [coordinates] – list of `[lng, lat]` points.
  /// [segmentsPerPair] – how many interpolated points to add between each
  ///   pair of original points (default 4).
  /// [tension] – Catmull-Rom tension parameter; 0.5 is the standard centripetal
  ///   variant which avoids cusps.
  ///
  /// Use this **after** simplification when the remaining segments still look
  /// angular (e.g. after aggressive Douglas-Peucker).
  static List<List<double>> smooth(
    List<List<double>> coordinates, {
    int segmentsPerPair = 4,
    double tension = 0.5,
  }) {
    if (coordinates.length < 3) return coordinates;

    final result = <List<double>>[];

    for (int i = 0; i < coordinates.length - 1; i++) {
      final p0 = coordinates[max(i - 1, 0)];
      final p1 = coordinates[i];
      final p2 = coordinates[min(i + 1, coordinates.length - 1)];
      final p3 = coordinates[min(i + 2, coordinates.length - 1)];

      result.add(p1);

      for (int j = 1; j < segmentsPerPair; j++) {
        final t = j / segmentsPerPair;
        final lng = _catmullRom(p0[0], p1[0], p2[0], p3[0], t, tension);
        final lat = _catmullRom(p0[1], p1[1], p2[1], p3[1], t, tension);
        result.add([lng, lat]);
      }
    }

    result.add(coordinates.last);
    return result;
  }

  static double _catmullRom(
    double v0,
    double v1,
    double v2,
    double v3,
    double t,
    double tension,
  ) {
    final t2 = t * t;
    final t3 = t2 * t;

    final a = -tension * v0 + (2 - tension) * v1 + (tension - 2) * v2 + tension * v3;
    final b = 2 * tension * v0 + (tension - 3) * v1 + (3 - 2 * tension) * v2 - tension * v3;
    final c = -tension * v0 + tension * v2;
    final d = v1;

    return a * t3 + b * t2 + c * t + d;
  }
}
