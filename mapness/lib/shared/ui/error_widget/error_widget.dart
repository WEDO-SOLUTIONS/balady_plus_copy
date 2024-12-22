import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

class ErrorWidget extends HookConsumerWidget {
  /// action how to recover state
  final VoidCallback onRetry;

  /// button label (localized default: reload)
  final String? buttonLabel;

  /// error label (localized default: somethingWentWrong)
  final String? errorLabel;

  const ErrorWidget({
    required this.onRetry,
    this.buttonLabel,
    this.errorLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
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
            const SizedBox(height: Spacing.$1x),
            BaseErrorWidget(
              onRetry: onRetry,
              buttonLabel: buttonLabel,
              errorLabel: errorLabel,
            ),
          ],
        ),
      );
}
