import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_day_splash.g.dart';

const String _prefsKey = 'is_saudi_day_shown';

@riverpod
class SaudiDaySplash extends _$SaudiDaySplash {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isSaudiDayShown = sharedPrefs.getBool(_prefsKey);

    if (isSaudiDayShown == null) {
      setIsSaudiDayShown(isSaudiDayShown: false);
    }

    return isSaudiDayShown ?? false;
  }

  void setIsSaudiDayShown({required bool isSaudiDayShown}) {
    ref.read(sharedPrefsProvider).setBool(_prefsKey, isSaudiDayShown);
    state = isSaudiDayShown;
  }
}
