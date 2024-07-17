import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/data/repository/weather_repository.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'forecast_weather_provider.g.dart';

@riverpod
class _ForecastWeather extends _$ForecastWeather {
  @override
  AllWeatherInfoModel? build() {
    final cancelToken = CancelToken();
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    controller?.getCameraPosition().then(
          (value) async => _onEvent(value, repository, cancelToken),
        );

    final subscription = controller?.cameraPositionEvents.debounceTime(const Duration(seconds: 1)).listen(
          (value) async => _onEvent(value, repository, cancelToken),
        );

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
    });

    return null;
  }

  Future<void> _onEvent(
    CameraPositionMessage value,
    WeatherRepository repository,
    CancelToken cancelToken,
  ) async {
    final latitude = value.point.latitude;
    final longitude = value.point.longitude;
    final result = await repository.getForecastWeather(
      latitude,
      longitude,
      5,
      cancelToken,
    );
    state = result;
  }
}

final forecastWeatherProvider = _forecastWeatherProvider;
