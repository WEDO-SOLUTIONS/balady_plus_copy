import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/explore_card.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';
import 'package:mapness/widgets/landing/dashboard/map_hidden_state_controls.dart';
import 'package:mapness/widgets/landing/dashboard_contents/base_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/dashboard_contents/makkah_based_dashboard_content.dart';
import 'package:mapness/widgets/landing/dashboard_contents/national_day_dashboard_content.dart';
import 'package:sheetify/sheetify.dart';

import 'city_event_config.dart';
import 'city_event_logo.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({required this.bottomSheetController, required this.fireworksController, super.key});

  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  final AnimationController fireworksController;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

// Using TickerProviderStateMixin here as SingleTickerProviderStateMixin throws,
// probably because DashboardHeaderDelegate is recreated
class _DashboardState extends ConsumerState<Dashboard> with TickerProviderStateMixin, WidgetsBindingObserver {
  late FreeRoamStartState freeRoamState;
  ThreeStateSheet? _lastMapControlsSheetState;

  StatefulSheetDelegateFunction<double, ThreeStateSheet> _buildOutsideOpacityDelegate(bool isMakkahTheme) {
    const threshold = 0.4;
    final fadeMultiplier = isMakkahTheme ? 15.0 : 9.0;

    return StatefulSheetDelegateFunction<double, ThreeStateSheet>(
      function: (controller) {
        final fraction = controller.fraction;
        final interpolation = controller.interpolation;
        final state = controller.state;

        final isGoToNavigatorShown = freeRoamState.canStart && !freeRoamState.isAutorun;

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
  void didChangeAppLifecycleState(AppLifecycleState state) => _checkLocationPermission(state);

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
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final themeConfig = dashboardThemeConfigFor(specialThemeMode, activeEvent, isDark: isDark);
    final isMakkahTheme =
        specialThemeMode == SpecialThemeMode.mekkahBase || specialThemeMode == SpecialThemeMode.ramadan;

    final config = CityEventConfig.fromEventType(activeEvent);
    final eventLogo = config?.logoConfig != null && config!.hasDashboardLogo
        ? CityEventLogo(
            config: config.logoConfig!,
            fireworksController: widget.fireworksController,
            onTap: () {
              if (kDebugMode) {
                debugPrint('amr activeEvent $activeEvent');
              }
              if (activeEvent == CityEventType.foundingDay) {
                ref.read(foundingDayUrbiProvider.notifier).openThePlace();
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
                dragger: SheetDragger(
                  backgroundColor: themeConfig.backgroundColor ?? context.colors.backgroundSurface2,
                ),
                footer: IgnorePointer(
                  child: SizedBox(
                    height: Spacing.$16x + Spacing.$5x,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.srcOver,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.colors.gradientBackgroundSurface4opacity0,
                            context.colors.gradientBackgroundSurface4opacity80,
                          ],
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
                content: [
                  _buildDashboardContent(specialThemeMode, themeConfig),
                ],
              ),
            ),
            if (eventLogo != null)
              Positioned(
                bottom: (widget.bottomSheetController.sheetHeight + 50).clamp(0.0, double.infinity),
                child: eventLogo,
              ),
            // TIFO entry now lives in the map controls column (TifoControl),
            // not as a debug-gated FAB here.
          ],
        ),
      ),
    );
  }

  void _scrollListenHandler() {
    if (!mounted) {
      return;
    }

    final sheetState = widget.bottomSheetController.state;
    if (_lastMapControlsSheetState == sheetState) {
      return;
    }
    _lastMapControlsSheetState = sheetState;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _lastMapControlsSheetState != sheetState) {
        return;
      }
      if (sheetState != ThreeStateSheet.hidden) {
        ref.read(mapControlsProvider.notifier).update(MapControlsStateDashboard());
      } else {
        ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle());
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
          bottomSheetController: widget.bottomSheetController,
        );
      case SpecialThemeMode.nationalDay:
        return NationalDayDashboardContent(
          themeConfig: themeConfig,
          bottomSheetController: widget.bottomSheetController,
          fireworksController: widget.fireworksController,
        );
      case SpecialThemeMode.foundationDay:
      case SpecialThemeMode.base:
        return BaseDashboardContent(
          themeConfig: themeConfig,
          bottomSheetController: widget.bottomSheetController,
          fireworksController: widget.fireworksController,
        );
    }
  }
}
