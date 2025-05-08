import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_animation_mixin.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/quick_filter_request_source_screen.dart';
import 'package:mapness/pages/free_roam/ui/go_to_navigator_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/map_quick_filters.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MapHiddenStateControls extends ConsumerStatefulWidget {
  final StatefulBottomSheetController<ThreeStateBottomSheet> controller;

  const MapHiddenStateControls(this.controller, {super.key});

  @override
  ConsumerState<MapHiddenStateControls> createState() => _MapHiddenStateControlsState();
}

class _MapHiddenStateControlsState extends ConsumerState<MapHiddenStateControls> {
  late final ItemScrollController quickScrollController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
    quickScrollController = ItemScrollController();
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
      if (widget.controller.state == ThreeStateBottomSheet.expanded) {
        ref.read(freeRoamStarterProvider.notifier).setShown();
      } else if (state.canStart && state.isAutorun) {
        widget.controller.setState(ThreeStateBottomSheet.hidden);
        setState(() {
          quickScrollController.scrollTo(index: 0, duration: const Duration(milliseconds: 150), alignment: 0.05);
        });
      }
    });

    final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
    final isFreeRoamStart = freeRoamState.canStart && !freeRoamState.isAutorun;

    return AnimatedCrossFade(
      crossFadeState: isFreeRoamStart ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: const FreeRoamBar(),
      secondChild: QuickSearchBar(
        direction: uiDirection,
        quickScrollController: quickScrollController,
        showLaunchingFreeRoam: showLaunchingFreeRoam,
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}

class FreeRoamBar extends ConsumerWidget {
  const FreeRoamBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
        child: GoToNavigatorButton(),
      );
}

class QuickSearchBar extends StatelessWidget {
  static const hiddenHeight = 0.0;

  final TextDirection direction;
  final ItemScrollController quickScrollController;
  final bool showLaunchingFreeRoam;

  QuickSearchBar({
    required this.quickScrollController,
    required this.showLaunchingFreeRoam,
    required this.direction,
    super.key,
  });

  final ValueNotifier<double> opacity = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) => BottomSheetStateBuilder<ThreeStateBottomSheet>(
        defaultState: ThreeStateBottomSheet.hidden,
        builder: (context, state, interpolation, child) {
          final delta = state == ThreeStateBottomSheet.hidden ? clampDouble(1 - interpolation * 3, 0, 1) : hiddenHeight;

          opacity.value = delta;
          return IgnorePointer(
            ignoring: state != ThreeStateBottomSheet.hidden,
            child: Align(
              heightFactor: delta,
              alignment: Alignment.topCenter,
              child: child,
            ),
          );
        },
        child: FadeTransition(
          opacity: Animation.fromValueListenable(opacity),
          child: Directionality(
            textDirection: direction,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$2x),
              child: MapQuickFilters(
                forMap: true,
                itemScrollController: quickScrollController,
                id: QuickFilterScreen.controls,
                customFilters: [
                  FilterItemBuilder(
                    filterType: FilterType.custom,
                    builder: (
                      context, {
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
      );
}

class _FreeRoamQuickAction extends ConsumerStatefulWidget {
  final bool isLaunching;

  const _FreeRoamQuickAction({
    required this.isLaunching,
  });

  @override
  ConsumerState<_FreeRoamQuickAction> createState() => _FreeRoamState();
}

class _FreeRoamState extends ConsumerState<_FreeRoamQuickAction>
    with TickerProviderStateMixin, FreeRoamAnimationMixin, AutomaticKeepAliveClientMixin {
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
    super.build(context);
    listerForStart();
    final color = context.color;
    final colorsV3 = context.colorsV2;

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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: Shadows.s,
        color: Color.lerp(colorsV3.accentOnAccent, colorsV3.accentSecondarySoft, delta) ?? colorsV3.accentOnAccent,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          context.router.push(const FreeRoamRoute());
          ref.read(freeRoamStarterProvider.notifier).setShown();
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
                            Assets.icons.svg.quickFilters.freeRoamRoad.keyName,
                            height: iconSize,
                            width: iconSize,
                            colorFilter: ColorFilter.mode(
                              context.colorsV3.foregroundSoft,
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
                          padding: const EdgeInsetsDirectional.only(start: Spacing.$2x),
                          child: Row(
                            children: [
                              Text(
                                context.l10n.launchingNavigator,
                                style: context.textStyleV3.bodySmallSemiBold.copyWith(color: iconAndTextColor),
                              ),
                              AppButton(
                                color: context.colorsV3.accentSecondarySoft,
                                onTap: () {
                                  ref.read(freeRoamStarterProvider.notifier).pauseAnimation();
                                  context.router.push(const AutostartSettingsSheetRoute());
                                },
                                primaryIcon: SystemIcons.close,
                                buttonColorScheme: ButtonColorScheme.primary,
                              )
                            ],
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
    );
  }

  @override
  bool get wantKeepAlive => widget.isLaunching;
}
