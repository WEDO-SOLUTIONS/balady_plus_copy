import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/hive.dart';
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
    final box = await ref.watch(hiveProvider('envType').future);
    final envType = box.get('envType');

    final env = _env ??
        switch (envType) {
          'dev' => DgisEnv.urbiDev,
          'stg' => DgisEnv.momrahStaging,
          'pre' => DgisEnv.urbiPreprod,
          'prod' => DgisEnv.momrahProd,
          'urbiPre' => DgisEnv.urbiPreprod,
          _ => DgisEnv.urbiPreprod,
        };
    return env.getConfig();
  }
}
