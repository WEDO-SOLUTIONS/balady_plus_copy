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
    this.errorTitle,
    super.key,
  });

  /// A factory constructor for creating a [BaseErrorWidget] without a retry button.
  factory BaseErrorWidget.noRetry({
    String? errorLabel,
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

  /// The error message title.
  ///
  /// Displayed at fullscreen error widget.
  final String? errorTitle;

  /// The color scheme for the retry button.
  final ButtonColorScheme buttonColorScheme;

  @override
  Widget build(BuildContext context) {
    final errorText = errorLabel ?? '${context.l10n.failedToLoadData}\n${context.l10n.tryAgainLater}';

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
            if (errorTitle != null) ...[
              const SizedBox(height: Spacing.$3x),
              Text(
                errorTitle!,
                textAlign: TextAlign.center,
                style: context.textStyleV3.h3Medium,
              ),
              const SizedBox(height: Spacing.$3x),
            ] else
              const SizedBox(height: Spacing.$2x),
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: context.textStyle.text.copyWith(
                color: errorTitle != null ? context.colorsV2.foregroundSoft : context.colorsV2.foregroundDefault,
              ),
            ),
            if (withRetryButton) ...[
              const SizedBox(height: Spacing.$6x),
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
