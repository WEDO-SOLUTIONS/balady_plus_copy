import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/free_roam/autostart_state.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_autostart_settings.g.dart';

const String _prefsKey = 'is_free_roam_autostart';

@riverpod
class _FreeRoamAutostartSettings extends _$FreeRoamAutostartSettings {
  bool get isEnabled => state == AutostartState.always;

  @override
  AutostartState build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isAutostart = sharedPrefs.getBool(_prefsKey);

    if (isAutostart != null) {
      return isAutostart ? AutostartState.always : AutostartState.declined;
    }

    return AutostartState.unknown;
  }

  void setState({required bool isAutostart}) {
    ref.read(freeRoamStarterProvider.notifier).setShown();
    ref.read(sharedPrefsProvider).setBool(_prefsKey, isAutostart);
    state = isAutostart ? AutostartState.always : AutostartState.declined;
  }

  void toggleAutostart() => setState(isAutostart: state != AutostartState.always);
}

final freeRoamAutostartSettingsProvider = _freeRoamAutostartSettingsProvider;
