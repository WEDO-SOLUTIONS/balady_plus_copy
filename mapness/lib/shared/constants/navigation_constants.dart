import 'package:dgis_map/library.dart';

class NavigationConstants {
  NavigationConstants._();

  /// The DGis SDK validates this sequence (see ZoomFollowSettings): consecutive speed
  /// intervals must overlap (maxSpeed[i] > minSpeed[i+1]), otherwise the whole sequence
  /// is silently rejected and the SDK default speed-dependent zoom stays active.
  static final List<SpeedRangeZoom> navigationSpeedRangeZooms = [
    SpeedRangeZoom(
      minSpeedRange: 0,
      maxSpeedRange: 6,
      routeDistanceMillimeters: 30_000,
      styleZoomValue: 22,
    ),
    SpeedRangeZoom(
      minSpeedRange: 5,
      maxSpeedRange: 16,
      routeDistanceMillimeters: 100_000,
      styleZoomValue: 20,
    ),
    SpeedRangeZoom(
      minSpeedRange: 15,
      maxSpeedRange: 28,
      routeDistanceMillimeters: 200_000,
      styleZoomValue: 18,
    ),
    SpeedRangeZoom(
      minSpeedRange: 27,
      maxSpeedRange: 1000,
      routeDistanceMillimeters: 300_000,
      styleZoomValue: 16.5,
    ),
  ];
}
