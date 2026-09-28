import 'package:dgis_map/library.dart';

/// Returns true when it consumed the tap; otherwise the default handling runs.
typedef PriorityMapTapHandler = bool Function(TapEvent event);

/// Map taps of the screen that takes them over for a while (active guidance).
class PriorityMapTapSlot {
  PriorityMapTapHandler? _handler;

  // ignore: avoid_setters_without_getters
  set handler(PriorityMapTapHandler handler) => _handler = handler;

  /// Clears the handler; with [owner] given, only if it is still the active one.
  void reset([PriorityMapTapHandler? owner]) {
    if (owner == null || owner == _handler) {
      _handler = null;
    }
  }

  /// True when the handler consumed [event]. An object tap right after a Makkah marker tap
  /// belongs to that marker and always goes to the default handling.
  bool dispatch(TapEvent event, {required bool makkahMarkerTapPending}) {
    final handler = _handler;
    if (handler == null || (event is ObjectTapEvent && makkahMarkerTapPending)) {
      return false;
    }
    return handler(event);
  }
}
