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

      final attributes = item['attributes'] as Map<String, dynamic>? ?? {};
      final geometry = item['geometry'] as Map<String, dynamic>? ?? {};

      final id = attributes['OBJECTID']?.toString();
      final nameArabic = attributes['Name_Arabic']?.toString();
      final nameEnglish = attributes['Name_English']?.toString();
      final colorCode = attributes['Color_Code']?.toString();

      // New format uses "paths" — plain [lon, lat] arrays, already densified by GIS
      final paths = geometry['paths'] as List<dynamic>? ?? [];
      final List<List<double>> coordinates = [];

      for (final path in paths) {
        if (path is! List<dynamic>) continue;
        for (final point in path) {
          if (point is List<dynamic> && point.length >= 2) {
            coordinates.add([_toDouble(point[0]), _toDouble(point[1])]);
          }
        }
      }

      if (coordinates.isEmpty) continue;

      result.add(MakkahBusesModel(
        id: id,
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        colorCode: colorCode,
        coordinates: coordinates,
      ));
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

