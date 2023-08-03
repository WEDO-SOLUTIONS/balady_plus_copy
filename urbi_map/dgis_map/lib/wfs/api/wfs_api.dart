import 'dart:async';
import 'package:dgis_map/wfs/data/feature_collection.dart';
import 'package:dgis_map/wfs/data/feature_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WfsApi {
  //TODO: refactor afterwards
  factory WfsApi.get() => _instance;

  WfsApi._() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30), //TODO: Random number yet
    );
    _dio.options = options;
  }

  static final WfsApi _instance = WfsApi._();

  static const _baseUrl = "https://roadmap-wfs-api-production.api.2gis.ru/";

  static const _maxFeatures = 10000;

  static const _parameters = {
    "service": "WFS",
    "version": "2.0.0",
    "request": "GetFeature",
    "srsName": "EPSG:4326",
    "crsName": "EPSG:4326",
    "maxFeatures": _maxFeatures,
    "outputFormat": "application/json",
  };

  CancelToken? _cancelToken;
  final _dio = Dio();
  //..interceptors.add(LogInterceptor());

  Future<List<FeatureItem>> getPanoramas({
    required double northEastLat,
    required double northEastLon,
    required double southWestLat,
    required double southWestLon,
  }) async {
    //TODO: replace with query parameters

    if (_cancelToken != null) {
      releasePanoramas();
    }

    _cancelToken = CancelToken();

    final response = await _dio.request(
      '$_baseUrl?SERVICE=${_parameters['service']}'
      '&VERSION=${_parameters['version']}'
      '&REQUEST=${_parameters['request']}'
      '&BBOX=$northEastLat,$northEastLon,$southWestLat,$southWestLon'
      '&srsName=${_parameters['srsName']}'
      '&crsName=${_parameters['crsName']}'
      '&MaxFeatures=${_parameters['maxFeatures']}'
      '&outputFormat=${_parameters['outputFormat']}',
      cancelToken: _cancelToken,
    );

    _cancelToken = null;
    return compute((data) => _parsePanoramas(data), response.data);
  }

  /// Clear cache and cancel panoramas assosiated requests
  void releasePanoramas() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  static List<FeatureItem> _parsePanoramas(Map<String, dynamic> data) {
    final collection = FeatureCollection.fromJson(data);
    return collection.features;
  }
}
