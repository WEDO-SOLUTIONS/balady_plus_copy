import 'dart:async';

import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/app_feedback_dio.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/send_offer_feedback_provider.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_feedback.g.dart';

enum AppFeedbackState { initial, loading, success, error }

@riverpod
class SendFeedback extends _$SendFeedback {
  @override
  Future<AppFeedbackState> build() async {
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
      await update((_) async => AppFeedbackState.error);
    }
  }

  Future<void> sendFeedback(AppFeedbackPayload payload) async {
    final source = payload.context?.feedbackSource;
    try {
      await update((_) async => AppFeedbackState.loading);

      if (source is FeedbackSourceOffer) {
        await _sendOfferFeedback(source.id, payload.review.stars, payload.review.text);
      } else {
        await _sendAppFeedback(payload);
      }

      await update((_) async => AppFeedbackState.success);
    } catch (e, st) {
      await update((_) async => AppFeedbackState.error);
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

  Future<void> _sendOfferFeedback(String offerId, int rating, String? text) async {
    final sendOfferFeedback = ref.watch(sendOfferFeedbackProvider(offerId).notifier);
    await sendOfferFeedback.send(rating, text);
  }
}
