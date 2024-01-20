import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/map_viewport_changes.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

class PoiModel {
  final DirectoryObjectMessage? directoryObjectMessage;

  PoiModel({
    required this.directoryObjectMessage,
  });
}

const poiMapLayer = 'point-of-interest';
const _poiMarkerPrefix = 'poi-marker-';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId,
) async {
  final dgisController = ref.watch(dgisControllerProvider);

  final cameraData = ref.read(cameraPositionProvider) ??
      await dgisController.value?.getCameraPosition();

  final highlightController = ref.watch(highlightProvider.notifier);

  final result = await dgisController.value?.searchByObjectId(objectId);
  final mapObjectManager =
      ref.watch(mapObjectManagerProvider(named: poiMapLayer).notifier);

  final cameraZoom = cameraData?.zoom;
  final point = cameraData?.point;

  print(
    'coordinates: ${result?.markerPosition?.latitude} ${result?.markerPosition?.longitude} zoom: $cameraZoom',
  );

  await highlightController.addHighlight(objectId);
  ref.onDispose(() {
    highlightController.removeAll();
  });
  if (result == null || result.markerPosition == null) return null;

  final markerPoint = GeoPointMessage(
    latitude: result.markerPosition!.latitude,
    longitude: result.markerPosition!.longitude,
  );

  // get viewport
  final viewPort = ref.read(mapViewportChangesProvider);
  final box = viewPort.getBounds();

  // Check if point is in viewport
  final bool isInViewPort = box != null
      ? await dgisController.value?.contains(
            GeoRectMessage(
              northEast:
                  GeoPointMessage(latitude: box.maxY, longitude: box.maxX),
              southWest:
                  GeoPointMessage(latitude: box.minY, longitude: box.minX),
            ),
            markerPoint,
          ) ??
          false
      : false;

  await ref.read(cameraPositionProvider.notifier).animateTo(
        CameraPositionMessage(
          point: isInViewPort && point != null ? point : markerPoint,
          zoom: isInViewPort ? cameraZoom ?? 17 : 17,
          tilt: 0,
          bearing: 0,
        ),
      );
  final markerId = '$_poiMarkerPrefix$objectId';
  await mapObjectManager.removeAllMarkers();
  await mapObjectManager.addMarker(
    Marker(
      id: markerId,
      options: MarkerOptionsMessage(
        position: result.markerPosition!,
        icon: MarkerIconMessage(
          path: "packages/mapness/assets/icons/svg/ic_pin.svg",
          width: 24,
        ),
        anchor: MarkerAnchorMessage(x: 0.5, y: 1),
        animatedAppearance: true,
        zIndex: 50,
      ),
    ),
  );
  ref.onDispose(() {
    mapObjectManager.removeAllMarkers();
  });

  return result;
}
