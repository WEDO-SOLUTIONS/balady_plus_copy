import 'package:dgis_map/library.dart';

/// Growing a geographic rectangle around its own centre.
extension GeoRectExpanded on GeoRectMessage {
  /// Returns this rectangle scaled by [by] about its centre - 1.5 makes it
  /// half again as wide and as tall. Values of 1 or less are ignored and the
  /// rectangle is returned unchanged, so this only ever grows.
  GeoRectMessage expandedBy(double by) {
    {
      if (by <= 1) {
        //Don't scale it down
        return this;
      }

      final percent = (by - 1) / 2;
      final latDelta = ((northEast.latitude - southWest.latitude) * percent).abs();
      final lonDelta = ((northEast.longitude - southWest.longitude) * percent).abs();

      final expanded = GeoRectMessage(
        northEast: GeoPointMessage(latitude: northEast.latitude + latDelta, longitude: northEast.longitude + lonDelta),
        southWest: GeoPointMessage(latitude: southWest.latitude - latDelta, longitude: southWest.longitude - lonDelta),
      );

      return expanded;
    }
  }
}
