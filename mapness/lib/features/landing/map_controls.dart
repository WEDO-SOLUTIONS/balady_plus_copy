import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_controls.g.dart';

sealed class MapControlsState {
  bool get controlsVisible;
}

class MapControlsStateIWish extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateIdle extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateDashboard extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateLayers extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateMosque extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

@riverpod
class MapControls extends _$MapControls {
  @override
  MapControlsState build() => MapControlsStateIdle();

  // ignore: use_setters_to_change_properties
  void update(MapControlsState value) => state = value;
}
