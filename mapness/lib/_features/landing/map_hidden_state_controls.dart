import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/free_roam.dart';
import 'package:mapness/app/routes/free_roam_autostart_settings.dart';
import 'package:mapness/features/free_roam/free_roam_animation_mixin.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/pages/free_roam/ui/go_to_navigator_button.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class MapHiddenStateControls extends ConsumerStatefulWidget {
  final StatefulBottomSheetController<ThreeStateBottomSheet> controller;

  const MapHiddenStateControls(this.controller, {super.key});

  @override
  ConsumerState<MapHiddenStateControls> createState() => _MapHiddenStateControlsState();
}

class _MapHiddenStateControlsState extends ConsumerState<MapHiddenStateControls> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapHiddenStateControls oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(update);
      widget.controller.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  void update() {
    final freeRoamState = ref.read(freeRoamStarterProvider);

    final isLaunchingDismiss =
        freeRoamState.canStart && freeRoamState.isAutorun && widget.controller.state != ThreeStateBottomSheet.hidden;

    final isGoToNavigatorDismiss = freeRoamState.canStart &&
        !freeRoamState.isAutorun &&
        widget.controller.state == ThreeStateBottomSheet.open &&
        widget.controller.interpolation > 0.5;

    if (isLaunchingDismiss || isGoToNavigatorDismiss) {
      ref.read(freeRoamStarterProvider.notifier).setShown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiDirection = ref.watch(uiDirectionProvider);

    final freeRoamState = ref.watch(freeRoamStarterProvider);
    ref.listen(freeRoamStarterProvider, (_, state) {
      if (state.canStart && state.isAutorun) {
        widget.controller.setState(ThreeStateBottomSheet.hidden);
      }
    });

    return BottomSheetStateBuilder<ThreeStateBottomSheet>(
      defaultState: ThreeStateBottomSheet.open,
      builder: (context, state, interpolation, child) {
        const hiddenHeight = 0.0;
        const controlsHeight = 60.0;

        final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
        final delta = state == ThreeStateBottomSheet.hidden ? clampDouble(1 - interpolation * 3, 0, 1) : hiddenHeight;
        return AnimatedCrossFade(
            crossFadeState: freeRoamState.canStart && !freeRoamState.isAutorun
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: Row(
                children: [
                  const Expanded(flex: 2, child: GoToNavigatorButton()),
                  Spacing.$2x.widthBox,
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: AppButton(
                        onTap: () {
                          ref.read(freeRoamStarterProvider.notifier).pauseAnimation();
                          FreeRoamAutostartSettingsRoute.open(context);
                        },
                        buttonColorScheme: ButtonColorScheme.onColor,
                        primaryLabel: context.l10n.cancel,
                        textColor: context.colorsV2.foregroundDefault,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: IgnorePointer(
              ignoring: state != ThreeStateBottomSheet.hidden,
              child: Opacity(
                opacity: delta,
                child: Align(
                  heightFactor: delta,
                  alignment: Alignment.topCenter,
                  child: Directionality(
                    textDirection: uiDirection,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Spacing.$2x * delta),
                      child: MapQuickFilters(
                        height: controlsHeight,
                        forMap: true,
                        id: QuickFilterScreen.controls,
                        customFilters: [
                          FilterItemBuilder(
                            filterType: FilterType.custom,
                            builder: (
                              context, {
                              required isDashboard,
                              required isSelected,
                            }) =>
                                _FreeRoamQuickAction(
                              isLaunching: showLaunchingFreeRoam,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 300));
      },
    );
  }
}

class _FreeRoamQuickAction extends ConsumerStatefulWidget {
  final bool isLaunching;

  const _FreeRoamQuickAction({
    required this.isLaunching,
  });

  @override
  ConsumerState<_FreeRoamQuickAction> createState() => _FreeRoamState();
}

class _FreeRoamState extends ConsumerState<_FreeRoamQuickAction> with TickerProviderStateMixin, FreeRoamAnimationMixin {
  late final AnimationController launchingController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 666),
  );

  @override
  void initState() {
    super.initState();
    initializeFreeRoam(this);

    if (widget.isLaunching) {
      launchingController.animateTo(1, curve: Curves.easeInOutCubic);
    }
  }

  @override
  void didUpdateWidget(covariant _FreeRoamQuickAction oldWidget) {
    if (oldWidget.isLaunching != widget.isLaunching) {
      if (widget.isLaunching) {
        launchingController.animateTo(1, curve: Curves.easeInOutCubic);
      } else {
        launchingController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    disposeAnimationController();
    launchingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listerForStart();
    final color = context.color;
    final colorsV2 = context.colorsV2;

    final delta = launchingController.value;
    final borderRadius = lerpDouble(RadiusBorder.m, RadiusBorder.l, delta) ?? RadiusBorder.m;

    final iconAndTextColor = Color.lerp(
          color.textAndIconsBasePrimary,
          context.colorsV2.backgroundSurface1,
          delta,
        ) ??
        color.textAndIconsBasePrimary;

    const startingPoint = 0;
    const progressOpacity = 0.2;
    const iconSize = 24.0;
    const minHeight = 40.0;
    const maxHeight = 48.0;
    const minWidth = 52.0;

    final isLTR = context.isLTR;
    final gradientPosition = Curves.decelerate.transform(animationProgress);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: Color.lerp(colorsV2.backgroundSurface1, colorsV2.accentDefault, delta) ?? colorsV2.backgroundSurface1,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            FreeRoamRoute.open(ref.watch(goRouterProvider));
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidth,
              maxHeight: lerpDouble(minHeight, maxHeight, delta) ?? maxHeight,
            ),
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      if (isLTR) Colors.black.withOpacity(progressOpacity),
                      Colors.transparent,
                      if (!isLTR) Colors.black.withOpacity(progressOpacity),
                    ],
                    stops: [
                      if (isLTR) gradientPosition else 1 - gradientPosition,
                      if (isLTR) gradientPosition else 1 - gradientPosition
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Spacing.$1x * delta),
                      child: SizedBox(
                        width: minHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(RadiusBorder.m),
                            color: Colors.white.withOpacity(progressOpacity * delta),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/svg/quick_filters/free_roam.svg',
                              height: iconSize,
                              width: iconSize,
                              package: PackageConfig.packageName,
                              colorFilter: ColorFilter.mode(
                                iconAndTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (delta > startingPoint)
                      ClipRect(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: delta,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: Spacing.$2x, end: Spacing.$3x),
                            child: Text(
                              context.l10n.launchingNavigator,
                              style: context.textStyleV3.bodySmallSemiBold.copyWith(color: iconAndTextColor),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
