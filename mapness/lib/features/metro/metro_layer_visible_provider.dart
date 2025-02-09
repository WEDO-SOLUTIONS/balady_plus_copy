import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_layer_visible_provider.g.dart';

@riverpod
class MetroLayerVisible extends _$MetroLayerVisible {
  @override
  bool build() => false;

  void showMetro() {
    state = true;
  }

  void hideMetro() {
    state = false;
  }
}
