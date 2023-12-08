import 'package:intl/intl.dart';
import 'package:mapness/_features/weather/domain/enum/weather_enum.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers/map/search.dart';

part 'weather_map_controller.g.dart';

class WeatherMapState {
  final WeatherMapType type;
  final bool? isEnabled;

  WeatherMapState({required this.type, this.isEnabled});

  WeatherMapState copy({WeatherMapType? type, bool? isEnabled}) {
    return WeatherMapState(
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

@riverpod
class WeatherMapController extends _$WeatherMapController {
  @override
  WeatherMapState build() {
    ref.onDispose(
      () {},
    );
    return WeatherMapState(
      type: WeatherMapType.temperature,
    );
  }

  Future<void> toggleWeatherMap({
    WeatherMapType? type,
    required bool enable,
  }) async {
    var d = ref.read(searchProvider.notifier);
    if (type case WeatherMapType.precipitation) {
      d.searchByText('critical_point').then((b) {});
    } else {
      d.removeMarkers();
    }

    final dgisController = await ref.read(dgisControllerProvider.future);

    final result = await dgisController.toggleHeatmap(
      tileSourceUri: enable == true ? _tileSourceUri(type!) : null,
      layerName: 'heatmap',
      enable: enable,
    );

    state = state.copy(type: type, isEnabled: result);
  }

  String _tileSourceUri(WeatherMapType type) {
    final format = DateFormat('yyyy-MM-dd\'T\'HH:mm').format(DateTime.now());
    const apiKey = 'be72f76237db';
    // const apiKey = '74daf4716240';

    ///{code}~{level}~{time-resolution}~{aggregation}~{type}~{type-parameter}
    return "https://maps-api.meteoblue.com/v1/map/raster/NEMSAUTO/"
        "$format/"
        "${type.parameters}/"
        "{z}/{x}/{y}?"
        "temperatureUnit=C"
        "&apikey=$apiKey";
  }
}
