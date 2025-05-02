import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
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
                Assets.icons.svg.icMarkerMNew.keyName.markerIcon(size: 16).copyWith(iconOpacity: 1),
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
  String get iconPath => switch (this) {
        MapMarkersType.markets => Assets.icons.svg.placesNew.icMarkets.keyName,
        MapMarkersType.beach => Assets.icons.svg.placesNew.icBeach.keyName,
        MapMarkersType.gym => Assets.icons.svg.placesNew.icGym.keyName,
        MapMarkersType.gasStation => Assets.icons.svg.placesNew.icGasstationLtr.keyName,
        MapMarkersType.events => Assets.icons.svg.placesNew.icEventsLtr.keyName,
        MapMarkersType.carServices => Assets.icons.svg.placesNew.icCarServices.keyName,
        MapMarkersType.hospitals => Assets.icons.svg.placesNew.icHospitalPlace.keyName,
        MapMarkersType.hotels => Assets.icons.svg.placesNew.icHotels.keyName,
        MapMarkersType.pharmacies => Assets.icons.svg.placesNew.icMedicineLtr.keyName,
        MapMarkersType.mosques => Assets.icons.svg.placesNew.icMosques.keyName,
        MapMarkersType.parks => Assets.icons.svg.placesNew.icPark.keyName,
        MapMarkersType.qibla => Assets.icons.svg.placesNew.icQibla.keyName,
        MapMarkersType.restaurants => Assets.icons.svg.placesNew.icRestaurant.keyName,
        MapMarkersType.wc => Assets.icons.svg.placesNew.icWc.keyName,
        MapMarkersType.dentalCenters => Assets.icons.svg.placesNew.icTooth.keyName,
        MapMarkersType.schools => Assets.icons.svg.placesNew.icSchoolLtr.keyName,
        MapMarkersType.shopping => Assets.icons.svg.placesNew.icShopping.keyName,
        MapMarkersType.beauty => Assets.icons.svg.placesNew.icBeauty.keyName,
        MapMarkersType.barbershops => Assets.icons.svg.placesNew.icBarbershop.keyName,
        MapMarkersType.recreationCenters => Assets.icons.svg.placesNew.icRecreation.keyName,
      };
}

extension BigIconPath on String {
  String get bigIconPath {
    final iconName = split('/').last;

    final bigIcons = {
      'ic_markets.svg': Assets.icons.svg.placesBigNew.icMarkets.keyName,
      'ic_beach.svg': Assets.icons.svg.placesBigNew.icBeach.keyName,
      'ic_gym.svg': Assets.icons.svg.placesBigNew.icGym.keyName,
      'ic_gasstation_ltr.svg': Assets.icons.svg.placesBigNew.icGasstationLtr.keyName,
      'ic_events.svg': Assets.icons.svg.placesBigNew.icEvents.keyName,
      'ic_car_services.svg': Assets.icons.svg.placesBigNew.icCarServices.keyName,
      'ic_hospital_place.svg': Assets.icons.svg.placesBigNew.icHospitalPlace.keyName,
      'ic_hotels.svg': Assets.icons.svg.placesBigNew.icHotels.keyName,
      'ic_medicine_ltr.svg': Assets.icons.svg.placesBigNew.icMedicineLtr.keyName,
      'ic_mosques.svg': Assets.icons.svg.placesBigNew.icMosques.keyName,
      'ic_park.svg': Assets.icons.svg.placesBigNew.icPark.keyName,
      'ic_qibla.svg': Assets.icons.svg.placesBigNew.icQibla.keyName,
      'ic_restaurant.svg': Assets.icons.svg.placesBigNew.icRestaurant.keyName,
      'ic_wc.svg': Assets.icons.svg.placesBigNew.icWc.keyName,
      'ic_tooth.svg': Assets.icons.svg.placesBigNew.icTooth.keyName,
      'ic_school_ltr.svg': Assets.icons.svg.placesBigNew.icSchoolLtr.keyName,
      'ic_shopping.svg': Assets.icons.svg.placesBigNew.icShopping.keyName,
      'ic_barbershop.svg': Assets.icons.svg.placesBigNew.icBarbershop.keyName,
      'ic_beauty.svg': Assets.icons.svg.placesBigNew.icBeauty.keyName,
      'ic_recreation.svg': Assets.icons.svg.placesBigNew.icRecreation.keyName,
    };

    return bigIcons[iconName] ?? Markers.defaultPinNew;
  }
}
