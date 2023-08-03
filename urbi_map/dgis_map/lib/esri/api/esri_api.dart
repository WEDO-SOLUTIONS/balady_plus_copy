import 'dart:io';

import 'package:dgis_map/esri/data/layer_collection.dart';
import 'package:dgis_map/esri/data/layer_data.dart';
import 'package:dgis_map/esri/data/layer_info.dart';
import 'package:dgis_map/esri/data/layer_item.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class EsriApi {
  factory EsriApi.get() => _instance;

  EsriApi._() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30), //TODO: Random number yet
    );
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  CancelToken? _cancelToken;
  final _dio = Dio();

  static final EsriApi _instance = EsriApi._();

  static const _baseUrl =
      "https://apiservicesstg.balady.gov.sa/gis-urbi-services/";

  Future<List<LayerItem>> getLayers() async {
    if (_cancelToken != null) {
      _cancelToken?.cancel();
      _cancelToken = null;
    }
    _cancelToken = CancelToken();

    final response = await _dio.request('${_baseUrl}layers?p=json',
        cancelToken: _cancelToken);

    _cancelToken = null;
    return compute((data) => _parseLayers(data), response.data);
  }

  Future<LayerInfo> getLayerInfo(LayerItem item) async {
    if (_cancelToken != null) {
      _cancelToken?.cancel();
      _cancelToken = null;
    }
    _cancelToken = CancelToken();

    final response = await _dio.request('${_baseUrl}layers/${item.id}?p=json',
        cancelToken: _cancelToken);

    _cancelToken = null;
    return compute((data) => _parseLayerInfo(data), response.data);
  }

  Future<LayerData> getLayerData(LayerInfo info) async {
    if (_cancelToken != null) {
      _cancelToken?.cancel();
      _cancelToken = null;
    }
    _cancelToken = CancelToken();

    // fetch only first 2000 objects. for fetching all objects you could user 'resultOffset' param
    // https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer-.htm#ESRI_SECTION2_2317851472E84DB9BD18FE3396197033
    final response = await _dio.request(
        '${_baseUrl}layers/${info.id}/query?where=1=1&p=json',
        cancelToken: _cancelToken);

    _cancelToken = null;
    return compute((data) => _parseLayerData(data), response.data);
  }

  Future<LayerData?> getLayerDataForViewport(
      LayerInfo info,
      double northEastLat,
      double northEastLon,
      double southWestLat,
      double southWestLon) async {
    if (_cancelToken != null) {
      _cancelToken?.cancel();
      _cancelToken = null;
    }
    _cancelToken = CancelToken();

    try {
      // fetch only first 2000 objects. for fetching all objects you could user 'resultOffset' param
      // https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer-.htm#ESRI_SECTION2_2317851472E84DB9BD18FE3396197033
      final response = await _dio.request(
          '${_baseUrl}layers/${info.id}/query?resultRecordCount=10000&geometryType=esriGeometryEnvelope&geometry=$southWestLon,$southWestLat,$northEastLon,$northEastLat&p=json',
          cancelToken: _cancelToken);

      _cancelToken = null;
      return compute((data) => _parseLayerData(data), response.data);
    } catch (e) {
      _cancelToken = null;
      return null;
    }
  }

  void cancelRequest() {
    if (_cancelToken != null) {
      _cancelToken?.cancel();
      _cancelToken = null;
    }
  }

  static List<LayerItem> _parseLayers(Map<String, dynamic> json) {
    final layers = LayerCollection.fromJson(json['data']['result']);
    return layers.layers;
  }

  static LayerInfo _parseLayerInfo(Map<String, dynamic> json) {
    final info = LayerInfo.fromJson(json['data']['result']);
    return info;
  }

  static LayerData _parseLayerData(Map<String, dynamic> json) {
    final data = LayerData.fromJson(json['data']['result']);
    return data;
  }
}
