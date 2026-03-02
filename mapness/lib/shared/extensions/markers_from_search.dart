import 'dart:async';

import 'package:balady_uikit/core/colorsV2/themes.dart';
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
import 'package:mapness/shared/lib/geo_point_ext.dart';
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
      int objectId,
      BaladyAppThemes theme, {
      GeoPointMessage? closestPoint,
    });

extension MarkerFromSearchResultMessage on SearchResultMessage {
  static const _invalidMarkerId = 'invalid';
  static const _propertyKey = 'objectId';
  static const poiMapFontAr = 'FrutigerLTArabic65Bold';
  static const poiMapFontEn = 'GolosText_SemiBold';

  Future<List<Marker>> getMarkers({
    required AppRouter router,
    required Future<MapMarkersType?> Function(Set<int>) iconResolver,
    required bool isDark,
    required BaladyAppThemes theme,
    AdvancedIconResolver? advancedIconResolver,
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

      if (advancedIconResolver != null) {
        icon = (await advancedIconResolver(
          rubrics,
          objectId!,
          theme,
          closestPoint: markerInfo.geoPoint.geoPoint,
        )).$1?.markerIcon(size: 32);
      } else {
        icon = (await iconResolver(rubrics))?.iconPath(theme).markerIcon(size: 32);
      }

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
              fontName: text.containsArabic() || isRtl ? poiMapFontAr : poiMapFontEn,
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
                switch (theme) {
                  BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icNewPin.keyName,
                  BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icNewPin.keyName,
                  BaladyAppThemes.saudiDay => Assets.icons.svg.icMarkerMNewSaudiDay.keyName,
                }.markerIcon(size: 16).copyWith(iconOpacity: 1),
          ),
        ),
      );
    }

    return markers;
  }
}

extension IconPathFromMapMarkersType on MapMarkersType {
  static final isSaudiDay = SaudiNationalDay.isNow();

