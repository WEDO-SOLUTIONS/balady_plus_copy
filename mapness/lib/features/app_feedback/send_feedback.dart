import 'dart:async';

import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/app_feedback_dio.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_feedback.g.dart';

enum AppFeedbackState { initial, loading, success }

@riverpod
class SendFeedback extends _$SendFeedback {
  AppFeedbackPayload? _feedbackPayload;
  @override
  Future<AppFeedbackState> build() async {
    _feedbackPayload = ref.watch(collectFeedbackProvider);

    ref.onDispose(() {
      ref.read(collectFeedbackProvider.notifier).dispose();
    });

    return AppFeedbackState.initial;
  }

  Future<void> sendFeedback() async {
    final feedbackDio = await ref.read(appFeedbackDioProvider.future);

    try {
      if (_feedbackPayload == null) {
        throw Exception('Feedback payload is null');
      }

      await update((_) async => AppFeedbackState.loading);

      await feedbackDio.post(
        '/1.0/feedbacks',
        data: _feedbackPayload!.toJson(),
      );

      await update((_) async => AppFeedbackState.success);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
