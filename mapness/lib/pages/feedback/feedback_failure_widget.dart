import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/fullscreen_error_widget.dart';

class FeedbackFailureWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isFullscreen;
  final String? screenTitle;
  const FeedbackFailureWidget({
    this.isFullscreen = true,
    this.onRetry,
    this.screenTitle,
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
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: BaladyTopBar.iconAndText(
            title: screenTitle,
            leading: ActionModel(
              icon: SystemIcons.arrowCornerLeftLarge,
              onPressed: context.pop,
            ),
            colorEnabled: context.colorsV2.accentDefault,
            colorDisabled: context.colorsV2.foregroundDefault,
          ),
          body: Center(
            child: child,
          ),
        ),
      );
    }
    return child;
  }
}
