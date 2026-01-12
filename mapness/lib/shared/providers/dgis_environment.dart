import 'dart:convert';

import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_environment.g.dart';

@riverpod
class DgisEnvironment extends _$DgisEnvironment {
  DgisEnv? _env;

  void setEnv(DgisEnv env) {
    _env = env;
    ref.invalidateSelf();
  }

  @override
  Future<EnvironmentConfig> build() async {
    final box = await ref.watch(hiveProvider(MapnessConstants.envConfigBoxKey).future);
    final envConfig = box.get(MapnessConstants.firebaseAppEnvConfigKey);
    final envType = box.get(MapnessConstants.envTypeKey);
    final envTypeJsonKey = _env?.name ?? envType;
    try {
      // ignore: avoid_dynamic_calls
      return EnvironmentConfig.fromJson(jsonDecode(envConfig)[envTypeJsonKey]);
    } catch (_, _) {
      logger.log('Error parsing environment config', logLevel: MapnessLogLevel.critical);
      return EnvironmentConfig.fromEnvType(envType);
    }
  }
}
