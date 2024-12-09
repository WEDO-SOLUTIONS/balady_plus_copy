import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

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
  static const _poiMapFont = 'Noto Sans Arabic Regular';

  Future<List<Marker>> getMarkers({
    required AppRouter router,
    required MapMarkersType? Function(Set<int>) iconResolver,
    bool withLabel = true,
    bool isRtl = true,
  }) async {
    final markers = <Marker>[];
    for (final markerInfo in itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      final objectId = markerInfo.objectId?.objectId;
      final cleanupRubrics = (markerInfo.rubricIds ?? []).nonNulls;
      final rubrics = Set<int>.from(cleanupRubrics);
      final icon = iconResolver(rubrics)?.iconPath.markerIcon(size: 32);
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

            final route = PoiCardWidgetRoute(
              objectId: DgisObjectIdMessage(
                objectId: objectId!,
                entranceId: 0,
              ),
            );
            router.replaceOrPush<PoiCardWidgetRoute>(route);
          },
          options: MarkerOptionsMessage(
            text: withLabel && markerInfo.title != null ? _breakLineInTwo(_removeComma(markerInfo.title!)) : null,
            textStyle: MarkerTextStyleMessage(
              color: 0xff1E2A36,
              fontSize: 13,
              fontName: _poiMapFont,
              textOffset: 4,
              strokeColor: 0xD3FFFFFF,
              strokeWidth: 1.25,
              textPlacement: MarkerTextPlacementMessage(
                placement: isRtl ? TextPlacementMessage.leftCenter : TextPlacementMessage.rightCenter,
              ),
            ),
            position: markerInfo.geoPoint,
            icon: icon ?? LayersSvgPaths.basicMarker.markerIcon(size: 16),
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
  static const _pathPrefix = 'packages/mapness/assets/icons/svg/places';

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
  static const _pathPrefix = 'packages/mapness/assets/icons/svg/places_big/';
  // Because we need to replace only this markers with big icons
  // If you need to add more icons, please add it in this list
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
  ];

  String? get bigIconPath {
    final iconName = split('/').last;
    if (_markersList.contains(iconName)) {
      final path = '$_pathPrefix$iconName';

      return path;
    } else {
      return null;
    }
  }
}
