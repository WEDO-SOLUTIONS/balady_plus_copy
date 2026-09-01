import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/marker_icons_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';

/// We use this method to throw away the part of the organization description that contains
/// additional information that is not necessary on the map next to the marker
///
/// Example:
/// input: "Al Ajazy, restaurant"
/// output: "Al Ajazy"
String _removeComma(String title) {
  final res = title.split(',');
  return res[0];
}

/// We use this method to break the long title of the organization
/// The break character is '\n' symbol
/// Max length in the line should be less or equal `maxLength` value
String _breakLineInTwo(String inputString) {
  const int maxLength = 30;

  // If the string fits within the max length, return it as is
  if (inputString.length <= maxLength) {
    return inputString;
  }

  // Find the nearest space before the 20th character
  int breakIndex = maxLength;
  while (breakIndex > 0 && inputString[breakIndex] != ' ') {
    breakIndex--;
  }

  // If no space is found, use the maxLength as the break index
  if (breakIndex == 0) {
    breakIndex = maxLength;
  }

  // Split the string into two parts
  final String firstLine = inputString.substring(0, breakIndex).trim();
  String secondLine = inputString.substring(breakIndex).trim();

  // If the second line exceeds maxLength, truncate it and add "..."
  if (secondLine.length > maxLength) {
    secondLine = '${secondLine.substring(0, maxLength - 3)}...';
  }

  return '$firstLine\n$secondLine';
}

typedef AdvancedIconResolver =
    Future<(String? smallIcon, String? bigIcon)> Function(
      Set<int> rubricIds,
      int objectId, {
      GeoPointMessage? closestPoint,
    });

extension MarkerFromSearchResultMessage on SearchResultMessage {
  static const _invalidMarkerId = 'invalid';
  static const poiMapFontAr = 'IBMPlexSansArabic-Bold';
  static const poiMapFontEn = 'GolosText_SemiBold';

  Future<List<Marker>> getMarkers({
    required AppRouter router,
    required Future<MapMarkersType?> Function(Set<int>) iconResolver,
    required bool isDark,
    required CityEventType? activeCityEvent,
    AdvancedIconResolver? advancedIconResolver,
    MapMarkersType? forcedMarkerType,
    bool withLabel = true,
    bool isRtl = true,
    Future<void> Function(ItemMarkerInfoMessage? data, int index)? onTapAnalytic,
  }) async {
    final itemMarkerInfos = this.itemMarkerInfos;
    if (itemMarkerInfos == null) {
      return [];
    }

    final markers = <Marker>[];
    final existingPositions = <LatLng>{};

    for (final item in itemMarkerInfos.indexed) {
      final markerInfo = item.$2;
      final position = markerInfo.geoPoint;
      final latLng = LatLng(latitude: position.latitude, longitude: position.longitude);

      if (existingPositions.contains(latLng)) {
        continue;
      }

      existingPositions.add(latLng);

      final objectId = markerInfo.objectId?.objectId;
      final cleanupRubrics = (markerInfo.rubricIds ?? []).nonNulls;
      final rubrics = Set<int>.from(cleanupRubrics);

      MarkerIconMessage? icon;

      if (forcedMarkerType != null) {
        icon = forcedMarkerType.pathBuilder(activeCityEvent, isDark: isDark).markerIcon(size: 32);
      } else if (advancedIconResolver != null) {
        icon = (await advancedIconResolver(
          rubrics,
          objectId!,
          closestPoint: markerInfo.geoPoint.geoPoint,
        )).$1?.markerIcon(size: 32);
      } else {
        icon = (await iconResolver(rubrics))?.pathBuilder(activeCityEvent, isDark: isDark).markerIcon(size: 32);
      }

      final text = withLabel && markerInfo.title != null ? _breakLineInTwo(_removeComma(markerInfo.title!)) : null;
      markers.add(
        Marker(
          id: objectId?.toString() ?? _invalidMarkerId,
          onTap: () {
            onTapAnalytic?.call(markerInfo, item.$1);

            router.replaceOrPush(
              route: PoiCardWidgetRoute(
                objectId: DgisObjectIdMessage(objectId: objectId!, entranceId: 0),
                closestPoint: latLng,
              ),
              toCompareRoutes: [PoiCardWidgetRoute.page],
            );
          },
          options: MarkerOptionsMessage(
            text: text,
            textStyle: MarkerTextStyleMessage(
              color: isDark ? 0xD3FFFFFF : 0xff1B1B1B,
              strokeColor: isDark ? 0xff1B1B1B : 0xD3FFFFFF,
              fontSize: 13,
              fontName: text.containsArabic() || isRtl ? MapnessConstants.poiMapFontAr : MapnessConstants.poiMapFontEn,
              textOffset: 4,
              strokeWidth: 1,
              textPlacement: MarkerTextPlacementMessage(
                placement: text.containsArabic() || isRtl
                    ? TextPlacementMessage.leftCenter
                    : TextPlacementMessage.rightCenter,
              ),
            ),
            position: position,
            isVisible: true,
            icon:
                icon?.copyWith(iconOpacity: 1) ??
                activeCityEvent.defaultMarker.markerIcon(size: 16).copyWith(iconOpacity: 1),
          ),
        ),
      );
    }

    return markers;
  }
}
