enum ZoomControlType { zoomIn, zoomOut }

class ZoomControlEnabledEvent {
  const ZoomControlEnabledEvent({required this.button, required this.isEnabled});

  static const zoomInEvent = 'zoomInEvent';
  static const zoomOutEvent = 'zoomOutEvent';

  final bool isEnabled;
  final ZoomControlType button;
}
