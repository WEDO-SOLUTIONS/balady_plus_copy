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

  final position = isMarkerPositionIsNull
      ? closestPoint
      : LatLng(
          latitude: directoryObject.markerPosition!.latitude,
          longitude: directoryObject.markerPosition!.longitude,
        );

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
  await highlightController.addHighlight(objectId);
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

  // Get viewports: visible (whole screen) and tappable (area of the screen where user can tap to interact with the marker)
  final visibleRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.value?.visibleRect;
  final tappableRect = _getRectWithPaddings(visibleRect, paddingConfig);

  // Check if point is in viewport
  final isInViewZone =
      visibleRect != null && await dgisController.value!.contains(visibleRect.geoRectMessage(), markerPoint);

  // Check if point is in tappable zone
  final isInTappableZone =
      tappableRect != null && await dgisController.value!.contains(tappableRect.geoRectMessage(), markerPoint);

  final cameraHaveToBeMoved = isInViewZone && !isInTappableZone;

  final cameraData = ref.read(cameraPositionProvider) ?? await dgisController.value?.getCameraPosition();

  final cameraZoom = cameraData?.zoom;
  final point = cameraData?.point;
  final bearing = cameraData?.bearing;
  final newPoint = point;

  if (cameraHaveToBeMoved && newPoint != null) {
    // If tapped point is to the left than min longitude => move right*
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

  // If point is in view zone, we animate to point of the camera (and slightly move it if needed)
  // Else we animate to marker point (if it is not in view zone, we will see the marker on the screen)
  final cameraPoint = isInViewZone && newPoint != null ? newPoint : markerPoint;

  // Act like 2GIS app: if point is in view zone, we animate to
  // a) point if it's not in tappable zone but in view zone
  // b) tilt set to 0 in all cases
  // c) zoom set to 17 if point is not in view zone
  // d) bearing set to 0 if not set
  await ref.read(cameraPositionProvider.notifier).animateTo(
        CameraPositionMessage(
          point: cameraPoint,
          zoom: isInViewZone ? cameraZoom ?? 17 : 17,
          tilt: 0,
          bearing: bearing ?? 0,
        ),
      );
  return directoryObject;
}

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
    southWestLon = southWestLon + difLon * (padding.left / screenSize.width);
    northEastLon = northEastLon - difLon * (padding.right / screenSize.width);
    southWestLat = southWestLat + difLat * (padding.bottom / screenSize.height);
    northEastLat = northEastLat - difLat * (padding.top / screenSize.height);
  }

  return VisibleRect(
    northEastLat: northEastLat,
    northEastLon: northEastLon,
    southWestLat: southWestLat,
    southWestLon: southWestLon,
    zoom: rect.zoom,
  );
}
