import 'dart:async';

import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_sound_provider.g.dart';

const String _prefsKey = 'navigator.soundsEnabled';

@riverpod
class _PathNavSoundProvider extends _$PathNavSoundProvider {
  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final value = sharedPrefs.getBool(_prefsKey) ?? true;

    detach(updateNavigator(newState: value), tag: 'pathNavSoundProvider.updateNavigator');

    return value;
  }

  Future<void> toggle() async {
    state = !state;

    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.setBool(_prefsKey, state);
    await updateNavigator(newState: state);
  }

  Future<void> updateNavigator({required bool newState}) async {
    /// TODO(Ayat) Check Roma if you need this part of the code because we control the event via toggle
    // await controller.toggleVoiceInstruction(
    //   toggleType: newState ? SoundToggleType.all : SoundToggleType.none,
    // );
  }

  Future<void> muteOtherSounds({required bool mute}) async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.muteOtherSounds(
      mute: mute,
    );
  }

  Future<void> setNavigatorVolume({required int volume}) async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.setNavigatorVolume(
      volume: volume,
    );
  }
}

final pathNavSoundProviderProvider = _pathNavSoundProviderProvider;
