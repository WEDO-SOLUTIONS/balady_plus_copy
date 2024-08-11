import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

// TODO: Implement the FeedbackPhoneNumberPage
class FeedbackWebsitePage extends StatelessWidget {
  const FeedbackWebsitePage({super.key});

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackWebsiteOrSocialMedia,
        child: const Placeholder(),
      );
}
