import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackFailureWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const FeedbackFailureWidget({this.onRetry, super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.somethingWentWrong,
              style: context.textStyles.bodySmallRegular,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.$4x),
                child: AppButton(
                  buttonType: ButtonType.secondary,
                  buttonColorScheme: ButtonColorScheme.primary,
                  primaryLabel: context.l10n.tryAgain,
                  onTap: onRetry,
                ),
              ),
          ],
        ),
      );
}
