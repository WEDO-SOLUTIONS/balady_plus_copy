import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/app_feedback.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackCard extends StatelessWidget {
  const AppFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push(AppFeedbackRoute.path),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$3x),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusBorder.l),
              color: context.colorsV3.lightAccent,
            ),
            child: ContentRow(
              options: ContentRowOptions(
                leadingIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                  child: Image.asset(
                    'assets/images/wavinghand.png',
                    width: Spacing.$8x,
                    package: PackageConfig.packageName,
                  ),
                ),
                titleBuilder: (context) => Padding(
                  padding: const EdgeInsets.only(top: Spacing.$1x),
                  child: Text(
                    'Share Feedback',
                    style: context.textStyleV3.bodyLargeSemiBold.copyWith(
                      color: context.colorsV2.staticWhite,
                    ),
                  ),
                ),
                subtitleBuilder: (context) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.$1x),
                  child: Text(
                    'Do you like Balady App? Tell us more',
                    style: context.textStyleV3.captionLargeRegular.copyWith(
                      color: context.colorsV2.staticWhite,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(Spacing.$2x),
                customActionWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colorsV2.staticWhite,
                        borderRadius: BorderRadius.circular(RadiusBorder.s),
                      ),
                      width: Spacing.$8x,
                      height: Spacing.$8x,
                      child: Center(
                        child: Icon(
                          SystemIcons.arrowRight,
                          size: Spacing.$6x,
                          color: context.colorsV2.accentDefault,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
      );
}
