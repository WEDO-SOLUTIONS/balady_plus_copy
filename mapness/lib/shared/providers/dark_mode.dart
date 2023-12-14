import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode.g.dart';

const _prefsKey = "settings.darkMode";

@Riverpod(keepAlive: true)
class DarkMode extends _$DarkMode {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    return sharedPrefs.getBool(_prefsKey) ?? false;
  }

  void toggle() {
    state = !state;
    ref.read(sharedPrefsProvider).setBool(_prefsKey, state);
  }
}
