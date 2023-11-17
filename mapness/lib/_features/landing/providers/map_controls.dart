import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_controls.g.dart';

sealed class MapControlsState {
  bool get controlsVisible;
}

class MapControlsStateIdle extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateDashboard extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

class MapControlsStateNavigation extends MapControlsState {
  @override
  bool get controlsVisible => false;
}

// class MapControlsStateHappinessMap extends MapControlsState {
//   @override
//   bool get controlsVisible => false;
// }

class MapControlsStateLayers extends MapControlsState {
  @override
  bool get controlsVisible => true;
}

@riverpod
class MapControls extends _$MapControls {
  @override
  MapControlsState build() {
    return MapControlsStateIdle();
  }

  void update(MapControlsState value) => state = value;
}
