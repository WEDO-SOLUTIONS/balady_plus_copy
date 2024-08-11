import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

// TODO: Implement the FeedbackPhoneNumberPage
class FeedbackPhoneNumberPage extends StatelessWidget {
  final String initialPhoneNumber;
  const FeedbackPhoneNumberPage({required this.initialPhoneNumber, super.key});

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackPhoneNumber,
        child: const Placeholder(),
      );
}
