import 'dart:async';

import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/app_feedback_dio.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_feedback.g.dart';

enum AppFeedbackState { initial, loading, success, error }

@riverpod
class SendFeedback extends _$SendFeedback {
  @override
  AppFeedbackState build() {
    final collectFeedbackRef = ref.read(collectFeedbackProvider.notifier);

    ref
      ..listen(collectFeedbackProvider, (_, payload) {
        if (payload != null) {
          sendFeedback(payload);
        }
      })
      ..onDispose(() {
        collectFeedbackRef.dispose();
      });

    return AppFeedbackState.initial;
  }

  Future<void> retry() async {
    final payload = ref.read(collectFeedbackProvider);

    if (payload != null) {
      await sendFeedback(payload);
    } else {
      state = AppFeedbackState.error;
    }
  }

  Future<void> sendFeedback(AppFeedbackPayload payload) async {
    final source = payload.context?.feedbackSource;
    try {
      state = AppFeedbackState.loading;

      await _sendAppFeedback(payload);

      state = AppFeedbackState.success;
    } catch (e, st) {
      state = AppFeedbackState.error;
      logger.log('Failed to send feedback ${e.toString()}');
      Metrics.logException(e, st);
    }
  }

  Future<void> _sendAppFeedback(AppFeedbackPayload payload) async {
    final _feedbackDio = await ref.watch(appFeedbackDioProvider.future);
    await _feedbackDio.post(
      '/1.0/feedbacks',
      data: payload.toJson(),
    );
  }
}
