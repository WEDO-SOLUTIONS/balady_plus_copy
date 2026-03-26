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
      final colorName = attributes['Color_Name']?.toString();
      
      final List<List<double>> coordinates = [];
      final curvePaths = geometry['curvePaths'] as List<dynamic>? ?? [];
      
      for (final path in curvePaths) {
        if (path is! List<dynamic>) continue;
        for (final segment in path) {
          if (segment is List<dynamic> && segment.length >= 2) {
            coordinates.add([_toDouble(segment[0]), _toDouble(segment[1])]);
          } else if (segment is Map<String, dynamic> && segment.containsKey('c')) {
            final cData = segment['c'] as List<dynamic>? ?? [];
            for (final point in cData) {
              if (point is List<dynamic> && point.length >= 2) {
                coordinates.add([_toDouble(point[0]), _toDouble(point[1])]);
              }
            }
          }
        }
      }
      
      result.add(MakkahBusesModel(
        id: id,
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        colorCode: colorCode,
        colorName: colorName,
        coordinates: coordinates.isNotEmpty ? coordinates : null,
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

