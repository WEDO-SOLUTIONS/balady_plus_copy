/// Emitted by the native map whenever the vehicle enters or leaves a tunnel on the
/// active navigation route. The map surface is already re-themed natively by the time
/// this arrives; the event lets the Flutter side follow with the rest of the app.
class TunnelStateEvent {
  const TunnelStateEvent({required this.inTunnel});

  static const name = "tunnelStateChanged";

  final bool inTunnel;
}
