import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/datasources/web_service_weather.dart';
import 'package:mapness/_features/weather/domain/entities/weather_params.dart';
import 'package:mapness/entry_point.dart';

abstract class WeatherRemoteDataSource {
  factory WeatherRemoteDataSource(WebServiceWeather service) =>
      _WeatherRemoteDataSource(webServiceWeather: service);

  Future<Map<String, dynamic>?>? getCurrentWeatherData({
    required WeatherParams params,
    required CancelToken cancelToken,
  });
  Future<Map<String, dynamic>?>? getForecastData({
    required WeatherParams params,
    required CancelToken cancelToken,
  });
}

class _WeatherRemoteDataSource implements WeatherRemoteDataSource {
  final WebServiceWeather webServiceWeather;

  _WeatherRemoteDataSource({required this.webServiceWeather});

  @override
  Future<Map<String, dynamic>?>? getCurrentWeatherData(
      {required WeatherParams params, required CancelToken cancelToken}) async {
    mixpanel?.timeEvent("WebServiceWeather: getCurrentWeatherData");
    String weatherAPI = '/v1/current.json?';
    try {
      var map = params.toMap();
      final response = await webServiceWeather.dio.get(
        weatherAPI,
        queryParameters: map,
        cancelToken: cancelToken,
      );
      mixpanel?.track("WebServiceWeather: getCurrentWeatherData");
      return response.data;
    } on DioException catch (e) {
      log("WEATHER API DioException $e");
    } catch (e) {
      log("WEATHER API EXCEPTION $e");
    }
    mixpanel?.track("WebServiceWeather: getCurrentWeatherData");
    return null;
  }

  @override
  Future<Map<String, dynamic>?>? getForecastData(
      {required WeatherParams params, required CancelToken cancelToken}) async {
    mixpanel?.timeEvent("WebServiceWeather: getForecastData");
    String weatherAPI = '/v1/forecast.json?';
    try {
      var map = params.toMap();
      final response = await webServiceWeather.dio.get(
        weatherAPI,
        queryParameters: map,
        cancelToken: cancelToken,
      );
      mixpanel?.track("WebServiceWeather: getForecastData");
      return response.data;
    } on DioException catch (e) {
      log("WEATHER API DioException $e");
    } catch (e) {
      log("WEATHER API EXCEPTION $e");
    }
    mixpanel?.track("WebServiceWeather: getForecastData");
    return null;
  }
}
