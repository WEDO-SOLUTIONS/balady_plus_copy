import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/metro/metro_line_model.dart';

// compute function to parse json
List<MetroLineModel> parseJson(String jsonInput) {
  // parse json
  final List<MetroLineModel> result = [];
  final json = jsonDecode(jsonInput) as List<dynamic>;

  for (final item in json) {
    result.add(MetroLineModel.fromJson(item));
  }

  return result;
}

class MetroLineJsonDatasource {
  Future<List<MetroLineModel>> getMetroLineInfo() async {
    // open asset json
    final jsonOutput = await rootBundle.loadString('assets/maps/metro/metro_lines.json');

    final result = compute(parseJson, jsonOutput);

    return result;
  }
}
