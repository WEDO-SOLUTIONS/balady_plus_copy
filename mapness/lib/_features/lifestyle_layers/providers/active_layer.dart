import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'layers_state.dart';

part 'active_layer.g.dart';

@Riverpod()
class ActiveLayer extends _$ActiveLayer {
  static const _activeLayerKey = 'activeLayerKey';

  @override
  LayerType? build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final string = sharedPrefs.getString(_activeLayerKey);

    final layerState = LayerTypeEx.stringToType(string);
    return layerState;
  }

  Future<void> setActiveLayer(LayerType? type) async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    if (type != null) {
      await sharedPrefs.setString(_activeLayerKey, type.name);
    }
    state = type;
  }

  Future<void> removeActiveLayer() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.remove(_activeLayerKey);
    ref.invalidateSelf();
  }
}
