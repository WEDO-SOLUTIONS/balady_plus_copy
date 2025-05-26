import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit hide Stories;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';
import 'package:mapness/widgets/landing/dashboard/map_hidden_state_controls.dart';
import 'package:mapness/widgets/landing/dashboard_feedback_card.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
import 'package:mapness/widgets/landing/place_preview.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    required this.bottomSheetController,
    super.key,
  });

  final uikit.StatefulBottomSheetController<uikit.ThreeStateBottomSheet> bottomSheetController;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin {
  final ValueNotifier<double> footerOpacity = ValueNotifier<double>(1.0);

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
  Widget build(BuildContext context) {
    ref.listen(layersControlsProvider, (previous, next) {
      if (next.layersVisible) {
        widget.bottomSheetController.setState(uikit.ThreeStateBottomSheet.hidden);
      }
    });

    return SafeArea(
      bottom: false,
      child: uikit.StatefulBottomSheet<uikit.ThreeStateBottomSheet>(
        animateOpening: false,
        keepContentBehindFooter: true,
        scrollController: widget.bottomSheetController,
        topHeader: MapHiddenStateControls(widget.bottomSheetController),
        backgroundColor: context.colorsV2.backgroundSurface2,
        header: const DashboardHeader(),
        footer: IgnorePointer(
          child: SizedBox(
            height: uikit.Spacing.$16x + uikit.Spacing.$5x,
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
        backgroundColorDelegate: (controller) {
          final state = controller.state;
          if (state == ThreeStateBottomSheet.expanded) {
            return Colors.black.withOpacity(.4);
          }
          return null;
        },
        outside: MapDashboardControls(widget.bottomSheetController, key: const ValueKey('MapDashboardControls')),
        outsideOpacityDelegate: (controller) {
          final aspectRatio = controller.aspectRatio;
          final interpolation = controller.interpolation;
          final state = controller.state;

          final freeRoamState = ref.watch(freeRoamStarterProvider);
          final isGoToNavigatorShown = freeRoamState.canStart && !freeRoamState.isAutorun;

          final isSheetCoversHalfOfTheScreen = aspectRatio > 0.4;
          final isSheetStateOpen = state == uikit.ThreeStateBottomSheet.open;
          final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

          final isFull = isGoToNavigatorShown ||
              (!widget.bottomSheetController.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
              isSheetCoversHalfOfTheScreen;

          return !isFull ? 1.0 : max(0.0, 1 - (aspectRatio - 0.4) * 9);
        },
        sliverBeforeContent: SliverPersistentHeader(
          delegate: DashboardHeaderDelegate(vsync: this),
          pinned: true,
          floating: true,
        ),
        content: [
          const SizedBox(height: uikit.Spacing.$3x),
          FeedbackBannerCardV2(
            path: Assets.images.feedbackDashboard.keyName,
            onTap: () {
              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
              context.router.push(QuickFeedbackRoute());
            },
            gradientColors: const [
              /// It's normal that some components are not from the design and color system too
              Color(0xFF4EC9C0),
              Color(0xFF2AB3A9),
            ],
            title: context.l10n.contribute,
            subtitle: context.l10n.buildBaladyTogether,
          ),
          const SizedBox(height: uikit.Spacing.$6x),
          StoriesWidget(
            titleWidget: Padding(
              padding: const EdgeInsets.only(bottom: uikit.Spacing.$3x),
              child: DashboardTitle(context.l10n.whatIsNewInBalady),
            ),
          ),
          const SizedBox(height: uikit.Spacing.$6x),
          DashboardTitle(context.l10n.quickActions),
          const SizedBox(height: uikit.Spacing.$4x),
          ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x, vertical: uikit.Spacing.$0_5x),
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
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.freeRoam,
                    icon: uikit.TransportIcons.locationDirectionNavigator,
                    onTap: _openFreeRoam,
                  ),
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.parkingAction,
                    icon: General32Icons.parkingAction,
                    onTap: _openParking,
                  ),
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.snapAndSendAction,
                    icon: General32Icons.snapAndSendAction,
                    onTap: _openSnapAndSend,
                  ),
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.qibla,
                    icon: General32Icons.qiblaAction,
                    onTap: () => _openQibla(context),
                  ),
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.quaranAction,
                    icon: General32Icons.quaranAction,
                    onTap: () => _openQuran(context),
                  ),
                  const SizedBox(width: uikit.Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.athkarAction,
                    icon: General32Icons.athkarAction,
                    onTap: () => _openAthkar(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: uikit.Spacing.$4x),
          const DriveBackHomeCard(),
          const SizedBox(height: uikit.Spacing.$6x),
          DashboardTitle(context.l10n.exploreNearby),
          const SizedBox(height: uikit.Spacing.$4x),
          const PlacePreview(),
          const SizedBox(height: uikit.Spacing.$6x),
          const DashboardFeedbackCard(),
          const SizedBox(height: uikit.Spacing.$6x),
        ],
      ),
    );
  }

  void _openParking() {
    ref.read(appAnalyticsProvider).quickActionSelected('parking');
    widget.bottomSheetController.position.animateTo(0, duration: Durations.medium1, curve: Curves.easeOutQuart);
    widget.bottomSheetController.setState(uikit.ThreeStateBottomSheet.hidden);
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
    NavigationService.navigatorKey.currentState?.pushNamed(RouteName.menuQuranPage);
  }

  void _openAthkar(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    NavigationService.navigatorKey.currentState?.pushNamed(RouteName.mainAthkarPage);
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
    CommonFunctions.openSnapAndSend();
  }

  void _scrollListenHandler() {
    footerOpacity.value = min(1.0, (1 - widget.bottomSheetController.aspectRatio) * 2);

    Future.delayed(Duration.zero, () {
      if (widget.bottomSheetController.state != uikit.ThreeStateBottomSheet.hidden) {
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
