import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/data/repository/weather_repository.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'current_weather_provider.g.dart';

@riverpod
class _CurrentWeather extends _$CurrentWeather {
  @override
  AllWeatherInfoEntity? build() {
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    final cancelToken = CancelToken();

    Future<void> listener(CameraPositionMessage event) async {
      if (!ref.mounted || cancelToken.isCancelled) {
        return;
      }
      final latitude = event.point.latitude;
      final longitude = event.point.longitude;

      try {
        final result = await repository.getForecastWeather(
          latitude: latitude,
          longitude: longitude,
          numberOfDays: 1,
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

    final subscription = controller?.cameraPositionEvents.debounceTime(const Duration(seconds: 1)).listen(listener);

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
    });

    return null;
  }
}

final currentWeatherProvider = _currentWeatherProvider;
