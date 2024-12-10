import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';

@Deprecated(
  'Search automatically zoom by markers nearby. Look at [Search] provider method [_animateToRepresentativeArea]',
)
Future<void> computeCameraPosition(
  List<Marker> markers,
  CameraPositionMessage? cameraPosition,
  Position? userLocation,
  Future<void> Function(CameraPositionMessage) animateTo,
) async {
  var location = cameraPosition?.point;
  if (location == null && userLocation != null) {
    location = GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude);
  }

  if (location == null) {
    return;
  }

  var zoom = await GeoUtils.zoomByMarkersNearby(
    markers: markers,
    position: location,
  );
  if (cameraPosition?.zoom != null) {
    zoom = cameraPosition!.zoom < zoom ? cameraPosition.zoom : zoom;
  }

  await animateTo(
    CameraPositionMessage(
      point: location,
      tilt: cameraPosition?.tilt ?? 0.0,
      bearing: cameraPosition?.bearing ?? 0.0,
      zoom: zoom,
    ),
  );
}
