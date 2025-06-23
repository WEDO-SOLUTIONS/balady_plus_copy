import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

class FullscreenErrorWidget extends StatelessWidget {
  const FullscreenErrorWidget({
    required this.onRetry,
    this.withRetryButton = true,
    this.buttonLabel,
    this.errorLabel,
    this.errorTitle,
    this.onClose,
    this.buttonColorScheme,
    super.key,
  });

  /// action how to recover state
  final VoidCallback onRetry;

  /// action when leave the sheet (default: pop)
  final VoidCallback? onClose;

  /// button label (localized default: reload)
  final String? buttonLabel;

  /// error label (localized default: pleaseTryAgainLater)
  final String? errorLabel;

  /// error title (localized default: somethingWentWrong)
  final String? errorTitle;

  /// error label (localized default: somethingWentWrong)
  final bool withRetryButton;

  /// error button scheme (default: primary)
  final ButtonColorScheme? buttonColorScheme;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        type: MaterialType.transparency,
        child: Center(
          child: BaseErrorWidget(
            onRetry: onRetry,
            buttonLabel: buttonLabel,
            errorLabel: errorLabel ?? context.l10n.pleaseTryAgainLater,
            errorTitle: errorTitle ?? context.l10n.somethingWentWrong,
            buttonColorScheme: buttonColorScheme ?? ButtonColorScheme.accent,
            withRetryButton: withRetryButton,
          ),
        ),
      );
}
