import 'package:mapness/shared/utils/detach.dart';

/// Serialises the show/hide calls of a map layer.
///
/// Layers like the bus overlays draw by clearing the whole object manager and
/// repopulating it. Two such calls in flight at once interleave their native
/// operations and leave the layer half-drawn - and they easily are, because
/// visibility is driven from two independent listeners (the camera and the
/// layer's own visibility provider).
///
/// A plain `isDrawn` flag does not help: it flips before the asynchronous work
/// starts, so it prevents a duplicate call in the same direction but nothing
/// about a show and a hide overlapping.
///
/// Here at most one [apply] runs at a time, and requests that arrive while it
/// runs collapse into the last one - the only state the caller actually wants.
final class MapLayerVisibilitySync {
  MapLayerVisibilitySync({
    required Future<void> Function({required bool visible}) apply,
    required bool Function() isDisposed,
    required String tag,
  }) : _apply = apply,
       _isDisposed = isDisposed,
       _tag = tag;

  final Future<void> Function({required bool visible}) _apply;
  final bool Function() _isDisposed;
  final String _tag;

  /// The state currently drawn on the map, or `null` before the first apply.
  bool? _applied;

  /// The state asked for while an apply was running.
  bool? _pending;

  bool _running = false;

  /// Asks for the layer to become [visible].
  ///
  /// Cheap to call from a listener on every camera frame: already-applied
  /// states are dropped, and nothing is awaited here.
  void request({required bool visible}) {
    if (_isDisposed()) {
      return;
    }
    if (!_running && _applied == visible) {
      return;
    }
    _pending = visible;
    if (_running) {
      return;
    }
    _running = true;
    detach(_drain(), tag: _tag);
  }

  Future<void> _drain() async {
    try {
      while (_pending != null && _pending != _applied && !_isDisposed()) {
        final next = _pending!;
        _pending = null;
        await _apply(visible: next);
        _applied = next;
      }
    } finally {
      _running = false;
      _pending = null;
    }
  }
}
