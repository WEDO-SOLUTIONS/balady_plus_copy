import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

part 'fullscreen_story_content.dart';

class FullscreenStroryError extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onRetry;
  final String? buttonLabel;
  final String? errorLabel;
  final String? errorTitle;

  const FullscreenStroryError({
    super.key,
    this.onClose,
    this.onRetry,
    this.buttonLabel,
    this.errorLabel,
    this.errorTitle,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: context.colorsV3.backgroundSurface4,
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: context.colorsV3.backgroundSurface4)),
            _FullscreenErrorContent(
              onClose: onClose,
              onRetry: onRetry,
              buttonLabel: buttonLabel,
              errorLabel: errorLabel,
              errorTitle: errorTitle,
            ),
          ],
        ),
      ),
    ),
  );
}
