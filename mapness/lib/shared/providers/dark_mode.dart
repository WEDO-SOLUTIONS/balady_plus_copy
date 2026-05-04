import 'dart:ui';

import 'package:dart_suncalc/suncalc.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode.g.dart';

const _prefsKey = 'settings.darkModeName';

enum DarkMapStateEnum {
  asInASystem,

  /// [autoSunDependent] - updates theme in sync with sunrise and sunset
  autoSunDependent,
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
  }) => DarkMapStateModel(
    isDark: isDark ?? this.isDark,
    currentMapMode: currentMapMode ?? this.currentMapMode,
  );
}

@Riverpod(keepAlive: true)
class DarkMode extends _$DarkMode {
  final _locationProvider = locationWithPrecisionProvider(decimalPlaces: 3);

  @override
  Future<DarkMapStateModel> build() async {
    final location = ref.watch(_locationProvider);
    final sharedPrefs = await ref.read($asyncPrefsLoaderProvider.future);
    final modeKey = sharedPrefs.getString(_prefsKey) ?? DarkMapStateEnum.asInASystem.name;
    final currentMode = _getModeFromKey(modeKey);
    final currentIsDark = _getIsDarkFromMode(currentMode, location);

    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () => ref.invalidateSelf();

    return DarkMapStateModel(
      currentMapMode: currentMode,
      isDark: currentIsDark,
    );
  }

  DarkMapStateEnum _getModeFromKey(String key) => DarkMapStateEnum.values.firstWhere((e) => e.name == key);

  bool _getIsDarkFromMode(DarkMapStateEnum mode, LocationPoint? location) => switch (mode) {
    DarkMapStateEnum.asInASystem => isSystemDartMode,
    DarkMapStateEnum.alwaysEnabled => true,
    DarkMapStateEnum.autoSunDependent => _isLocationBasedDarkMode(location) ?? isSystemDartMode,
    DarkMapStateEnum.off => false,
  };

  bool? _isLocationBasedDarkMode(LocationPoint? location) {
    if (location == null) {
      return null;
    }
    final sunriseAndSunset = _getSunriseAndSunset(location);
    if (sunriseAndSunset == null) {
      return null;
    }
    final now = DateTime.now();
    final (sunrise, sunset) = sunriseAndSunset;
    return now.isBefore(sunrise) || now.isAfter(sunset);
  }

  bool get isSystemDartMode => SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  void changeDarkModeState(DarkMapStateEnum currentMapMode) {
    final location = ref.read(_locationProvider);
    final isDark = _getIsDarkFromMode(currentMapMode, location);

    final stateData = state.value;
    if (stateData == null) {
      state = AsyncData(
        DarkMapStateModel(
          isDark: isDark,
          currentMapMode: currentMapMode,
        ),
      );
    } else {
      state = AsyncData(
        stateData.copyWith(
          isDark: isDark,
          currentMapMode: currentMapMode,
        ),
      );
    }

    ref
        .read(sharedPrefsProvider)
        .setString(
          _prefsKey,
          currentMapMode.name,
        );
  }

  (DateTime, DateTime)? _getSunriseAndSunset(LocationPoint location) {
    final times = SunCalc.getTimes(DateTime.now(), lat: location.latitude, lng: location.longitude);
    final sunrise = times.sunrise;
    final sunset = times.sunset;
    if (sunrise == null || sunset == null) {
      return null;
    }

    return (sunrise, sunset);
  }
}
