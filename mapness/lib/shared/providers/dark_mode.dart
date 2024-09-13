import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode.g.dart';

const _prefsKey = 'settings.darkMode';

enum DarkMapStateEnum {
  asInASystem,
  alwaysEnabled,
  off,
}

class DarkMapStateModel {
  final bool isDark;
  final DarkMapStateEnum currentMapMode;

  DarkMapStateModel({
    required this.isDark,
    required this.currentMapMode,
  });

  DarkMapStateModel copyWith({
    bool? isDark,
    DarkMapStateEnum? currentMapMode,
  }) =>
      DarkMapStateModel(
        isDark: isDark ?? this.isDark,
        currentMapMode: currentMapMode ?? this.currentMapMode,
      );
}

@Riverpod(keepAlive: true)
class DarkMode extends _$DarkMode {
  @override
  DarkMapStateModel build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final modeKey = sharedPrefs.getString(_prefsKey) ?? DarkMapStateEnum.asInASystem.name;
    final currentMode = _getModeFromKey(modeKey);
    final currentIsDark = _getIsDarkFromMode(currentMode);

    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () => ref.invalidateSelf();

    return DarkMapStateModel(
      currentMapMode: currentMode,
      isDark: currentIsDark,
    );
  }

  DarkMapStateEnum _getModeFromKey(String key) => DarkMapStateEnum.values.firstWhere((e) => e.name == key);

  bool _getIsDarkFromMode(DarkMapStateEnum mode) => switch (mode) {
        DarkMapStateEnum.asInASystem =>
          SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
        DarkMapStateEnum.alwaysEnabled => true,
        DarkMapStateEnum.off => false,
      };

  void changeDarkModeState(DarkMapStateEnum currentMapMode) {
    final isDark = _getIsDarkFromMode(currentMapMode);

    state = state.copyWith(
      isDark: isDark,
      currentMapMode: currentMapMode,
    );

    ref.read(sharedPrefsProvider).setString(_prefsKey, state.currentMapMode.name);
  }
}
