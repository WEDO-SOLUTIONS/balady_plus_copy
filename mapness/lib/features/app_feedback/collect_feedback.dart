import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
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

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = 'android::${androidInfo.serialNumber}::${androidInfo.id}::${androidInfo.model}';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor ?? 'unknown';
    }
    return deviceIdentifier;
  }

  Future<void> collectFeedback({required int stars, String? text, List<String>? tags, FeedbackSource? source}) async {
    final deviceContext = await ref.read(deviceInfoProvider.future);

    _storeLink?.close();
    _storeLink = ref.keepAlive();

    state = AppFeedbackPayload(
      review: AppFeedbackReview(
        stars: stars,
        tags: tags,
        text: text,
      ),
      context: deviceContext.copyWith(
        feedbackSource: source,
      ),
    );
  }

  void dispose() {
    _storeLink?.close();
  }
}
