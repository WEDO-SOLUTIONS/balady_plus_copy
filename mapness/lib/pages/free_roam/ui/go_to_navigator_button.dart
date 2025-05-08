import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_animation_mixin.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class GoToNavigatorButton extends ConsumerStatefulWidget {
  const GoToNavigatorButton({super.key});

  @override
  ConsumerState<GoToNavigatorButton> createState() => _GoToNavigatorButtonState();
}

class _GoToNavigatorButtonState extends ConsumerState<GoToNavigatorButton>
    with TickerProviderStateMixin, FreeRoamAnimationMixin {
  @override
  void initState() {
    super.initState();
    initializeFreeRoam(this);
  }

  @override
  void dispose() {
    disposeAnimationController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listerForStart();
    return LayoutBuilder(builder: (context, constrains) {
      const height = 52.0;
      const squareSize = 40.0;
      const iconSize = 24.0;

      final colorsV2 = context.colorsV2;
      final alignment = context.isLTR ? Alignment.centerLeft : Alignment.centerRight;

      return ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: InkWell(
          onTap: () {
            ref.read(freeRoamStarterProvider.notifier).pauseAnimation();
            context.router.push(const FreeRoamRoute());
            ref.read(freeRoamStarterProvider.notifier).setShown();
          },
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height,
                  child: ColoredBox(color: colorsV2.accentDefault),
                ),
                Align(
                  alignment: alignment,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.$2x),
                    child: SizedBox(
                      width: squareSize,
                      height: squareSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusBorder.s),
                        child: ColoredBox(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constrains.maxWidth * Curves.decelerate.transform(animationProgress),
                  height: height,
                  child: ColoredBox(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                Center(
                  child: Text(
                    context.l10n.goToNavigator,
                    style: context.textStyleV3.bodyLargeSemiBold.copyWith(
                      color: colorsV2.backgroundSurface1,
                    ),
                  ),
                ),
                Align(
                  alignment: alignment,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
                    child: Icon(
                      TransportIcons.locationDirectionNavigator,
                      size: iconSize,
                      color: context.colorsV3.foregroundSoft,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
