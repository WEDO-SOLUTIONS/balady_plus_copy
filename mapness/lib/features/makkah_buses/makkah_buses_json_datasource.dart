import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';

// compute function to parse json
List<MakkahBusesModel> parseMakkahBusesJson(String jsonInput) {
  // parse json
  final List<MakkahBusesModel> result = [];
  final json = jsonDecode(jsonInput) as List<dynamic>;

  for (final item in json) {
    result.add(MakkahBusesModel.fromJson(item));
  }

  return result;
}

class MakkahBusesJsonDatasource {
  Future<List<MakkahBusesModel>> getMakkahBusesInfo() async {
    // open asset json
    final jsonOutput = await rootBundle.loadString('assets/maps/makkah_buses/makkah_buses.json');

    final result = compute(parseMakkahBusesJson, jsonOutput);

    return result;
  }
}
