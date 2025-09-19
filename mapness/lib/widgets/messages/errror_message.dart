import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    Text text(String text) => Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .heading2
              .copyWith(color: context.colors.foregroundDefault),
        );
    return Column(
      children: [
        SvgPicture.asset(
          Assets.imagesSvg.sadFace.keyName,
        ),
        const SizedBox(height: 16),
        text(context.l10n.somethingWentWrong),
        const SizedBox(height: 4),
        text(context.l10n.pleaseTryAgainLater),
        const SizedBox(height: 24),
        LabeledElevatedButton(
          onPressed: onRetry ?? () {},
          label: context.l10n.reload,
        ),
      ],
    );
  }
}
