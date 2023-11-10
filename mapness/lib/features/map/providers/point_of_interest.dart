import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/camera_position.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:mapness/features/map/providers/highlight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId,
) async {
  final dgisController = ref.watch(dgisControllerProvider);
  final cameraController = ref.watch(cameraPositionProvider.notifier);
  final highlightController = ref.watch(highlightProvider.notifier);

  final result = await dgisController?.searchByObjectId(objectId);
  if (result == null) return null;

  if (result.markerPosition != null) {
    await cameraController.animateTo(
      CameraPositionMessage(
        point: GeoPointMessage(
          latitude: result.markerPosition!.latitude,
          longitude: result.markerPosition!.longitude,
        ),
        zoom: 17,
        tilt: 45,
        bearing: 0,
      ),
    );
    final markerId = 'pointOfInterest-$objectId';
    await dgisController?.addMarker(
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
      dgisController?.removeMarker(markerId);
    });
  }

  await highlightController.addHighlight(objectId);
  ref.onDispose(() {
    highlightController.removeHighlight(objectId);
  });

  return result;
}
