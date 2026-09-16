import 'dart:io';

/// An [HttpClient] that prefers an IPv4 address when connecting.
///
/// Fly.io hosts (like the personal test deployment this feature talks to)
/// are dual-stack (A + AAAA). Android emulators typically have no IPv6 route
/// at all, which surfaces as `SocketException: Network is unreachable, errno
/// = 101` the moment the OS tries the AAAA address — this host is always
/// reachable over IPv4, so prefer that address explicitly instead of leaving
/// the choice to the platform's DNS ordering. Shared by the REST Dio client
/// (`friends_on_map_network.dart`) and the events WebSocket
/// (`friends_on_map_events_socket.dart`), since `WebSocket.connect` uses its
/// own `HttpClient` for the upgrade request rather than going through Dio.
HttpClient createIpv4PreferringHttpClient() => HttpClient()
  // Disables client-side keep-alive reuse (dart:io's default is 15s). This
  // client talks to a personal Fly.io test deployment behind a proxy whose
  // own idle-connection timeout is unknown and could easily be shorter —
  // reusing a connection the far side already closed silently produces
  // `HttpException: Connection closed before full header was received`
  // (confirmed hit on a real device, 3 requests in a row, while the server
  // itself was independently verified healthy and fast at the same time).
  // Every request opening a fresh connection costs a few hundred extra ms,
  // a non-issue for this low-traffic feature, in exchange for removing this
  // whole failure class.
  ..idleTimeout = Duration.zero
  ..connectionFactory = (uri, proxyHost, proxyPort) async {
    final addresses = await InternetAddress.lookup(uri.host);
    final ipv4 = addresses.firstWhere((a) => a.type == InternetAddressType.IPv4, orElse: () => addresses.first);
    // `Uri.port` only knows a default for "http"/"https" — dart:io's
    // WebSocket.connect internally rewrites "wss"/"ws" to "https"/"http" for
    // its own HttpClient request, but a `wss://host/path` URL with no
    // explicit `:443` in it still carries a `.port` of 0 through to this
    // factory (confirmed: caused a real `Can't assign requested address,
    // errno = 49` connecting to port 0). Every endpoint this client talks to
    // is HTTPS/WSS-only, so 0 unambiguously means "use 443".
    final port = uri.port == 0 ? 443 : uri.port;

    // A custom `connectionFactory` completely opts out of dart:io's own
    // automatic TLS wrapping for secure requests — confirmed by reading
    // `_http/http_impl.dart`: the `isSecure ? SecureSocket.startConnect(...)
    // : Socket.startConnect(...)` branch only runs when NO custom factory is
    // set; with one set, its returned socket is used as-is. Returning a
    // plain `Socket` here (as this used to) meant every request/WS upgrade
    // was sending plaintext straight at Fly's TLS-terminating edge on port
    // 443, which closes the connection immediately — this was the real
    // cause of a real, reproducible `HttpException: Connection closed
    // before full header was received` on every endpoint. Upgrading
    // explicitly here fixes it. `host: uri.host` (the real hostname, not
    // the IP we connected to) is required for correct SNI and certificate
    // hostname verification against Fly's shared, multi-tenant edge — see
    // `io/secure_socket.dart`'s own docs on `SecureSocket.secure`'s `host`
    // parameter.
    final task = await Socket.startConnect(ipv4, port);
    final secureSocket = task.socket.then((socket) => SecureSocket.secure(socket, host: uri.host));
    return ConnectionTask.fromSocket(secureSocket, task.cancel);
  };
