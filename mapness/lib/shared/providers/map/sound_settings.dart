import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dgis_packages.dart';

part 'sound_settings.g.dart';

class SoundSettingsModel {
  /// Index of list from enum SoundToggleType, default value is SoundToggleType.all
  final int voiceInstructionIndex;

  /// Value of toggle Muffle others sound, this function now unavailable
  final bool muffleOtherSounds;

  /// Index of list from enum AudioVolumeMessage, default value is AudioVolumeMessage.standard
  final int promptsVolumeIndex;

  /// Value of toggle Background navigation, if true - in AppState.paused, maneuvers will be voiced, if false - maneuvers will be muted
  final bool backgroundNavigation;

  /// Value of toggle Road cameras, if true - camera alerts will be voiced, if false - camera alerts will be muted
  final bool roadCameras;

  /// Value of toggle Over speeding, if true - over speeding alerts will be voiced, if false - over speeding alerts will be muted
  final bool overSpeeding;

  /// Current voice language code, if value wasn't picked before, it takes value from app language
  final String voicesLanguage;

  /// List of English installed voices on device
  final List<PackageMessage> englishInstalledVoices;

  /// List of English available for download voices
  final List<PackageMessage> englishUnInstalledVoices;

  /// List of Arabic installed voices on device
  final List<PackageMessage> arabicInstalledVoices;

  /// List of Arabic available for download voices
  final List<PackageMessage> arabicUnInstalledVoices;

  /// Current voice of assistant
  final String? voiceName;

  const SoundSettingsModel({
    required this.voicesLanguage,
    required this.englishInstalledVoices,
    required this.englishUnInstalledVoices,
    required this.arabicInstalledVoices,
    required this.arabicUnInstalledVoices,
    this.voiceInstructionIndex = 0,
    this.muffleOtherSounds = false,
    this.promptsVolumeIndex = 2,
    this.backgroundNavigation = true,
    this.roadCameras = true,
    this.overSpeeding = true,
    this.voiceName,
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
    List<PackageMessage>? englishInstalledVoices,
    List<PackageMessage>? englishUnInstalledVoices,
    List<PackageMessage>? arabicInstalledVoices,
    List<PackageMessage>? arabicUnInstalledVoices,
  }) =>
      SoundSettingsModel(
        voiceInstructionIndex: voiceInstructionIndex ?? this.voiceInstructionIndex,
        muffleOtherSounds: muffleOtherSounds ?? this.muffleOtherSounds,
        promptsVolumeIndex: promptsVolumeIndex ?? this.promptsVolumeIndex,
        backgroundNavigation: backgroundNavigation ?? this.backgroundNavigation,
        roadCameras: roadCameras ?? this.roadCameras,
        overSpeeding: overSpeeding ?? this.overSpeeding,
        voicesLanguage: voicesLanguage ?? this.voicesLanguage,
        voiceName: voiceName ?? this.voiceName,
        englishInstalledVoices: englishInstalledVoices ?? this.englishInstalledVoices,
        englishUnInstalledVoices: englishUnInstalledVoices ?? this.englishUnInstalledVoices,
        arabicInstalledVoices: arabicInstalledVoices ?? this.arabicInstalledVoices,
        arabicUnInstalledVoices: arabicUnInstalledVoices ?? this.arabicUnInstalledVoices,
      );
}

@Riverpod(keepAlive: true)
class SoundSettings extends _$SoundSettings {
  static const _soundToggleTypesList = SoundToggleType.values;
  static const _promptsVolumeList = [10, 30, 60];
  StreamSubscription? _soundEventsSubscription;
  StreamSubscription? _carPlaySoundSubscription;

  SoundToggleType get currentSoundToggleType => SoundToggleType.values[state.voiceInstructionIndex];

  @override
  SoundSettingsModel build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final language = ref.watch(appLanguageProvider);
    String? voiceName;

    final selectedVoice = ref.watch(navigatorVoiceProvider);

    final voicePackages = ref.watch(voicePackagesProvider);

    if (voicePackages.isNotEmpty) {
      voiceName = voicePackages.map((e) => e.packageMessage).firstWhere((e) => e.id == selectedVoice).info.name;
    }

    final englishInstalledVoices = <PackageMessage>[];
    final englishUnInstalledVoices = <PackageMessage>[];

    final arabicInstalledVoices = <PackageMessage>[];
    final arabicUnInstalledVoices = <PackageMessage>[];

