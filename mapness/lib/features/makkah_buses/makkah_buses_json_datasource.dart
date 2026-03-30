import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

double _toDouble(dynamic val) {
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

// compute function to parse json
List<MakkahBusesModel> parseMakkahBusesJson(String jsonInput) {
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
            result.add(MakkahBusesModel(
              id: id != null ? '${id}_$lineIndex' : null,
              nameArabic: nameArabic,
              nameEnglish: nameEnglish,
              colorCode: colorCode,
              coordinates: lineCoordinates,
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
          result.add(MakkahBusesModel(
            id: id,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            colorCode: colorCode,
            coordinates: coordinates,
          ));
        }
      }
    }
  } catch (e) {
    debugPrint('Error parsing makkah buses JSON: $e');
  }

  return result;
}

class MakkahBusesJsonDatasource {
  Future<List<MakkahBusesModel>> getMakkahBusesInfo() async {
    try{
      final jsonOutput = await rootBundle.loadString(Assets.maps.makkahBuses.routes);
      final result = await compute(parseMakkahBusesJson, jsonOutput);
      return result;
    } catch (ex) {
      return [];
    }
  }
}

