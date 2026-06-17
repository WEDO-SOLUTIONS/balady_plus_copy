import 'dart:convert';

import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Geometry-type axis: a feature is either rendered as a marker (Point) or
/// as a polygon outline (Polygon / MultiPolygon).
enum DynamicPoiGeometryType { marker, polygon }

/// One zoom window: feature is visible iff `minZoom <= zoom <= maxZoom`.
class DynamicPoiZoomWindow {
  const DynamicPoiZoomWindow({required this.minZoom, required this.maxZoom});

  final int minZoom;
  final int maxZoom;

  bool contains(double zoom) => zoom >= minZoom && zoom <= maxZoom;

  @override
  String toString() => '[$minZoom..$maxZoom]';
}

/// Two-axis visibility table:
///   - geometry-type window (marker vs polygon — coarse remote-configurable
///     zoom bands)
///   - per-`object_type` lower bound (kept from iter3 for finer control:
///     branch/gate appear only at high zoom even within the marker window)
///
/// A feature is visible at zoom Z iff:
///   `geometryWindow.contains(Z) && Z >= objectTypeMinZoom`
class DynamicPoiVisibility {
  const DynamicPoiVisibility({required this.markerWindow, required this.polygonWindow});

  final DynamicPoiZoomWindow markerWindow;
  final DynamicPoiZoomWindow polygonWindow;

  /// Hardcoded fallback if the remote-config key is missing or malformed.
  /// Numbers from iter4 task spec: markers 13..22, polygons 10..18.
  static const fallback = DynamicPoiVisibility(
    markerWindow: DynamicPoiZoomWindow(minZoom: 13, maxZoom: 22),
    polygonWindow: DynamicPoiZoomWindow(minZoom: 10, maxZoom: 18),
  );

  DynamicPoiZoomWindow windowFor(DynamicPoiGeometryType type) =>
      type == DynamicPoiGeometryType.polygon ? polygonWindow : markerWindow;

  /// Per-`object_type` lower bound (iter3 spec, kept for finer control).
  /// `adm_div` is treated like `settlement` (it's the same kind of broad
  /// administrative polygon — the OpenAPI enum is incomplete).
  static int objectTypeMinZoom(String objectType) {
    switch (objectType) {
      case 'settlement':
      case 'adm_div':
        return 10;
      case 'attraction':
        return 13;
      case 'parking':
        return 15;
      case 'branch':
      case 'gate':
        return 16;
      default:
        return 10;
    }
  }

  /// Combined visibility check for one feature at one zoom level.
  bool isVisible({
    required DynamicPoiGeometryType geometry,
    required String objectType,
    required double zoom,
  }) {
    if (!windowFor(geometry).contains(zoom)) {
      return false;
    }
    return zoom >= objectTypeMinZoom(objectType);
  }

  /// Buckets continuous zoom into a small set of integers so that camera
  /// updates that don't cross any threshold can short-circuit.
  ///
  /// Threshold sources:
  ///   - both windows' min/max zooms
  ///   - all `objectTypeMinZoom` values
  /// Bucket = greatest threshold not exceeding `zoom`. Two zooms with the
  /// same bucket cannot have any feature change visibility.
  int bucketOf(double zoom) {
    // Collect every threshold edge.
    final edges = <int>{
      0,
      markerWindow.minZoom,
      markerWindow.maxZoom + 1, // crossing maxZoom hides; +1 = first hidden bucket
      polygonWindow.minZoom,
      polygonWindow.maxZoom + 1,
      10, // settlement / adm_div / unknown
      13, // attraction
      15, // parking
      16, // branch / gate
    };
    var picked = 0;
    for (final e in edges) {
      if (e <= zoom && e > picked) {
        picked = e;
      }
    }
    return picked;
  }

  /// Loads visibility config from Firebase Remote Config; falls back to
  /// [fallback] on missing/empty/malformed payload. Logs every step so the
  /// fallback path is visible without breakpoints.
  static Future<DynamicPoiVisibility> load() async {
    final raw = await AppConfigLoader.getDynamicPoiVisibility();
    if (raw == null || raw.trim().isEmpty) {
      logger.log(
        'dynamic_poi:visibility config missing — falling back to '
        '$fallback',
        logLevel: MapnessLogLevel.info,
      );
      return fallback;
    }
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException('top-level not an object');
      }
      final marker = _windowFromJson(json['marker']) ?? fallback.markerWindow;
      final polygon = _windowFromJson(json['polygon']) ?? fallback.polygonWindow;
      final result = DynamicPoiVisibility(markerWindow: marker, polygonWindow: polygon);
      logger.log(
        'dynamic_poi:visibility config loaded marker=$marker polygon=$polygon',
        logLevel: MapnessLogLevel.info,
      );
      return result;
    } catch (e) {
      logger.log(
        'dynamic_poi:visibility config parse failed ($e) — falling back to $fallback',
        logLevel: MapnessLogLevel.warning,
      );
      return fallback;
    }
  }

  static DynamicPoiZoomWindow? _windowFromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }
    final min = (raw['min_zoom'] as num?)?.toInt();
    final max = (raw['max_zoom'] as num?)?.toInt();
    if (min == null || max == null || min > max) {
      return null;
    }
    return DynamicPoiZoomWindow(minZoom: min, maxZoom: max);
  }

  @override
  String toString() => 'DynamicPoiVisibility(marker=$markerWindow, polygon=$polygonWindow)';
}
