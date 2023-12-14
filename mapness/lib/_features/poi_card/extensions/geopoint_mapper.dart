import 'package:dgis_map/library.dart';

extension GeopointMapper on GeoPointWithElevationMessage {
  GeoPointMessage toGeoPointMessage() {
    return GeoPointMessage(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
