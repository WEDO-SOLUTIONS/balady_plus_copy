// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';

class MapRequestParams {
  GISMapLayers layer;
  int? objectId;
  double southWestLongitude;
  double southWestLatitude;
  double northEastLongitude;
  double northEastLatitude;
  String proxy;
  String domain;

  MapRequestParams(
      {required this.layer,
      required this.southWestLongitude,
      required this.southWestLatitude,
      required this.northEastLongitude,
      required this.northEastLatitude,
      required this.proxy,
      required this.domain,
      this.objectId});

  Map<String, dynamic> toMap({bool pointsDetails = false}) {
    return {
      "outFields": pointsDetails
          ? layer.outFieldsLong.join(",")
          : layer.outFieldsShort.join(","),
      // "outFields": "OBJECTID",
      // "where": "1=1",
      "f": "json",
      "geometryType": "esriGeometryEnvelope",
      if (pointsDetails && objectId != null) "objectIds": objectId,
      "geometry": "$southWestLongitude,"
          "$southWestLatitude,"
          "$northEastLongitude,"
          "$northEastLatitude",
      // "spatialRel": "esriSpatialRelIntersects",
      "resultRecordCount": layer.resultRecordCount
    };
  }
}
