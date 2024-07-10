import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// A base error widget that displays an error message and a retry button.
class BaseErrorWidget extends StatelessWidget {
  /// Creates a [BaseErrorWidget].
  const BaseErrorWidget({
    required this.onRetry,
    this.withRetryButton = true,
    this.buttonColorScheme = ButtonColorScheme.secondary,
    this.buttonLabel,
    this.errorLabel,
    super.key,
  });

  /// A factory constructor for creating a [BaseErrorWidget] without a retry button.
  factory BaseErrorWidget.noRetry({
    required String errorLabel,
    Key? key,
  }) =>
      BaseErrorWidget(
        key: key,
        onRetry: () {},
        withRetryButton: false,
        errorLabel: errorLabel,
      );

  /// The action to be taken when the retry button is pressed.
  final VoidCallback onRetry;

  /// Whether to show the retry button or not.
  final bool withRetryButton;

  /// The label for the retry button.
  final String? buttonLabel;

  /// The error message to be displayed.
  final String? errorLabel;

  /// The color scheme for the retry button.
  final ButtonColorScheme buttonColorScheme;

  @override
  Widget build(BuildContext context) {
    Text text(String text) => Text(
          text,
          textAlign: TextAlign.center,
          style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
        );

    final errorText = errorLabel ?? '${context.l10n.somethingWentWrong}\n${context.l10n.tryAgainLater}';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(
          top: Spacing.$2x,
          left: Spacing.$4x,
          right: Spacing.$4x,
          bottom: Spacing.$4x,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/images_svg/illustration_error.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: Spacing.$4x),
            text(errorText),
            if (withRetryButton) ...[
              const SizedBox(height: Spacing.$5x),
              AppButton(
                onTap: onRetry,
                buttonColorScheme: buttonColorScheme,
                primaryLabel: buttonLabel ?? context.l10n.tryAgain,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
