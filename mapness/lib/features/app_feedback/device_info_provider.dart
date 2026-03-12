import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/insets_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info_provider.g.dart';

@riverpod
class DeviceInfo extends _$DeviceInfo {
  @override
  Future<AppFeedbackContext> build() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = isAndroid ? await deviceInfo.androidInfo : null;
    if (androidInfo != null) {
      InsetsUtils.androidSdkInt = androidInfo.version.sdkInt;
    }

    final mobileOs = isAndroid ? AppFeedbackMobileOs.android : AppFeedbackMobileOs.ios;
    final version = await _getAppVersion();
    final language = ref.read(appLanguageProvider) == Language.arabic ? AppFeedbackLocale.ar : AppFeedbackLocale.en;

    final auth = await ref.read(authProvider.future);
    final deviceId = await _getUniqDeviceString(defaultTargetPlatform, androidInfo: androidInfo);

    return AppFeedbackContext(
      locale: language,
      appVersion: version,
      mobileOS: mobileOs,
      authId: auth?.idNo,
      deviceId: deviceId,
    );
  }

  Future<String?> _getUniqDeviceString(TargetPlatform platform, {AndroidDeviceInfo? androidInfo}) async {
    final deviceInfo = DeviceInfoPlugin();
    if (platform == TargetPlatform.android) {
      final info = androidInfo ?? await deviceInfo.androidInfo;
      return 'android::${info.id}::${info.model}';
    } else if (platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
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
