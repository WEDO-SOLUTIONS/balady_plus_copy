import 'package:dgis_map/library.dart';

extension VisibleRectExpanded on VisibleRectMessage {
  VisibleRectMessage expandedBy(double by) {
    {
      if (by <= 1) {
        //Don't scale it down
        return this;
      }

      final percent = (by - 1) / 2;
      final latDelta =
          ((northEast.latitude - southWest.latitude) * percent).abs();
      final lonDelta =
          ((northEast.longitude - southWest.longitude) * percent).abs();

      final expanded = VisibleRectMessage(
          northEast: GeoPointMessage(
            latitude: northEast.latitude + latDelta,
            longitude: northEast.longitude + lonDelta,
          ),
          southWest: GeoPointMessage(
            latitude: southWest.latitude - latDelta,
            longitude: southWest.longitude - lonDelta,
          ));

      return expanded;
    }
  }
}