  String iconPath(BaladyAppThemes theme) => switch (this) {
    MapMarkersType.markets =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icMarkets.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icShops.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icShops.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icMarkets.keyName,
            },
    MapMarkersType.beach =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icBeach.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icBeach.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icBeach.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icBeach.keyName,
            },
    MapMarkersType.gym =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icGym.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icGym.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icGym.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icGym.keyName,
            },
    MapMarkersType.gasStation =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icGasstationLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icFuel.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icFuel.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icGasstationLtr.keyName,
            },
    MapMarkersType.events =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icEventsLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icEvents.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icEvents.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icEventsLtr.keyName,
            },
    MapMarkersType.carServices =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icCarServices.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icCarService.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icCarService.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icCarServices.keyName,
            },
    MapMarkersType.hospitals =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icHospitalPlace.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icHospital.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icHospital.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icHospitalPlace.keyName,
            },
    MapMarkersType.hotels =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icHotels.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icHotels.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icHotels.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icHotels.keyName,
            },
    MapMarkersType.pharmacies =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icMedicineLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icMedicine.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icMedicine.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icMedicineLtr.keyName,
            },
    MapMarkersType.mosques =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icMosques.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icMosques.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icMosques.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icMosques.keyName,
            },
    MapMarkersType.parks =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icPark.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icNature.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icNature.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icPark.keyName,
            },
    MapMarkersType.qibla =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icQibla.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icQibla.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icQibla.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icQibla.keyName,
            },
    MapMarkersType.restaurants =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icRestaurant.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icRestaurant.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icRestaurant.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icRestaurant.keyName,
            },
    MapMarkersType.wc =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icWc.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icWc.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icWc.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icWc.keyName,
            },
    MapMarkersType.dentalCenters =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icTooth.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icDentist.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icDentist.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icTooth.keyName,
            },
    MapMarkersType.schools =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icSchoolLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icEducation.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icEducation.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icSchoolLtr.keyName,
            },
    MapMarkersType.shopping =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icShopping.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icMalls.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icMalls.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icShopping.keyName,
            },
    MapMarkersType.beauty =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icBeauty.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icBeauty.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icBeauty.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icBeauty.keyName,
            },
    MapMarkersType.barbershops =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icBarbershop.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icBarbershop.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icBarbershop.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icBarbershop.keyName,
            },
    MapMarkersType.recreationCenters =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icRecreation.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icRecreation.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icRecreation.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesNewSaudiDay.icRecreation.keyName,
            },
    MapMarkersType.waterPlaces =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icWaterPlaces.keyName
          : Assets.icons.svg.placesNew.old.icWaterPlaces.keyName,
    MapMarkersType.medicalHelp =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icMedicalHelp.keyName
          : Assets.icons.svg.placesNew.old.icMedicalHelp.keyName,
    MapMarkersType.hajjSupport =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icHajjSupport.keyName
          : Assets.icons.svg.placesNew.old.icHajjSupport.keyName,
    MapMarkersType.kiosksRetail =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icKiosksRetail.keyName
          : Assets.icons.svg.placesNew.old.icKiosksRetail.keyName,
    MapMarkersType.additional =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icAdditional.keyName
          : Assets.icons.svg.placesNew.old.icAdditional.keyName,
    MapMarkersType.healthCenter =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icHealthCenter.keyName
          : Assets.icons.svg.placesNew.old.icHealthCenter.keyName,
    MapMarkersType.hospital =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icHospital.keyName
          : Assets.icons.svg.placesNew.old.icHospital.keyName,
    MapMarkersType.fireStation =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icFireStation.keyName
          : Assets.icons.svg.placesNew.old.icFireStation.keyName,
    MapMarkersType.policeStation =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icPoliceStation.keyName
          : Assets.icons.svg.placesNew.old.icPoliceStation.keyName,
    MapMarkersType.lostAndFound =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icLostAndFound.keyName
          : Assets.icons.svg.placesNew.old.icLostAndFound.keyName,
    MapMarkersType.stairs =>
      isSaudiDay
          ? Assets.icons.svg.placesNewSaudiDay.icStairs.keyName
          : Assets.icons.svg.placesNew.old.icStairs.keyName,
  };
}

