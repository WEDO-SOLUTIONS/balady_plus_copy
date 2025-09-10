import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
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
  static const poiMapFontAr = 'FrutigerLTArabic65Bold';
  static const poiMapFontEn = 'GolosText_SemiBold';

  Future<List<Marker>> getMarkers({
    required AppRouter router,
    required Future<MapMarkersType?> Function(Set<int>) iconResolver,
    required bool isDark,
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
      final icon = (await iconResolver(rubrics))?.iconPath.markerIcon(size: 32);

      final text = withLabel && markerInfo.title != null ? _breakLineInTwo(_removeComma(markerInfo.title!)) : null;
      markers.add(
        Marker(
          id: objectId?.toString() ?? _invalidMarkerId,
          onTap: () {
            onTapAnalytic?.call(markerInfo, item.$1);
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
              fontName: text.containsArabic() || isRtl ? poiMapFontAr : poiMapFontEn,
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
                (SaudiNationalDay.isNow()
                        ? Assets.icons.svg.icMarkerMNewSaudiDay.keyName
                        : Assets.icons.svg.icMarkerMNew.keyName)
                    .markerIcon(size: 16)
                    .copyWith(iconOpacity: 1),
          ),
        ),
      );
    }

    return markers;
  }
}

extension IconPathFromMapMarkersType on MapMarkersType {
  static final isSaudiDay = SaudiNationalDay.isNow();
  String get iconPath => switch (this) {
        MapMarkersType.markets => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icMarkets.keyName
            : Assets.icons.svg.placesNew.icMarkets.keyName,
        MapMarkersType.beach =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icBeach.keyName : Assets.icons.svg.placesNew.icBeach.keyName,
        MapMarkersType.gym =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icGym.keyName : Assets.icons.svg.placesNew.icGym.keyName,
        MapMarkersType.gasStation => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icGasstationLtr.keyName
            : Assets.icons.svg.placesNew.icGasstationLtr.keyName,
        MapMarkersType.events => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icEventsLtr.keyName
            : Assets.icons.svg.placesNew.icEventsLtr.keyName,
        MapMarkersType.carServices => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icCarServices.keyName
            : Assets.icons.svg.placesNew.icCarServices.keyName,
        MapMarkersType.hospitals => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icHospitalPlace.keyName
            : Assets.icons.svg.placesNew.icHospitalPlace.keyName,
        MapMarkersType.hotels => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icHotels.keyName
            : Assets.icons.svg.placesNew.icHotels.keyName,
        MapMarkersType.pharmacies => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icMedicineLtr.keyName
            : Assets.icons.svg.placesNew.icMedicineLtr.keyName,
        MapMarkersType.mosques => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icMosques.keyName
            : Assets.icons.svg.placesNew.icMosques.keyName,
        MapMarkersType.parks =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icPark.keyName : Assets.icons.svg.placesNew.icPark.keyName,
        MapMarkersType.qibla =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icQibla.keyName : Assets.icons.svg.placesNew.icQibla.keyName,
        MapMarkersType.restaurants => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icRestaurant.keyName
            : Assets.icons.svg.placesNew.icRestaurant.keyName,
        MapMarkersType.wc =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icWc.keyName : Assets.icons.svg.placesNew.icWc.keyName,
        MapMarkersType.dentalCenters =>
          isSaudiDay ? Assets.icons.svg.placesNewSaudiDay.icTooth.keyName : Assets.icons.svg.placesNew.icTooth.keyName,
        MapMarkersType.schools => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icSchoolLtr.keyName
            : Assets.icons.svg.placesNew.icSchoolLtr.keyName,
        MapMarkersType.shopping => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icShopping.keyName
            : Assets.icons.svg.placesNew.icShopping.keyName,
        MapMarkersType.beauty => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icBeauty.keyName
            : Assets.icons.svg.placesNew.icBeauty.keyName,
        MapMarkersType.barbershops => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icBarbershop.keyName
            : Assets.icons.svg.placesNew.icBarbershop.keyName,
        MapMarkersType.recreationCenters => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icRecreation.keyName
            : Assets.icons.svg.placesNew.icRecreation.keyName,
        MapMarkersType.waterPlaces => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icWaterPlaces.keyName
            : Assets.icons.svg.placesNew.icWaterPlaces.keyName,
        MapMarkersType.medicalHelp => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icMedicalHelp.keyName
            : Assets.icons.svg.placesNew.icMedicalHelp.keyName,
        MapMarkersType.hajjSupport => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icHajjSupport.keyName
            : Assets.icons.svg.placesNew.icHajjSupport.keyName,
        MapMarkersType.kiosksRetail => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icKiosksRetail.keyName
            : Assets.icons.svg.placesNew.icKiosksRetail.keyName,
        MapMarkersType.additional => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icAdditional.keyName
            : Assets.icons.svg.placesNew.icAdditional.keyName,
        MapMarkersType.healthCenter => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icHealthCenter.keyName
            : Assets.icons.svg.placesNew.icHealthCenter.keyName,
        MapMarkersType.hospital => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icHospital.keyName
            : Assets.icons.svg.placesNew.icHospital.keyName,
        MapMarkersType.fireStation => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icFireStation.keyName
            : Assets.icons.svg.placesNew.icFireStation.keyName,
        MapMarkersType.policeStation => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icPoliceStation.keyName
            : Assets.icons.svg.placesNew.icPoliceStation.keyName,
        MapMarkersType.lostAndFound => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icLostAndFound.keyName
            : Assets.icons.svg.placesNew.icLostAndFound.keyName,
        MapMarkersType.stairs => isSaudiDay
            ? Assets.icons.svg.placesNewSaudiDay.icStairs.keyName
            : Assets.icons.svg.placesNew.icStairs.keyName,
      };
}

