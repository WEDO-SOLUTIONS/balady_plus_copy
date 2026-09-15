import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collect_feedback.g.dart';

@riverpod
class CollectFeedback extends _$CollectFeedback {
  KeepAliveLink? _storeLink;

  @override
  AppFeedbackPayload? build() => null;

  Future<void> collectFeedback({required int stars, FeedbackSource? source, String? text, List<String>? tags}) async {
    final deviceContext = await ref.read(deviceInfoProvider.future);

    _storeLink?.close();
    _storeLink = ref.keepAlive();

    state = AppFeedbackPayload(
      review: AppFeedbackReview(stars: stars, tags: tags, text: text),
      context: deviceContext.copyWith(feedbackSource: source),
    );
  }

  void dispose() {
    _storeLink?.close();
  }
}

// mocktail's `Mock` is a class, not a mixin, and this has to be mixed in
// rather than extended because the generated `_$CollectFeedback` is already
// the superclass. Nor can the mock move to the test that uses it:
// `_$CollectFeedback` is private to this library. Same situation, and the same
// ignore, as MockDeviceInfoProvider in device_info_provider.dart.
// ignore: prefer_mixin
class MockCollectFeedback extends _$CollectFeedback with Mock implements CollectFeedback {}
