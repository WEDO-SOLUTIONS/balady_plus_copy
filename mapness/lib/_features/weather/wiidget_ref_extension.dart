import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/weather_map_controller.dart';

extension WidgetRefWeatherExt on WidgetRef {
  void toggleWeatherMap({WeatherMapType? type, required bool enable}) =>
      read(weatherMapControllerProvider.notifier)
          .toggleWeatherMap(enable: enable, type: type);

  Future<void> switchOffWeatherLayers() =>
      read(weatherMapControllerProvider.notifier).switchOffWeatherLayers();
}
