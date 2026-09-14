import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/apis/api_headers.dart';
import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_params.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

abstract class WeatherRemoteDataSource {
  factory WeatherRemoteDataSource({
    required Dio dio,
    required String baseUrl,
  }) => _WeatherRemoteDataSource(
    dio: dio,
    baseUrl: baseUrl,
  );

  Future<Map<String, dynamic>?>? getCurrentWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  });

  Future<Map<String, dynamic>?>? getForecastWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  });
}

class _WeatherRemoteDataSource implements WeatherRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  _WeatherRemoteDataSource({required this.dio, required this.baseUrl});

  @override
  Future<Map<String, dynamic>?>? getCurrentWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  }) async {
    mixpanel?.timeEvent('WebServiceWeather: getCurrentWeatherData');
    const weatherAPI = 'v1/current.json?';
    try {
      final map = params.toMap();
      final response = await dio.get(
        baseUrl + weatherAPI,
        queryParameters: map,
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      detach(mixpanel?.track('WebServiceWeather: getCurrentWeatherData'), tag: 'weatherRemoteDatasource.track');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.log('WEATHER API DioException $e', logLevel: MapnessLogLevel.critical);
    } catch (e) {
      logger.log('WEATHER API EXCEPTION $e', logLevel: MapnessLogLevel.critical);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?>? getForecastWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  }) async {
    mixpanel?.timeEvent('WebServiceWeather: getForecastData');
    const weatherAPI = 'v1/weather-services/forecast?';
    try {
      final response = await dio.get(
        baseUrl + weatherAPI,
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            'Accept-Language': params.languageCode,
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name: params.getVerifyingKey(),
          },
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
        cancelToken: cancelToken,
      );
      detach(mixpanel?.track('WebServiceWeather: getForecastData'), tag: 'weatherRemoteDatasource.track');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.log('WEATHER API DioException $e', logLevel: MapnessLogLevel.critical);
    } catch (e) {
      logger.log('WEATHER API EXCEPTION $e', logLevel: MapnessLogLevel.critical);
    }
    detach(mixpanel?.track('WebServiceWeather: getForecastData'), tag: 'weatherRemoteDatasource.track');
    return null;
  }
}
