import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';
const fontName = 'Noto Sans Arabic Regular';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  Ref ref,
  DgisObjectIdMessage objectId,
  LatLng? closestPoint,
) async {
  final directoryObject = await ref.watch(directoryObjectFromDgisIdProvider(objectId).future);

  final cleanupRubrics = (directoryObject?.rubricIds ?? []).nonNulls;
  final rubrics = Set<int>.from(cleanupRubrics);
  final mapMarkerMapper = ref.read(rubricMarkerMapperProvider.notifier).getMarkerType(rubrics);

  final isMarkerPositionIsNull = directoryObject == null || directoryObject.markerPosition == null;

  final position = LatLng(
    latitude: directoryObject?.markerPosition!.latitude ?? 0,
    longitude: directoryObject?.markerPosition!.longitude ?? 0,
  );

  final selectedMarker = ref.read(selectedMarkerProvider.notifier);
  final textStyle = MarkerTextStyleMessage(
    fontSize: 13,
    textOffset: 4,
    strokeColor: 0xD3FFFFFF,
    strokeWidth: 3,
    fontName: fontName,
    textPlacement: MarkerTextPlacementMessage(
      placement: TextPlacementMessage.rightCenter,
    ),
  );

  if (closestPoint != null) {
    await selectedMarker.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: closestPoint.latitude,
          longitude: closestPoint.longitude,
          elevation: 1,
        ),
        text: directoryObject?.title,
        textStyle: textStyle,
        icon: mapMarkerMapper?.iconPath.bigIconPath,
        id: poiPinId,
      ),
    );
  } else {
    await selectedMarker.showMarker(
      Markers.pinMarker(
        GeoPointWithElevationMessage(
          latitude: position.latitude,
          longitude: position.longitude,
          elevation: 1,
        ),
        text: directoryObject?.title,
        textStyle: textStyle,
        icon: mapMarkerMapper?.iconPath.bigIconPath,
        id: poiPinId,
      ),
    );
  }

  final highlightController = ref.read(highlightProvider.notifier);
  await highlightController.removeAll();
  await highlightController.addHighlight(objectId);

  if (directoryObject != null) {
    for (final entrance in directoryObject.entrances) {
      await highlightController.addHighlight(entrance.id);
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
