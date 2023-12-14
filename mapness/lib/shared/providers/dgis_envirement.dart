import 'package:mapness/shared/config/envirement_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_envirement.g.dart';

@riverpod
class DgisEnvirement extends _$DgisEnvirement {
  // Default value is Pre prod
  DgisEnv _env = DgisEnv.preProd;

  void setPreprod() {
    _env = DgisEnv.preProd;
    ref.invalidateSelf();
  }

  void setDev() {
    _env = DgisEnv.dev;
    ref.invalidateSelf();
  }

  void setMomrahProd() {
    _env = DgisEnv.momrahProd;
    ref.invalidateSelf();
  }

  void setMomrahStaging() {
    _env = DgisEnv.momrahStaging;
    ref.invalidateSelf();
  }

  @override
  EnvirementConfig build() {
    return switch (_env) {
      DgisEnv.preProd => EnvirementConfig.preProd(),
      DgisEnv.dev => EnvirementConfig.dev(),
      DgisEnv.momrahProd => EnvirementConfig.momrahProd(),
      DgisEnv.momrahStaging => EnvirementConfig.momrahStaging(),
    };
  }
}
