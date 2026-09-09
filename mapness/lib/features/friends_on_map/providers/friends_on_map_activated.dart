import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_activated.g.dart';

const String _prefsKey = 'friends_on_map_activated';

/// Whether the user has completed Friends on Map activation (R-01) and has
/// not deactivated since. Also doubles as the "don't repeat the disclosure"
/// flag for S-01 AC-05 — declining the disclosure never sets this, only a
/// completed activation does. Pattern copied from `shared/providers/onboarding.dart`.
@riverpod
class FriendsOnMapActivated extends _$FriendsOnMapActivated {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    return sharedPrefs.getBool(_prefsKey) ?? false;
  }

  void setActivated({required bool activated}) {
    ref.read(sharedPrefsProvider).setBool(_prefsKey, activated);
    state = activated;
  }
}
