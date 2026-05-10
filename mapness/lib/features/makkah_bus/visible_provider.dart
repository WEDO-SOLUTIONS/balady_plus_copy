import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visible_provider.g.dart';

@riverpod
class MakkahBusLayerVisible extends _$MakkahBusLayerVisible {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}
