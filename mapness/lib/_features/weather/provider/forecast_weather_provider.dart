import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/data/repository/weather_repository.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'forecast_weather_provider.g.dart';

@riverpod
class _ForecastWeather extends _$ForecastWeather {
  double? lastLatitude = 0.0;
  double? lastLongitude = 0.0;
  @override
  AllWeatherInfoModel? build() {
    final cancelToken = CancelToken();
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    controller?.getCameraPosition().then(
          (value) async => _onEvent(value, repository, cancelToken),
        );

    final subscription = controller?.cameraPositionEvents.debounceTime(const Duration(seconds: 1)).listen(
      (value) async {
        if (lastLatitude == value.point.latitude && lastLongitude == value.point.longitude) {
          return;
        }

        if (lastLatitude != null && lastLongitude != null) {
          final distance =
              CommonFunctions.distance(lastLatitude!, lastLongitude!, value.point.latitude, value.point.longitude);

          if (distance < 0.2) {
            // fetch if camera move 200 meters long
            return;
          }
        }

        cancelToken.cancel();

        lastLatitude = value.point.latitude;
        lastLongitude = value.point.longitude;

        return _onEvent(value, repository, cancelToken);
      },
    );

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
