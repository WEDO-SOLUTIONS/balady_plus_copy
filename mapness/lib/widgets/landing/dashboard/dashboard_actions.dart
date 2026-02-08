import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';

/// Encapsulates all dashboard quick action callbacks and navigation logic.
///
/// This class eliminates props drilling by centralizing all action handlers
/// that were previously passed as 8 separate callbacks through the widget tree.
class DashboardActions {
  const DashboardActions(this.ref);

  final WidgetRef ref;

  /// Opens the parking layer view.
  void openParking() {
    ref.read(appAnalyticsProvider).quickActionSelected('parking');
    ref.read(layersControlsProvider.notifier).enableParking();
  }

  /// Opens the Qibla (Kiblah) direction screen.
  ///
  /// Checks location permission before navigating.
  Future<void> openQibla(BuildContext context) async {
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

  /// Opens the Quran mini-app.
  void openQuran() {
    ref.read(appAnalyticsProvider).quickActionSelected('quran');
    sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Quran_Show_All_Surahs_Page",
    );
  }

  /// Opens the Athkar mini-app.
  void openAthkar() {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Athkar_Page",
    );
  }

  /// Opens the Free Roam navigation screen.
  void openFreeRoam(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('free_roam');
    context.router.push(const FreeRoamRoute());
  }

  /// Opens the user's current location sharing screen.
  ///
  /// Checks location permission before navigating.
  Future<void> openMyLocation(BuildContext context) async {
    ref.read(appAnalyticsProvider).quickActionSelected('my_location');
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

    ref
        .read(advertMetricsProvider.notifier)
        .sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final location = ref.read(locationProvider.notifier);
    final allowed = await location.checkLocationPermission();
    if (!allowed) return;

    final userLocation = ref.read(locationProvider);
    if (userLocation == null) return;

    if (!context.mounted) return;
    context.router.push(
      ShareMyLocationRoute(
        cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
        closestPoint: LatLng(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
        ),
      ),
    );
  }

  /// Opens the Snap and Send mini-app for reporting issues.
  void openSnapAndSend() {
    ref.read(appAnalyticsProvider).quickActionSelected('snap_and_send');
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.enhanceUrbanSceneBannerButton,
      action: MetricAction.tap.name,
      group: MetricsConstants.exploreTag,
    );
    sl<HomeMiniAppsListCubit>().openMiniApp(serviceKey: "snapandsend");
  }

  /// Opens the road event reporting feature.
  ///
  /// TODO: Implement road event action when feature is ready.
  void openRoadEvent() {
    // TODO: Implement road event action
    ref.read(appAnalyticsProvider).quickActionSelected('road_event');
  }
}
