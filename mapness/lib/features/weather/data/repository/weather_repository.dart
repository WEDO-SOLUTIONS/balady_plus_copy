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
  /// Requests the forecast and returns the raw `data.result` object, or `null` if the request failed or the
  /// response has no forecast. Never throws except for a cancelled [cancelToken].
  Future<Map<String, dynamic>?> fetchForecastPayload({
    required double latitude,
    required double longitude,
    required int numberOfDays,
    required CancelToken cancelToken,
  }) async {
    final locale = ref.read(appLanguageProvider).locale;
    final env = await ref.read(dgisEnvironmentProvider.future);
    // Await the data source instead of reading `state.value`: right after start-up it may still be loading, and the
    // request would silently turn into "no weather".
    final dataSource = await future;

    final weatherParams = WeatherParams(
      latitude: latitude,
      longitude: longitude,
      numberOfDays: numberOfDays,
      languageCode: locale.languageCode,
      domain: env.weatherApi,
      proxy: env.proxy,
    );

    final data = await dataSource.getForecastWeatherData(params: weatherParams, cancelToken: cancelToken);
    final result = data?['data'];
    if (result is! Map<String, dynamic>) {
      return null;
    }
    final payload = result['result'];
    return payload is Map<String, dynamic> ? payload : null;
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

/// Parses a payload from [WeatherRepository.fetchForecastPayload]; `null` if it has no current weather.
AllWeatherInfoEntity? forecastFromPayload(Map<String, dynamic> payload) {
  try {
    final forecast = AllWeatherInfoModel.fromJson(payload).toDomain();
    return forecast.current == null ? null : forecast;
  } catch (_) {
    return null;
  }
}
