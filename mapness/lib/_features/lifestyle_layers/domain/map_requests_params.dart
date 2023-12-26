// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';

class MapRequestParams {
  GISMapLayers? layer;
  int? objectId;
  double? southWestLongitude;
  double? southWestLatitude;
  double? northEastLongitude;
  double? northEastLatitude;
  String? proxy;
  String domain;
  bool? pointsDetails;

  MapRequestParams(
      {this.layer,
      this.southWestLongitude,
      this.southWestLatitude,
      this.northEastLongitude,
      this.northEastLatitude,
      required this.domain,
      this.pointsDetails,
      this.proxy,
      this.objectId});

  String getUrl() {
    var resultUrl;

    final params = toMap();
    final layerId = layer?.layerId ?? 0;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      const gisLayers = 'v1/gis-urbi-services/layers';

      var hashedUrl = "$domain/$gisLayers/$layerId/query?";
      final mainUrl = "$proxy/$gisLayers";

      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
      hashedUrl = "$mainUrl/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    } else {
      const gisLayers = 'gis-urbi-services/layers';
      var domainYUrl = domain.replaceAll('/urbi-services/', '');
      var hashedUrl = "$domainYUrl/$gisLayers/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    }

    return resultUrl;
  }

  String? getVerifyingKey() {
    String verifyingKey;

    const gisLayers = 'v1/gis-urbi-services/layers';

    final params = toMap();
    final layerId = layer?.layerId ?? 0;
    var hashedUrl;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      hashedUrl = "$domain/$gisLayers/$layerId/query?";
    } else {
      var domainYUrl = domain.replaceAll('/urbi-services/', '');
      const gisLayers = 'gis-urbi-services/layers';
      hashedUrl = "$domainYUrl/$gisLayers/$layerId/query?";
    }

    params.forEach((key, value) => hashedUrl += "$key=$value&");
    hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    verifyingKey = hashRequest(hashedUrl, "GET");
    return verifyingKey;
  }

  Map<String, dynamic> toMap() {
    return {
      "outFields": (layer != null && pointsDetails == true)
          ? layer?.outFieldsLong.join(",")
          : layer?.outFieldsShort.join(","),
          // : "OBJECTID,STATUS",
      // "where": "1=1",
      "f": "json",
      "geometryType": "esriGeometryEnvelope",
      if (pointsDetails == true && objectId != null) "objectIds": objectId,
      if (pointsDetails != true && objectId == null)
        "geometry": "${southWestLongitude?.toStringAsFixed(3)},"
            "${southWestLatitude?.toStringAsFixed(3)},"
            "${northEastLongitude?.toStringAsFixed(3)},"
            "${northEastLatitude?.toStringAsFixed(3)}",
      "resultRecordCount": layer?.resultRecordCount ?? 0
    };
  }
}
