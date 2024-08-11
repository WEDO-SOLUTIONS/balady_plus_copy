import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

// TODO: Implement the FeedbackAddressPage
class FeedbackAddressPage extends StatelessWidget {
  final String initialAddress;
  const FeedbackAddressPage({required this.initialAddress, super.key});

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackAddress,
        child: const Placeholder(),
      );
}
