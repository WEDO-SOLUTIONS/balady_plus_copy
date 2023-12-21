import 'package:dgis_map/library.dart';
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
  final cameraController = ref.watch(cameraPositionProvider.notifier);
  final cameraData = ref.read(cameraPositionProvider);
  final highlightController = ref.watch(highlightProvider.notifier);
  final dgisController = ref.watch(dgisControllerProvider);
  final result = await dgisController.value?.searchByObjectId(objectId);
  final mapObjectManager =
      ref.watch(mapObjectManagerProvider(named: poiMapLayer).notifier);

  final cameraZoom = cameraData?.zoom;
  print(
    'coordinates: ${result?.markerPosition?.latitude} ${result?.markerPosition?.longitude} zoom: $cameraZoom',
  );

  await highlightController.addHighlight(objectId);
  ref.onDispose(() {
    highlightController.removeAll();
  });
  if (result == null || result.markerPosition == null) return null;

  await cameraController.animateTo(
    CameraPositionMessage(
      point: GeoPointMessage(
        latitude: result.markerPosition!.latitude,
        longitude: result.markerPosition!.longitude,
      ),
      zoom: cameraZoom ?? 17,
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
      ),
    ),
  );
  ref.onDispose(() {
    mapObjectManager.removeAllMarkers();
  });

  return result;
}
