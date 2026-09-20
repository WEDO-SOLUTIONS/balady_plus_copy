import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/free_roam/free_roam_animation_mixin.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/pages/free_roam/ui/go_to_navigator_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_display.dart';
import 'package:mapness/widgets/landing/dashboard/special_theme_header.dart';
import 'package:mapness/widgets/landing/map_quick_filters.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:sheetify/sheetify.dart';

import '../../../features/cityscape/cityscape.dart';

class MapHiddenStateControls extends ConsumerStatefulWidget {
  final MultiStateSheetController<ThreeStateSheet> controller;

  final AnimationController fireworksController;

  const MapHiddenStateControls(this.controller, this.fireworksController, {super.key});

  @override
  ConsumerState<MapHiddenStateControls> createState() => _MapHiddenStateControlsState();
}

class _MapHiddenStateControlsState extends ConsumerState<MapHiddenStateControls> {
  final ScrollController quickScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(update);
    quickScrollController.dispose();
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
        freeRoamState.canStart && freeRoamState.isAutorun && widget.controller.state != ThreeStateSheet.hidden;

    final isGoToNavigatorDismiss =
        freeRoamState.canStart &&
        !freeRoamState.isAutorun &&
        widget.controller.state == ThreeStateSheet.open &&
        widget.controller.interpolation > 0.5;

    if (isLaunchingDismiss || isGoToNavigatorDismiss) {
      ref.read(freeRoamStarterProvider.notifier).setShown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiDirection = ref.watch(uiDirectionProvider);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final bool showSpecialBanner =
        specialThemeMode == SpecialThemeMode.nationalDay ||
        specialThemeMode == SpecialThemeMode.mekkahBase ||
        specialThemeMode == SpecialThemeMode.ramadan;
    final bool showCityEventBanner =
        specialThemeMode == SpecialThemeMode.foundationDay || (activeEvent?.isLeap ?? false);
    final isCityscapeDay = ref.watch(cityscapeProvider);
    final freeRoamState = ref.watch(freeRoamStarterProvider);
    ref.listen(freeRoamStarterProvider, (_, state) {
      if (!mounted) {
        return;
      }
      if (widget.controller.state == ThreeStateSheet.expanded) {
        ref.read(freeRoamStarterProvider.notifier).setShown();
      } else if (state.canStart && state.isAutorun) {
        widget.controller.setState(ThreeStateSheet.hidden);
        setState(() {
          if (quickScrollController.hasClients) {
            quickScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    final showLaunchingFreeRoam = freeRoamState.canStart && freeRoamState.isAutorun;
    final isFreeRoamStart = freeRoamState.canStart && !freeRoamState.isAutorun;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          // CityEventDisplay's logo is deliberately taller than its own banner
          // and paints past its bounds (see city_event_display.dart) so it
          // doesn't inflate the measured topHeader height — don't clip that
          // overflow here either.
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: showSpecialBanner ? Spacing.$4x : 0.0),
              child: AnimatedCrossFade(
                crossFadeState: isFreeRoamStart ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const FreeRoamBar(),
                secondChild: Container(),
                duration: const Duration(milliseconds: 300),
              ),
            ),
            if (showCityEventBanner)
              CityEventDisplay(
                activeEvent: activeEvent,
                controller: widget.controller,
                fireworksController: widget.fireworksController,
              ),
            if (specialThemeMode != SpecialThemeMode.base)
              SpecialThemeHeader(
                mode: specialThemeMode,
                controller: widget.controller,
                fireworksController: widget.fireworksController,
              ),
          ],
        ),
      ],
    );
  }
}

class FreeRoamBar extends ConsumerWidget {
  const FreeRoamBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
    child: GoToNavigatorButton(),
  );
}

class QuickSearchBar extends StatelessWidget {
  static const hiddenHeight = 0.0;

  final TextDirection direction;
  final ScrollController quickScrollController;
  final bool showLaunchingFreeRoam;

  QuickSearchBar({
    required this.quickScrollController,
    required this.showLaunchingFreeRoam,
    required this.direction,
    super.key,
  });

  final ValueNotifier<double> opacity = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) => MultiStateSheetBuilder<ThreeStateSheet>(
    defaultState: ThreeStateSheet.hidden,
    builder: (context, state, interpolation, child) {
      final delta = state == ThreeStateSheet.hidden ? clampDouble(1 - interpolation * 3, 0, 1) : hiddenHeight;

      opacity.value = delta;
      return IgnorePointer(
        ignoring: state != ThreeStateSheet.hidden,
        child: Align(heightFactor: delta, alignment: Alignment.topCenter, child: child),
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
            scrollController: quickScrollController,
            customFilters: [
              FilterItemBuilder(
                filterType: FilterType.custom,
                builder: (context, {required isSelected}) => _FreeRoamQuickAction(isLaunching: showLaunchingFreeRoam),
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

  const _FreeRoamQuickAction({required this.isLaunching});

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
    final colors = context.colors;

    final delta = launchingController.value;
    final borderRadius = lerpDouble(RadiusBorder.m, RadiusBorder.l, delta) ?? RadiusBorder.m;

    final iconAndTextColor =
        Color.lerp(colors.foregroundDefault, context.colors.backgroundSurface1, delta) ?? colors.foregroundDefault;

    const startingPoint = 0;
    const progressOpacity = 0.2;
    const iconSize = 18.0;
    const minHeight = 40.0;
    const maxHeight = 48.0;
    const minWidth = 52.0;

    final isLTR = context.isLTR;
    final gradientPosition = Curves.decelerate.transform(animationProgress);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: Shadows.s,
        color: colors.backgroundSurface2,
      ),
      child: Semantics(
        label: widget.isLaunching ? context.l10n.launchingNavigator : context.l10n.goToNavigator,
        button: true,
        container: true,
        child: ExcludeSemantics(
          excluding: widget.isLaunching,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () {
              BaladyNavigationEvents.trackFreeRoamStarted(BaladyFreeRoamSource.dashboard);
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
                        if (isLTR) gradientPosition else 1 - gradientPosition,
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
                              child: Icon(
                                TransportIcons.newlocationDirectionNavigator,
                                size: iconSize,
                                color: context.colors.foregroundSoft,
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
                                    style: context.textStyles.bodySmallSemiBold.copyWith(color: iconAndTextColor),
                                  ),
                                  AppButton(
                                    color: context.colors.accentSecondarySoft,
                                    onTap: () {
                                      ref.read(freeRoamStarterProvider.notifier).pauseAnimation();
                                      context.router.push(const AutostartSettingsSheetRoute());
                                    },
                                    primaryIcon: SystemIcons.close,
                                    buttonColorScheme: ButtonColorScheme.accent,
                                  ),
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.isLaunching;
}
