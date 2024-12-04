import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collect_feedback.g.dart';

@riverpod
class CollectFeedback extends _$CollectFeedback {
  KeepAliveLink? _storeLink;

  @override
  AppFeedbackPayload? build() => null;

  Future<String> getDeviceIdentifier() async {
    String deviceIdentifier = 'unknown';
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = 'android::${androidInfo.serialNumber}::${androidInfo.id}::${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor ?? 'unknown';
    }
    return deviceIdentifier;
  }

  Future<void> collectFeedback({required int stars, String? text, List<String>? tags, FeedbackSource? source}) async {
    final isAndroid = Platform.isAndroid;
    final packageInfo = await PackageInfo.fromPlatform();

    final mobileOs = isAndroid ? AppFeedbackMobileOs.android : AppFeedbackMobileOs.ios;
    final version = packageInfo.version;
    final language = ref.read(appLanguageProvider) == Language.arabic ? AppFeedbackLocale.ar : AppFeedbackLocale.en;

    final auth = await ref.read(authProvider.future);
    final deviceId = await getDeviceIdentifier();

    _storeLink?.close();
    _storeLink = ref.keepAlive();

    state = AppFeedbackPayload(
      review: AppFeedbackReview(
        stars: stars,
        tags: tags,
        text: text,
      ),
      context: AppFeedbackContext(
        locale: language,
        appVersion: version,
        mobileOS: mobileOs,
        authId: auth?.idNo,
        deviceId: deviceId,
        feedbackSource: source,
      ),
    );
  }

  void dispose() {
    _storeLink?.close();
  }
}
