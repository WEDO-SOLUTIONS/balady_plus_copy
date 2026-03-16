import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_buses_layer_visible_provider.g.dart';

@riverpod
class MakkahBusesLayerVisible extends _$MakkahBusesLayerVisible {
  @override
  bool build() => false;

  void showMakkahBuses() {
    state = true;
  }

  void hideMakkahBuses() {
    state = false;
  }
}
