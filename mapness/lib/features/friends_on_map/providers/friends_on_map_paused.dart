import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_visibility_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_paused.g.dart';

const String _prefsKey = 'friends_on_map_paused';

/// R-23/R-24: the global visibility pause. Has no expiry and is
/// deliberately independent of activation — per BR-03 of S-06, deactivating
/// the feature must not reset this. Pattern copied from
/// `friends_on_map_activated.dart`.
@riverpod
class FriendsOnMapPaused extends _$FriendsOnMapPaused {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    return sharedPrefs.getBool(_prefsKey) ?? false;
  }

  Future<void> setPaused({required bool paused}) async {
    await ref.read(friendsOnMapVisibilityRepositoryProvider).setPaused(paused: paused);
    ref.read(sharedPrefsProvider).setBool(_prefsKey, paused);
    state = paused;
  }
}
