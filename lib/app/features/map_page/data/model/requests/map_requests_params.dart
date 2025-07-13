// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../enums/map_enums.dart';

class MapRequestParams {
  GISMapLayers layer;
  int? objectId;
  double southWestLongitude;
  double southWestLlatitude;
  double northEastLongitude;
  double northEastLatitude;

  MapRequestParams(
      {required this.layer,
      required this.southWestLongitude,
      required this.southWestLlatitude,
      required this.northEastLongitude,
      required this.northEastLatitude,
      this.objectId});

  Map<String, dynamic> toMap({bool pointsDetails = false}) {
    return {
      "outFields": pointsDetails
          ? layer.outFieldsLong.join(",")
          : layer.outFieldsShort.join(","),
      //  "where": "1=1",
      "geometryType": "esriGeometryEnvelope",
      if (pointsDetails && objectId != null) "objectIds": objectId,
      "geometry":
          "$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude",
      "spatialRel": "esriSpatialRelIntersects",
      //  "resultRecordCount": layer.resultRecordCount
    };
  }
}
