import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_layers_tab.g.dart';

/// Filter tab on the layers sheet. Selection persists across sessions
/// via SharedPreferences.
enum LayersTab {
  allLayers,
  mapDetails,
  publicTransport;

  static LayersTab? _fromName(String? name) {
    if (name == null) {
      return null;
    }
    for (final value in LayersTab.values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}

const _activeLayersTabKey = 'active_layers_tab_key';

@Riverpod(keepAlive: true)
class ActiveLayersTab extends _$ActiveLayersTab {
  @override
  LayersTab build() {
    final prefs = ref.read(sharedPrefsProvider);
    return LayersTab._fromName(prefs.getString(_activeLayersTabKey)) ?? LayersTab.allLayers;
  }

  Future<void> set(LayersTab tab) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_activeLayersTabKey, tab.name);
    state = tab;
  }
}
