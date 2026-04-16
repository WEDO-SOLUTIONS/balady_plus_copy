import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visible_provider.g.dart';

@riverpod
class ShuttleBusLayerVisible extends _$ShuttleBusLayerVisible {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}
