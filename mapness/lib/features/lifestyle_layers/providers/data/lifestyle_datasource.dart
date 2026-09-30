import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mapness/features/lifestyle_layers/models/map_requests_params.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

abstract class LifestyleDataSource {
  factory LifestyleDataSource(Dio dio) => _LifestyleDataSource(dio: dio);

  Future<List<dynamic>?> getEsriPoints(
    MapRequestParams params,
    CancelToken? cancelToken,
  );
}

class _LifestyleDataSource implements LifestyleDataSource {
  final Dio dio;

  _LifestyleDataSource({required this.dio});

  @override
  Future<List<dynamic>?> getEsriPoints(
    MapRequestParams params,
    CancelToken? cancelToken,
  ) async {
    Response points;
    try {
      final verifyingKey = params.getVerifyingKey();
      points = await dio.get(
        params.getUrl(),
        options: Options(
          headers: {
            if (verifyingKey != null) 'verifyingKEY': verifyingKey,
          },
        ),
        cancelToken: cancelToken,
      );

      // ignore: avoid_dynamic_calls
      return points.data['data']['result']['features'] as List<dynamic>?;
    } on DioException catch (error) {
      // Superseded viewport requests are cancelled on purpose; that is not a failure.
      if (!CancelToken.isCancel(error)) {
        logger.log('[getEsriMarkers] DioError $error', logLevel: MapnessLogLevel.critical);
      }
      return null;
    } catch (error) {
      logger.log('[getEsriMarkers] $error', logLevel: MapnessLogLevel.critical);
      return null;
    }
  }
}
