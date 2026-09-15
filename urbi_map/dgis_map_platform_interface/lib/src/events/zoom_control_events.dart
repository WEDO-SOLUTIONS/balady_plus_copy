/// The two buttons of the on-map zoom control.
enum ZoomControlType {
  /// The button that zooms the map in.
  zoomIn,

  /// The button that zooms the map out.
  zoomOut,
}

/// Reports that one of the zoom buttons became available or unavailable,
/// which happens when the map reaches its minimum or maximum zoom.
class ZoomControlEnabledEvent {
  /// Creates the event for [button] with its new [isEnabled] state.
  const ZoomControlEnabledEvent({required this.button, required this.isEnabled});

  /// Name of the platform channel event carrying the zoom-in button's state.
  static const zoomInEvent = 'zoomInEvent';

  /// Name of the platform channel event carrying the zoom-out button's state.
  static const zoomOutEvent = 'zoomOutEvent';

  /// Whether the button can still be pressed.
  final bool isEnabled;

  /// Which of the two zoom buttons this is about.
  final ZoomControlType button;
}
