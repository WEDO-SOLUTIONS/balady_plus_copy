import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId, {
  LatLng? closestPoint,
}) async {
  final directoryObject = await ref.watch(directoryObjectFromDgisIdProvider(objectId).future);
  final isMarkerPositionIsNull = directoryObject == null || directoryObject.markerPosition == null;

  final position = LatLng(
    latitude: directoryObject?.markerPosition!.latitude ?? 0,
    longitude: directoryObject?.markerPosition!.longitude ?? 0,
  );

  if (closestPoint == null) {
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

  return directoryObject;
}
