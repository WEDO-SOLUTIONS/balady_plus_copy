import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/ui/error_widget/error_widget.dart';

class ErrorSheet extends StatelessWidget {
  const ErrorSheet({
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
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: SheetDragger(),
                ),
              ),
              const SizedBox(height: 16),
              BaseErrorWidget(
                onRetry: onRetry,
                buttonLabel: buttonLabel,
                errorLabel: errorLabel,
              ),
            ],
          ),
        ),
      );
}
