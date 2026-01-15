import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart' hide Stories;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/wrc/wrc.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';
import 'package:mapness/widgets/landing/dashboard/map_hidden_state_controls.dart';
import 'package:mapness/widgets/landing/dashboard/wrc_logo.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/dashboard_offers_row.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
import 'package:mapness/widgets/landing/place_preview.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
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

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ValueNotifier<double> footerOpacity = ValueNotifier<double>(1.0);

  late FreeRoamStartState freeRoamState;

  late final outsideOpacityDelegate = StatefulSheetDelegateFunction<double, ThreeStateSheet>(
    function: (controller) {
      final fraction = controller.fraction;
      final interpolation = controller.interpolation;
      final state = controller.state;

      final isGoToNavigatorShown = freeRoamState.canStart && !freeRoamState.isAutorun;

      final isSheetCoversHalfOfTheScreen = fraction > 0.4;
      final isSheetStateOpen = state == ThreeStateSheet.open;
      final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

      final isFull = isGoToNavigatorShown ||
          (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
          isSheetCoversHalfOfTheScreen;

      return !isFull ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
    },
  );
  final barrierColorDelegate = StatefulSheetDelegateFunction<Color?, ThreeStateSheet>(function: (controller) {
    final state = controller.state;

    if (state == ThreeStateSheet.expanded) {
      return Colors.black.withOpacity(.4);
    }
    if (state == ThreeStateSheet.open) {
      return Colors.black.withOpacity(.4 * controller.interpolation);
    }
    return null;
  });

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
    final isNationalDay = ref.watch(saudiNationalDayProvider);
    final isWRCActive = ref.watch(wRCProvider);

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
                topHeaderOffset: isNationalDay ? topHeaderOffset : null,
                offsetOutsideWidgetByTopheader: !isNationalDay,
                backgroundColor: context.colors.backgroundSurface2,
                dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface2),
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
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                barrierColorDelegate: barrierColorDelegate,
                outside:
                    MapDashboardControls(widget.bottomSheetController, key: const ValueKey('MapDashboardControls')),
                outsideOpacityDelegate: outsideOpacityDelegate,
                sliver: SliverPersistentHeader(
                  delegate: DashboardHeaderDelegate(vsync: this),
                  pinned: true,
                  floating: true,
                ),
                content: [
                  const SizedBox(height: Spacing.$3x),
                  FeedbackBannerCardV2(
                    path: isNationalDay
                        ? Assets.images.feedbackDashboardSaudiday.keyName
                        : Assets.images.feedbackDashboard.keyName,
                    onTap: () {
                      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
                      context.router.push(const ContributeRoute());
                    },
                    gradientColors: isNationalDay
                        ? [
                            const Color(0xFF014850),
                            const Color(0xFF00343A),
                          ]
                        : [
                            const Color(0xFF4EC9C0),
                            const Color(0xFF2AB3A9),
                          ],
                    title: context.l10n.contribute,
                    subtitle: context.l10n.buildBaladyTogether,
                  ),
                  const SizedBox(height: Spacing.$6x),
                  StoriesWidget(
                    titleWidget: Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.$3x),
                      child: DashboardTitle(context.l10n.whatIsNewInBalady),
                    ),
                  ),
                  const SizedBox(height: Spacing.$6x),
                  DashboardTitle(context.l10n.quickActions),
                  const SizedBox(height: Spacing.$4x),
                  ScrollConfiguration(
                    behavior: NoGlowingScrollBehavior(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$0_5x),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickActionButton(
                            text: context.l10n.sendLocation,
                            icon: General32Icons.locationAction,
                            onTap: _openMyLocation,
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.freeRoam,
                            icon: TransportIcons.locationDirectionNavigator,
                            onTap: _openFreeRoam,
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.parkingAction,
                            icon: General32Icons.parkingAction,
                            onTap: _openParking,
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.snapAndSendAction,
                            icon: General32Icons.snapAndSendAction,
                            onTap: _openSnapAndSend,
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.qibla,
                            icon: General32Icons.qiblaAction,
                            onTap: () => _openQibla(context),
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.quaranAction,
                            icon: General32Icons.quaranAction,
                            onTap: () => _openQuran(context),
                          ),
                          const SizedBox(width: Spacing.$2x),
                          QuickActionButton(
                            text: context.l10n.athkarAction,
                            icon: General32Icons.athkarAction,
                            onTap: () => _openAthkar(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.$4x),
                  const DriveBackHomeCard(),
                  const SizedBox(height: Spacing.$6x),
                  const DashboardOffersRow(),
                  const SizedBox(height: Spacing.$6x),
                  if (!isNationalDay) ...[
                    DashboardTitle(context.l10n.exploreNearby),
                    const SizedBox(height: Spacing.$4x),
                    const PlacePreview(),
                    const SizedBox(height: Spacing.$6x),
                  ],
                  if (isNationalDay)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xff00343A),
                          ],
                        ),
                        image: DecorationImage(
                          image: Assets.images.backgroundOrnamentSaudiday.provider(),
                          matchTextDirection: true,
                          fit: BoxFit.cover,
                          alignment: AlignmentDirectional.centerEnd,
                        ),
                      ),
                      child: Column(
                        children: [
                          DashboardTitle(context.l10n.exploreNearby),
                          const SizedBox(height: Spacing.$4x),
                          const PlacePreview(),
                          const SizedBox(height: Spacing.$6x),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (isWRCActive)
              AnimatedBuilder(
                animation: widget.bottomSheetController,
                builder: (context, snapshot) {
                  final fraction = widget.bottomSheetController.fraction;
                  // Direction-agnostic visibility windows:
                  // Opening:  0.91 → 0.96  (becomes fully invisible at >= 0.96)
                  // Closing:  0.19 → 0.11  (becomes fully invisible at <= 0.11)
                  const double openStart = 0.91;
                  const double openEnd = 0.96; // fully invisible here
                  const double closeStart = 0.19;
                  const double closeEnd = 0.11; // fully invisible here
                  const double eps = 1e-6;

                  // Compute shrink amount independently for both windows and take the stronger effect.
                  final double openT = ((fraction - openStart) / (openEnd - openStart)).clamp(0.0, 1.0);
                  final double closeT = ((closeStart - fraction) / (closeStart - closeEnd)).clamp(0.0, 1.0);
                  final double shrink = max(openT, closeT); // 0.0..1.0
                  double scaleValue = 1.0 - shrink; // 1.0..0.0

                  // Hard clamp to 0 when we are beyond the full-invisible bounds.
                  if (fraction >= openEnd - eps || fraction <= closeEnd + eps) {
                    scaleValue = 0.0;
                  }

                  final double _baseBottom =
                      (widget.bottomSheetController.sheetHeight + (50 * scaleValue)).clamp(0.0, double.infinity);
                  return Positioned(
                    bottom: _baseBottom,
                    child: scaleValue <= 0.0
                        ? const SizedBox.shrink()
                        : Opacity(
                            opacity: scaleValue, // fade together with scale to avoid subpixel artifacts
                            child: Transform.scale(
                              scale: scaleValue,
                              alignment: Alignment.bottomCenter,
                              child: WRCLogo(
                                onTap: () {
                                  ref.read(wRCProvider.notifier).moveCameraToEventArea();
                                },
                              ),
                            ),
                          ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openParking() {
    ref.read(appAnalyticsProvider).quickActionSelected('parking');
    widget.bottomSheetController.position.animateTo(0, duration: Durations.medium1, curve: Curves.easeOutQuart);
    widget.bottomSheetController.setState(ThreeStateSheet.hidden);
    ref.read(layersControlsProvider.notifier).enableParking();
  }

  Future<void> _openQibla(BuildContext context) async {
    ref.read(appAnalyticsProvider).quickActionSelected('qibla');
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.qibla,
      action: MetricAction.tap.name,
      group: MetricsConstants.exploreTag,
    );
    final location = ref.read(locationProvider.notifier);

    await location.checkLocationPermission().then((allowed) {
      if (allowed) {
        context.router.push(const KiblahRoute());
      }
    });
  }

  void _openQuran(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('quran');
    sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Quran_Show_All_Surahs_Page",
    );
  }

  void _openAthkar(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Athkar_Page",
    );
  }

  void _openFreeRoam() {
    ref.read(appAnalyticsProvider).quickActionSelected('free_roam');
    context.router.push(const FreeRoamRoute());
  }

  void _openMyLocation() {
    ref.read(appAnalyticsProvider).quickActionSelected('my_location');
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final userLocation = ref.read(locationProvider);
    if (userLocation != null) {
      context.router.push(
        ShareMyLocationRoute(
          cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
          closestPoint: LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude),
        ),
      );
    }
  }

  void _openSnapAndSend() {
    ref.read(appAnalyticsProvider).quickActionSelected('snap_and_send');
    Metrics.logEventAdvanced(MetricsConstants.exploreKeys.enhanceUrbanSceneBannerButton,
        action: MetricAction.tap.name, group: MetricsConstants.exploreTag);
    sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "snapandsend",
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
}
