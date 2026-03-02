import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'layers_state.dart';

part 'active_layer.g.dart';

@Riverpod()
class ActiveLayer extends _$ActiveLayer {
  @override
  LayerType? build() => null;

  Future<void> setActiveLayer(LayerType? type) async {
    state = type;
  }

  Future<void> removeActiveLayer() async {
    ref.invalidateSelf();
  }
}
