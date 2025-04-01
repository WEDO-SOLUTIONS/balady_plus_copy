import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding.g.dart';

const String _prefsKey = 'is_onboarding_shown';

@riverpod
class Onboarding extends _$Onboarding {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isOnboardingShown = sharedPrefs.getBool(_prefsKey);

    if (isOnboardingShown == null) {
      setIsOnboardingShown(isOnboardingShown: false);
    }

    return false;
  }

  void setIsOnboardingShown({required bool isOnboardingShown}) {
    ref.read(sharedPrefsProvider).setBool(_prefsKey, isOnboardingShown);
    state = isOnboardingShown;
  }
}
