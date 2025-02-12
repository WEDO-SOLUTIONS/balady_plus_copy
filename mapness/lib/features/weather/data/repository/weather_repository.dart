import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/entities/weather/weather_params.dart';
import 'package:mapness/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:mapness/features/weather/data/models/weather_model.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_repository.g.dart';

@riverpod
class WeatherRepository extends _$WeatherRepository {
  late final WeatherRemoteDataSource weatherDataSource;

  Future<AllWeatherInfoEntity?> getForecastWeather(
    double latitude,
    double longitude,
    int numberOfDays,
    CancelToken cancelToken,
  ) async {
    final locale = ref.read(appLanguageProvider).locale;
    final env = await ref.read(dgisEnvironmentProvider.future);

    final weatherParams = WeatherParams(
      latitude: latitude,
      longitude: longitude,
      numberOfDays: numberOfDays,
      languageCode: locale.languageCode,
      domain: env.weatherApi,
      proxy: env.proxy,
    );
    final data = await weatherDataSource.getForecastWeatherData(
      params: weatherParams,
      cancelToken: cancelToken,
    );
    final result = mapper(data);

    return result.toDomain();
  }

  @override
  Future<void> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final dio = await ref.read(dGisNetworkProvider.future);

    weatherDataSource = WeatherRemoteDataSource(
      dio: dio,
      baseUrl: env.weatherApi,
    );
  }
}

final weatherRepository = weatherRepositoryProvider;
