import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/urbi_map_x/lat_lng_x.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/parking_spot/parking_manage.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';
const poiMapFontAr = 'FrutigerLTArabic65Bold';
const poiMapFontEn = 'GolosText_SemiBold';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  Ref ref,
  DgisObjectId objectId,
  LatLng? closestPoint,
  BaladyAppThemes theme,
) async {
  final selectedMarker = ref.watch(selectedMarkerProvider.notifier);
  final parkingManager = ref.watch(parkingManageProvider(theme: theme).notifier);

  ref.onDispose(() {
    selectedMarker.removeMarker(poiPinId);
    parkingManager.restoreMarker();
  });

  final dgisController = await ref.read(dgisControllerProvider.future);
  final directoryObject = await dgisController.searchByObjectId(objectId.toMessage());

  if (directoryObject.levelId == null) {
    final nearestObjects = await dgisController.getNearestObjects();
    final renderedObject = nearestObjects.where((e) => e.objectId.objectId == objectId.objectId).firstOrNull;

    if (renderedObject?.levelId != null) {
      directoryObject.levelId = renderedObject!.levelId;
    }
  }

  final cleanupRubrics = directoryObject.rubricIds.nonNulls;
  final rubrics = Set<int>.from(cleanupRubrics);
  final mapMarkerMapper = await ref
      .watch(rubricMarkerMapperProvider.notifier)
      .getMarkerPath(rubrics, objectId.objectId, theme, closestPoint: closestPoint?.geoPoint);
  final bigIconPath = mapMarkerMapper.$2;

  if (directoryObject.markerPosition == null) {
    return null;
  }

  final position = LatLng(
    latitude: directoryObject.markerPosition!.latitude,
    longitude: directoryObject.markerPosition!.longitude,
  );

  final dark = await ref.watch(darkModeProvider.future);
  final isRtl = ref.watch(appLanguageProvider) == Language.arabic;

  final title = directoryObject.title;
  final textStyle = MarkerTextStyleMessage(
    fontSize: 13,
    textOffset: 4,
    color: dark.isDark ? 0xD3FFFFFF : 0xff1B1B1B,
    strokeColor: dark.isDark ? 0xff1B1B1B : 0xD3FFFFFF,
    strokeWidth: 1,
    fontName: title.containsArabic() || isRtl ? poiMapFontAr : poiMapFontEn,
    textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.bottomCenter),
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
      icon: bigIconPath,
      id: poiPinId,
    ),
    objectId: objectId.objectId,
  );

  final highlightController = ref.watch(highlightProvider.notifier);
  await highlightController.removeAll();
  await highlightController.addHighlight(objectId.toMessage());

  for (final entrance in directoryObject.entrances) {
    await highlightController.addHighlight(entrance.id);
  }

  ref.onDispose(() async {
    await highlightController.removeAll();
  });

  return directoryObject;
}
