import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// A base error widget that displays an error message and a retry button.
class BaseErrorWidget extends StatelessWidget {
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

  /// The padding for the image.
  final EdgeInsetsGeometry paddingForImage;

  /// Add a close button to the widget. If [null] it will be not displayed.
  final VoidCallback? onClose;

  /// Creates a [BaseErrorWidget].
  const BaseErrorWidget({
    required this.onRetry,
    this.withRetryButton = true,
    this.buttonLabel,
    this.errorLabel,
    this.errorTitle,
    this.onClose,
    this.paddingForImage = EdgeInsets.zero,
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
            if (onClose != null)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.$2x, top: Spacing.$1x),
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.neutral,
                    primaryIcon: SystemIcons.close,
                    onTap: onClose,
                  ),
                ),
              ),
            Padding(
              padding: paddingForImage,
              child: SvgPicture.asset(
                Assets.imagesSvg.illustrationError.keyName,
              ),
            ),
            if (errorTitle != null)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.$4x, bottom: Spacing.$2x),
                child: Text(
                  errorTitle!,
                  textAlign: TextAlign.center,
                  style: context.textStyles.h3SemiBold.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                ),
              )
            else
              const SizedBox(height: Spacing.$2x),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
              child: Text(
                errorText,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLargeRegular.copyWith(
                  color: errorTitle != null ? context.colors.foregroundSoft : context.colors.foregroundDefault,
                ),
              ),
            ),
            if (withRetryButton)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.$6x),
                  child: AppButton(
                    onTap: onRetry,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    size: ButtonSize.large,
                    primaryLabel: buttonLabel ?? context.l10n.tryAgain,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
