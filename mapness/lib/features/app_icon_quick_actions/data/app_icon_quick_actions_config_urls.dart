import 'package:mapness/shared/config/environment_config.dart';

/// Remote URLs for the Balady+ Quick Actions configuration service (BRD User Story #1 publish endpoint).
class AppIconQuickActionsConfigUrls {
  AppIconQuickActionsConfigUrls._();

  static String getConfigUrl(EnvironmentConfig env) => '${env.appFeedbackApi}/mobile/quick-actions/config';

  static String getConfigUrlForEnv(DgisEnv env) => getConfigUrl(env.getConfig());
}
