import 'dart:async';
import 'dart:math' as math;

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Requests the content for [rect]. Returns `false` only when the request genuinely failed; a request that was
/// cancelled or superseded is not a failure.
typedef CameraRefetch = Future<bool> Function(VisibleRect rect);

/// Decides when region-level content that follows the map camera (stories, interesting places) is refetched.
///
/// The camera moves constantly (panning, zooming, following the user, flying to a POI), while such content is about a
/// region, not about the exact viewport. [onCamera] therefore triggers [refetch] only when all of these hold:
/// - the gate is not [paused];
/// - the camera moved meaningfully since the last request: the centre is more than
///   `max(minDistanceMeters, viewportFraction * half-diagonal of the last viewport)` away, or the zoom differs by at
///   least [minZoomDelta] levels. The absolute floor (10 km by default) is roughly a district-to-district move in a
///   city and never fires while panning at street zoom; the relative part keeps a zoomed-out map (whose viewport is
///   hundreds of kilometres wide) from refetching on every nudge;
/// - at least [minInterval] passed since the previous request. A camera event that comes too early is not dropped:
///   it is re-checked when the interval ends, so the final resting position is always covered.
///
/// Camera events that arrive while paused are only remembered. Un-pausing re-checks the latest one after
/// [resumeDelay] (a settle window for the camera animation that usually accompanies closing a card or a search), so
/// the content catches up with a single request, and only if the camera really moved in the meantime.
///
/// The gate performs no request itself and never throws: [refetch] is expected to handle its own errors, anything that
/// still escapes is logged.
class CameraRefetchGate {
  CameraRefetchGate({
    required this.refetch,
    this.minDistanceMeters = 10000,
    this.viewportFraction = 0.5,
    this.minZoomDelta = 3,
    this.minInterval = const Duration(seconds: 5),
    this.resumeDelay = const Duration(seconds: 1),
    this.refineUnbounded = true,
    bool paused = false,
  }) : _paused = paused;

  final CameraRefetch refetch;
  final double minDistanceMeters;
  final double viewportFraction;
  final double minZoomDelta;
  final Duration minInterval;
  final Duration resumeDelay;

  /// Whether the first camera position refines content that was requested without a viewport (`markFetched(null)`).
  /// When `false`, the unbounded content is assumed to cover wherever the map opened.
  final bool refineUnbounded;

  bool _paused;
  bool _disposed = false;
  Timer? _timer;
  VisibleRect? _camera;
  _Baseline? _baseline;
  DateTime? _lastRequestAt;
  int _sequence = 0;

  bool get paused => _paused;

  set paused(bool value) {
    if (_paused == value || _disposed) {
      return;
    }
    _paused = value;
    if (value) {
      _timer?.cancel();
      _timer = null;
    } else {
      _schedule(resumeDelay);
    }
  }

  /// Records that the content for [rect] (`null`: requested without a viewport) has just been loaded by the caller,
  /// e.g. by the initial request.
  void markFetched(VisibleRect? rect) {
    _baseline = _Baseline(rect);
    _lastRequestAt = DateTime.now();
  }

  /// Feeds the latest settled camera position.
  void onCamera(VisibleRect rect) {
    _camera = rect;
    _evaluate();
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
  }

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, () {
      _timer = null;
      _evaluate();
    });
  }

  void _evaluate() {
    _timer?.cancel();
    _timer = null;
    final camera = _camera;
    if (_disposed || _paused || camera == null) {
      return;
    }

    final baseline = _baseline;
    final isRefine = baseline != null && baseline.rect == null;
    if (isRefine && !refineUnbounded) {
      // The unbounded content is taken to cover the place the map opened at; measure movement from here on.
      _baseline = _Baseline(camera);
      return;
    }
    final base = baseline?.rect;
    if (base != null && !_movedEnough(camera, base)) {
      return;
    }

    // Refining unbounded content is a one-off, not a repeat request: it does not wait for the interval.
    final wait = isRefine ? Duration.zero : _intervalLeft();
    if (wait > Duration.zero) {
      _schedule(wait);
      return;
    }

    final id = ++_sequence;
    _baseline = _Baseline(camera);
    _lastRequestAt = DateTime.now();
    unawaited(_run(id, camera, baseline));
  }

  Future<void> _run(int id, VisibleRect camera, _Baseline? previous) async {
    var succeeded = true;
    try {
      succeeded = await refetch(camera);
    } on Object catch (error, stackTrace) {
      succeeded = false;
      logger.log('Camera refetch failed: $error\n$stackTrace', logLevel: MapnessLogLevel.error);
    }
    if (!succeeded && id == _sequence && !_disposed) {
      // The failed request does not cover this area: the next camera event or resume retries, subject to the interval.
      _baseline = previous;
    }
  }

  Duration _intervalLeft() {
    final lastRequestAt = _lastRequestAt;
    if (lastRequestAt == null) {
      return Duration.zero;
    }
    return minInterval - DateTime.now().difference(lastRequestAt);
  }

  bool _movedEnough(VisibleRect camera, VisibleRect base) {
    if ((camera.zoom - base.zoom).abs() >= minZoomDelta) {
      return true;
    }
    final distance = camera.distanceMeters(point1: camera.center(), point2: base.center());
    return distance > math.max(minDistanceMeters, viewportFraction * base.distanceToNW());
  }
}

/// What the last request was made for: a viewport, or (`rect == null`) no viewport at all.
class _Baseline {
  const _Baseline(this.rect);

  final VisibleRect? rect;
}