    final voicesLanguage = sharedPrefs.getString(MapnessConstants.voicesLanguagePrefsKey) ?? language.languageCode;
    final prefsVoiceInstructionIndex = sharedPrefs.getInt(MapnessConstants.voiceInstructionIndexPrefsKey);
    final prefsMuffleOtherSounds = sharedPrefs.getBool(MapnessConstants.muffleOtherSoundsPrefsKey);
    final prefsPromptsVolumeIndex = sharedPrefs.getInt(MapnessConstants.promptsVolumeIndexPrefsKey);
    final prefsBackgroundNavigation = sharedPrefs.getBool(MapnessConstants.backgroundNavigationPrefsKey);
    final prefsRoadCameras = sharedPrefs.getBool(MapnessConstants.roadCamerasPrefsKey);
    final prefsOverSpeeding = sharedPrefs.getBool(MapnessConstants.overSpeedingPrefsKey);

    for (final package in voicePackages) {
      if (Language.parceString(package.language)?.isEnglish == true) {
        if (package.packageMessage.info.installed) {
          englishInstalledVoices.add(package.packageMessage);
        } else {
          englishUnInstalledVoices.add(package.packageMessage);
        }
      } else if (Language.parceString(package.language)?.isArabic == true) {
        if (package.packageMessage.info.installed) {
          arabicInstalledVoices.add(package.packageMessage);
        } else {
          arabicUnInstalledVoices.add(package.packageMessage);
        }
      }
    }

    final _defaultSoundSettings = SoundSettingsModel(
      voicesLanguage: voicesLanguage,
      englishInstalledVoices: englishInstalledVoices,
      englishUnInstalledVoices: englishUnInstalledVoices,
      arabicInstalledVoices: arabicInstalledVoices,
      arabicUnInstalledVoices: arabicUnInstalledVoices,
    ).copyWith(
      voiceInstructionIndex: prefsVoiceInstructionIndex,
      muffleOtherSounds: prefsMuffleOtherSounds,
      promptsVolumeIndex: prefsPromptsVolumeIndex,
      backgroundNavigation: prefsBackgroundNavigation,
      roadCameras: prefsRoadCameras,
      overSpeeding: prefsOverSpeeding,
      voiceName: voiceName,
    );

    toggleVoiceInstruction(currentVoiceInstruction: _defaultSoundSettings.voiceInstructionIndex);
    // Only apply overSpeeding/roadCameras if voice instruction is not NONE.
    // When voice is NONE, all sound categories are cleared — re-applying these
    // would add categories back and re-enable partial sound output.
    if (_soundToggleTypesList[_defaultSoundSettings.voiceInstructionIndex] != SoundToggleType.none) {
      toggleOverSpeeding(overSpeeding: _defaultSoundSettings.overSpeeding);
      toggleRoadCameras(roadCameras: _defaultSoundSettings.roadCameras);
    }
    toggleNavigatorVolume(currentPromptVolumeIndex: _defaultSoundSettings.promptsVolumeIndex);
    toggleBackgroundNavigation(backgroundNavigation: _defaultSoundSettings.backgroundNavigation);

    // Subscribe to sound events from CarPlay or Android Auto
    _subscribeToSoundEvents();

    // Subscribe to CarPlay plugin-level method channel for sound changes.
    // Unlike the view-specific EventChannel, this works on real CarPlay
    // devices where the phone scene may be backgrounded.
    _subscribeToCarPlaySoundChannel();

    ref.onDispose(() {
      _soundEventsSubscription?.cancel();
      _carPlaySoundSubscription?.cancel();
    });

