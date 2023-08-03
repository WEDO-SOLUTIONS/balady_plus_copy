enum ZoomControlType { zoomIn, zoomOut }

class ZoomControlEnabledEvent {
  const ZoomControlEnabledEvent(this.button, this.isEnabled);

  static const zoomInEvent = 'zoomInEvent';
  static const zoomOutEvent = 'zoomOutEvent';

  final bool isEnabled;
  final ZoomControlType button;
}
