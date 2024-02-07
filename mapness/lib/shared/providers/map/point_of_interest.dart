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
}) async {
  final dgisController = ref.watch(dgisControllerProvider);

  final cameraData = ref.read(cameraPositionProvider) ??
      await dgisController.value?.getCameraPosition();

  final highlightController = ref.watch(highlightProvider.notifier);

  final result = await dgisController.value?.searchByObjectId(objectId);

  final cameraZoom = cameraData?.zoom;
  final point = cameraData?.point;

  await highlightController.addHighlight(objectId);
  ref.onDispose(() {
    highlightController.removeAll();
  });
  if (result == null || result.markerPosition == null) {
    return null;
  }
  final position = result.markerPosition!;
  final markerPoint = GeoPointMessage(
    latitude: position.latitude,
    longitude: position.longitude,
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
  await ref.read(selectedMarkerProvider.notifier).showMarker(
        Markers.pinMarker(position, id: poiPinId),
      );
  ref.onDispose(() async {
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.removeMarker(poiPinId);
  });

  return result;
}