extension BigIconPath on String {
  String get bigIconPath {
    final iconName = split('/').last;
    final isSaudiPath = contains('saudi_day');

    final bigIcons = {
      'ic_markets.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMarkets.keyName
          : Assets.icons.svg.placesBigNew.icMarkets.keyName,
      'ic_beach.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBeach.keyName
          : Assets.icons.svg.placesBigNew.icBeach.keyName,
      'ic_gym.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icGym.keyName
          : Assets.icons.svg.placesBigNew.icGym.keyName,
      'ic_gasstation_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icGasstationLtr.keyName
          : Assets.icons.svg.placesBigNew.icGasstationLtr.keyName,
      'ic_events.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icEvents.keyName
          : Assets.icons.svg.placesBigNew.icEvents.keyName,
      'ic_car_services.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icCarServices.keyName
          : Assets.icons.svg.placesBigNew.icCarServices.keyName,
      'ic_hospital_place.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHospitalPlace.keyName
          : Assets.icons.svg.placesBigNew.icHospitalPlace.keyName,
      'ic_hotels.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHotels.keyName
          : Assets.icons.svg.placesBigNew.icHotels.keyName,
      'ic_medicine_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMedicineLtr.keyName
          : Assets.icons.svg.placesBigNew.icMedicineLtr.keyName,
      'ic_mosques.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMosques.keyName
          : Assets.icons.svg.placesBigNew.icMosques.keyName,
      'ic_park.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icPark.keyName
          : Assets.icons.svg.placesBigNew.icPark.keyName,
      'ic_qibla.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icQibla.keyName
          : Assets.icons.svg.placesBigNew.icQibla.keyName,
      'ic_restaurant.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icRestaurant.keyName
          : Assets.icons.svg.placesBigNew.icRestaurant.keyName,
      'ic_wc.svg':
          isSaudiPath ? Assets.icons.svg.placesBigNewSaudiDay.icWc.keyName : Assets.icons.svg.placesBigNew.icWc.keyName,
      'ic_tooth.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icTooth.keyName
          : Assets.icons.svg.placesBigNew.icTooth.keyName,
      'ic_school_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icSchoolLtr.keyName
          : Assets.icons.svg.placesBigNew.icSchoolLtr.keyName,
      'ic_shopping.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName
          : Assets.icons.svg.placesBigNew.icShopping.keyName,
      'ic_barbershop.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBarbershop.keyName
          : Assets.icons.svg.placesBigNew.icBarbershop.keyName,
      'ic_beauty.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBeauty.keyName
          : Assets.icons.svg.placesBigNew.icBeauty.keyName,
      'ic_recreation.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icRecreation.keyName
          : Assets.icons.svg.placesBigNew.icRecreation.keyName,
      'ic_water_places.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icWaterPlaces.keyName
          : Assets.icons.svg.placesBigNew.icWaterPlaces.keyName,
      'ic_medical_help.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMedicalHelp.keyName
          : Assets.icons.svg.placesBigNew.icMedicalHelp.keyName,
      'ic_hajj_support.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHajjSupport.keyName
          : Assets.icons.svg.placesBigNew.icHajjSupport.keyName,
      'ic_kiosks_retail.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icKiosksRetail.keyName
          : Assets.icons.svg.placesBigNew.icKiosksRetail.keyName,
      'ic_additional.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icAdditional.keyName
          : Assets.icons.svg.placesBigNew.icAdditional.keyName,
      'ic_health_center.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHealthCenter.keyName
          : Assets.icons.svg.placesBigNew.icHealthCenter.keyName,
      'ic_hospital.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHospital.keyName
          : Assets.icons.svg.placesBigNew.icHospital.keyName,
      'ic_fire_station.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icFireStation.keyName
          : Assets.icons.svg.placesBigNew.icFireStation.keyName,
      'ic_police_station.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icPoliceStation.keyName
          : Assets.icons.svg.placesBigNew.icPoliceStation.keyName,
      'ic_lost_and_found.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icLostAndFound.keyName
          : Assets.icons.svg.placesBigNew.icLostAndFound.keyName,
      'ic_stairs.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icStairs.keyName
          : Assets.icons.svg.placesBigNew.icStairs.keyName,
    };

    return bigIcons[iconName] ?? (isSaudiPath ? Markers.defaultPinNewSaudiDay : Markers.defaultPinNew);
  }
}
