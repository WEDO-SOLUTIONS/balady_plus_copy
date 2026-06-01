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
  /// follow behaviour and animation timings. Speed thresholds are authored in
  /// km/h (converted to the SDK's m/s); distances are in mm.
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

  /// Zoom→tilt curve. 2GIS `Tilt` is measured from top-down: **0° = straight
  /// down, higher = toward the horizon = more road visible ahead**. The curve is
  /// decreasing in zoom. Combined with the speed→zoom table below (faster → lower
  /// zoom) it gives the requested behaviour: **faster → zoomed out + tilted toward
  /// the horizon (more road ahead); slower → zoomed in + closer to top-down
  /// (detail for maneuvers)**. Tilt in degrees.
  static final List<StyleZoomTiltPoint> defaultTiltRelation = [
    StyleZoomTiltPoint(styleZoom: 16, tiltDegrees: 60), // fast / zoomed out → toward horizon (road ahead)
    StyleZoomTiltPoint(styleZoom: 18, tiltDegrees: 50),
    StyleZoomTiltPoint(styleZoom: 20, tiltDegrees: 38),
    StyleZoomTiltPoint(styleZoom: 22, tiltDegrees: 28),
    StyleZoomTiltPoint(styleZoom: 23, tiltDegrees: 22), // slow / zoomed in → closer to top-down
  ];

  /// Converts km/h to the m/s used by the SDK's [SpeedRange].
  static double _kmh(double kmh) => kmh / 3.6;

  /// Speed→zoom rules. Thresholds are written in **km/h** and converted to the
  /// SDK's m/s [SpeedRange] via [_kmh], with finer granularity in the 0–60 km/h
  /// city range. **Faster → lower zoom (zooms out)**, which via
  /// [defaultTiltRelation] tilts the camera toward the horizon for more road
  /// ahead; slower → higher zoom (zooms in) + closer to top-down.
  static final List<SpeedZoomRule> _defaultSpeedZoomRules = [
    ..._bandRules(minSpeed: _kmh(0), maxSpeed: _kmh(20), cruiseZoom: 20),
    ..._bandRules(minSpeed: _kmh(20), maxSpeed: _kmh(40), cruiseZoom: 19),
    ..._bandRules(minSpeed: _kmh(40), maxSpeed: _kmh(60), cruiseZoom: 18),
    ..._bandRules(minSpeed: _kmh(60), maxSpeed: _kmh(90), cruiseZoom: 17),
    ..._bandRules(minSpeed: _kmh(90), maxSpeed: _kmh(250), cruiseZoom: 16),
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
