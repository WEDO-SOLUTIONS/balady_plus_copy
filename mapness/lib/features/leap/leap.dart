import 'package:dgis_map/library.dart' as sdk;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/leap/leap_poi.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leap.g.dart';

@riverpod
class Leap extends _$Leap {
  static const _config = LeapConfig();

  static const double _minVisibleZoom = 12;

  static const double _poiCardZoom = 17;
  static const double _iconWidth = 56;

  MapObjectManager? mapManager;

  bool _markerAdded = false;

  /// Marker/pin asset used for the LEAP venue itself, both as the map marker
  /// and as the selected-POI pin (see [RubricMarkerMapper.getMarkerPath]).
  String get customMarker => _config.customMarkerPath;

  @override
  bool build() {
    mapManager = ref.watch(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.cityEvent().name,
        layerId: MapObjectManagerSettings.cityEvent().layerId,
      ).notifier,
    );

    final debugOverride = ref.watch(leapDebugProvider);
    if (debugOverride) {
      return true;
    }

    final eventDateRange = ref.watch(dgisEnvironmentProvider.select((value) => value.value?.leapDateRange));

    return eventDateRange?.isNow ?? false;
  }

  Future<void> initializeGlobalMarker() async {
    await ref.read(dgisControllerProvider.future);

    mapManager = ref.read(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.cityEvent().name,
        layerId: MapObjectManagerSettings.cityEvent().layerId,
      ).notifier,
    );
    await mapManager?.removeMarkerById(_config.globalMarkerId);

    final globalMarker = sdk.Marker(
      id: _config.globalMarkerId,
      options: sdk.MarkerOptionsMessage(
        position: _config.center,
        icon: _icon,
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        isVisible: false,
        zIndex: 50,
      ),
      onTap: openThePlace,
    );

    await mapManager?.addMarker(globalMarker);
    _markerAdded = true;
  }

  Future<void> showGlobalMarker() async {
    await ref.read(dgisControllerProvider.future);
    if (!_markerAdded) {
      await initializeGlobalMarker();
    }

    final zoom = ref.read(cameraPositionProvider)?.zoom ?? 0.0;

    if (zoom < _minVisibleZoom) {
      await hideGlobalMarker();
      return;
    }

    await mapManager?.setMarkerOptions(
      _config.globalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: _config.center,
        icon: _icon,
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        animatedAppearance: true,
        isVisible: true,
        zIndex: 50,
      ),
    );
  }

  Future<void> hideGlobalMarker() async {
    await mapManager?.setMarkerOptions(_config.globalMarkerId, sdk.ChangeMarkerOptionsMessage(isVisible: false));
  }

  bool isLeapObject(int objectId) => _config.objectId == objectId && state;

  LeapPoi? getLeapPoi(int objectId) {
    if (!isLeapObject(objectId)) {
      return null;
    }

    final eventDateRange = ref.read(dgisEnvironmentProvider).value?.leapDateRange ?? CityEventDateRange.leapDefault();

    return LeapPoi(
      objectId: _config.objectId,
      center: sdk.GeoPointMessage(latitude: _config.center.latitude, longitude: _config.center.longitude),
      eventFrom: eventDateRange.from,
      eventTo: eventDateRange.to,
    );
  }

  Future<void> openThePlace() async {
    const cameraConfig = PoiCameraConfig(zoom: _poiCardZoom);
    final closestPoint = sdk.LatLng(latitude: _config.center.latitude, longitude: _config.center.longitude);
    await moveCameraToEventArea();

    await ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: sdk.DgisObjectIdMessage(objectId: _config.objectId, entranceId: 0),
            closestPoint: closestPoint,
            cameraConfig: cameraConfig,
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
  }

  Future<void> moveCameraToEventArea() async {
    await ref
        .read(cameraPositionProvider.notifier)
        .animateTo(
          sdk.CameraPositionMessage(
            point: sdk.GeoPointMessage(latitude: _config.center.latitude, longitude: _config.center.longitude),
            zoom: _poiCardZoom,
            tilt: 0,
            bearing: 0,
          ),
        );
  }

  sdk.MarkerIconMessage get _icon => _config.defaultMarkerPath.markerIcon(size: _iconWidth);
}
