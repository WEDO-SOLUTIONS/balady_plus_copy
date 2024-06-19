import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

FutureOr<Map<int, String>> generateTitleMap(List<UiMarkerInfoMessage?>? uiMarkers) {
  final titleMap = <int, String>{};
  for (final uiMarker in uiMarkers ?? List<UiMarkerInfoMessage?>.empty()) {
    if (uiMarker?.objectId == null || uiMarker?.label == null) {
      continue;
    }
    titleMap[uiMarker!.objectId!.objectId] = uiMarker.label!;
  }
  return titleMap;
}

extension MarkerFromSearchResultMessage on SearchResultMessage {
  static const _invalidMarkerId = 'invalid';
  static const _propertyKey = 'objectId';
  static const _poiMapFont = 'Noto Sans Arabic Regular';

  Future<List<Marker>> getMarkers({
    required GoRouter router,
    MarkerIconMessage? icon,
    bool withLabel = true,
  }) async {
    final uiObjectMaps = withLabel
        ? await compute<List<UiMarkerInfoMessage?>?, Map<int, String>>(generateTitleMap, markersWithLabel)
        : null;

    final hasLabels = uiObjectMaps != null && uiObjectMaps.isNotEmpty && withLabel;

    final markers = <Marker>[];
    for (final markerInfo in itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      if (markerInfo != null) {
        final objectId = markerInfo.objectId?.objectId;
        markers.add(
          Marker(
            id: objectId?.toString() ?? _invalidMarkerId,
            onTap: () {
              Metrics.logEventAdvanced(MetricsConstants.poiKeys.marker,
                  group: MetricsConstants.poiTag, action: MetricAction.tap.toString(), props: {_propertyKey: objectId});
              PoiMapRoute.open(router, objectId!);
            },
            options: MarkerOptionsMessage(
              text: hasLabels && objectId != null ? uiObjectMaps[objectId] : null,
              textStyle: MarkerTextStyleMessage(
                color: 0xff1E2A36,
                fontSize: 13,
                fontName: _poiMapFont,
                textOffset: 4,
                strokeColor: 0xD3FFFFFF,
                strokeWidth: 2,
                textPlacement: MarkerTextPlacementMessage(
                  placement: TextPlacementMessage.rightCenter,
                ),
              ),
              position: markerInfo.geoPoint,
              icon: icon ?? LayersSvgPaths.basicMarker.markerIcon(),
            ),
          ),
        );
      }
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
      };
}
