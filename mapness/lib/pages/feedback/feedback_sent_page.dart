import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/feedback/submit_feedback.dart';
import 'package:mapness/features/feedback/submit_feedback_payload.dart';
import 'package:mapness/pages/feedback/feedback_sheet_widget.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

@RoutePage()
class FeedbackSentPage extends HookConsumerWidget {
  final String payloadId;

  const FeedbackSentPage({required this.payloadId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentFeedback = ref.watch(submitFeedbackProvider(payloadId));
    final payload = ref.watch(submitFeedbackPayloadProvider(payloadId));

    final isRetring = useState(false);

    void onRetry() {
      ref.invalidate(submitFeedbackProvider(payloadId));
      isRetring.value = true;
    }

    final state = sentFeedback.when(
      data: (data) {
        isRetring.value = false;
        return FeedbackSheetState.success;
      },
      loading: () => FeedbackSheetState.loading,
      error: (error, stack) {
        logger.log('Error submitting feedback: $error\nStacktrace:\n$stack', logLevel: MapnessLogLevel.critical);
        return FeedbackSheetState.failure;
      },
    );

    final hasPhotos = payload?.hasPhotos ?? false;

    return FeedbackSheetWidget(
      state: isRetring.value ? FeedbackSheetState.loading : state,
      onRetry: onRetry,
      hasPhotos: hasPhotos,
    );
  }
}
