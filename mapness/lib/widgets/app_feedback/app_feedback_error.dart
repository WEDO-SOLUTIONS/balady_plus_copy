import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
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
        errorLabel: context.l10n.appFeedbackConnectionIssueV2,
        backgroundColor: context.colors.backgroundSurface4,
        withRetryButton: onRetry != null,
        buttonColorScheme: ButtonColorScheme.accentSecondary,
      );
}
