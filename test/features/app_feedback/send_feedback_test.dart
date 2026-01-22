import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/app_feedback_dio.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAppFeedbackPayload extends Mock implements AppFeedbackPayload {
  @override
  Map<String, dynamic> toJson() => {};
}

void main() {
  group('Send feedback tests', () {
    late ProviderContainer container;
    late MockDio mockDio;
    late MockAppFeedbackPayload mockPayload;
    late CollectFeedback mockCollectFeedback;

    setUp(() {
      container = ProviderContainer();
      mockDio = MockDio();
      mockPayload = MockAppFeedbackPayload();
      mockCollectFeedback = MockCollectFeedback();

      container = ProviderContainer(overrides: [
        appFeedbackDioProvider.overrideWith((_) => mockDio),
        collectFeedbackProvider.overrideWith(() => mockCollectFeedback),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('Send feedback init values', () async {
      final state = container.read(sendFeedbackProvider);

      expect(state, isNotNull);
      expect(state, AppFeedbackState.initial);
    });

    test('Send feedback success', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions()));

      await container.read(sendFeedbackProvider.notifier).sendFeedback(mockPayload);

      final state = container.read(sendFeedbackProvider);
      expect(state, isNotNull);
      expect(state, AppFeedbackState.success);
    });

    test('Send feedback error', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      await container.read(sendFeedbackProvider.notifier).sendFeedback(mockPayload);

      final state = container.read(sendFeedbackProvider);
      expect(state, AppFeedbackState.error);
    });

    test('Send feedback empty Payload', () async {
      when(() => mockCollectFeedback.build()).thenReturn(null);

      await container.read(sendFeedbackProvider.notifier).sendFeedback(mockPayload);

      final state = container.read(sendFeedbackProvider);
      expect(state, AppFeedbackState.error);
    });

    test('retry feedback empty Payload', () async {
      when(() => mockCollectFeedback.build()).thenReturn(null);

      await container.read(sendFeedbackProvider.notifier).retry();

      final state = container.read(sendFeedbackProvider);
      expect(state, AppFeedbackState.error);
    });

    test('Send feedback with not initialized dio', () async {
      final nullDioContainer = ProviderContainer(overrides: [
        // ignore: null_argument_to_non_null_type
        appFeedbackDioProvider.overrideWith((_) => Future.value(null)),
        collectFeedbackProvider.overrideWith(() => mockCollectFeedback),
      ]);

      await nullDioContainer.read(sendFeedbackProvider.notifier).sendFeedback(mockPayload);

      final state = nullDioContainer.read(sendFeedbackProvider);

      nullDioContainer.dispose();
      expect(state, AppFeedbackState.error);
    });

    test('Send feedback flow states', () async {
      when(() => mockCollectFeedback.build()).thenReturn(mockPayload);

      final List<AppFeedbackState> states = [];

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions()));

      container.listen(sendFeedbackProvider, (_, state) {
        states.add(state);
      }, fireImmediately: true);

      await container.read(sendFeedbackProvider.notifier).sendFeedback(mockPayload);
      await container.read(sendFeedbackProvider.notifier).retry();

      expect(states, [
        AppFeedbackState.initial,
        AppFeedbackState.loading,
        AppFeedbackState.success,
        AppFeedbackState.loading,
        AppFeedbackState.success
      ]);
    });
  });
}
