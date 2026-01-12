import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/entities/weather/weather_params.dart';
import 'package:mapness/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:mapness/features/weather/data/models/weather_model.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_repository.g.dart';

@riverpod
class WeatherRepository extends _$WeatherRepository {
  Future<AllWeatherInfoEntity?> getForecastWeather({
    required double latitude,
    required double longitude,
    required int numberOfDays,
    required CancelToken cancelToken,
  }) async {
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

    final data = await state.value?.getForecastWeatherData(
      params: weatherParams,
      cancelToken: cancelToken,
    );

    final result = mapper(data);

    return result.toDomain();
  }

  @override
  Future<WeatherRemoteDataSource> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final dio = await ref.watch(dGisHttpService.future);

    return WeatherRemoteDataSource(
      dio: dio,
      baseUrl: env.weatherApi,
    );
  }
}

final weatherRepository = weatherRepositoryProvider;
