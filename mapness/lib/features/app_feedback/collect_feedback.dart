import 'dart:io';

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

  Future<void> collectFeedback(String reviewText) async {
    final isAndroid = Platform.isAndroid;
    final packageInfo = await PackageInfo.fromPlatform();

    final mobileOs = isAndroid ? AppFeedbackMobileOs.android : AppFeedbackMobileOs.ios;
    final version = packageInfo.version;
    final language = ref.read(appLanguageProvider) == Language.arabic ? AppFeedbackLocale.ar : AppFeedbackLocale.en;

    final auth = await ref.read(authProvider.future);

    _storeLink?.close();
    _storeLink = ref.keepAlive();

    state = AppFeedbackPayload(
      reviewText: reviewText,
      context: AppFeedbackContext(
        locale: language,
        appVersion: version,
        mobileOS: mobileOs,
        authId: auth?.idNo,
      ),
    );
  }

  void dispose() {
    _storeLink?.close();
  }
}
