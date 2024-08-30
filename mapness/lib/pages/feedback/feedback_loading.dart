import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackLoading extends StatelessWidget {
  const FeedbackLoading({super.key});

  @override
  Widget build(BuildContext context) => const FeedbackFormContainer(
        title: '',
        isSendVisible: false,
        child: Center(
          child: Loading(
            size: LoaderSize.large,
          ),
        ),
      );
}
