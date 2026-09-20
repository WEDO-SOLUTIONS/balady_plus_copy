import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/balady_analytics/events/service_events.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:sheetify/sheetify.dart';

/// Encapsulates all dashboard quick action callbacks and navigation logic.
/// This class eliminates props drilling by centralizing all action handlers
/// that were previously passed as 8 separate callbacks through the widget tree.
class DashboardActions {
  const DashboardActions(this.ref, {this.bottomSheetController});

  final WidgetRef ref;
  final MultiStateSheetController<ThreeStateSheet>? bottomSheetController;

  /// Helper to log themed quick action
  void _logThemedQuickAction(String actionName) {
    final themeMode = ref.read(specialThemeModeProvider);
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.quickActionTapped,
      group: MetricsConstants.themesTag,
      action: MetricAction.tap.name,
      props: {'action': actionName, 'theme': themeMode.name},
    );
  }

  /// Toggles the parking layer view on/off.
  void openParking() {
    _logThemedQuickAction('parking');
    ref.read(appAnalyticsProvider).quickActionSelected('parking');
    bottomSheetController?.position.animateTo(0, duration: Durations.medium1, curve: Curves.easeOutQuart);
    bottomSheetController?.setState(ThreeStateSheet.hidden);
    ref.read(layersControlsProvider.notifier).toggleParking();
  }

  /// Opens the Qibla (Kiblah) direction screen.
  ///
  /// Checks location permission before navigating.
  Future<void> openQibla(BuildContext context) async {
    _logThemedQuickAction('qibla');
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

  Future<void> openNearby(BuildContext context) async {
    await context.router.push(const NearbyRoute());
  }

  /// Opens the Quran mini-app.
  void openQuran() {
    _logThemedQuickAction('quran');
    ref.read(appAnalyticsProvider).quickActionSelected('quran');
    ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    CommonFunctions.openMiniApp(serviceKey: 'Quran');
  }

  /// Opens the Athkar mini-app.
  void openAthkar() {
    _logThemedQuickAction('athkar');
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    CommonFunctions.openMiniApp(serviceKey: 'Athkar');
  }

  /// Opens the Free Roam navigation screen.
  void openFreeRoam(BuildContext context) {
    _logThemedQuickAction('free_roam');
    ref.read(appAnalyticsProvider).quickActionSelected('free_roam');
    BaladyNavigationEvents.trackFreeRoamStarted(BaladyFreeRoamSource.dashboard);
    context.router.push(const FreeRoamRoute());
  }

  /// Opens the user's current location sharing screen.
  ///
  /// Checks location permission before navigating.
  Future<void> openMyLocation(BuildContext context) async {
    _logThemedQuickAction('send_location');
    ref.read(appAnalyticsProvider).quickActionSelected('my_location');
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final location = ref.read(locationProvider.notifier);
    final allowed = await location.checkLocationPermission();
    if (!allowed) {
      return;
    }

    final userLocation = ref.read(locationProvider);
    if (userLocation == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }
    detach(
      context.router.push(
        ShareMyLocationRoute(
          cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
          closestPoint: LatLng(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          ),
        ),
      ),
      tag: 'dashboardActions.push',
    );
  }

  /// Opens the Snap and Send mini-app for reporting issues.
  void openSnapAndSend() {
    _logThemedQuickAction('snap_and_send');
    ref.read(appAnalyticsProvider).quickActionSelected('snap_and_send');
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.enhanceUrbanSceneBannerButton,
      action: MetricAction.tap.name,
      group: MetricsConstants.exploreTag,
    );
    ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    CommonFunctions.openMiniApp(serviceKey: 'snapandsend');
  }

  /// Opens the road event reporting feature.
  ///
  /// TODO: Implement road event action when feature is ready.
  void openRoadEvent() {
    _logThemedQuickAction('road_event');
    ref.read(appAnalyticsProvider).quickActionSelected('road_event');
  }
}
