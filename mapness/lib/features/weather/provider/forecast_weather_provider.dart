import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/data/repository/weather_repository.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'forecast_weather_provider.g.dart';

@Riverpod(keepAlive: true)
class _ForecastWeather extends _$ForecastWeather {
  @override
  AllWeatherInfoEntity? build() {
    final cancelToken = CancelToken();
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    controller?.getCameraPosition().then((value) async => _onEvent(value, repository, cancelToken));

    final subscription = controller?.cameraPositionEvents
        .debounceTime(const Duration(seconds: 1))
        .listen((value) async => _onEvent(value, repository, cancelToken));

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
    });

    return null;
  }

  Future<void> forceRefresh() async {
    final cancelToken = CancelToken();
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);
    final position = await controller?.getCameraPosition();
    if (position != null) {
      await _onEvent(position, repository, cancelToken);
    }
  }

  Future<void> _onEvent(CameraPositionMessage value, WeatherRepository repository, CancelToken cancelToken) async {
    final latitude = value.point.latitude;
    final longitude = value.point.longitude;
    final result = await repository.getForecastWeather(
      latitude: latitude,
      longitude: longitude,
      numberOfDays: 5,
      cancelToken: cancelToken,
    );
    state = result;
  }
}

final forecastWeatherProvider = _forecastWeatherProvider;
