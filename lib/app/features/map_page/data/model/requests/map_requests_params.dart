// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../enums/map_enums.dart';

class MapRequestParams {
  GISMapLayers layer;
  double southWestLongitude;
  double southWestLlatitude;
  double northEastLongitude;
  double northEastLatitude;

  MapRequestParams({
    required this.layer,
    required this.southWestLongitude,
    required this.southWestLlatitude,
    required this.northEastLongitude,
    required this.northEastLatitude,
  });

  Map<String, dynamic> toMap() {
    return {
      "outFields": layer.outFieldsShort.join(","),
      "geometryType": "esriGeometryEnvelope",
      "geometry":
          "$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude",
      "spatialRel": "esriSpatialRelIntersects",
      "resultRecordCount": 100
    };
  }
}
