import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackSuccessPage extends StatelessWidget {
  final String username;
  const FeedbackSuccessPage({required this.username, super.key});

  @override
  Widget build(BuildContext context) => Material(
        color: context.colorsV2.backgroundSurface1,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images_svg/illustration_notifications.svg',
                      matchTextDirection: true,
                      package: PackageConfig.packageName,
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxs),
                      child: Text(
                        context.l10n.feedbackSuccessTitle,
                        style: context.textStyleV3.h3SemiBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxs),
                      child: Text(
                        context.l10n.feedbackSuccessText(username),
                        style: context.textStyleV3.bodyLargeRegular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.$4x,
                      vertical: Spacing.$4x,
                    ),
                    buttonColorScheme: ButtonColorScheme.primary,
                    primaryLabel: context.l10n.complete,
                    onTap: () {
                      context.popRouteUntilFirst();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
