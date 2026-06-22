import 'package:dgis_map/library.dart';

class NavigationConstants {
  NavigationConstants._();

  // NB: THIS legacy list is what actually drives the in-navigation zoom. It is
  // applied in the native `setupCamera` right before `navigationManager.start*`,
  // and the SDK captures the speed→zoom sequence at that moment. A later
  // `setNavigationCameraSettings` only re-tilts live (TiltFollowController) — its
  // speedZoomRules do NOT override the zoom once navigation has started. So the
  // zoom sequence must be set here. Speed numbers match the simulation-speed
  // slider (km/h). TEST sequence: zoom RISES with speed (10 → 20).
  static final List<SpeedRangeZoom> navigationSpeedRangeZooms = [
    SpeedRangeZoom(minSpeedRange: 0, maxSpeedRange: 20, routeDistanceMillimeters: 0, styleZoomValue: 10),
    SpeedRangeZoom(minSpeedRange: 20, maxSpeedRange: 40, routeDistanceMillimeters: 0, styleZoomValue: 13),
    SpeedRangeZoom(minSpeedRange: 40, maxSpeedRange: 60, routeDistanceMillimeters: 0, styleZoomValue: 15),
    SpeedRangeZoom(minSpeedRange: 60, maxSpeedRange: 90, routeDistanceMillimeters: 0, styleZoomValue: 20),
    SpeedRangeZoom(minSpeedRange: 90, maxSpeedRange: 250, routeDistanceMillimeters: 0, styleZoomValue: 20),
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
    // NB: do NOT set minZoom/maxZoom here. CameraZoomRestrictions freezes the
    // navigation zoom-follow (observed: zoom pinned at ~18.9 regardless of
    // speed). The high-speed zoom floor that keeps the camera out of the SDK's
    // tilt-flatten zone (below ~z16 the SDK clamps tilt toward top-down) is
    // enforced via the speed→zoom bands in [_defaultSpeedZoomRules] instead.
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
    // Decreasing in zoom: low zoom (high speed) leans toward the horizon; high
    // zoom (low speed / near a maneuver) flattens toward top-down. Kept within the
    // z16–20 range the speed→zoom bands actually use — below ~z16 the SDK flattens
    // tilt regardless of this curve.
    StyleZoomTiltPoint(styleZoom: 16, tiltDegrees: 58),
    StyleZoomTiltPoint(styleZoom: 18, tiltDegrees: 45),
    StyleZoomTiltPoint(styleZoom: 20, tiltDegrees: 30),
  ];

  /// Converts km/h to the m/s used by the SDK's [SpeedRange].
  static double _kmh(double kmh) => kmh / 3.6;

  /// Speed→zoom rules. Thresholds are written in **km/h** and converted to the
  /// SDK's m/s [SpeedRange] via [_kmh], with finer granularity in the 0–60 km/h
  /// city range. **Faster → lower zoom (zooms out)**, which via
  /// [defaultTiltRelation] tilts the camera toward the horizon for more road
  /// ahead; slower → higher zoom (zooms in) + closer to top-down.
  ///
  /// StyleZoom must be **non-increasing as speed rises**, otherwise 2GIS rejects
  /// the whole sequence (`ZoomFollowSettings: Wrong StyleZoom and SpeedRange
  /// sequences. Skipped`) and zoom-by-speed silently stops working. The floor is
  /// kept ≥ ~16 so the camera stays out of the SDK's low-zoom tilt-flatten zone
  /// and [defaultTiltRelation] can hold its tilt.
  static final List<SpeedZoomRule> _defaultSpeedZoomRules = [
    ..._bandRules(minSpeed: _kmh(0), maxSpeed: _kmh(20), cruiseZoom: 19),
    ..._bandRules(minSpeed: _kmh(20), maxSpeed: _kmh(40), cruiseZoom: 18),
    ..._bandRules(minSpeed: _kmh(40), maxSpeed: _kmh(60), cruiseZoom: 17.5),
    ..._bandRules(minSpeed: _kmh(60), maxSpeed: _kmh(90), cruiseZoom: 17),
    ..._bandRules(minSpeed: _kmh(90), maxSpeed: _kmh(250), cruiseZoom: 16.5),
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
