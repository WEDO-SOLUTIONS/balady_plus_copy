import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';

class AppFeedbackCard extends ConsumerWidget {
  const AppFeedbackCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(dgisEnvironmentProvider).valueOrNull;

    return env?.appFeedbackEnable == true
        ? GestureDetector(
            onTap: () => context.router.push(AppFeedbackSheet()),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.$3x),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.l),
                  color: context.colorsV2.accentSecondaryDefault,
                ),
                child: ContentRow(
                  options: ContentRowOptions(
                    leadingIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                      child: Image.asset(
                        Assets.images.wavinghand.keyName,
                        width: Spacing.$8x,
                        matchTextDirection: true,
                      ),
                    ),
                    titleBuilder: (context) => Padding(
                      padding: const EdgeInsets.only(top: Spacing.$1x),
                      child: Text(
                        context.l10n.appFeedbackShareFeedback,
                        style: context.textStyleV3.bodyLargeSemiBold.copyWith(
                          color: context.colorsV2.staticWhite,
                        ),
                      ),
                    ),
                    subtitleBuilder: (context) => Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.$1x),
                      child: Text(
                        context.l10n.appFeedbackDoYouLikeBaladyAppTellUsMore,
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
          )
        : const SizedBox.shrink();
  }
}
