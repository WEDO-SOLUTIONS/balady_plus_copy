import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';

abstract class LifestyleDataSource {
  factory LifestyleDataSource(LifestyleLayersService service) =>
      _LifestyleDataSource(service: service);

  Future<List<dynamic>?> getEsriPoints(
    MapRequestParams params,
    CancelToken? cancelToken,
  );
}

class _LifestyleDataSource implements LifestyleDataSource {
  final LifestyleLayersService service;

  _LifestyleDataSource({required this.service});

  @override
  Future<List<dynamic>?> getEsriPoints(
    MapRequestParams params,
    CancelToken? cancelToken,
  ) async {
    var points;
    try {
      var verifyingKey = params.getVerifyingKey();
      points = await service.dio.get(
        params.getUrl(),
        options: Options(headers: {
          if (verifyingKey != null) 'verifyingKEY': verifyingKey,
        }),cancelToken: cancelToken,
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
}
