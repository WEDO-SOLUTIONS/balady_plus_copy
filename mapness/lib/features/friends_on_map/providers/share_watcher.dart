import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dgis_map/library.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_config.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_ipv4_http_client.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';
import 'package:mapness/features/friends_on_map/models/share_watch_state.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_watcher.g.dart';

// Same values as EtaGeoSubscriber's streamBreakTimeout/streamBreakTimerInterval
// (features/share_eta/providers/eta_geo_subscriber.dart) — a proven working
// staleness bar, no BRD-specified number to differ from.
const Duration _kNoDataTimeout = Duration(seconds: 30);
const Duration _kNoDataCheckInterval = Duration(seconds: 5);

/// Recipient-side S-19 watch channel — `GET /v1/shares/{token}/watch`
/// (upgraded to a WebSocket, no auth header at all: the token is the sole
/// secret and it's already in the URL path). Modeled on
/// `FriendsOnMapEventsSocket`'s raw-WebSocket connect shape and on
/// `EtaGeoSubscriber`'s staleness-timeout shape, but simpler than both:
/// exactly 3 frame types (`snapshot`/`position`/`expired`), no
/// route/reroute handling (S-19's eta payload is just
/// arrivalAt/distanceMeters, not a navigable route).
///
/// Explicitly started/stopped (not keepAlive) — the 5-concurrent-share cap
/// is sender-side only; a recipient only ever watches one link at a time.
@riverpod
class ShareWatcher extends _$ShareWatcher {
  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;
  Timer? _staleCheckTimer;
  DateTime? _lastFrameAt;
  // Camera is centered on the sharer only once per watch session (first
  // position) — re-centering on every ~8s frame would fight the user's own
  // panning.
  bool _didCenterCamera = false;

  @override
  ShareWatchState build() {
    ref.onDispose(_disconnect);
    return const ShareWatchState();
  }

  Future<void> startWatching(String token, {required ShareMode mode}) async {
    await stopWatching();
    // [mode] is known from the deep link's own query param — set it
    // immediately, not only from a `snapshot` frame. Previously `mode` only
    // ever came from the server's first frame, so a connection that failed
    // or dropped before that first frame left `mode` permanently null —
    // which silently defeated both this marker's `mode == live` gate and
    // `map_page.dart`'s own expiry-sheet listener (same gate), leaving a
    // failed watch indistinguishable from "still connecting" with nothing
    // in the logs either (see the onError/onDone logging added below).
    _didCenterCamera = false;
    state = ShareWatchState(mode: mode);
    try {
      final socket = await WebSocket.connect(
        _watchUri(token).toString(),
        customClient: createIpv4PreferringHttpClient(),
      );
      if (!ref.mounted) {
        unawaited(socket.close());
        return;
      }
      _socket = socket;
      _lastFrameAt = DateTime.now();
      _subscription = socket.listen(
        _onMessage,
        onError: (Object e) {
          logger.log('friends_on_map: share watch socket error: $e');
          _markExpired();
        },
        onDone: () {
          logger.log('friends_on_map: share watch socket closed');
          _markExpired();
        },
        cancelOnError: true,
      );
      _staleCheckTimer?.cancel();
      _staleCheckTimer = Timer.periodic(_kNoDataCheckInterval, (_) => _checkStale());
    } on Object catch (e) {
      logger.log('friends_on_map: share watch connect failed: $e');
      _markExpired();
    }
  }

  Future<void> stopWatching() async {
    _staleCheckTimer?.cancel();
    _staleCheckTimer = null;
    _lastFrameAt = null;
    await _subscription?.cancel();
    _subscription = null;
    await _socket?.close();
    _socket = null;
    // ShareWatchMarker only clears the map marker when this state is
    // reassigned (it's a bare `ref.watch`) — without this, a manual stop
    // left the last-drawn marker frozen on the map forever. Reset to the
    // plain default rather than `ShareWatchStatus.expired`: map_page.dart's
    // listener pops a "share expired" sheet on that exact transition, which
    // would be wrong messaging for a stop the user chose themselves.
    if (ref.mounted) {
      state = const ShareWatchState();
    }
  }

  void _onMessage(Object? raw) {
    if (!ref.mounted || raw is! String) {
      return;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _lastFrameAt = DateTime.now();
      switch (json['type']) {
        case 'snapshot':
        case 'position':
          _applyPosition(json);
        case 'expired':
          _markExpired();
      }
    } on Object catch (e) {
      logger.log('friends_on_map: share watch bad message: $e');
    }
  }

  void _applyPosition(Map<String, dynamic> json) {
    final eta = json['eta'] as Map<String, dynamic>?;
    state = state.copyWith(
      status: ShareWatchStatus.live,
      mode: json['mode'] == null ? null : ShareMode.fromWire(json['mode'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
      expiresAt: json['expiresAt'] == null ? null : DateTime.parse(json['expiresAt'] as String),
      sharerDisplayName: json['sharerDisplayName'] as String?,
      sharerAccountId: json['sharerAccountId'] as String?,
      etaArrivalAt: eta?['arrivalAt'] == null ? null : DateTime.parse(eta!['arrivalAt'] as String),
      etaDistanceMeters: (eta?['distanceMeters'] as num?)?.toDouble(),
      stale: false,
    );
    _centerCameraOnce();
  }

  // R-81: the holder must actually see the sharer's position — without this
  // the marker could be drawn off-screen. Live mode only; eta mode shows an
  // arrival card instead of a marker.
  void _centerCameraOnce() {
    if (_didCenterCamera || state.mode != ShareMode.live || !state.hasPosition) {
      return;
    }
    _didCenterCamera = true;
    final camera = ref.read(cameraPositionProvider);
    unawaited(
      ref
          .read(cameraPositionProvider.notifier)
          .animateTo(
            CameraPositionMessage(
              point: GeoPointMessage(latitude: state.lat!, longitude: state.lon!),
              zoom: camera?.zoom ?? 16,
              tilt: camera?.tilt ?? 0,
              bearing: camera?.bearing ?? 0,
            ),
          )
          .catchError((Object e) => logger.log('friends_on_map: share watch camera move failed: $e')),
    );
  }

  // BR-04: the server never sends a position after this — [state] is only
  // ever flipped to a terminal, position-free "expired" marker here.
  void _markExpired() {
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(status: ShareWatchStatus.expired);
    unawaited(stopWatching());
  }

  void _checkStale() {
    final lastFrameAt = _lastFrameAt;
    if (lastFrameAt == null) {
      return;
    }
    final isStale = DateTime.now().difference(lastFrameAt) > _kNoDataTimeout;
    if (isStale != state.stale) {
      state = state.copyWith(stale: isStale);
    }
  }

  void _disconnect() {
    _staleCheckTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_socket?.close());
  }

  Uri _watchUri(String token) => Uri.parse(
    '${friendsOnMapApiBaseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')}:443/v1/shares/$token/watch',
  );
}
