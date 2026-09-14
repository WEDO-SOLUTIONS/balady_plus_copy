import 'dart:convert';

import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_environment.g.dart';

/// Key for storing debug environment override in Hive.
/// Separate from envTypeKey to avoid overwriting the original config.
const _debugEnvOverrideKey = 'debugEnvOverrideKey';

@riverpod
class DgisEnvironment extends _$DgisEnvironment {
  /// Sets a debug environment override and persists it to storage.
  Future<void> setEnv(DgisEnv env) async {
    final box = await ref.read(hiveProvider(MapnessConstants.envConfigBoxKey).future);
    await box.put(_debugEnvOverrideKey, env.name);
    ref.invalidateSelf();
    // Also invalidate the env type provider so UI updates
    ref.invalidate(dgisEnvTypeProvider);
  }

  @override
  Future<EnvironmentConfig> build() async {
    final box = await ref.watch(hiveProvider(MapnessConstants.envConfigBoxKey).future);
    final envConfig = box.get(MapnessConstants.firebaseAppEnvConfigKey);
    final envType = box.get(MapnessConstants.envTypeKey) as String?;
    // Check for debug override first, then fall back to original envType
    final debugOverride = box.get(_debugEnvOverrideKey) as String?;
    final envTypeJsonKey = debugOverride ?? envType;
    try {
      // ignore: avoid_dynamic_calls
      return EnvironmentConfig.fromJson(jsonDecode(envConfig)[envTypeJsonKey]);
    } catch (_) {
      logger.log('Error parsing environment config', logLevel: MapnessLogLevel.critical);
      return EnvironmentConfig.fromEnvType(envTypeJsonKey ?? envType ?? 'momrahProd');
    }
  }
}

/// Provider that returns the current environment type (for debug UI).
@riverpod
Future<DgisEnv> dgisEnvType(Ref ref) async {
  final box = await ref.watch(hiveProvider(MapnessConstants.envConfigBoxKey).future);
  final envType = box.get(MapnessConstants.envTypeKey) as String?;
  final debugOverride = box.get(_debugEnvOverrideKey) as String?;
  final envTypeKey = debugOverride ?? envType;

  return DgisEnv.values.firstWhere(
    (e) => e.name == envTypeKey,
    orElse: () => DgisEnv.momrahProd,
  );
}
