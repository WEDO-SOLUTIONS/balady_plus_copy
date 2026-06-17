import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/data/app_analytics_insider_impl.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_analytics.g.dart';

@riverpod
class AppAnalytics extends _$AppAnalytics {
  @override
  AppAnalyticsRepository build() {
    final auth = ref.watch(authProvider.future);
    final analytics = stateOrNull ?? AppAnalyticsInsiderImpl();
    final locale = ref.watch(appLanguageProvider).languageCode;
    final deviceInfo = ref.watch(deviceInfoProvider.future);
    Future(() async {
      final authValue = await auth;
      final deviceInfoValue = await deviceInfo;

      analytics.setUserInfo(
        email: authValue?.getEmail(),
        locale: locale,
        deviceId: deviceInfoValue.deviceId,
        deviceOs: deviceInfoValue.mobileOS?.name,
        appVersion: deviceInfoValue.appVersion,
      );
    });

    return analytics;
  }
}
