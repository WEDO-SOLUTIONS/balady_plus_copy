import 'package:mapness/_features/weather/widgets/weather_card_header.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_map_controls.g.dart';

class WeatherMapControlsState {
  final double extent;
  final bool controlsVisible;

  WeatherMapControlsState(this.extent, this.controlsVisible);

  WeatherMapControlsState copy({double? extent, bool? controlsVisible}) {
    return WeatherMapControlsState(
      extent ?? this.extent,
      controlsVisible ?? this.controlsVisible,
    );
  }
}

@riverpod
class WeatherMapControls extends _$WeatherMapControls {
  @override
  WeatherMapControlsState build() {
    return WeatherMapControlsState(weatherHeaderSize, true);
  }

  void update({double? extent, bool? controlsVisible}) {
    state = state.copy(
      extent: extent,
      controlsVisible: controlsVisible,
    );
  }
}
