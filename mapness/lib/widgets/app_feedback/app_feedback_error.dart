import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/fullscreen_error_widget.dart';

class AppFeedbackError extends StatelessWidget {
  final VoidCallback? onRetry;
  const AppFeedbackError({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) => FullscreenErrorWidget(
        onRetry: () {
          onRetry?.call();
        },
        errorLabel: onRetry != null
            ? context.l10n.somethingDidntGoAsPlannedDescription
            : context.l10n.somethingDidntGoAsPlanned,
        errorTitle: context.l10n.failedToLoadData,
        withRetryButton: onRetry != null,
      );
}
