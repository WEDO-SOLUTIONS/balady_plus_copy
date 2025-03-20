import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

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
  const int maxLength = 20;

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

extension MarkerFromSearchResultMessage on SearchResultMessage {
  static const _invalidMarkerId = 'invalid';
  static const _propertyKey = 'objectId';
  static const _poiMapFontAr = 'FrutigerLTArabic65Bold';
  static const _poiMapFontEn = 'GolosText_SemiBold';

  Future<List<Marker>> getMarkers({
    required AppRouter router,
    required MapMarkersType? Function(Set<int>) iconResolver,
    required bool isDark,
    bool withLabel = true,
    bool isRtl = true,
  }) async {
    final markers = <Marker>[];
    final existingPositions = <LatLng>{};

    for (final markerInfo in itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      final position = markerInfo.geoPoint;
      final latLng = LatLng(latitude: position.latitude, longitude: position.longitude);

      if (existingPositions.contains(latLng)) {
        continue;
      }

      existingPositions.add(latLng);

      final objectId = markerInfo.objectId?.objectId;
      final cleanupRubrics = (markerInfo.rubricIds ?? []).nonNulls;
      final rubrics = Set<int>.from(cleanupRubrics);
      final icon = iconResolver(rubrics)?.iconPath.markerIcon(size: 32);

      final text = withLabel && markerInfo.title != null ? _breakLineInTwo(_removeComma(markerInfo.title!)) : null;
      markers.add(
        Marker(
          id: objectId?.toString() ?? _invalidMarkerId,
          onTap: () {
            Metrics.logEventAdvanced(
              MetricsConstants.poiKeys.marker,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
              props: {_propertyKey: objectId},
            );

            router.replaceOrPush(
                route: PoiCardWidgetRoute(
                  objectId: DgisObjectIdMessage(
                    objectId: objectId!,
                    entranceId: 0,
                  ),
                ),
                toCompareRoutes: [PoiCardWidgetRoute.page]);
          },
          options: MarkerOptionsMessage(
            text: text,
            textStyle: MarkerTextStyleMessage(
              color: isDark ? 0xD3FFFFFF : 0xff1B1B1B,
              strokeColor: isDark ? 0xff1B1B1B : 0xD3FFFFFF,
              fontSize: 13,
              fontName: text.containsArabic() || isRtl ? _poiMapFontAr : _poiMapFontEn,
              textOffset: 4,
              strokeWidth: 1,
              textPlacement: MarkerTextPlacementMessage(
                placement:
                    text.containsArabic() || isRtl ? TextPlacementMessage.leftCenter : TextPlacementMessage.rightCenter,
              ),
            ),
            position: position,
            isVisible: true,
            icon: icon?.copyWith(iconOpacity: 1) ??
                LayersSvgPaths.basicMarker.markerIcon(size: 16).copyWith(iconOpacity: 1),
          ),
        ),
      );
    }

    return markers;
  }
}

/// According to the icons that we have in our pack and which we can show on the map as marker
enum MapMarkersType {
  markets,
  beach,
  gym,
  gasStation,
  events,
  carServices,
  hospitals,
  hotels,
  pharmacies,
  mosques,
  parks,
  qibla,
  restaurants,
  wc,
  dentalCenters,
  schools,
  shopping,
  beauty,
  barbershops,
  recreationCenters,
}

extension IconPathFromMapMarkersType on MapMarkersType {
  static const _pathPrefix = 'packages/mapness/assets/icons/svg/places_new';

  /// We can get svg icon for the map to draw marker with special icon
  /// Or we can get null if [MapMarkersType] is null
  ///
  /// It's easy to use because we can use this extension right in the build method of the marker
  String get iconPath => switch (this) {
        MapMarkersType.markets => '$_pathPrefix/ic_markets.svg',
        MapMarkersType.beach => '$_pathPrefix/ic_beach.svg',
        MapMarkersType.gym => '$_pathPrefix/ic_gym.svg',
        MapMarkersType.gasStation => '$_pathPrefix/ic_gasstation_ltr.svg',
        MapMarkersType.events => '$_pathPrefix/ic_events_ltr.svg',
        MapMarkersType.carServices => '$_pathPrefix/ic_car_services.svg',
        MapMarkersType.hospitals => '$_pathPrefix/ic_hospital_place.svg',
        MapMarkersType.hotels => '$_pathPrefix/ic_hotels.svg',
        MapMarkersType.pharmacies => '$_pathPrefix/ic_medicine_ltr.svg',
        MapMarkersType.mosques => '$_pathPrefix/ic_mosques.svg',
        MapMarkersType.parks => '$_pathPrefix/ic_park.svg',
        MapMarkersType.qibla => '$_pathPrefix/ic_qibla.svg',
        MapMarkersType.restaurants => '$_pathPrefix/ic_restaurant.svg',
        MapMarkersType.wc => '$_pathPrefix/ic_wc.svg',
        MapMarkersType.dentalCenters => '$_pathPrefix/ic_tooth.svg',
        MapMarkersType.schools => '$_pathPrefix/ic_school_ltr.svg',
        MapMarkersType.shopping => '$_pathPrefix/ic_shopping.svg',
        MapMarkersType.beauty => '$_pathPrefix/ic_beauty.svg',
        MapMarkersType.barbershops => '$_pathPrefix/ic_barbershop.svg',
        MapMarkersType.recreationCenters => '$_pathPrefix/ic_recreation.svg',
      };
}

extension BigIconPath on String {
  static const _pathPrefix = 'packages/mapness/assets/icons/svg/places_big_new/';

  // Because we need to replace only this markers with big icons
  // If you need to add more icons, please add it in this list
  // ignore: unused_field
  static const _markersList = [
    'ic_markets.svg',
    'ic_beach.svg',
    'ic_gym.svg',
    'ic_gasstation_ltr.svg',
    'ic_events_ltr.svg',
    'ic_car_services.svg',
    'ic_hospital_place.svg',
    'ic_hotels.svg',
    'ic_medicine_ltr.svg',
    'ic_mosques.svg',
    'ic_park.svg',
    'ic_qibla.svg',
    'ic_restaurant.svg',
    'ic_wc.svg',
    'ic_tooth.svg',
    'ic_school_ltr.svg',
    'ic_recreation.svg',
    'ic_shopping.svg',
    'ic_barbershop.svg',
    'ic_beauty.svg',
  ];

  // ignore: prefer_expression_function_bodies
  String? get bigIconPath {
    final iconName = split('/').last;
    if (_markersList.contains(iconName)) {
      final path = '$_pathPrefix$iconName';

      return path;
    } else {
      return Markers.defaultPinNew;
    }
  }
}
