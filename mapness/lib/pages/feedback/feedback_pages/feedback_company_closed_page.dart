import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

class FeedbackCompanyClosedPage extends StatelessWidget {
  const FeedbackCompanyClosedPage({super.key});

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackCompanyHasBeenClosed,
        child: const Placeholder(),
      );
}
