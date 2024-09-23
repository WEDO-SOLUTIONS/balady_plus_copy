import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/fullscreen_error_widget.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackFailureWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isFullscreen;
  const FeedbackFailureWidget({
    this.onRetry,
    this.isFullscreen = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = FullscreenErrorWidget(
      onRetry: () {
        onRetry?.call();
      },
      errorLabel: context.l10n.somethingDidntGoAsPlannedDescription,
      errorTitle: context.l10n.failedToLoadData,
      withRetryButton: onRetry != null,
    );

    if (isFullscreen) {
      return FeedbackFormContainer(
        title: '',
        isSendVisible: false,
        child: child,
      );
    }
    return child;
  }
}
