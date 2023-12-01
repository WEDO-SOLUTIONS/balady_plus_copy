import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:mapness/_features/weather/data/datasources/web_service_weather.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/domain/entities/weather_params.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'weather_provider.g.dart';

@riverpod
class _AllWeatherInfoModel extends _$AllWeatherInfoModel {
  final weatherDataSource = WeatherRemoteDataSource(
    WebServiceWeather(dio: Dio()),
  );

  @override
  AllWeatherInfoModel? build() {
    final controller = ref.watch(dgisControllerProvider);

    final cancelToken = CancelToken();

    final subscription = controller?.cameraPositionEvents
        .debounceTime(const Duration(seconds: 1))
        .listen((event) async {
      final latitude = event.point.latitude;
      final longitude = event.point.longitude;

      final weatherParams = WeatherParams(
        latitude: latitude,
        longitude: longitude,
      );
      final data = await weatherDataSource.getAllWeatherInfoForLocation(
        params: weatherParams,
        cancelToken: cancelToken,
      );
      final result = mapper(data);
      _listener(result);
    });

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
    });

    return null;
  }

  void _listener(AllWeatherInfoModel event) {
    state = event;
  }
}

final weatherProvider = _allWeatherInfoModelProvider;
