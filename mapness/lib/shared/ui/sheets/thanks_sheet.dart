import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class ThanksSheet extends StatelessWidget {
  const ThanksSheet({super.key, this.onClose, this.buttonLabel});

  /// action when leave the sheet (default: pop)
  final VoidCallback? onClose;

  /// button label (localized default: reload)
  final String? buttonLabel;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppCloseButton(
                  onPressed: onClose ?? () => context.router.popForced(),
                ),
              ),
              SvgPicture.asset(
                Assets.imagesSvg.illustrationThanks.keyName,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.thanksForYourFeedback,
                textAlign: TextAlign.center,
                style: context.textStyle.heading2.copyWith(color: context.colors.foregroundDefault),
              ),
            ],
          ),
        ),
      );
}
