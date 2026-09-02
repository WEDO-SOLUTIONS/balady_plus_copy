import 'dart:typed_data';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/urbi_map_x/lat_lng_x.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_membership.dart';
import 'package:mapness/features/favourites/helpers/construct_marker.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/favorite_pin_marker_bitmap.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/ui/toast/app_locale.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

const poiPinId = 'poi_pin_id';

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  Ref ref,
  DgisObjectId objectId,
  LatLng? closestPoint,
  BaladyAppThemes theme, {
  bool showHighlight = true,
}) async {
  final selectedMarker = ref.watch(selectedMarkerProvider.notifier);
  final l10n = ref.watch(appLocaleProvider);
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
      .getMarkerPath(rubrics, objectId.objectId, closestPoint: closestPoint?.geoPoint);
  final favoriteMarker = await ref.read(favoritePlaceMarkerProvider(objectId.objectId.toString()).future);
  final favoritePinBitmap = ref.read(favoritePinMarkerBitmapProvider);
  Uint8List? favoriteIconBytes;
  if (favoriteMarker != null) {
    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    favoriteIconBytes = await favoritePinBitmap.renderTeardropPin(
      tint: favoriteMarker.markerColorCode.color,
      icon: favoriteMarker.iconType ?? FavoriteIconType.$default,
      devicePixelRatio: devicePixelRatio,
    );
  }
  final bigIconPath = favoriteMarker == null ? mapMarkerMapper.$2 : null;

  final markerPosition = directoryObject.markerPosition;
  final fallbackPosition = closestPoint;
  if (markerPosition == null && fallbackPosition == null) {
    return null;
  }

  final position = LatLng(
    latitude: (fallbackPosition?.latitude ?? markerPosition?.latitude)!,
    longitude: (fallbackPosition?.longitude ?? markerPosition?.longitude)!,
  );
  directoryObject.markerPosition = GeoPointWithElevationMessage(
    latitude: position.latitude,
    longitude: position.longitude,
    elevation: 0,
  );

  final dark = await ref.watch(darkModeProvider.future);
  final isRtl = ref.watch(appLanguageProvider) == Language.arabic;

  final textStyle = MarkerTextStyleMessage(
    fontSize: 13,
    textOffset: 4,
    color: dark.isDark ? 0xD3FFFFFF : 0xff1B1B1B,
    strokeColor: dark.isDark ? 0xff1B1B1B : 0xD3FFFFFF,
    strokeWidth: 1,
    fontName: directoryObject.title.containsArabic() || isRtl
        ? MapnessConstants.poiMapFontAr
        : MapnessConstants.poiMapFontEn,
    textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.bottomCenter),
  );
  final isDark = ref.read(darkModeProvider).value?.isDark ?? false;
  final markerTitle = directoryObject.title.trim();
  final fullStreetAddress = directoryObject.fullAddressName?.streetAddress?.trim();
  final shortStreetAddress = directoryObject.shortAddressName?.streetAddress?.trim();
  final isAddressUsedAsTitle =
      (fullStreetAddress != null && fullStreetAddress == markerTitle) ||
      (shortStreetAddress != null && shortStreetAddress == markerTitle);

  final isLeapObject = ref.watch(leapProvider.notifier).isLeapObject(objectId.objectId);
  final showPinLabel =
      markerTitle.isNotEmpty && !directoryObject.isDroppedPin && !isAddressUsedAsTitle && !isLeapObject;

  await selectedMarker.showMarker(
    Markers.pinMarker(
      GeoPointWithElevationMessage(
        latitude: position.latitude,
        longitude: position.longitude,
        elevation: 1,
      ),
      text: showPinLabel ? directoryObject.title : null,
      textStyle: textStyle.copyWith(suppressOnOverlap: false),
      icon: bigIconPath,
      iconBytes: favoriteIconBytes,
      anchor: favoriteMarker != null
          ? MarkerAnchorMessage(x: favoritePinBitmap.teardropAnchor.x, y: favoritePinBitmap.teardropAnchor.y)
          : MarkerAnchorMessage(x: 0.5, y: 0.5),
      width: favoriteMarker != null ? favoritePinBitmap.teardropLogicalSize : null,
      id: poiPinId,
      activeCityEvent: ref.read(activeCityEventProvider),
      isDark: isDark,
    ),
    objectId: objectId.objectId,
    favouriteMarkerId: favoriteMarker != null ? favoriteListPlaceMarkerId(objectId.objectId.toString()) : null,
  );

  final highlightController = ref.watch(highlightProvider.notifier);
  await highlightController.removeAll();

  if (!showHighlight) {
    return directoryObject;
  }

  const haramZone = 70030077050725730;
  const holySites = 70030077050669177;
  const arafat = 70030076872378603;
  const mina = 70030077051689430;

  if (objectId.objectId == haramZone ||
      objectId.objectId == holySites ||
      objectId.objectId == arafat ||
      objectId.objectId == mina) {
    await highlightController.addHighlight(objectId.toMessage());
  } else {
    if (directoryObject.hasHighlightableType) {
      await highlightController.addHighlight(objectId.toMessage());
    }
  }

  return directoryObject;
}
