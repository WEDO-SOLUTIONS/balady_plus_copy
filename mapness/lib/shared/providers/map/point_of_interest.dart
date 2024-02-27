import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';

class PoiModel {
  final DirectoryObjectMessage? directoryObjectMessage;

  PoiModel({
    required this.directoryObjectMessage,
  });
}

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId, {
  PoiCameraConfig? cameraConfig,
  LatLng? closestPoint,
}) async {
  final dgisController = ref.watch(dgisControllerProvider);
  if (closestPoint != null) {
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: closestPoint.latitude,
          longitude: closestPoint.longitude,
          elevation: 0,
        ),
        id: poiPinId,
      ),
    );
  }

  final cameraData = ref.read(cameraPositionProvider) ??
      await dgisController.value?.getCameraPosition();

  final result = await dgisController.value?.searchByObjectId(objectId);

  final cameraZoom = cameraData?.zoom;
  final point = cameraData?.point;

  final highlightController = ref.read(highlightProvider.notifier);
  await highlightController.removeAll();
  await highlightController.addHighlight(objectId);
  ref.onDispose(() async {
    await highlightController.removeAll();
  });
  if (result == null || result.markerPosition == null) {
    return null;
  }
  final position = result.markerPosition!;
  if (closestPoint == null) {
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: position.latitude,
          longitude: position.longitude,
          elevation: 0,
        ),
        id: poiPinId,
      ),
    );
  }
  final markerPoint = GeoPointMessage(
    latitude: closestPoint?.latitude ?? position.latitude,
    longitude: closestPoint?.longitude ?? position.longitude,
  );
  if (cameraConfig == null) {
    // get viewport
    final visibleRect = ref
        .read(dgisControllerProvider.notifier)
        .visibleRectSubject
        .value
        ?.visibleRect;
    final viewPort = visibleRect != null
        ? CommonFunctions.getPolygonFromRect(visibleRect)
        : null;
    final box = viewPort?.getBounds();

    // Check if point is in viewport
    final bool isInViewPort = box != null &&
        await dgisController.value!.contains(
          GeoRectMessage(
            northEast: GeoPointMessage(latitude: box.maxY, longitude: box.maxX),
            southWest: GeoPointMessage(latitude: box.minY, longitude: box.minX),
          ),
          markerPoint,
        );

    await ref.read(cameraPositionProvider.notifier).animateTo(
          CameraPositionMessage(
            point: isInViewPort && point != null ? point : markerPoint,
            zoom: isInViewPort ? cameraZoom ?? 17 : 17,
            tilt: 0,
            bearing: 0,
          ),
        );
  } else {
    await ref.read(cameraPositionProvider.notifier).animateTo(
          CameraPositionMessage(
            point: markerPoint,
            zoom: cameraConfig.zoom ?? 17,
            tilt: cameraConfig.tilt ?? 0,
            bearing: cameraConfig.bearing ?? 0,
          ),
        );
  }
  return result;
}
