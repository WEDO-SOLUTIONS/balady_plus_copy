import 'dart:async';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:mapness/_features/lifestyle_layers/domain/esri_feature.dart';

abstract class LifestyleDataSource {
  factory LifestyleDataSource(LifestyleLayersService service) =>
      _LifestyleDataSource(service: service);

  Future<List<EsriPointFeature>?> getEsriMarkers(String layerId, VisibleRect searchRect);
}

class _LifestyleDataSource implements LifestyleDataSource {
  final LifestyleLayersService service;

  _LifestyleDataSource({required this.service});

  @override
  Future<List<EsriPointFeature>?> getEsriMarkers(
      String layerId, VisibleRect searchRect) async {
    var points;
    try {
      final params = {
        "where": "1=1",
        "northEastLatitude": searchRect.northEastLat,
        "northEastLongitude": searchRect.northEastLon,
        "southWestLongitude": searchRect.southWestLon,
        "southWestLlatitude": searchRect.southWestLat,
        "f": "json",
        "outFields": "OBJECTID",
      };

      String q =
          "https://apiservicesstg.balady.gov.sa/v1/gis-urbi-services/layers/$layerId/query?";
      params.forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);

      final verifyingKey = hashRequest_(
        q,
        "GET",
      );

      print("[getEsriMarkers] $q = $verifyingKey");


      // dev(domain: "https://apiservicesstg.balady.gov.sa/"),
    // stg(domain: "https://apiservicesstg.balady.gov.sa/"),
    // pre(domain: "https://apiservicespp.balady.gov.sa/"),
    // prod(domain: "https://apiservices.balady.gov.sa/"),

      const domain = 'https://sa1.ops.2gis.dev';
      String mainUrl = "${domain}/v1/gis-urbi-services/layers";

      q = "$mainUrl/$layerId/query?";
      params.forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);

      print("[getEsriMarkers] $q");

      points = await service.dio.get(
        q,
        options: Options(headers: {
          // "verifyingKEY": verifyingKey,
          // "Authorization": "Basic bW9tcmFoOjBTeFIwUWtpZElkQXJ4ODk=",
          // ApiHeader.requiresToken.eName: false,
          'verifyingKEY': verifyingKey,
        }),
      );

      return (points.data['data']['result']['features'] as List<dynamic>)
          .map((x) => EsriPointFeature.fromJson(x, layerId))
          .toList();
    } on DioException catch (error) {
      "[getEsriMarkers] DioError $error";
    } catch (error) {
      print("[getEsriMarkers] $error");
    }
    return null;
  }


}
