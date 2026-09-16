/// Base URL of the real Friends on Map backend (BE-213) — a personal Fly.io
/// test deployment built from `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`
/// (source also mirrored at `~/dev/code/wedo/go/balady-friends-service`), not
/// a provisioned environment. Deliberately NOT added to `EnvironmentConfig`
/// (`shared/config/environment_config.dart`), which is reserved for the
/// app's real per-environment backends sourced from Firebase Remote
/// Config — this is a throwaway cross-device test server for this feature
/// only, with nothing to select between environments for yet.
const String friendsOnMapApiBaseUrl = 'https://balady-friends-service.fly.dev';

/// Live "something changed" event stream (`GET /v1/events`, upgraded to a
/// WebSocket) — same base URL, `https`/`http` swapped for `wss`/`ws`. See
/// `providers/friends_on_map_events_socket.dart`.
///
/// The port is spelled out explicitly (`:443`): `Uri.port` only has a known
/// default for the "http"/"https" schemes, not "ws"/"wss" — a `wss://`
/// string with no explicit port carries a `.port` of 0 all the way through
/// `WebSocket.connect`'s internal HttpClient request into a custom
/// `connectionFactory`, which caused a real `Can't assign requested address`
/// connecting to port 0. `createIpv4PreferringHttpClient` also defends
/// against this independently, but there's no reason to rely on only one of
/// the two fixes.
final Uri friendsOnMapEventsUri = Uri.parse(
  '${friendsOnMapApiBaseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')}:443/v1/events',
);
