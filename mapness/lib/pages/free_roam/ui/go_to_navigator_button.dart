import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
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
    return LayoutBuilder(
      builder: (context, constrains) {
        const height = 56.0;
        const squareSize = 40.0;
        const iconSize = 24.0;

        final colors = context.colors;
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
                    child: ColoredBox(color: colors.accentSecondarySoft),
                  ),
                  SizedBox(
                    width: constrains.maxWidth * Curves.decelerate.transform(animationProgress),
                    height: height,
                    child: ColoredBox(color: colors.accentSecondaryDefault),
                  ),
                  Align(
                    alignment: alignment,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: Spacing.$2x),
                          child: Container(
                            width: squareSize,
                            height: squareSize,
                            padding: const EdgeInsets.all(Spacing.$2x),
                            decoration: BoxDecoration(
                              color: colors.accentSecondaryOnAccentSecondary,
                              borderRadius: BorderRadius.circular(RadiusBorder.s),
                            ),
                            child: Icon(
                              TransportIcons.locationDirectionNavigator,
                              size: iconSize,
                              color: context.colors.foregroundSoft,
                            ),
                          ),
                        ),
                        Spacing.$3x.widthBox,
                        Text(
                          context.l10n.goToNavigator,
                          style: context.textStyles.bodyLargeSemiBold.copyWith(
                            color: colors.accentOnAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AppButton(
                      padding: const EdgeInsetsDirectional.only(end: Spacing.$2x),
                      color: context.colors.accentSecondarySoft,
                      onTap: () {
                        ref.read(freeRoamStarterProvider.notifier).pauseAnimation();
                        context.router.push(const AutostartSettingsSheetRoute());
                      },
                      primaryIcon: SystemIcons.close,
                      buttonColorScheme: ButtonColorScheme.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