extension BigIconPath on String {
  String bigIconPath(BaladyAppThemes theme) {
    final iconName = split('/').last;
    final isSaudiPath = contains('saudi_day');

    final bigIcons = {
      'ic_markets.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMarkets.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icShops.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icShops.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icMarkets.keyName,
            },
      'ic_beach.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBeach.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icBeach.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icBeach.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icBeach.keyName,
            },
      'ic_gym.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icGym.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icGym.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icGym.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icGym.keyName,
            },
      'ic_gasstation_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icGasstationLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icFuel.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icFuel.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icGasstationLtr.keyName,
            },
      'ic_events.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icEvents.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icEvents.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icEvents.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icEvents.keyName,
            },
      'ic_car_services.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icCarServices.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icCarService.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icCarService.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icCarServices.keyName,
            },
      'ic_hospital_place.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHospitalPlace.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icHospital.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icHospital.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icHospitalPlace.keyName,
            },
      'ic_hotels.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHotels.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icHotels.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icHotels.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icHotels.keyName,
            },
      'ic_medicine_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMedicineLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icMedicine.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icMedicine.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icMedicineLtr.keyName,
            },
      'ic_mosques.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMosques.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icMosques.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icMosques.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icMosques.keyName,
            },
      'ic_park.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icPark.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icNature.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icNature.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icPark.keyName,
            },
      'ic_qibla.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icQibla.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icQibla.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icQibla.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icQibla.keyName,
            },
      'ic_restaurant.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icRestaurant.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icRestaurant.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icRestaurant.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icRestaurant.keyName,
            },
      'ic_wc.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icWc.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icWc.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icWc.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icWc.keyName,
            },
      'ic_tooth.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icTooth.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icDentist.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icDentist.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icTooth.keyName,
            },
      'ic_school_ltr.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icSchoolLtr.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icEducation.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icEducation.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icSchoolLtr.keyName,
            },
      'ic_shopping.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icMalls.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icMalls.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName,
            },
      'ic_shops.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icShops.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icShops.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName,
            },
      'ic_malls.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icMalls.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icMalls.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icShopping.keyName,
            },
      'ic_barbershop.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBarbershop.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icBarbershop.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icBarbershop.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icBarbershop.keyName,
            },
      'ic_beauty.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icBeauty.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icBeauty.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icBeauty.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icBeauty.keyName,
            },
      'ic_recreation.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icRecreation.keyName
          : switch (theme) {
              BaladyAppThemes.dark => Assets.icons.svg.placesBigNew.dark.icRecreation.keyName,
              BaladyAppThemes.light => Assets.icons.svg.placesBigNew.light.icRecreation.keyName,
              BaladyAppThemes.saudiDay => Assets.icons.svg.placesBigNewSaudiDay.icRecreation.keyName,
            },
      'ic_water_places.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icWaterPlaces.keyName
          : Assets.icons.svg.placesBigNew.old.icWaterPlaces.keyName,
      'ic_medical_help.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icMedicalHelp.keyName
          : Assets.icons.svg.placesBigNew.old.icMedicalHelp.keyName,
      'ic_hajj_support.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHajjSupport.keyName
          : Assets.icons.svg.placesBigNew.old.icHajjSupport.keyName,
      'ic_kiosks_retail.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icKiosksRetail.keyName
          : Assets.icons.svg.placesBigNew.old.icKiosksRetail.keyName,
      'ic_additional.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icAdditional.keyName
          : Assets.icons.svg.placesBigNew.old.icAdditional.keyName,
      'ic_health_center.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHealthCenter.keyName
          : Assets.icons.svg.placesBigNew.old.icHealthCenter.keyName,
      'ic_hospital.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icHospital.keyName
          : Assets.icons.svg.placesBigNew.old.icHospital.keyName,
      'ic_fire_station.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icFireStation.keyName
          : Assets.icons.svg.placesBigNew.old.icFireStation.keyName,
      'ic_police_station.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icPoliceStation.keyName
          : Assets.icons.svg.placesBigNew.old.icPoliceStation.keyName,
      'ic_lost_and_found.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icLostAndFound.keyName
          : Assets.icons.svg.placesBigNew.old.icLostAndFound.keyName,
      'ic_stairs.svg': isSaudiPath
          ? Assets.icons.svg.placesBigNewSaudiDay.icStairs.keyName
          : Assets.icons.svg.placesBigNew.old.icStairs.keyName,
      'ic_offer_marker.svg': switch (theme) {
        BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffers.keyName,
        BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icOffers.keyName,
        BaladyAppThemes.saudiDay => Assets.icons.svg.placesNew.light.icOffers.keyName,
      },
      'ic_offers_clustering_marker.svg': switch (theme) {
        BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffersClusteringMarkerDark.keyName,
        BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icOffersClusteringMarker.keyName,
        BaladyAppThemes.saudiDay => Assets.icons.svg.placesNew.light.icOffersClusteringMarker.keyName,
      },
      'ic_offers_clustering_marker_dark.svg': switch (theme) {
        BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffersClusteringMarkerDark.keyName,
        BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icOffersClusteringMarker.keyName,
        BaladyAppThemes.saudiDay => Assets.icons.svg.placesNew.light.icOffersClusteringMarker.keyName,
      },
      'ic_offer_marker_dark.svg': switch (theme) {
        BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icOffers.keyName,
        BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icOffers.keyName,
        BaladyAppThemes.saudiDay => Assets.icons.svg.placesNew.light.icOffers.keyName,
      },
    };

    return bigIcons[iconName] ?? (isSaudiPath ? Markers.defaultPinNewSaudiDay : Markers.defaultPinNew);
  }
}
