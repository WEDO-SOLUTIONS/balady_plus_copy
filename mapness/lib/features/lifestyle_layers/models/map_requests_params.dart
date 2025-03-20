import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/shared/utils/common_function.dart';

class MapRequestParams {
  final GISMapLayers? layer;
  final int? objectId;
  final double? southWestLongitude;
  final double? southWestLatitude;
  final double? northEastLongitude;
  final double? northEastLatitude;
  final String? proxy;
  final String domain;
  final bool? pointsDetails;

  const MapRequestParams({
    required this.domain,
    this.layer,
    this.southWestLongitude,
    this.southWestLatitude,
    this.northEastLongitude,
    this.northEastLatitude,
    this.pointsDetails,
    this.proxy,
    this.objectId,
  });

  String getUrl() {
    String resultUrl;

    final params = toMap();
    final layerId = layer?.layerId ?? 0;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      const gisLayers = 'v1/gis-urbi-services/layers';

      var hashedUrl = '$domain/$gisLayers/$layerId/query?';
      final mainUrl = '$proxy/$gisLayers';

      params.forEach((key, value) => hashedUrl += '$key=$value&');
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
      hashedUrl = '$mainUrl/$layerId/query?';
      params.forEach((key, value) => hashedUrl += '$key=$value&');
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    } else {
      const gisLayers = 'gis-urbi-services/layers';
      final domainYUrl = domain.replaceAll('/urbi-services/', '');
      var hashedUrl = '$domainYUrl/$gisLayers/$layerId/query?';
      params.forEach((key, value) => hashedUrl += '$key=$value&');
      resultUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    }

    return resultUrl;
  }

  String? getVerifyingKey() {
    if (layer?.layerId == null) {
      return null;
    }
    const gisLayers = 'v1/gis-urbi-services/layers';

    final params = toMap();
    final int layerId = layer!.layerId;
    String hashedUrl;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      hashedUrl = '$domain/$gisLayers/$layerId/query?';
    } else {
      final domainYUrl = domain.replaceAll('/urbi-services/', '');
      const gisLayers = 'gis-urbi-services/layers';
      hashedUrl = '$domainYUrl/$gisLayers/$layerId/query?';
    }

    params.forEach((key, value) => hashedUrl += '$key=$value&');
    hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    return hashRequest(hashedUrl, 'GET');
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'f': 'json',
      'geometryType': 'esriGeometryEnvelope',
      'resultRecordCount': layer?.resultRecordCount ?? 0,
    };
    if (layer != null && pointsDetails == true) {
      map['outFields'] = layer?.outFieldsLong.join(',');
    } else {
      map['outFields'] = layer?.outFieldsShort.join(',');
    }

    if (pointsDetails == true && objectId != null) {
      map['objectIds'] = objectId;
    } else if (pointsDetails != true && objectId == null) {
      map['geometry'] = '${southWestLongitude?.toStringAsFixed(3)},'
          '${southWestLatitude?.toStringAsFixed(3)},'
          '${northEastLongitude?.toStringAsFixed(3)},'
          '${northEastLatitude?.toStringAsFixed(3)}';
    }
    return map;
  }
}
