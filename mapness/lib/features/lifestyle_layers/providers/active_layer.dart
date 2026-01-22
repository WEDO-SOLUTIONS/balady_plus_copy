import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'layers_state.dart';

part 'active_layer.g.dart';

const _activeLayerKey = 'active_layer_key';

@Riverpod(keepAlive: true)
class ActiveLayer extends _$ActiveLayer {
  @override
  LayerType? build() {
    final prefs = ref.read(sharedPrefsProvider);
    final savedLayer = prefs.getString(_activeLayerKey);
    return LayerTypeEx.stringToType(savedLayer);
  }

  Future<void> setActiveLayer(LayerType? type) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (type != null) {
      await prefs.setString(_activeLayerKey, type.name);
    } else {
      await prefs.remove(_activeLayerKey);
    }
    state = type;
  }

  Future<void> removeActiveLayer() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.remove(_activeLayerKey);
    state = null;
  }
}
