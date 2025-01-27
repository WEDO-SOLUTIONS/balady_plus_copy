import 'package:mapness/widgets/wheather/weather_card_header.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_map_controls.g.dart';

class WeatherMapControlsState {
  WeatherMapControlsState(this.extent, {required this.controlsVisible});

  final double extent;
  final bool controlsVisible;

  WeatherMapControlsState copy({double? extent, bool? controlsVisible}) => WeatherMapControlsState(
        extent ?? this.extent,
        controlsVisible: controlsVisible ?? this.controlsVisible,
      );
}

@riverpod
class WeatherMapControls extends _$WeatherMapControls {
  @override
  WeatherMapControlsState build() => WeatherMapControlsState(
        weatherHeaderSize,
        controlsVisible: true,
      );

  void update({double? extent, bool? controlsVisible}) {
    state = state.copy(
      extent: extent,
      controlsVisible: controlsVisible,
    );
  }
}
