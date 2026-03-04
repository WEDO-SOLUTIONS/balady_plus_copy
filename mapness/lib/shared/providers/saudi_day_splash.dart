import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_day_splash.g.dart';

const String _prefsKey = 'is_saudi_day_shown';

/// @deprecated Use [ThemeSplashState] instead.
///
/// This provider is deprecated and will be removed in a future release.
/// It has been replaced by the generic [ThemeSplashState] which manages
/// splash state for all themed modes centrally.
///
/// **Migration:**
/// Use `themeSplashStateProvider` instead of `saudiDaySplashProvider`.
///
/// See: /mapness/lib/features/special_themes/core/theme_splash_state.dart
@Deprecated('Use ThemeSplashState instead. Will be removed in next release.')
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
