import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';

Future<void> computeCameraPosition(
  List<Marker> markers,
  CameraPositionMessage? cameraPosition,
  Future<void> Function(CameraPositionMessage) animateTo,
) async {
  var location = cameraPosition?.point;
  if (cameraPosition == null || location == null) {
    try {
      final position = await Geolocator.getCurrentPosition();
      location = GeoPointMessage(latitude: position.latitude, longitude: position.longitude);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      location = null;
    }
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
