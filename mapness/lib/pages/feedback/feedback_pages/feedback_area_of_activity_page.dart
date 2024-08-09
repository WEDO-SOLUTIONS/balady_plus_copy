import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

// TODO: Implement the FeedbackAreaOfActivityPage
class FeedbackAreaOfActivityPage extends StatelessWidget {
  final String initialAreaOfActivity;
  const FeedbackAreaOfActivityPage({
    required this.initialAreaOfActivity,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackAreaOfActivity,
        child: const Placeholder(),
      );
}
