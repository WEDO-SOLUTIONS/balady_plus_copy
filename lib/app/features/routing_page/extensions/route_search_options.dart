import 'package:dgis_map/library.dart';

/// getters for mapping the [RouteSearchOptionsMessage] enum to ui elements
extension RouteSearchOptionsMessageExtension on RouteSearchOptionsMessage {
  /// map index to [RouteSearchOptionsMessage] type
  int get indexTab {
    switch (this) {
      case RouteSearchOptionsMessage.car:
        return 0;
      case RouteSearchOptionsMessage.pedestrian:
        return 1;
      case RouteSearchOptionsMessage.bicycle:
        return 2;
      case RouteSearchOptionsMessage.publicTransport:
        return 3;
      default:
        throw ArgumentError("Invalid enum value: $this");
    }
  }

  /// map [RouteSearchOptionsMessage] type to the corresponding asset
  String get iconPath {
    switch (this) {
      case RouteSearchOptionsMessage.car:
        return "assets/icons/svg/routing/ic_car_filled.svg";
      case RouteSearchOptionsMessage.pedestrian:
        return "assets/icons/svg/routing/ic_pedestrian.svg";
      case RouteSearchOptionsMessage.bicycle:
        return "assets/icons/svg/routing/ic_bike.svg";
      case RouteSearchOptionsMessage.publicTransport:
        return "assets/icons/svg/routing/ic_bus.svg";
      default:
        throw ArgumentError("Invalid enum value: $this");
    }
  }
}

/// getter for mapping the ui to [RouteSearchOptionsMessage] type
extension IntRouteSearchOptionsMessageExtension on int {
  /// map [RouteSearchOptionsMessage] enum to the corresponding index
  RouteSearchOptionsMessage toRouteSearchOptionsMessage() {
    switch (this) {
      case 0:
        return RouteSearchOptionsMessage.car;
      case 1:
        return RouteSearchOptionsMessage.pedestrian;
      case 2:
        return RouteSearchOptionsMessage.bicycle;
      case 3:
        return RouteSearchOptionsMessage.publicTransport;
      default:
        throw ArgumentError("Invalid enum index: $this");
    }
  }
}
