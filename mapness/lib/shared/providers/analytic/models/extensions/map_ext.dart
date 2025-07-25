import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';

const emptyBssMap = BssMap(inviewport: []);

extension MapExt on VisibleRect {
  BssMap toBssMap() => BssMap(
        inviewport: [
          BssViewport(lat: northEastLat, lon: northEastLon),
          BssViewport(lat: southWestLat, lon: northEastLon),
          BssViewport(lat: southWestLat, lon: southWestLon),
          BssViewport(lat: northEastLat, lon: southWestLon),
        ],
        zoomLevel: zoom,
      );
}
