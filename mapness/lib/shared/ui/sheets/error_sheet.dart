import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

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
  Widget build(BuildContext context) {
    Text text(String text) => Text(
          text,
          textAlign: TextAlign.center,
          style: context.textStyle.heading2.copyWith(color: context.color.textAndIconsBasePrimary),
        );

    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: isLtr ? Alignment.centerRight : Alignment.centerLeft,
              child: CustomCloseButton(
                onClose: onClose ?? () => context.pop(),
              ),
            ),
            SvgPicture.asset(
              'assets/images_svg/sad_face.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: 16),
            if (errorLabel != null)
              text(errorLabel!)
            else ...[
              text(context.l10n.somethingWentWrong),
              const SizedBox(height: 4),
              text(context.l10n.pleaseTryAgainLater),
            ],
            const SizedBox(height: 24),
            LabeledElevatedButton(
              onPressed: onRetry,
              label: buttonLabel ?? context.l10n.reload,
            ),
          ],
        ),
      ),
    );
  }
}
