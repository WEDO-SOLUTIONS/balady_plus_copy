import 'package:flutter/foundation.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info_provider.g.dart';

@Riverpod(keepAlive: true)
class DeviceInfo extends _$DeviceInfo {
  @override
  Future<AppFeedbackContext> build() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    // Read all ref-dependent values BEFORE any async gap to avoid
    // "Cannot use Ref after disposal" errors.
    final languageState = ref.read(appLanguageProvider);
    final authFuture = ref.read(authProvider.future);
    // Persisted per-install UUID — generated identically on iOS and Android
    // (uuid v4 stored in shared prefs). This replaces the old platform-divergent
    // device string (iOS `identifierForVendor` vs Android `id::model`, the
    // latter not even unique per device) so the device identity has the same
    // shape everywhere.
    final uniqueDeviceId = ref.read(uuidProviderProvider);
    final mobileOs = isAndroid ? AppFeedbackMobileOs.android : AppFeedbackMobileOs.ios;
    final version = await _getAppVersion();
    final language = languageState == Language.arabic ? AppFeedbackLocale.ar : AppFeedbackLocale.en;

    final auth = await authFuture;
    final deviceId = uniqueDeviceId;

    return AppFeedbackContext(
      locale: language,
      appVersion: version,
      mobileOS: mobileOs,
      authId: auth?.idNo,
      deviceId: deviceId,
    );
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

// ignore: prefer_mixin
class MockDeviceInfoProvider extends _$DeviceInfo with Mock implements DeviceInfo {
  @override
  Future<AppFeedbackContext> build() => Future.value(
    AppFeedbackContext(
      locale: AppFeedbackLocale.en,
      appVersion: '1.0.0',
      mobileOS: AppFeedbackMobileOs.android,
      authId: '123',
      deviceId: 'android::serial123::id123::Pixel 4',
    ),
  );
}
