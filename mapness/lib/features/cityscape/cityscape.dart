import 'package:dgis_map/library.dart' as sdk;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/cityscape/cityscape_debug.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cityscape.g.dart';

/// Configuration for the Cityscape date range
class CityscapeConfig {
  /// Start date for the Cityscape
  static DateTime get startDate => DateTime(2025, 9, 18);

  /// End date for the Cityscape
  static DateTime get endDate => DateTime(2025, 9, 27, 23, 59, 59);

  /// Update interval for the provider (15 minutes)
  static const Duration updateInterval = Duration(minutes: 15);
}

/// Provider that checks if the current time is between two specified dates
/// and updates every 15 minutes.
///
/// Returns `true` if the current time is between the start and end dates,
/// `false` otherwise.
@riverpod
class Cityscape extends _$Cityscape {
  /// Object IDs for Riyadh International Convention & Exhibition Center
  static const int _cityscapeObjectId = 70030076677108076;

  // Riyadh International Convention & Exhibition Center,
  // Riyadh, Ar-Riyad, Riyadh, Saudi Arabia
  static final sdk.GeoPointMessage center = sdk.GeoPointMessage(
    latitude: 25.252325164174778,
    longitude: 46.38741921633482,
  );

  static const String cityscapeGlobalMarkerId = 'cityscape_global';

  MapObjectManager? mapManager;

  String get customPinPath => Assets.icons.svg.icCityscapePin.keyName;

  String get customMarker => Assets.icons.svg.cityscapeUniqueMarker.keyName;

  String get globalImg => Assets.images.cityscapeGlobal.keyName;

  @override
  bool build() {
    // Check if debug override is enabled
    final debugOverride = ref.watch(cityscapeDebugProvider);
    if (debugOverride) {
      return true;
    }

    // Return the initial state
    return _isCurrentTimeInRange();
  }

  /// Checks if the current time is within the specified date range
  bool _isCurrentTimeInRange() {
    final now = DateTime.now();
    return now.isAfter(CityscapeConfig.startDate) && now.isBefore(CityscapeConfig.endDate);
  }

  /// Checks if the custom pin should be shown, based on the object ID
  bool showCustomPin(int objectId) => _cityscapeObjectId == objectId && state;

  /// Manually triggers an update of the state
  void refresh() {
    state = _isCurrentTimeInRange();
  }

  Future<void> initializeGlobalMarker() async {
    mapManager = ref.read(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.myLocation().name,
        layerId: MapObjectManagerSettings.myLocation().layerId,
      ).notifier,
    );
    await mapManager?.removeMarkerById(cityscapeGlobalMarkerId);

    final globalMarker = sdk.Marker(
      id: cityscapeGlobalMarkerId,
      options: sdk.MarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: customPinPath, width: 70),
        anchor: sdk.MarkerAnchorMessage(x: 0.5, y: 1),
        animatedAppearance: true,
        isVisible: false,
        zIndex: 50,
      ),
      onTap: openThePlace,
    );

    await mapManager?.addMarker(globalMarker);
  }

  Future<void> showGlobalMarker() async {
    await mapManager?.setMarkerOptions(
      cityscapeGlobalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: customPinPath, width: 70),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        animatedAppearance: true,
        isVisible: true,
        zIndex: 50,
      ),
    );
  }

  Future<void> hideGlobalMarker() async {
    await mapManager?.setMarkerOptions(cityscapeGlobalMarkerId, sdk.ChangeMarkerOptionsMessage(isVisible: false));
  }

  void openThePlace() {
    ref.read(appRouterProvider).replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: sdk.DgisObjectIdMessage(
          objectId: _cityscapeObjectId,
          entranceId: 0,
        ),
        closestPoint: sdk.LatLng(latitude: center.latitude, longitude: center.longitude),
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ),
      toCompareRoutes: [PoiCardWidgetRoute.page],
    );
  }

  /// Simple provider that returns the current status without periodic updates
  /// Use this if you only need a one-time check
  static bool isNow() {
    // Check if debug override is enabled
    if (cityscapeDebugOverride) {
      return true;
    }

    final now = DateTime.now();
    return now.isAfter(CityscapeConfig.startDate) && now.isBefore(CityscapeConfig.endDate);
  }
}
