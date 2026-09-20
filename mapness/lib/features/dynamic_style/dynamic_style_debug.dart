import 'package:flutter/services.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_provider.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_service.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_style_debug.g.dart';

const _logTag = '[dynamic_style.debug]';

/// Debug-only presets for [DynamicStyleController].
///
/// Non-default modes produce a real repacked `.2gis` so the production
/// code path (`loadStylesFromPath` → SDK reload) gets exercised.
enum DynamicStyleDebugMode {
  /// Bundled `styles.2gis` from assets, no overrides.
  bundled,

  /// Replace every user-position model with `car_buhanka_fixed.glb`.
  carBuhanka,

  /// Replace every user-position model with `car_sport_fixed.glb`.
  carSport,

  /// Replace every user-position model with `car_fly_fixed.glb`.
  carFly,

  /// Replace every user-position model with `car_jeep_fixed.glb`.
  carJeep,

  /// Replace every user-position model with `utka_default_fixed.glb`.
  utkaDefault,

  /// Replace every user-position model with `utka_boss_fixed.glb`.
  utkaBoss,

  /// Replace every user-position model with `utka_getpack_fixed.glb`.
  utkaGetpack,
}

// The navigation car model slots. `styles.zss` binds these by exact filename
// and the SDK draws them ONLY during turn-by-turn car navigation (the static
// dashboard marker is a separate FOOT_GPS model, intentionally left untouched).
// So a swap here is visible only after starting car navigation.
const _carModelPaths = <String>[
  'zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb',
  'zmap/vidoc/models/night_DARK_THEME_CAR_MODEL.glb',
];

const _userModelsAssetDir = 'assets/maps/styles/user_models';

String? _customAssetFor(DynamicStyleDebugMode mode) {
  switch (mode) {
    case DynamicStyleDebugMode.carBuhanka:
      return '$_userModelsAssetDir/car_buhanka_fixed.glb';
    case DynamicStyleDebugMode.carSport:
      return '$_userModelsAssetDir/car_sport_fixed.glb';
    case DynamicStyleDebugMode.carFly:
      return '$_userModelsAssetDir/car_fly_fixed.glb';
    case DynamicStyleDebugMode.carJeep:
      return '$_userModelsAssetDir/car_jeep_fixed.glb';
    case DynamicStyleDebugMode.utkaDefault:
      return '$_userModelsAssetDir/utka_default_fixed.glb';
    case DynamicStyleDebugMode.utkaBoss:
      return '$_userModelsAssetDir/utka_boss_fixed.glb';
    case DynamicStyleDebugMode.utkaGetpack:
      return '$_userModelsAssetDir/utka_getpack_fixed.glb';
    case DynamicStyleDebugMode.bundled:
      return null;
  }
}

@Riverpod(keepAlive: true)
class DynamicStyleDebugController extends _$DynamicStyleDebugController {
  @override
  DynamicStyleDebugMode build() => DynamicStyleDebugMode.bundled;

  Future<void> select(DynamicStyleDebugMode mode) async {
    if (mode == state) {
      return;
    }
    final styleController = ref.read(dynamicStyleControllerProvider.notifier);
    logger.log('$_logTag select: $state → $mode');
    final sw = Stopwatch()..start();
    try {
      switch (mode) {
        case DynamicStyleDebugMode.bundled:
          await styleController.resetToBundled();
        case DynamicStyleDebugMode.carBuhanka:
        case DynamicStyleDebugMode.carSport:
        case DynamicStyleDebugMode.carFly:
        case DynamicStyleDebugMode.carJeep:
        case DynamicStyleDebugMode.utkaDefault:
        case DynamicStyleDebugMode.utkaBoss:
        case DynamicStyleDebugMode.utkaGetpack:
          final assetPath = _customAssetFor(mode)!;
          logger.log('$_logTag custom: loading asset $assetPath');
          final bytes = await _loadAssetBytes(assetPath);
          logger.log('$_logTag custom: asset ${bytes.length}B, applying to day+night car models');
          // Apply the same custom model to both day/night car slots so the
          // navigation car marker is theme-independent.
          await styleController.applyOverrides([
            for (final path in _carModelPaths) StyleEntryOverride(archivePath: path, bytes: bytes),
          ]);
      }
      state = mode;
      sw.stop();
      logger.log('$_logTag select: applied $mode in ${sw.elapsedMilliseconds}ms');
    } catch (e, st) {
      sw.stop();
      logger.log(
        '$_logTag select: FAILED $mode after ${sw.elapsedMilliseconds}ms: $e\n$st',
        logLevel: MapnessLogLevel.error,
      );
      rethrow;
    }
  }

  Future<Uint8List> _loadAssetBytes(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
