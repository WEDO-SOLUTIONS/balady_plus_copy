import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:proj4dart/proj4dart.dart';

double _toDouble(val) {
  if (val is num) {
    return val.toDouble();
  }
  if (val is String) {
    return double.tryParse(val) ?? 0.0;
  }
  return 0.0;
}

final _wgs84 = Projection.get('EPSG:4326')!;

final Map<int, Projection> _utmCache = {};

Projection getUtmProjection(int zone) => _utmCache.putIfAbsent(
  zone,
  () {
    final key = 'EPSG:326$zone';
    Projection.add(
      key,
      '+proj=utm +zone=$zone +datum=WGS84 +units=m +no_defs +type=crs',
    );
    return Projection.get(key)!;
  },
);

List<double> _utmToWgs84(double easting, double northing, {int zone = 37}) {
  final result = getUtmProjection(zone).transform(
    _wgs84,
    Point(x: easting, y: northing),
  );
  return [result.x, result.y];
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
      return x.abs() > 1000 || y.abs() > 1000;
    }
  } catch (_) {}
  return false;
}

/// Convert a raw coordinate point, applying UTM→WGS84 if needed.
List<double> _convertPoint(point, bool isUtm) {
  if (point is! List<dynamic> || point.length < 2) {
    return [];
  }
  final x = _toDouble(point[0]);
  final y = _toDouble(point[1]);
  if (isUtm) {
    return _utmToWgs84(x, y);
  }
  return [x, y];
}

List<MakkahBusModel> _parseJson(String jsonInput) {
  final List<MakkahBusModel> result = [];
  try {
    final Map<String, dynamic> json = jsonDecode(jsonInput);
    final features = json['features'] as List<dynamic>? ?? [];

    for (final item in features) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

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
          if (line is! List<dynamic>) {
            continue;
          }
          final List<List<double>> lineCoordinates = [];
          for (final point in line) {
            final converted = _convertPoint(point, isUtm);
            if (converted.length == 2) {
              lineCoordinates.add(converted);
            }
          }
          if (lineCoordinates.isNotEmpty) {
            result.add(
              MakkahBusModel(
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
            MakkahBusModel(
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

class ShuttleBusJsonDatasource {
  static const _assetPath = 'packages/mapness/assets/maps/buses/shuttle_bus.geojson';

  Future<List<MakkahBusModel>> getInfo() async {
    try {
      final jsonOutput = await rootBundle.loadString(_assetPath);
      final result = await compute(_parseJson, jsonOutput);
      return result;
    } catch (ex) {
      return [];
    }
  }
}
