import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';
const poiMapFontAr = 'FrutigerLTArabic65Bold';
const poiMapFontEn = 'GolosText_SemiBold';

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
  final dark = await ref.watch(darkModeProvider.future);
  final isRtl = ref.read(appLanguageProvider) == Language.arabic;

  final title = directoryObject?.title;
  final textStyle = MarkerTextStyleMessage(
    fontSize: 13,
    textOffset: 4,
    color: dark.isDark ? 0xD3FFFFFF : 0xff1B1B1B,
    strokeColor: dark.isDark ? 0xff1B1B1B : 0xD3FFFFFF,
    strokeWidth: 1,
    fontName: title.containsArabic() || isRtl ? poiMapFontAr : poiMapFontEn,
    textPlacement: MarkerTextPlacementMessage(
      placement: TextPlacementMessage.bottomCenter,
    ),
  );

  await selectedMarker.showMarker(
    Markers.pinMarker(
      GeoPointWithElevationMessage(
        latitude: closestPoint?.latitude ?? position.latitude,
        longitude: closestPoint?.longitude ?? position.longitude,
        elevation: 1,
      ),
      text: title,
      textStyle: textStyle.copyWith(suppressOnOverlap: false),
      icon: mapMarkerMapper?.iconPath.bigIconPath,
      id: poiPinId,
    ),
  );

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
