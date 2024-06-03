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
