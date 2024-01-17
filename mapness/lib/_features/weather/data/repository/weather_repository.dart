import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:mapness/_features/weather/data/datasources/web_service_weather.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/domain/entities/weather_params.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_repository.g.dart';

@riverpod
class WeatherRepository extends _$WeatherRepository {
  late final WeatherRemoteDataSource weatherDataSource;

  Future<AllWeatherInfoModel?> getForecastWeather(
    double latitude,
    double longitude,
    CancelToken cancelToken,
  ) async {
    final locale = ref.read(appLanguageProvider).locale;
    final env = await ref.read(dgisEnvironmentProvider.future);


    final weatherParams = WeatherParams(
      latitude: latitude,
      longitude: longitude,
      numberOfDays: 5,
      alert: "yes",
      languageCode: locale.languageCode,
      domain: env.url,
      proxy: env.proxy,
    );
    final data = await weatherDataSource.getForecastWeatherData(
      params: weatherParams,
      cancelToken: cancelToken,
    );
    final result = mapper(data);
    return result;
  }

  Future<AllWeatherInfoModel?> getCurrentWeather(
    double latitude,
    double longitude,
    CancelToken cancelToken,
  ) async {
    final locale = ref.read(appLanguageProvider).locale;
    final env = await ref.read(dgisEnvironmentProvider.future);

    final weatherParams = WeatherParams(
      latitude: latitude,
      longitude: longitude,
      numberOfDays: 1,
      alert: "no",
      languageCode: locale.languageCode,
      proxy: env.proxy,
      domain: env.url
    );

    final data = await weatherDataSource.getForecastWeatherData(
      params: weatherParams,
      cancelToken: cancelToken,
    );
    final result = mapper(data);

    return result;
  }

  @override
  Future<void> build()async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    // "https://api.weatherapi.com"
    weatherDataSource = WeatherRemoteDataSource(
      WebServiceWeather(
        dio: Dio(),
        baseUrl: env.weatherApi,
      ),
    );
  }
}

final weatherRepository = weatherRepositoryProvider;
