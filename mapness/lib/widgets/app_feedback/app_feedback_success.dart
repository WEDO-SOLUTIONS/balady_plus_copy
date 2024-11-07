import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';

class AppFeedbackSuccess extends StatelessWidget {
  const AppFeedbackSuccess({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_feedback_success.png',
              matchTextDirection: true,
              width: 185,
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: AppSizes.xxs),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xxs,
              ),
              child: Text(
                'Thank you!',
                style: context.textStyleV3.h3SemiBold.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xxs,
              ),
              child: Text(
                'Your feedback will help us create a\nbetter experience for you.',
                style: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.colorsV2.foregroundSoft,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 120),
              child: AppButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$4x,
                  vertical: Spacing.$4x,
                ),
                buttonColorScheme: ButtonColorScheme.primary,
                primaryLabel: 'Done',
                onTap: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      );
}
