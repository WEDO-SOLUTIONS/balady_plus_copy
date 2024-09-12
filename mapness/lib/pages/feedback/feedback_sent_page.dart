import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/features/feedback/submit_feedback.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
import 'package:mapness/pages/feedback/feedback_loading_widget.dart';
import 'package:mapness/pages/feedback/feedback_success_widget.dart';
import 'package:urbi_analytics/logger.dart';

class FeedbackSentPage extends ConsumerWidget {
  final String payloadId;

  const FeedbackSentPage({
    required this.payloadId,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(Demezy): get data from form
    final sentFeedback = ref.watch(
      submitFeedbackProvider(
        //   const FeedbackFormPayloadEntity(
        //     objectId: 0,
        //     fields: IList.empty(),
        //     category: '',
        //   ),
        payload,
      ),
    );

    return sentFeedback.when(
      data: (data) => const FeedbackSuccessWidget(),
      loading: () => const FeedbackLoadingWidget(),
      error: (error, stack) {
        log(
          'Error submitting feedback: $error\nStacktrace:\n$stack',
          kind: LogFilterKind.error,
        );
        return const FeedbackFailureWidget();
      },
    );
  }
}
