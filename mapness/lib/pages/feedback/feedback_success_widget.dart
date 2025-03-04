import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/app/auto_route/app_routes.gr.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

class FeedbackSuccessWidget extends HookWidget {
  final ConfettiGeneratorConfig config =
      ConfettiGeneratorConfig.confetti(animationDuration: const Duration(seconds: 3));

  FeedbackSuccessWidget({super.key});

  void popNavigation(BuildContext context) => context.router.popUntil((route) =>
      route.settings.name == PoiCardWidgetRoute.name ||
      route.settings.name == SearchRoute.name ||
      route.settings.name == BottomMenuRoute.name);

  @override
  Widget build(BuildContext context) {
    final sheetController = useStatelessBottomsheetController(onClose: (_) => popNavigation(context));
    final confettiController = useAnimationController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        confettiController.animateTo(1.0, duration: config.animationDuration, curve: config.animationCurve);
      });
      return null;
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: RepaintBoundary(child: ConfettiAnimation(animationController: confettiController, config: config)),
            ),
            SafeArea(
              child: StatelessBottomSheet(
                backgroundColor: context.colorsV2.backgroundSurface1,
                scrollController: sheetController,
                header: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.tertiary,
                      primaryIcon: SystemIcons.close,
                      onTap: sheetController.close,
                    ),
                  ),
                ),
                footer: ColoredBox(
                  color: context.colorsV2.backgroundSurface1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.$4x,
                          vertical: Spacing.$4x,
                        ),
                        buttonColorScheme: ButtonColorScheme.primary,
                        primaryLabel: context.l10n.complete,
                        onTap: sheetController.close,
                      ),
                    ),
                  ),
                ),
                content: [
                  const SizedBox(height: Spacing.$3x),
                  SvgPicture.asset(
                    'assets/images_svg/illustration_notifications.svg',
                    matchTextDirection: true,
                    package: PackageConfig.packageName,
                  ),
                  const SizedBox(height: AppSizes.$4xs),
                  Text(
                    context.l10n.feedbackSuccessTitle,
                    style: context.textStyleV3.h3SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.$4xs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
