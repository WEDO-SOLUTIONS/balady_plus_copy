import 'package:dgis_map/library.dart';

extension LatLngX on LatLng {
  GeoPointMessage get geoPoint => GeoPointMessage(latitude: latitude, longitude: longitude);
}
