import 'package:dgis_map/library.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

extension MarkerFromSearchResultMessage on SearchResultMessage {
  static const _invalidMarkerId = 'invalid';
  static const _propertyKey = 'objectId';
  Future<List<Marker>> getMarkers({
    required GoRouter router,
    MarkerIconMessage? icon,
  }) async {
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

// TODO(@smitsk): Move it to anywhere where we need it

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

extension IconPathFromMapMarkersType on MapMarkersType? {
  static const _pathPrefix = 'assets/icons/svg/places';

  /// We can get svg icon for the map to draw marker with special icon
  /// Or we can get null if [MapMarkersType] is null
  ///
  /// It's easy to use because we can use this extension right in the build method of the marker
  String? iconPath() => switch (this) {
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
        _ => null,
      };
}
