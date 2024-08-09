import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

/// TODO: Implement the FeedbackCompanyNamePage
class FeedbackCompanyNamePage extends StatelessWidget {
  final String initialCompanyName;

  const FeedbackCompanyNamePage({
    required this.initialCompanyName,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackCompanyName,
        child: const Placeholder(),
      );
}
