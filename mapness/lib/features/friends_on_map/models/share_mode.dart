/// S-19 (R-78-R-87): a temporary location/ETA sharing link's mode — see
/// `~/dev/code/wedo/go/balady-friends-service`'s `internal/api/handlers_shares.go`
/// for the wire contract this mirrors.
enum ShareMode {
  live,
  eta;

  String get wireValue => switch (this) {
    ShareMode.live => 'live',
    ShareMode.eta => 'eta',
  };

  static ShareMode fromWire(String value) => switch (value) {
    'eta' => ShareMode.eta,
    _ => ShareMode.live,
  };
}
