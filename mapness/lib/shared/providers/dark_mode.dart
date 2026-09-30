import 'package:dart_suncalc/suncalc.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode.g.dart';

const _prefsKey = 'settings.darkModeName';

/// Default sunrise/sunset reference used when device location is unavailable.
/// Matches the outside-KSA fallback in [_Location._getLocation] (Riyadh).
/// Picked so that "Automatic" produces a sensible result before the user
/// grants location permission, instead of silently degrading to system mode.
const _fallbackLocation = LocationPoint(
  latitude: 24.712899222459676,
  longitude: 46.631036554650116,
);

enum DarkMapStateEnum {
  asInASystem,

  /// [autoSunDependent] - updates theme in sync with sunrise and sunset
  autoSunDependent,
  alwaysEnabled,
  off,
}

@immutable
class DarkMapStateModel {
  final bool isDark;
  final DarkMapStateEnum currentMapMode;

  const DarkMapStateModel({
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

  // Value equality: DarkMode rebuilds often (location precision changes, app resume, brightness changes) and
  // Riverpod notifies listeners whenever the new value is not `==` to the old one.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkMapStateModel && other.isDark == isDark && other.currentMapMode == currentMapMode;

  @override
  int get hashCode => Object.hash(isDark, currentMapMode);
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

    // Re-evaluate when the app is resumed from background — the user may have
    // crossed a sunrise/sunset boundary while the app was suspended.
    final lifecycle = AppLifecycleListener(
      onResume: () {
        debugPrint('[DarkModeDebug] app resumed — invalidating dark mode');
        ref.invalidateSelf();
      },
    );
    ref.onDispose(lifecycle.dispose);

    return DarkMapStateModel(
      currentMapMode: currentMode,
      isDark: currentIsDark,
    );
  }

  DarkMapStateEnum _getModeFromKey(String key) => DarkMapStateEnum.values.firstWhere((e) => e.name == key);

  bool _getIsDarkFromMode(DarkMapStateEnum mode, LocationPoint? location) {
    final isDark = switch (mode) {
      DarkMapStateEnum.asInASystem => isSystemDartMode,
      DarkMapStateEnum.alwaysEnabled => true,
      DarkMapStateEnum.autoSunDependent => _isLocationBasedDarkMode(location) ?? isSystemDartMode,
      DarkMapStateEnum.off => false,
    };
    debugPrint(
      '[DarkModeDebug] resolve mode=${mode.name} hasLocation=${location != null} isDark=$isDark',
    );
    return isDark;
  }

  bool? _isLocationBasedDarkMode(LocationPoint? location) {
    // Fall back to a fixed KSA coordinate when device location is unavailable.
    // Without this, fresh installs (permission not yet granted) silently
    // degrade Automatic to system brightness — indistinguishable from "On"
    // on a system-dark phone, which is the bug the tester reported.
    final reference = location ?? _fallbackLocation;
    final usingFallback = location == null;
    final sunriseAndSunset = _getSunriseAndSunset(reference);
    if (sunriseAndSunset == null) {
      debugPrint(
        '[DarkModeDebug] suncalc returned no sunrise/sunset for $reference (fallback=$usingFallback)',
      );
      return null;
    }
    final now = DateTime.now();
    final (sunrise, sunset) = sunriseAndSunset;
    final isDark = now.isBefore(sunrise) || now.isAfter(sunset);
    debugPrint(
      '[DarkModeDebug] auto resolve now=$now sunrise=$sunrise sunset=$sunset '
      'isDark=$isDark fallback=$usingFallback',
    );
    return isDark;
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
