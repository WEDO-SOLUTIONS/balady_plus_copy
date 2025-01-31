import 'dart:async';
import 'dart:developer';

import 'package:balady_plus/app/core/utils/constants/apis/api_headers.dart';
import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_params.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/weather/data/datasources/web_service_weather.dart';

abstract class WeatherRemoteDataSource {
  factory WeatherRemoteDataSource(WebServiceWeather service) => _WeatherRemoteDataSource(webServiceWeather: service);

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
  _WeatherRemoteDataSource({required this.webServiceWeather});
  final WebServiceWeather webServiceWeather;

  @override
  Future<Map<String, dynamic>?>? getCurrentWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  }) async {
    mixpanel?.timeEvent('WebServiceWeather: getCurrentWeatherData');
    const weatherAPI = '/v1/current.json?';
    try {
      final map = params.toMap();
      final response = await webServiceWeather.dio.get(
        weatherAPI,
        queryParameters: map,
        cancelToken: cancelToken,
      );
      unawaited(mixpanel?.track('WebServiceWeather: getCurrentWeatherData'));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      log('WEATHER API DioException $e');
    } catch (e) {
      log('WEATHER API EXCEPTION $e');
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
      final response = await webServiceWeather.dio.get(
        weatherAPI,
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            'Accept-Language': params.languageCode,
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name: params.getVerifyingKey(),
          },
        ),
        cancelToken: cancelToken,
      );
      unawaited(mixpanel?.track('WebServiceWeather: getForecastData'));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      log('WEATHER API DioException $e');
    } catch (e) {
      log('WEATHER API EXCEPTION $e');
    }
    unawaited(mixpanel?.track('WebServiceWeather: getForecastData'));
    return null;
  }
}
