import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/fullscreen_error_widget.dart';
import 'package:provider/provider.dart';

class FeedbackFailureWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isFullscreen;
  final String? screenTitle;

  const FeedbackFailureWidget({this.isFullscreen = true, this.onRetry, this.screenTitle, super.key});

  @override
  Widget build(BuildContext context) {
    final child = FullscreenErrorWidget(
      onRetry: () {
        onRetry?.call();
      },
      errorLabel: onRetry != null
          ? context.l10n.somethingDidntGoAsPlannedDescription
          : context.l10n.somethingDidntGoAsPlanned,
      errorTitle: context.l10n.failedToLoadData,
      withRetryButton: onRetry != null,
    );

    if (isFullscreen) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.read<ThemeController>().systemOverlayStyle,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: BaladyTopBar(
            title: screenTitle,
            onLeadingPressed: context.router.pop,
            leading: Semantics(
              label: context.l10n.a11yBack,
              button: true,
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: Spacing.$4x),
                    Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.accentDefault),
                    const SizedBox(width: Spacing.$4x),
                  ],
                ),
              ),
            ),
          ),
          body: Center(child: child),
        ),
      );
    }
    return child;
  }
}
