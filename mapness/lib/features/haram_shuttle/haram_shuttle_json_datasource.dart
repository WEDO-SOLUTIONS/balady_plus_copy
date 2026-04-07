import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';

double _toDouble(dynamic val) {
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

/// Convert UTM Zone 37N (EPSG:32637) coordinates to WGS84 (lon, lat).
/// Returns [longitude, latitude].
List<double> _utmToWgs84(double easting, double northing) {
  const int zone = 37;

  // WGS84 ellipsoid constants
  const double a = 6378137.0; // semi-major axis
  const double e = 0.0818191908426; // eccentricity
  const double e2 = e * e;
  const double e1sq = e2 / (1 - e2); // e'^2

  const double k0 = 0.9996; // scale factor
  const double falseEasting = 500000.0;

  final double x = easting - falseEasting;
  // Makkah is in the northern hemisphere, so no false northing adjustment needed
  final double y = northing;

  final double m = y / k0;

  final double mu = m / (a * (1 - e2 / 4 - 3 * e2 * e2 / 64 - 5 * e2 * e2 * e2 / 256));

  final double e1 = (1 - sqrt(1 - e2)) / (1 + sqrt(1 - e2));

  final double phi1 =
      mu +
      (3 * e1 / 2 - 27 * e1 * e1 * e1 / 32) * sin(2 * mu) +
      (21 * e1 * e1 / 16 - 55 * e1 * e1 * e1 * e1 / 32) * sin(4 * mu) +
      (151 * e1 * e1 * e1 / 96) * sin(6 * mu) +
      (1097 * e1 * e1 * e1 * e1 / 512) * sin(8 * mu);

  final double sinPhi1 = sin(phi1);
  final double cosPhi1 = cos(phi1);
  final double tanPhi1 = tan(phi1);

  final double n1 = a / sqrt(1 - e2 * sinPhi1 * sinPhi1);
  final double t1 = tanPhi1 * tanPhi1;
  final double c1 = e1sq * cosPhi1 * cosPhi1;
  final double r1 = a * (1 - e2) / pow(1 - e2 * sinPhi1 * sinPhi1, 1.5);
  final double d = x / (n1 * k0);

  final double lat =
      phi1 -
      (n1 * tanPhi1 / r1) *
          (d * d / 2 -
              (5 + 3 * t1 + 10 * c1 - 4 * c1 * c1 - 9 * e1sq) * d * d * d * d / 24 +
              (61 + 90 * t1 + 298 * c1 + 45 * t1 * t1 - 252 * e1sq - 3 * c1 * c1) * d * d * d * d * d * d / 720);

  final double lon0 = ((zone - 1) * 6 - 180 + 3) * pi / 180; // central meridian

  final double lon =
      lon0 +
      (d -
              (1 + 2 * t1 + c1) * d * d * d / 6 +
              (5 - 2 * c1 + 28 * t1 - 3 * c1 * c1 + 8 * e1sq + 24 * t1 * t1) * d * d * d * d * d / 120) /
          cosPhi1;

  // Convert radians to degrees
  return [lon * 180 / pi, lat * 180 / pi];
}

/// Check if coordinates are in UTM (large values) vs WGS84 (small degree values).
bool _isUtmCoordinates(List<dynamic> rawCoords, String? geomType) {
  try {
    List<dynamic>? firstPoint;
    if (geomType == 'LineString' && rawCoords.isNotEmpty) {
      firstPoint = rawCoords[0] as List<dynamic>?;
    } else if (geomType == 'MultiLineString' && rawCoords.isNotEmpty) {
      final firstLine = rawCoords[0] as List<dynamic>?;
      if (firstLine != null && firstLine.isNotEmpty) {
        firstPoint = firstLine[0] as List<dynamic>?;
      }
    }
    if (firstPoint != null && firstPoint.length >= 2) {
      final x = _toDouble(firstPoint[0]);
      final y = _toDouble(firstPoint[1]);
      // UTM coordinates are typically > 100000, WGS84 lon/lat are < 360
      return x.abs() > 1000 || y.abs() > 1000;
    }
  } catch (_) {}
  return false;
}

/// Convert a raw coordinate point, applying UTM→WGS84 if needed.
List<double> _convertPoint(dynamic point, bool isUtm) {
  if (point is! List<dynamic> || point.length < 2) return [];
  final x = _toDouble(point[0]);
  final y = _toDouble(point[1]);
  if (isUtm) {
    return _utmToWgs84(x, y);
  }
  return [x, y]; // already [lon, lat]
}

// compute function to parse json
List<MakkahBusesModel> parseHaramShuttleJson(String jsonInput) {
  final List<MakkahBusesModel> result = [];
  try {
    // ESRI format: top-level object with features array
    final Map<String, dynamic> json = jsonDecode(jsonInput);
    final features = json['features'] as List<dynamic>? ?? [];

    for (final item in features) {
      if (item is! Map<String, dynamic>) continue;

      final attributes = item['properties'] as Map<String, dynamic>? ?? {};
      final geometry = item['geometry'] as Map<String, dynamic>? ?? {};

      final id = attributes['OBJECTID']?.toString();
      final nameArabic = attributes['Name_Arabic']?.toString();
      final nameEnglish = attributes['Name_English']?.toString();
      final colorCode = attributes['Color_Code']?.toString();

      final geomType = geometry['type'] as String?;
      final rawCoords = geometry['coordinates'] as List<dynamic>? ?? [];

      final isUtm = _isUtmCoordinates(rawCoords, geomType);

      if (geomType == 'MultiLineString') {
        int lineIndex = 0;
        for (final line in rawCoords) {
          if (line is! List<dynamic>) continue;
          final List<List<double>> lineCoordinates = [];
          for (final point in line) {
            final converted = _convertPoint(point, isUtm);
            if (converted.length == 2) {
              lineCoordinates.add(converted);
            }
          }
          if (lineCoordinates.isNotEmpty) {
            result.add(
              MakkahBusesModel(
                id: id != null ? '${id}_$lineIndex' : null,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                colorCode: colorCode,
                coordinates: lineCoordinates,
              ),
            );
            lineIndex++;
          }
        }
      } else if (geomType == 'LineString') {
        final List<List<double>> coordinates = [];
        for (final point in rawCoords) {
          final converted = _convertPoint(point, isUtm);
          if (converted.length == 2) {
            coordinates.add(converted);
          }
        }

        if (coordinates.isNotEmpty) {
          result.add(
            MakkahBusesModel(
              id: id,
              nameArabic: nameArabic,
              nameEnglish: nameEnglish,
              colorCode: colorCode,
              coordinates: coordinates,
            ),
          );
        }
      }
    }
  } catch (e) {
    debugPrint('Error parsing haram shuttle JSON: $e');
  }

  return result;
}

class HaramShuttleJsonDatasource {
  static const _assetPath = 'packages/mapness/assets/maps/makkah_buses/haram_shuttle.geojson';

  Future<List<MakkahBusesModel>> getHaramShuttleInfo() async {
    try {
      final jsonOutput = await rootBundle.loadString(_assetPath);
      final result = await compute(parseHaramShuttleJson, jsonOutput);
      return result;
    } catch (ex) {
      return [];
    }
  }
}