    return _defaultSoundSettings;
  }

  Future<void> _subscribeToSoundEvents() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    await _soundEventsSubscription?.cancel();
    _soundEventsSubscription = dgisController.soundOnEvents.listen(_handleSoundEvent);
  }

  void _subscribeToCarPlaySoundChannel() {
    _carPlaySoundSubscription?.cancel();
    _carPlaySoundSubscription = CarPlaySoundChannel.instance.soundChangedEvents.listen((isSoundEnabled) {
      final index = SoundToggleType.values.indexOf(isSoundEnabled ? SoundToggleType.all : SoundToggleType.none);
      toggleVoiceInstruction(currentVoiceInstruction: index);
    });
  }

  Future<void> _handleSoundEvent(SoundOnEvent soundOn) async {
    final index = SoundToggleType.values.indexOf(soundOn.value ? SoundToggleType.all : SoundToggleType.none);
    // Sync sound state with the phone-side SDK components (NavigationHandler/DashboardControlModel).
    // CarPlay/Android Auto already set the NavigationManager's enabledSoundCategories directly,
    // but we must also propagate via toggleVoiceInstruction so the phone-side DashboardControlModel
    // stays in sync — otherwise toggleOverSpeeding/toggleRoadCameras can re-enable categories.
    await toggleVoiceInstruction(currentVoiceInstruction: index);
  }

  Future<void> toggleRoadCameras({required bool roadCameras}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleRoadCameras(roadCameras: roadCameras);

    await ref.read(sharedPrefsProvider).setBool(MapnessConstants.roadCamerasPrefsKey, roadCameras);

    state = state.copyWith(roadCameras: roadCameras);
  }

  Future<void> toggleOverSpeeding({required bool overSpeeding}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleOverSpeeding(overSpeeding: overSpeeding);

    await ref.read(sharedPrefsProvider).setBool(MapnessConstants.overSpeedingPrefsKey, overSpeeding);

    state = state.copyWith(overSpeeding: overSpeeding);
  }

  Future<void> toggleMuteOtherSounds({required bool mute}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleOverSpeeding(overSpeeding: mute);

    await ref.read(sharedPrefsProvider).setBool(MapnessConstants.muffleOtherSoundsPrefsKey, mute);

    state = state.copyWith(muffleOtherSounds: mute);
  }

  Future<void> toggleVoiceInstruction({required int currentVoiceInstruction}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);
    final toggleType = _soundToggleTypesList[currentVoiceInstruction];

    await dGisController.toggleVoiceInstruction(toggleType: toggleType);

    // When voice is set to NONE, ensure overSpeeding and roadCameras are also
    // disabled on the SDK side. Otherwise their categories remain enabled and
    // partial sound output continues even though voice instruction is NONE.
    // When voice is re-enabled, restore overSpeeding and roadCameras settings.
    if (toggleType == SoundToggleType.none) {
      await dGisController.toggleOverSpeeding(overSpeeding: false);
      await dGisController.toggleRoadCameras(roadCameras: false);
    } else {
      await dGisController.toggleOverSpeeding(overSpeeding: state.overSpeeding);
      await dGisController.toggleRoadCameras(roadCameras: state.roadCameras);
    }

    await ref.read(sharedPrefsProvider).setInt(MapnessConstants.voiceInstructionIndexPrefsKey, currentVoiceInstruction);

    state = state.copyWith(voiceInstructionIndex: currentVoiceInstruction);
  }

  Future<void> toggleNavigatorVolume({required int currentPromptVolumeIndex}) async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.setNavigatorVolume(volume: _promptsVolumeList[currentPromptVolumeIndex]);

    await ref.read(sharedPrefsProvider).setInt(MapnessConstants.promptsVolumeIndexPrefsKey, currentPromptVolumeIndex);

    state = state.copyWith(promptsVolumeIndex: currentPromptVolumeIndex);
  }

  Future<void> switchLanguage({required String currentVoiceLanguage}) async {
    await ref.read(sharedPrefsProvider).setString(MapnessConstants.voicesLanguagePrefsKey, currentVoiceLanguage);

    state = state.copyWith(voicesLanguage: currentVoiceLanguage);
    ref.invalidateSelf();
    if (state.englishInstalledVoices.isNotEmpty) {
      ref.read(navigatorVoiceProvider.notifier).update(state.englishInstalledVoices.first.id);
    }
  }

  Future<void> toggleBackgroundNavigation({required bool backgroundNavigation}) async {
    await ref.read(sharedPrefsProvider).setBool(MapnessConstants.backgroundNavigationPrefsKey, backgroundNavigation);

    state = state.copyWith(backgroundNavigation: backgroundNavigation);
  }

  Future<void> muteNavigationSound() async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleVoiceInstruction(toggleType: SoundToggleType.none);
  }

  Future<void> restoreNavigationSound() async {
    final dGisController = await ref.watch(dgisControllerProvider.future);

    await dGisController.toggleVoiceInstruction(toggleType: _soundToggleTypesList[state.voiceInstructionIndex]);
  }

  /// Re-reads voice instruction index from SharedPreferences (after reload)
  /// and applies it if it differs from the current in-memory state.
  /// Call this when the app resumes from background so that changes
  /// made by CarPlay/Android Auto (which write directly to UserDefaults)
  /// are picked up by Flutter.
  Future<void> syncFromPersistence() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    // Reload picks up values written externally (e.g. by CarPlay native code)
    await sharedPrefs.reload();
    final persistedIndex = sharedPrefs.getInt(MapnessConstants.voiceInstructionIndexPrefsKey) ?? 0;
    if (persistedIndex != state.voiceInstructionIndex) {
      await toggleVoiceInstruction(currentVoiceInstruction: persistedIndex);
    }
  }
}
