import 'package:dio/dio.dart';
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/data/repository/weather_repository.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'current_weather_provider.g.dart';

@riverpod
class _CurrentWeather extends _$CurrentWeather {
  @override
  AllWeatherInfoModel? build() {
    final controller = ref.watch(dgisControllerProvider).value;
    final repository = ref.watch(weatherRepository.notifier);

    final cancelToken = CancelToken();

    final subscription = controller?.cameraPositionEvents
        .debounceTime(const Duration(seconds: 1))
        .listen((event) async {
      final latitude = event.point.latitude;
      final longitude = event.point.longitude;

      final result =
          await repository.getCurrentWeather(latitude, longitude, cancelToken);
      _listener(result);
    });

    ref.onDispose(() {
      subscription?.cancel();
      cancelToken.cancel();
    });

    return null;
  }

  void _listener(AllWeatherInfoModel? event) {
    state = event;
  }
}

final currentWeatherProvider = _currentWeatherProvider;
