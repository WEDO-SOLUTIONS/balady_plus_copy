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

  /// Maneuver-distance window edge (mm) used to split each speed band into a
  /// "near a maneuver" rule and a "cruising" rule.
  static const double _maneuverZoneMm = 500000; // 500 m
  static const double _farMm = 1000000000; // ~1000 km (effectively unbounded)

  /// Full default navigation-camera configuration applied via
  /// [DgisMapController.setNavigationCameraSettings]. Unlike
  /// [navigationSpeedRangeZooms] it uses real maneuver-distance windows (so the
  /// camera zooms in before a turn), drives tilt from zoom, and configures the
  /// follow behaviour and animation timings. Speeds are in m/s; distances in mm.
  static final NavigationCameraSettings defaultNavigationCameraSettings = NavigationCameraSettings(
    speedZoomRules: _defaultSpeedZoomRules,
    freeRoamSpeedZoomRules: _defaultSpeedZoomRules,
    tiltRelation: defaultTiltRelation,
    followBehaviour: CameraFollowBehaviourMessage(
      followBearing: true,
      followStyleZoom: true,
      followTilt: true,
    ),
    followReturnDelaySeconds: 15,
    zoomTuning: ZoomFollowTuning(
      styleZoomSpeedRangesAnimationMs: 500,
      zoomInBeforeManeuverAnimationMs: 700,
      zoomOutAfterManeuverAnimationMs: 700,
      distanceGapToManeuverMm: _maneuverZoneMm,
    ),
  );

  /// Zoom→tilt curve: flatter (more top-down) when zoomed in near a maneuver,
  /// steeper 3D chase when zoomed out at speed. Tilt in degrees.
  static final List<StyleZoomTiltPoint> defaultTiltRelation = [
    StyleZoomTiltPoint(styleZoom: 15, tiltDegrees: 55),
    StyleZoomTiltPoint(styleZoom: 17, tiltDegrees: 45),
    StyleZoomTiltPoint(styleZoom: 19, tiltDegrees: 35),
    StyleZoomTiltPoint(styleZoom: 23, tiltDegrees: 20),
  ];

  /// Per speed band: a "near maneuver" rule (zoomed in) and a "cruising" rule.
  static final List<SpeedZoomRule> _defaultSpeedZoomRules = [
    ..._bandRules(minSpeed: 0, maxSpeed: 5, cruiseZoom: 22),
    ..._bandRules(minSpeed: 5, maxSpeed: 20, cruiseZoom: 20),
    ..._bandRules(minSpeed: 20, maxSpeed: 60, cruiseZoom: 18),
    ..._bandRules(minSpeed: 60, maxSpeed: 200, cruiseZoom: 16.5),
  ];

  static List<SpeedZoomRule> _bandRules({
    required double minSpeed,
    required double maxSpeed,
    required double cruiseZoom,
  }) => [
    SpeedZoomRule(
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      minDistanceToManeuverMm: 0,
      maxDistanceToManeuverMm: _maneuverZoneMm,
      styleZoom: cruiseZoom + 1, // zoom in closer near a maneuver
    ),
    SpeedZoomRule(
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      minDistanceToManeuverMm: _maneuverZoneMm,
      maxDistanceToManeuverMm: _farMm,
      styleZoom: cruiseZoom,
    ),
  ];
}
