import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_layer_visible.g.dart';

const String _prefsKey = 'friends_on_map_layer_visible';

/// R-97/R-98 (D-13 fallback): a display-only toggle for the friends layer
/// on the map. Shown by default per Appendix B ("Friends layer default
/// state on first activation: shown"). No repository call — per R-97 this
/// is purely local display state and doesn't affect reporting, visibility
/// rules, sharing links, or notifications, so there's nothing for a mocked
/// "backend" to model. Pattern copied from `friends_on_map_activated.dart`.
@riverpod
class FriendsOnMapLayerVisible extends _$FriendsOnMapLayerVisible {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    return sharedPrefs.getBool(_prefsKey) ?? true;
  }

  void setVisible({required bool visible}) {
    ref.read(sharedPrefsProvider).setBool(_prefsKey, visible);
    state = visible;
  }
}
