// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';

class MapRequestParams {
  GISMapLayers layer;
  int? objectId;
  double southWestLongitude;
  double southWestLatitude;
  double northEastLongitude;
  double northEastLatitude;
  String? proxy;
  String domain;

  MapRequestParams(
      {required this.layer,
      required this.southWestLongitude,
      required this.southWestLatitude,
      required this.northEastLongitude,
      required this.northEastLatitude,
      required this.domain,
      this.proxy,
      this.objectId});

  String getUrl() {
    var resultUrl;

    final params = toMap();
    final layerId = layer.layerId;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
    const gisLayers = 'v1/gis-urbi-services/layers';

      var hashedUrl = "$domain/$gisLayers/$layerId/query?";
      final mainUrl = "$proxy/$gisLayers";

      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

      // verifyingKey = hashRequest_(hashedUrl, "GET");

      hashedUrl = "$mainUrl/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    } else {
      const gisLayers = 'gis-urbi-services/layers';
      var domainYUrl = domain.replaceAll('/urbi-services/', '');
      var hashedUrl = "$domainYUrl/$gisLayers/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    }

    return resultUrl;
  }

  String? getVerifyingKey() {
    var verifyingKey;

    const gisLayers = 'v1/gis-urbi-services/layers';

    final params = toMap();
    final layerId = layer.layerId;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      var hashedUrl = "$domain/$gisLayers/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
      verifyingKey = hashRequest_(hashedUrl, "GET");
    }

    return verifyingKey;
  }

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
