import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_padding_config.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';

class PoiModel {
  PoiModel({
    required this.directoryObjectMessage,
  });
  final DirectoryObjectMessage? directoryObjectMessage;
}

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId, {
  PoiCameraConfig? cameraConfig,
  LatLng? closestPoint,
  PoiPaddingConfig? paddingConfig,
}) async {
  final dgisController = ref.watch(dgisControllerProvider);
  final directoryObject = await ref.watch(directoryObjectFromDgisIdProvider(objectId).future);
  final isMarkerPositionIsNull = directoryObject == null || directoryObject.markerPosition == null;

  final position = closestPoint ??
      (isMarkerPositionIsNull
          ? null
          : LatLng(
              latitude: directoryObject.markerPosition!.latitude,
              longitude: directoryObject.markerPosition!.longitude,
            ));

  if (position != null) {
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: position.latitude,
          longitude: position.longitude,
          elevation: 1,
        ),
        id: poiPinId,
      ),
    );
  }

  final highlightController = ref.read(highlightProvider.notifier);
  await highlightController.removeAll();

  if (directoryObject != null) {
    for (final entrance in directoryObject.entrances) {
      if (entrance != null) {
        await highlightController.addHighlight(entrance.id);
      }
    }
  }

  ref.onDispose(() async {
    await highlightController.removeAll();
  });

  if (isMarkerPositionIsNull) {
    return null;
  }

  final markerPoint = GeoPointMessage(
    latitude: position!.latitude,
    longitude: position.longitude,
  );

  // Get viewports: visible (whole screen) and tappable (area of the screen where marker will not overlap on other elements)
  final visibleRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.value?.visibleRect;
  final tappableRect = _getRectWithPaddings(visibleRect, paddingConfig);

  // Check if point is in viewport
  final isInViewZone = await _isInViewZone(visibleRect, dgisController, markerPoint);

  // Check if point is in tappable zone
  final isInTappableZone = await _isInViewZone(tappableRect, dgisController, markerPoint);

  final cameraHaveToBeMoved = isInViewZone && !isInTappableZone;

  final cameraData = ref.read(cameraPositionProvider) ?? await dgisController.value?.getCameraPosition();

  final cameraZoom = cameraData?.zoom;
  final point = cameraData?.point;
  final bearing = cameraData?.bearing;
  final newPoint = point;

  if (cameraHaveToBeMoved && newPoint != null) {
    // If tapped point is to the left than min longitude => move right
    final distFromMarkerToTapZoneLeft = tappableRect!.southWestLon - markerPoint.longitude;
    if (distFromMarkerToTapZoneLeft > 0) {
      newPoint.longitude -= distFromMarkerToTapZoneLeft;
    }
    // If tapped point is higher then max latitude => move down
    final distFromMarkerToTapZoneTop = markerPoint.latitude - tappableRect.northEastLat;
    if (distFromMarkerToTapZoneTop > 0) {
      newPoint.latitude += distFromMarkerToTapZoneTop;
    }
    // If tapped point is to right then max longitude => move left
    final distFromMarkerToTapZoneRight = markerPoint.longitude - tappableRect.northEastLon;
    if (distFromMarkerToTapZoneRight > 0) {
      newPoint.longitude += distFromMarkerToTapZoneRight;
    }
    // If tapped point is lower then min latitude => move up
    final distFromMarkerToTapZoneBottom = tappableRect.southWestLat - markerPoint.latitude;
    if (distFromMarkerToTapZoneBottom > 0) {
      newPoint.latitude -= distFromMarkerToTapZoneBottom;
    }
  }

  // If point is in view zone, we do nothing or we slightly move to point of the camera if needed
  // Else we animate to marker point (we will see the marker on the screen and the camera will be centered on it)
  // If you want to center the map, you must pass the sum value to PoiCameraConfig
  final cameraPoint = isInViewZone && newPoint != null && cameraConfig?.zoom == null ? newPoint : markerPoint;

  // Act like 2GIS app: if point is in view zone, we do:
  // a) slightly animate to point if it's not in tappable zone but in view zone
  // b) tilt set to 0 in all cases
  // c) zoom set to 17 if point is not in view zone or if zoom is not set
  // d) bearing set to 0 if not set

  final cameraPosition = ref.read(cameraPositionProvider.notifier);
  await cameraPosition.animateTo(
    CameraPositionMessage(
      point: cameraPoint,
      zoom: isInViewZone ? cameraConfig?.zoom ?? cameraZoom ?? 17 : 17,
      tilt: 0,
      bearing: bearing ?? 0,
    ),
  );
  return directoryObject;
}

Future<bool> _isInViewZone(
        VisibleRect? rect, AsyncValue<DgisMapController> dgisController, GeoPointMessage markerPoint) async =>
    rect != null && await dgisController.value!.contains(rect.geoRectMessage(), markerPoint);

VisibleRect? _getRectWithPaddings(VisibleRect? rect, PoiPaddingConfig? paddingConfig) {
  if (rect == null) {
    return null;
  }
  if (paddingConfig == null) {
    return rect;
  }
  final screenSize = paddingConfig.sizeOfScreen;
  final padding = paddingConfig.paddingOfCamera;

  final difLon = rect.northEastLon - rect.southWestLon;
  final difLat = rect.northEastLat - rect.southWestLat;

  double southWestLon = rect.southWestLon;
  double southWestLat = rect.southWestLat;
  double northEastLon = rect.northEastLon;
  double northEastLat = rect.northEastLat;

  if (screenSize != null && padding != null) {
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    southWestLon = southWestLon + difLon * (padding.left / screenWidth);
    northEastLon = northEastLon - difLon * (padding.right / screenWidth);
    southWestLat = southWestLat + difLat * (padding.bottom / screenHeight);
    northEastLat = northEastLat - difLat * (padding.top / screenHeight);
  }

  return VisibleRect(
    northEastLat: northEastLat,
    northEastLon: northEastLon,
    southWestLat: southWestLat,
    southWestLon: southWestLon,
    zoom: rect.zoom,
  );
}
