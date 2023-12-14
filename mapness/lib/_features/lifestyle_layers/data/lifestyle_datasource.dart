import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:mapness/_features/lifestyle_layers/domain/building_compliance_certificate.dart';
import 'package:mapness/_features/lifestyle_layers/domain/divisional_chart_boundaries.dart';
import 'package:mapness/_features/lifestyle_layers/domain/excavations.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/resturant_model.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';

abstract class LifestyleDataSource {
  factory LifestyleDataSource(LifestyleLayersService service) =>
      _LifestyleDataSource(service: service);


  Future<List<dynamic>?> getEsriPoints(MapRequestParams params);

  Future<List<PointLayersData>?> getPointsInLayers(
      {required MapRequestParams params});
}

class _LifestyleDataSource implements LifestyleDataSource {
  final LifestyleLayersService service;

  _LifestyleDataSource({required this.service});

  @override
  Future<List<dynamic>?> getEsriPoints(MapRequestParams requestParams) async {
    var points;
    try {
      final params = requestParams.toMap();
      // final params = {
      //   "where": "1=1",
      //   "geometry":
      //       "${searchRect.southWestLon},${searchRect.southWestLat},${searchRect.northEastLon},${searchRect.northEastLat}",
      //   "f": "json",
      //   "outFields": "OBJECTID",
      //   "geometryType": "esriGeometryEnvelope",
      //   // "geometryType": "esriGeometryPath",
      //   // "distance": 100,
      //   // "supportsQueryWithDistance": true,
      //   // "units": "esriSRUnit_Kilometer",
      //   // "spatialRel": "esriSpatialRelIntersects",
      //   "resultRecordCount": 100,
      // };

      const proxy = 'https://sa1.ops.2gis.dev';
      const domain = 'https://apiservicesstg.balady.gov.sa';
      const gisLayers = 'v1/gis-urbi-services/layers';

      var layerId = requestParams.layer.layerId;

      var hashedUrl = "$domain/$gisLayers/$layerId/query?";
      const mainUrl = "$proxy/$gisLayers";

      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

      final verifyingKey = hashRequest_(hashedUrl, "GET");

      hashedUrl = "$mainUrl/$layerId/query?";
      params.forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

      points = await service.dio.get(
        hashedUrl,
        options: Options(headers: {'verifyingKEY': verifyingKey}),
      );

      return points.data['data']['result']['features'];
    } on DioException catch (error) {
      print("[getEsriMarkers] DioError $error");
      return null;
    } catch (error) {
      print("[getEsriMarkers] $error");
      return null;
    }
  }

  @override
  Future<List<PointLayersData>?> getPointsInLayers(
      {required MapRequestParams params}) async {
    var points;
    try {
      const proxy = 'https://sa1.ops.2gis.dev';
      const domain = 'https://apiservicesstg.balady.gov.sa';
      const gisLayers = 'v1/gis-urbi-services/layers';

      var hashedUrl = "$domain/$gisLayers/${params.layer.layerId}/query?";
      const mainUrl = "$proxy/$gisLayers";

      params.toMap().forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

      final verifyingKey = hashRequest_(hashedUrl, "GET");

      hashedUrl = "$mainUrl/${params.layer.layerId}/query?";
      params.toMap().forEach((key, value) => hashedUrl += "$key=$value&");
      hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

      points = await service.dio.get(
        hashedUrl,
        options: Options(headers: {'verifyingKEY': verifyingKey}),
      );

      switch (params.layer.layerId) {
        case 1: //     المطاعم
          return resturantFromJson(
            points.data['data']['result']['features'],
          );
        case 2: //     المواقع الاستثمارية
          return investmentSitesFromJson(
            points.data['data']['result']['features'],
          );
        case 5: //   الحفريات
          return excavationsFromJson(
            points.data['data']['result']['features'],
          );
        case 7: //   شهادة امتثال المباني
          return buildingComplianceCertificateFromJson(
            points.data['data']['result']['features'],
          );
        /*case 8: //   اراضي مطلوب تسويرها
          return landsFencedFromJson(
            points.data['data']['result']['features'],
          );*/
        case 8: //   اراضي بيضاء
          return whiteLandsFromJson(
            points.data['data']['result']['features'],
          );
        //case 10: //       حدود قطع الأراضي
        //   return boundariesPlotsFromJson(
        //   points.data['data']['result']['features'],
        //  );
        case 9: //       حدود المخططات التقسيمية
          return divisionalChartBoundariesFromJson(
            points.data['data']['result']['features'],
          );
      }
    } on DioError catch (error) {
      debugPrint(error.message);
      return null;
    } catch (ex) {
      return null;
    }
    return null;
  }
}
