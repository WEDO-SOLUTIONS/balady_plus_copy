import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackFailureWidget extends StatelessWidget {
  const FeedbackFailureWidget({super.key});

  @override
  Widget build(BuildContext context) => FeedbackFormContainer(
        title: '',
        isSendVisible: false,
        onSend: null,
        child: Center(
          child: Text(context.l10n.failedToLoadData),
        ),
      );
}
