import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/error_widget/error_widget.dart';

class FullscreenErrorIndicator extends StatelessWidget {
  const FullscreenErrorIndicator({
    required this.onRetry,
    super.key,
    this.buttonLabel,
    this.errorLabel,
    this.onClose,
  });

  /// action how to recover state
  final VoidCallback onRetry;

  /// action when leave the sheet (default: pop)
  final VoidCallback? onClose;

  /// button label (localized default: reload)
  final String? buttonLabel;

  /// error label (localized default: somethingWentWrong)
  final String? errorLabel;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Center(
          child: BaseErrorWidget(
            onRetry: onRetry,
            buttonLabel: buttonLabel,
            errorLabel: errorLabel,
            buttonColorScheme: ButtonColorScheme.primary,
          ),
        ),
      );
}
