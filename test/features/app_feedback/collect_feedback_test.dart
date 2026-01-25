// Импорт необходимых пакетов
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';

void main() {
  group('CollectFeedback Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    test('collectFeedback sets state with correct values', () async {
      container = ProviderContainer(overrides: [
        deviceInfoProvider.overrideWith(MockDeviceInfoProvider.new),
      ]);

      await container.read(collectFeedbackProvider.notifier).collectFeedback(
            stars: 5,
            text: 'Good app!',
            tags: ['fast', 'friendly'],
            source: const FeedbackSource.main(),
          );

      final state = container.read(collectFeedbackProvider);

      expect(state, isNotNull);
      expect(state?.review.stars, 5);
      expect(state?.review.text, 'Good app!');
      expect(state?.review.tags, ['fast', 'friendly']);
      expect(state?.context?.locale, AppFeedbackLocale.en);
      expect(state?.context?.appVersion, '1.0.0');
      expect(state?.context?.mobileOS, AppFeedbackMobileOs.android);
      expect(state?.context?.deviceId, 'android::serial123::id123::Pixel 4');
      expect(state?.context?.feedbackSource, const FeedbackSource.main());
      expect(state?.context?.authId, '123');
    });
  });
}
