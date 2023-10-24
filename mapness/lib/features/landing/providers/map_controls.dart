import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_controls.g.dart';

enum MapControlsState {
  idle,
  dashboard,
  navigation;
}

@riverpod
class MapControls extends _$MapControls {
  @override
  MapControlsState build() => MapControlsState.idle;

  void update(MapControlsState value) => state = value;
}
