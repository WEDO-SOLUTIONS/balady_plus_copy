import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';

/// BALADY-3960: MapTapHandler takes over only the cursor tap during
/// guidance/free roam; every other map tap keeps its normal handling.
void main() {
  const latLng = LatLng(latitude: 24.7136, longitude: 46.6753);
  const cursorTap = MyLocationTapEvent(latLng);
  const poiTap = ObjectTapEvent(DgisObjectId(objectId: 70000001, entranceId: 0), latLng, null);
  final roadEventTap = RoadEventTapEvent(
    const DgisObjectId(objectId: 42, entranceId: 0),
    'Road closed',
    '',
    null,
    null,
    latLng,
  );

  test('a cursor tap in path nav and free roam opens the cursors sheet', () {
    expect(isCursorsSheetTap(cursorTap, topRouteName: PathNavRoute.name), isTrue);
    expect(isCursorsSheetTap(cursorTap, topRouteName: FreeRoamRoute.name), isTrue);
  });

  test('outside navigation the my-location tap keeps the share-location card', () {
    expect(isCursorsSheetTap(cursorTap, topRouteName: LandingRoute.name), isFalse);
    expect(isCursorsSheetTap(cursorTap, topRouteName: null), isFalse);
  });

  test('POI and road-event taps are never taken over, the sheet open or not', () {
    for (final route in [PathNavRoute.name, FreeRoamRoute.name]) {
      expect(isCursorsSheetTap(poiTap, topRouteName: route), isFalse);
      expect(isCursorsSheetTap(roadEventTap, topRouteName: route), isFalse);
    }
  });
}
