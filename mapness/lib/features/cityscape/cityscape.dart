import 'package:dgis_map/library.dart' as sdk;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/cityscape/cityscape_debug.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cityscape.g.dart';

/// Provider that checks if the current time is between two specified dates
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

  String get cityscapeDefaultMarker => Assets.icons.svg.cityscapeUniqueDefaultMarker.keyName;

  String get globalImg => Assets.images.cityscapeGlobal.keyName;

  ProviderSubscription<AsyncValue<EnvironmentConfig>>? _environmentProviderSubscription;

  @override
  bool build() {
    // Check if debug override is enabled
    final debugOverride = ref.watch(cityscapeDebugProvider);
    if (debugOverride) {
      return true;
    }

    _environmentProviderSubscription = ref.listen(dgisEnvironmentProvider, (prev, current) {
      final range = current.value?.cityscapeDateTimeRange;
      if (range != null) {
        state = _checkIfInRange(range.from, range.to);
      }
    });

    ref.onDispose(() {
      _environmentProviderSubscription?.close();
    });

    return false;
  }

  bool _checkIfInRange(DateTime from, DateTime to) {
    final now = DateTime.now();
    return now.isAfter(from) && now.isBefore(to);
  }

  /// Checks if the custom pin should be shown, based on the object ID
  bool showCustomPin(int objectId) => _cityscapeObjectId == objectId && state;

  Future<void> initializeGlobalMarker() async {
    mapManager = ref.read(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.cityEvent().name,
        layerId: MapObjectManagerSettings.cityEvent().layerId,
      ).notifier,
    );
    await mapManager?.removeMarkerById(cityscapeGlobalMarkerId);

    final isArabic = ref.read(appLanguageProvider) == Language.arabic;
    final fontName = isArabic ? MapnessConstants.poiMapFontAr : MapnessConstants.poiMapFontEn;
    final title = isArabic
        ? 'الرياض الدولي\nالمعرض\nو مركز المؤتمرات'
        : 'Riyadh International\nExhibition\n& Convention Center';
    final globalMarker = sdk.Marker(
      id: cityscapeGlobalMarkerId,
      options: sdk.MarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: cityscapeDefaultMarker, width: 20),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        text: title,
        textStyle: sdk.MarkerTextStyleMessage(
          fontSize: 13,
          color: 0xFF2AB3A9,
          strokeWidth: 1,
          strokeColor: 0xFFFFFFFF,
          fontName: fontName,
          suppressOnOverlap: true,
        ),
        isVisible: false,
        zIndex: 50,
      ),
      onTap: openThePlace,
    );

    await mapManager?.addMarker(globalMarker);
  }

  Future<void> showGlobalMarker() async {
    final cameraPosition = ref.read(cameraPositionProvider);
    final zoom = cameraPosition?.zoom ?? 0.0;

    if (zoom < 12) {
      await hideGlobalMarker();
      return;
    }

    final isArabic = ref.read(appLanguageProvider) == Language.arabic;
    final fontName = isArabic ? MapnessConstants.poiMapFontAr : MapnessConstants.poiMapFontEn;
    final title = isArabic
        ? 'الرياض الدولي\nالمعرض\nو مركز المؤتمرات'
        : 'Riyadh International\nExhibition\n& Convention Center';
    await mapManager?.setMarkerOptions(
      cityscapeGlobalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: cityscapeDefaultMarker, width: 20),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        text: title,
        textStyle: sdk.MarkerTextStyleMessage(
          fontSize: 13,
          color: 0xFF2AB3A9,
          strokeWidth: 1,
          strokeColor: 0xFFFFFFFF,
          fontName: fontName,
          suppressOnOverlap: true,
        ),
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
    ref
        .read(appRouterProvider)
        .replaceOrPush(
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
}
