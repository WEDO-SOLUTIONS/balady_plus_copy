import 'package:dgis_map/library.dart';

class NavigationConstants {
  NavigationConstants._();

  static final List<SpeedRangeZoom> navigationSpeedRangeZooms = [
    SpeedRangeZoom(
      maxSpeedRange: 5,
      minSpeedRange: 0,
      routeDistanceMillimeters: 0,
      styleZoomValue: 22,
    ),
    SpeedRangeZoom(
      maxSpeedRange: 20,
      minSpeedRange: 5,
      routeDistanceMillimeters: 20,
      styleZoomValue: 20,
    ),
    SpeedRangeZoom(
      maxSpeedRange: 60,
      minSpeedRange: 20,
      routeDistanceMillimeters: 100,
      styleZoomValue: 18,
    ),
    SpeedRangeZoom(
      maxSpeedRange: 200,
      minSpeedRange: 60,
      routeDistanceMillimeters: 300,
      styleZoomValue: 16.5,
    ),
  ];
}
