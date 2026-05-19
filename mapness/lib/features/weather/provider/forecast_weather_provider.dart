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
  CancelToken? _forceRefreshCancelToken;

  @override
  AllWeatherInfoEntity? build() {
    final cancelToken = CancelToken();
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    controller?.getCameraPosition().then((value) async {
      if (!ref.mounted || cancelToken.isCancelled) {
        return;
      }
      await _onEvent(value, repository, cancelToken);
    });

    final subscription = controller?.cameraPositionEvents
        .debounceTime(const Duration(seconds: 1))
        .listen((value) async => _onEvent(value, repository, cancelToken));

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
      _forceRefreshCancelToken?.cancel();
    });

    return null;
  }

  Future<void> forceRefresh() async {
    final cancelToken = CancelToken();
    _forceRefreshCancelToken?.cancel();
    _forceRefreshCancelToken = cancelToken;
    final controller = ref.read(dgisControllerProvider).value;
    final repository = ref.read(weatherRepository.notifier);
    final position = await controller?.getCameraPosition();
    if (position != null && ref.mounted && !cancelToken.isCancelled) {
      await _onEvent(position, repository, cancelToken);
    }
    if (identical(_forceRefreshCancelToken, cancelToken)) {
      _forceRefreshCancelToken = null;
    }
  }

  Future<void> _onEvent(CameraPositionMessage value, WeatherRepository repository, CancelToken cancelToken) async {
    final latitude = value.point.latitude;
    final longitude = value.point.longitude;
    try {
      final result = await repository.getForecastWeather(
        latitude: latitude,
        longitude: longitude,
        numberOfDays: 5,
        cancelToken: cancelToken,
      );
      if (!ref.mounted || cancelToken.isCancelled) {
        return;
      }
      state = result;
    } on DioException catch (error) {
      if (cancelToken.isCancelled || CancelToken.isCancel(error)) {
        return;
      }
      rethrow;
    }
  }
}

final forecastWeatherProvider = _forecastWeatherProvider;
