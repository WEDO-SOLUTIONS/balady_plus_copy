import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haram_shuttle_layer_visible_provider.g.dart';

@riverpod
class HaramShuttleLayerVisible extends _$HaramShuttleLayerVisible {
  @override
  bool build() => false;

  void showHaramShuttle() {
    state = true;
  }

  void hideHaramShuttle() {
    state = false;
  }
}
