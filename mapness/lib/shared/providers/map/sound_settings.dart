import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_settings.g.dart';

const _voiceInstructionIndexPrefsKey = 'voice_instruction_index';
const _muffleOtherSoundsPrefsKey = 'muffle_other_sounds';
const _promptsVolumeIndexPrefsKey = 'prompts_volume_index';
const _backgroundNavigationPrefsKey = 'background_navigation';
const _roadCamerasPrefsKey = 'road_cameras';
const _overSpeedingPrefsKey = 'over_speeding';
const _voicesLanguagePrefsKey = 'voices_language';

class SoundSettingsModel {
  final int voiceInstructionIndex;
  final bool muffleOtherSounds;
  final int promptsVolumeIndex;
  final bool backgroundNavigation;
  final bool roadCameras;
  final bool overSpeeding;
  final String voicesLanguage;

  const SoundSettingsModel({
    required this.voicesLanguage,
    this.voiceInstructionIndex = 2,
    this.muffleOtherSounds = false,
    this.promptsVolumeIndex = 2,
    this.backgroundNavigation = true,
    this.roadCameras = true,
    this.overSpeeding = true,
  });

  SoundSettingsModel copyWith({
    String? voicesLanguage,
    int? voiceInstructionIndex,
    bool? muffleOtherSounds,
    int? promptsVolumeIndex,
    bool? backgroundNavigation,
    bool? roadCameras,
    bool? overSpeeding,
    String? voiceName,
  }) =>
      SoundSettingsModel(
        voiceInstructionIndex: voiceInstructionIndex ?? this.voiceInstructionIndex,
        muffleOtherSounds: muffleOtherSounds ?? this.muffleOtherSounds,
        promptsVolumeIndex: promptsVolumeIndex ?? this.promptsVolumeIndex,
        backgroundNavigation: backgroundNavigation ?? this.backgroundNavigation,
        roadCameras: roadCameras ?? this.roadCameras,
        overSpeeding: overSpeeding ?? this.overSpeeding,
        voicesLanguage: voicesLanguage ?? this.voicesLanguage,
      );
}

@Riverpod(keepAlive: true)
class SoundSettings extends _$SoundSettings {
  static const _soundToggleTypesList = SoundToggleType.values;
  static const _promptsVolumeList = AudioVolumeMessage.values;

  @override
  SoundSettingsModel build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final language = ref.watch(appLanguageProvider);

    final voicesLanguage = sharedPrefs.getString(_voicesLanguagePrefsKey) ?? language.locale.languageCode;
    final prefsVoiceInstructionIndex = sharedPrefs.getInt(_voiceInstructionIndexPrefsKey);
    final prefsMuffleOtherSounds = sharedPrefs.getBool(_muffleOtherSoundsPrefsKey);
    final prefsPromptsVolumeIndex = sharedPrefs.getInt(_promptsVolumeIndexPrefsKey);
    final prefsBackgroundNavigation = sharedPrefs.getBool(_backgroundNavigationPrefsKey);
    final prefsRoadCameras = sharedPrefs.getBool(_roadCamerasPrefsKey);
    final prefsOverSpeeding = sharedPrefs.getBool(_overSpeedingPrefsKey);

    final _defaultSoundSettings = SoundSettingsModel(
      voicesLanguage: voicesLanguage,
    ).copyWith(
      voiceInstructionIndex: prefsVoiceInstructionIndex,
      muffleOtherSounds: prefsMuffleOtherSounds,
      promptsVolumeIndex: prefsPromptsVolumeIndex,
      backgroundNavigation: prefsBackgroundNavigation,
      roadCameras: prefsRoadCameras,
      overSpeeding: prefsOverSpeeding,
    );

    //toggleVoiceInstruction(currentVoiceInstruction: _defaultSoundSettings.voiceInstructionIndex);

    return _defaultSoundSettings;
  }

  Future<void> toggleRoadCameras({required bool roadCameras}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleRoadCameras(roadCameras: roadCameras);

    await ref.read(sharedPrefsProvider).setBool(_roadCamerasPrefsKey, roadCameras);

    state = state.copyWith(roadCameras: roadCameras);
  }

  Future<void> toggleOverSpeeding({required bool overSpeeding}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleOverSpeeding(overSpeeding: overSpeeding);

    await ref.read(sharedPrefsProvider).setBool(_overSpeedingPrefsKey, overSpeeding);

    state = state.copyWith(overSpeeding: overSpeeding);
  }

  Future<void> toggleMuteOtherSounds({required bool mute}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleOverSpeeding(overSpeeding: mute);

    await ref.read(sharedPrefsProvider).setBool(_muffleOtherSoundsPrefsKey, mute);

    state = state.copyWith(muffleOtherSounds: mute);
  }

  Future<void> toggleVoiceInstruction({required int currentVoiceInstruction}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleVoiceInstruction(toggleType: _soundToggleTypesList[currentVoiceInstruction]);

    await ref.read(sharedPrefsProvider).setInt(_voiceInstructionIndexPrefsKey, currentVoiceInstruction);

    state = state.copyWith(voiceInstructionIndex: currentVoiceInstruction);
  }

  Future<void> toggleNavigatorVolume({required int currentPromptVolumeIndex}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.setNavigatorVolume(volume: _promptsVolumeList[currentPromptVolumeIndex]);

    await ref.read(sharedPrefsProvider).setInt(_promptsVolumeIndexPrefsKey, currentPromptVolumeIndex);

    state = state.copyWith(promptsVolumeIndex: currentPromptVolumeIndex);
  }

  Future<void> switchLanguage({required String currentVoiceLanguage}) async {
    await ref.read(sharedPrefsProvider).setString(_voicesLanguagePrefsKey, currentVoiceLanguage);

    state = state.copyWith(voicesLanguage: currentVoiceLanguage);
  }
}
