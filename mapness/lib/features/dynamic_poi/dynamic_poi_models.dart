import 'package:dgis_map/library.dart';

/// Domain model for a single dynamic POI feature returned by
/// `/1.0/dynamic-markers`.
///
/// Carries enough info to render a marker (always) and optionally a polygon
/// outline (for `Polygon`/`MultiPolygon` geometries). The tap anchor is
/// resolved as: explicit `properties.centroid` → polygon vertex average →
/// raw point geometry. Features without any usable anchor are dropped.
///
/// `id` is a string in the API but represents an integer DgisObjectId
/// (Momrah-injected — not a real 2GIS object id; SDK may or may not resolve).
class DynamicPoi {
  const DynamicPoi({
    required this.id,
    required this.objectId,
    required this.name,
    required this.objectType,
    required this.regionId,
    required this.rubricIds,
    required this.lat,
    required this.lon,
    this.polygonContours,
  });

  final String id;
  final int objectId;
  final String? name;
  final String objectType;
  final String regionId;

  /// Rubric IDs returned by the API. Empty list when none provided.
  final List<String> rubricIds;

  /// Anchor point used for marker placement and label positioning.
  /// For polygons, this is the centroid (server-provided or computed).
  final double lat;
  final double lon;

  /// Outer rings (one per polygon) when geometry is `Polygon` or
  /// `MultiPolygon`. `null` for `Point` geometries. Each inner list is the
  /// ring's vertices in `[lon, lat]` order, ready to feed into
  /// `PolylineGeometryMessage(points:)`.
  final List<List<GeoPointMessage>>? polygonContours;

  bool get hasPolygon => polygonContours != null && polygonContours!.isNotEmpty;

  /// Returns null when neither an anchor nor a polygon could be resolved.
  static DynamicPoi? fromGeoJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) {
      return null;
    }

    final objectId = int.tryParse(id);
    if (objectId == null) {
      return null;
    }

    final props = json['properties'];
    if (props is! Map<String, dynamic>) {
      return null;
    }

    final geometry = json['geometry'];
    final contours = _extractContours(geometry);

    final anchor =
        _pointFromObject(props['centroid']) ??
        _pointFromObject(geometry) ??
        _centroidFromContours(contours);
    if (anchor == null) {
      return null;
    }

    final regionId = props['region_id'];
    final objectType = props['object_type'];
    final rubricIdsRaw = props['rubric_id'];
    final rubricIds = rubricIdsRaw is List
        ? rubricIdsRaw.whereType<String>().toList(growable: false)
        : const <String>[];

    return DynamicPoi(
      id: id,
      objectId: objectId,
      name: props['name'] is String ? props['name'] as String : null,
      objectType: objectType is String ? objectType : 'unknown',
      regionId: regionId is String ? regionId : '',
      rubricIds: rubricIds,
      lat: anchor.$2,
      lon: anchor.$1,
      polygonContours: contours,
    );
  }

  /// Extracts a list of outer rings as `GeoPointMessage` lists.
  /// Returns null for non-polygon or malformed geometries.
  static List<List<GeoPointMessage>>? _extractContours(Object? geometry) {
    if (geometry is! Map<String, dynamic>) {
      return null;
    }
    final type = geometry['type'];
    final coords = geometry['coordinates'];
    if (coords is! List) {
      return null;
    }

    final result = <List<GeoPointMessage>>[];
    if (type == 'Polygon') {
      final outer = coords.isNotEmpty ? coords.first : null;
      final ring = _ringFromObject(outer);
      if (ring != null) {
        result.add(ring);
      }
    } else if (type == 'MultiPolygon') {
      for (final poly in coords) {
        if (poly is! List || poly.isEmpty) {
          continue;
        }
        final ring = _ringFromObject(poly.first);
        if (ring != null) {
          result.add(ring);
        }
      }
    } else {
      return null;
    }
    return result.isEmpty ? null : result;
  }

  static List<GeoPointMessage>? _ringFromObject(Object? obj) {
    if (obj is! List || obj.length < 3) {
      return null;
    }
    final pts = <GeoPointMessage>[];
    for (final raw in obj) {
      if (raw is! List || raw.length < 2) {
        continue;
      }
      final lon = (raw[0] as num?)?.toDouble();
      final lat = (raw[1] as num?)?.toDouble();
      if (lon == null || lat == null) {
        continue;
      }
      pts.add(GeoPointMessage(latitude: lat, longitude: lon));
    }
    return pts.length >= 3 ? pts : null;
  }

  /// Returns `(lon, lat)` per GeoJSON convention, or null.
  static (double, double)? _pointFromObject(Object? obj) {
    if (obj is! Map<String, dynamic>) {
      return null;
    }
    if (obj['type'] != 'Point') {
      return null;
    }
    final coords = obj['coordinates'];
    if (coords is! List || coords.length < 2) {
      return null;
    }
    final lon = (coords[0] as num?)?.toDouble();
    final lat = (coords[1] as num?)?.toDouble();
    if (lon == null || lat == null) {
      return null;
    }
    return (lon, lat);
  }

  /// Average of the first ring's vertices — a cheap fallback centroid when
  /// the API doesn't supply one. Good enough for label placement.
  static (double, double)? _centroidFromContours(List<List<GeoPointMessage>>? contours) {
    if (contours == null || contours.isEmpty) {
      return null;
    }
    final ring = contours.first;
    if (ring.isEmpty) {
      return null;
    }
    var sumLon = 0.0;
    var sumLat = 0.0;
    for (final pt in ring) {
      sumLon += pt.longitude;
      sumLat += pt.latitude;
    }
    return (sumLon / ring.length, sumLat / ring.length);
  }
}
