import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: context.colorsV2.backgroundSurface1,
              boxShadow: Shadows.s,
              borderRadius: BorderRadius.circular(RadiusBorder.xl)),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Spacing.$12x,
                  child: Image.asset('assets/images/feedback_eyes.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x + Spacing.$0_5x, bottom: Spacing.$5x),
                  child: Text(
                    context.l10n.doYouLikeBaladyApp,
                    style: context.textStyleV3.bodyLargeMedium,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaladyAppButton(
                        size: BaladyButtonSize.large,
                        primaryLabel: context.l10n.yes,
                        buttonType: BaladyButtonType.secondary,
                        buttonColorScheme: BaladyButtonColorScheme.accent,
                        onTap: () {
                          context.router.push(AppFeedbackSheet(initialRating: 5));
                        },
                      ),
                    ),
                    const SizedBox(width: Spacing.$2x),
                    Expanded(
                      child: BaladyAppButton(
                        size: BaladyButtonSize.large,
                        primaryLabel: context.l10n.no,
                        buttonType: BaladyButtonType.secondary,
                        buttonColorScheme: BaladyButtonColorScheme.neutral,
                        onTap: () {
                          context.router.push(AppFeedbackSheet(initialRating: 2));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
