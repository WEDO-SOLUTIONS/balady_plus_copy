import 'package:dgis_map/library.dart';

extension GeoPointWithElevationHelper on GeoPointWithElevationMessage {
  GeoPointMessage get geoPoint => GeoPointMessage(latitude: latitude, longitude: longitude);
}
