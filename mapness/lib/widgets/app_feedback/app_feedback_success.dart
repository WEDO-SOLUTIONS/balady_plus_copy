import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackSuccess extends StatelessWidget {
  const AppFeedbackSuccess({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.$6x),
            Image.asset(
              Assets.images.successAppFeedback.keyName,
              matchTextDirection: true,
              width: 132,
            ),
            const SizedBox(height: AppSizes.xxs),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xxs,
              ),
              child: Text(
                context.l10n.appFeedbackThankYouV2,
                style: context.textStyles.h3SemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.$3x),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xxs,
              ),
              child: Text(
                context.l10n.appFeedbackHappy,
                style: context.textStyles.bodySmallRegular.copyWith(
                  color: context.colors.foregroundSoft,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.$6x),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: AppButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$4x,
                  vertical: Spacing.$4x,
                ),
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                size: ButtonSize.large,
                primaryLabel: context.l10n.done,
                onTap: context.router.pop,
              ),
            ),
          ],
        ),
      );
}
