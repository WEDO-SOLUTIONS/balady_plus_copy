import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ErrorSheet extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onClose;
  final String buttonLabel;

  const ErrorSheet({
    super.key,
    required this.onRetry,
    required this.buttonLabel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    Text text(String text) => Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: const Color(0xB21E2A36)),
        );

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
              alignment: Alignment.centerLeft,
              child: AppCloseButton(onPressed: onClose),
            ),
            SvgPicture.asset(
              'assets/images_svg/sad_face.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: 16),
            text(context.l10n.somethingWentWrong),
            const SizedBox(height: 4),
            text(context.l10n.pleaseTryAgainLater),
            const SizedBox(height: 24),
            LabeledElevatedButton(onPressed: onRetry, label: buttonLabel),
          ],
        ),
      ),
    );
  }
}
