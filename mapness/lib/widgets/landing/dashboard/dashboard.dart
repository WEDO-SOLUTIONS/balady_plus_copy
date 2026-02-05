import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart' hide Stories, StatefulSheetDelegateFunction, StatefulSheetDelegateValue;
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_contents/base_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/national_day_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/makkah_based_dashboard_content.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';
import 'package:mapness/widgets/landing/dashboard/map_hidden_state_controls.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:sheetify/sheetify.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    required this.bottomSheetController,
    required this.fireworksController,
    super.key,
  });

  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  final AnimationController fireworksController;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

// Using TickerProviderStateMixin here as SingleTickerProviderStateMixin throws,
// probably because DashboardHeaderDelegate is recreated
class _DashboardState extends ConsumerState<Dashboard> with TickerProviderStateMixin, WidgetsBindingObserver {
  final ValueNotifier<double> footerOpacity = ValueNotifier<double>(1.0);

  late FreeRoamStartState freeRoamState;

  StatefulSheetDelegateFunction<double, ThreeStateSheet> _buildOutsideOpacityDelegate(bool isMakkahTheme) {
    // Makkah theme: start fading earlier (0.33) and fade faster (multiplier 15)
    // Other themes: start fading at 0.4 with multiplier 9
    final threshold = isMakkahTheme ? 0.33 : 0.4;
    final fadeMultiplier = isMakkahTheme ? 15.0 : 9.0;

    return StatefulSheetDelegateFunction<double, ThreeStateSheet>(
      function: (controller) {
        final fraction = controller.fraction;
        final interpolation = controller.interpolation;
        final state = controller.state;

      final isGoToNavigatorShown = freeRoamState.canStart &&
          !freeRoamState.isAutorun;

        final isSheetCoversThreshold = fraction > threshold;
        final isSheetStateOpen = state == ThreeStateSheet.open;
        final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

        final isFull =
            isGoToNavigatorShown ||
            (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
            isSheetCoversThreshold;

        return !isFull ? 1.0 : max(0.0, 1 - (fraction - threshold) * fadeMultiplier);
      },
    );
  }
  final barrierColorDelegate = StatefulSheetDelegateFunction<Color?, ThreeStateSheet>(
    function: (controller) {
      final state = controller.state;

      if (state == ThreeStateSheet.expanded) {
        return Colors.black.withOpacity(.4);
      }
      if (state == ThreeStateSheet.open) {
        return Colors.black.withOpacity(.4 * controller.interpolation);
      }
      return null;
    },
  );

  final topHeaderOffset = const StatefulSheetDelegateValue<double>(value: -Spacing.$4x);

  @override
  void initState() {
    super.initState();
    widget.bottomSheetController.addListener(_scrollListenHandler);
  }

  @override
  void dispose() {
    widget.bottomSheetController.removeListener(_scrollListenHandler);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _checkLocationPermission(state);

  ///This method is intended for handling location permission requests
  /// if it's triggered by someone before Mapness starts.
  void _checkLocationPermission(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(layersControlsProvider, (previous, next) {
      if (next.layersVisible) {
        widget.bottomSheetController.setState(ThreeStateSheet.hidden);
      }
    });

    freeRoamState = ref.watch(freeRoamStarterProvider);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final themeConfig = dashboardThemeConfigFor(specialThemeMode);
    final isMakkahTheme = specialThemeMode == SpecialThemeMode.mekkahBase ||
        specialThemeMode == SpecialThemeMode.ramadan;
    final config = CityEventConfig.fromEventType(activeEvent);

    final eventLogo = config?.logoConfig != null && config!.hasDashboardLogo
        ? CityEventLogo(
      config: config.logoConfig!,
      fireworksController: widget.fireworksController,
      onTap: () {
        if (activeEvent == CityEventType.foundingDay) {
          ref.read(foundingDayProvider.notifier).openThePlace();
        }
      },
    )
        : null;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
        child: Stack(
          children: [
            Directionality(
              textDirection: Directionality.of(context),
              child: MultiStateSheet<ThreeStateSheet>(
                animateOpening: false,
                keepContentBehindFooter: true,
                useSafeArea: false,
                scrollController: widget.bottomSheetController,
                topHeader: MapHiddenStateControls(widget.bottomSheetController, widget.fireworksController),
                topHeaderOffset: themeConfig.useTopHeaderOffset ? topHeaderOffset : null,
                offsetOutsideWidgetByTopheader: themeConfig.offsetOutsideWidgetByTopHeader,
                backgroundColor: themeConfig.backgroundColor ?? context.colors.backgroundSurface2,
                dragger: SheetDragger(backgroundColor: themeConfig.backgroundColor ?? context.colors.backgroundSurface2),
                header: const DashboardHeader(),
                footer: IgnorePointer(
                  child: SizedBox(
                    height: Spacing.$16x + Spacing.$5x,
                    width: double.infinity,
                    child: FadeTransition(
                      opacity: Animation.fromValueListenable(footerOpacity),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.srcOver,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white.withOpacity(0), Colors.white.withOpacity(0.8)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                barrierColorDelegate: barrierColorDelegate,
                outside: MapDashboardControls(
                  widget.bottomSheetController,
                  key: const ValueKey('MapDashboardControls'),
                ),
                outsideOpacityDelegate: _buildOutsideOpacityDelegate(isMakkahTheme),
                sliver: SliverPersistentHeader(
                  delegate: DashboardHeaderDelegate(vsync: this),
                  pinned: true,
                  floating: true,
                ),
                content: [
                  _buildDashboardContent(specialThemeMode, themeConfig),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListenHandler() {
    footerOpacity.value = min(1.0, (1 - widget.bottomSheetController.fraction) * 2);

    Future.delayed(Duration.zero, () {
      if (widget.bottomSheetController.state != ThreeStateSheet.hidden) {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateDashboard(),
            );
      } else {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateIdle(),
            );
      }
    });
  }

  Widget _buildDashboardContent(SpecialThemeMode themeMode, DashboardThemeConfig themeConfig) {
    switch (themeMode) {
      case SpecialThemeMode.mekkahBase:
      case SpecialThemeMode.ramadan:
        return MakkahBasedDashboardContent(
          themeMode: themeMode,
          themeConfig: themeConfig,
        );
      case SpecialThemeMode.nationalDay:
        return NationalDayDashboardContent(themeConfig: themeConfig);
      case SpecialThemeMode.foundationDay:
      case SpecialThemeMode.base:
        return BaseDashboardContent(themeConfig: themeConfig);
    }
  }
}
