import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/shared/utils/polyline_simplifier.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

double _toDouble(dynamic val) {
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

// compute function to parse json
List<MakkahBusModel> _parse(String jsonInput) {
  final List<MakkahBusModel> result = [];
  try {
    // ESRI format: top-level object with features array
    final Map<String, dynamic> json = jsonDecode(jsonInput);
    final features = json['features'] as List<dynamic>? ?? [];

    for (final item in features) {
      if (item is! Map<String, dynamic>) continue;

      final attributes = item['properties'] as Map<String, dynamic>? ?? {};
      final geometry = item['geometry'] as Map<String, dynamic>? ?? {};

      final id = attributes['OBJECTID']?.toString();
      final nameArabic = attributes['Name Arabic']?.toString();
      final nameEnglish = attributes['Name English']?.toString();
      final colorCode = attributes['Color Code']?.toString();

      final geomType = geometry['type'] as String?;
      final rawCoords = geometry['coordinates'] as List<dynamic>? ?? [];

      if (geomType == 'MultiLineString') {
        int lineIndex = 0;
        for (final line in rawCoords) {
          if (line is! List<dynamic>) continue;
          final List<List<double>> lineCoordinates = [];
          for (final point in line) {
            if (point is List<dynamic> && point.length >= 2) {
              lineCoordinates.add([_toDouble(point[0]), _toDouble(point[1])]);
            }
          }
          if (lineCoordinates.isNotEmpty) {
            // Simplify to reduce excessive point density from ESRI export.
            // epsilon ~0.00002 deg ≈ 2 m — removes sub-pixel zigzag artifacts
            // while keeping the route visually accurate.
            final simplified = PolylineSimplifier.simplify(
              lineCoordinates,
              epsilon: 0.00002,
            );
            result.add(MakkahBusModel(
              id: id != null ? '${id}_$lineIndex' : null,
              nameArabic: nameArabic,
              nameEnglish: nameEnglish,
              colorCode: colorCode,
              coordinates: simplified,
            ));
            lineIndex++;
          }
        }
      } else if (geomType == 'LineString') {
        final List<List<double>> coordinates = [];
        for (final point in rawCoords) {
          if (point is List<dynamic> && point.length >= 2) {
            coordinates.add([_toDouble(point[0]), _toDouble(point[1])]);
          }
        }

        if (coordinates.isNotEmpty) {
          final simplified = PolylineSimplifier.simplify(
            coordinates,
            epsilon: 0.00002,
          );
          result.add(MakkahBusModel(
            id: id,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            colorCode: colorCode,
            coordinates: simplified,
          ));
        }
      }
    }
  } catch (e) {
    debugPrint('Error parsing makkah buses JSON: $e');
  }

  return result;
}

class MakkahBusJsonDatasource {
  Future<List<MakkahBusModel>> getInfo() async {
    try{
      final jsonOutput = await rootBundle.loadString(Assets.maps.buses.makkahBus);
      final result = await compute(_parse, jsonOutput);
      return result;
    } catch (ex) {
      return [];
    }
  }
}

