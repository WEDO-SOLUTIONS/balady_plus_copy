import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

class FeedbackFailure extends StatelessWidget {
  const FeedbackFailure({super.key});

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: '',
        isSendVisible: false,
        child: Center(
          child: Text(context.l10n.failedToLoadData),
        ),
      );
}
