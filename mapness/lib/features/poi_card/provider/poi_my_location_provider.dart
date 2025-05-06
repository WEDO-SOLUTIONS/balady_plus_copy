import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_my_location_provider.g.dart';

class PoiMyLocationState {
  final String? address;
  final LatLng location;
  final String? title;
  final bool isAuthorized;

  const PoiMyLocationState({
    required this.address,
    required this.location,
    required this.title,
    required this.isAuthorized,
  });
}

@riverpod
class PoiMyLocation extends _$PoiMyLocation {
  @override
  Future<PoiMyLocationState?> build({
    required LatLng? closestPoint,
    required PoiCameraConfig? cameraConfig,
  }) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    String? address;

    if (closestPoint == null || cameraConfig == null) {
      return null;
    }

    unawaited(_cameraAnimation(closestPoint));

    try {
      final data = await dgisController.search(
        '${closestPoint.latitude}, ${closestPoint.longitude}',
        sortingType: SortingTypeMessage.byDistance,
      );

      if (data.firstPage?.items.isNotEmpty == true) {
        address = data.firstPage!.items.firstOrNull?.makeAddress();
        address ??= '${closestPoint.latitude}, ${closestPoint.longitude}';
      }
    } catch (_) {}

    final userData = ref.watch(authProvider).requireValue;

    final language = ref.read(appLanguageProvider);
    final title = userData?.getLocalizedFirstAndLastName(language);
    return PoiMyLocationState(
      address: address,
      location: closestPoint,
      title: title,
      isAuthorized: CommonProperties.isLoggedIn,
    );
  }

  Future<void> _cameraAnimation(LatLng closestPoint) async {
    final settings = MapObjectManagerSettings.myLocation();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    await mapObjectManager.removeAllMarkers();
    final marker = Markers.pinMarker(
      GeoPointWithElevationMessage(
        latitude: closestPoint.latitude,
        longitude: closestPoint.longitude,
        elevation: 1,
      ),
    );

    /// For those cases when we switch from an area (building) to MyLocation
    final selectedMarker = ref.read(selectedMarkerProvider.notifier);
    await selectedMarker.removeAllMarkers();
    await ref.read(highlightProvider.notifier).removeAll();

    await mapObjectManager.addMarker(marker);

    await ref.read(cameraPositionProvider.notifier).animateTo(
          CameraPositionMessage(
            point: GeoPointMessage(latitude: closestPoint.latitude, longitude: closestPoint.longitude),
            zoom: cameraConfig?.zoom ?? 16,
            tilt: cameraConfig?.tilt ?? 0,
            bearing: cameraConfig?.bearing ?? 0,
          ),
        );

    ref.onDispose(() async {
      await mapObjectManager.removeAllMarkers();
    });
  }
}
