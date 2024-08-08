import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_sound_provider.g.dart';

const String _prefsKey = 'navigator.soundsEnabled';

@riverpod
class _PathNavSoundProvider extends _$PathNavSoundProvider {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final value = sharedPrefs.getBool(_prefsKey) ?? true;

    unawaited(updateNavigator(newState: value));

    return value;
  }

  Future<void> toggle() async {
    state = !state;

    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.setBool(_prefsKey, state);
    await updateNavigator(newState: state);
  }

  Future<void> updateNavigator({required bool newState}) async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.toggleSound(
      toggleType: newState ? SoundToggleType.all : SoundToggleType.none,
    );
  }
}

final pathNavSoundProviderProvider = _pathNavSoundProviderProvider;
