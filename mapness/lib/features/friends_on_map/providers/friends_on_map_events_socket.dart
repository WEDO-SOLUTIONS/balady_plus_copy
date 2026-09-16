import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mapness/features/friends_on_map/data/friends_on_map_api_config.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_ipv4_http_client.dart';
import 'package:mapness/features/friends_on_map/providers/friend_requests.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_service_token.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_list.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_events_socket.g.dart';

const Duration _kMinBackoff = Duration(seconds: 1);
const Duration _kMaxBackoff = Duration(seconds: 30);

/// Live "something changed" push from the real backend's `GET /v1/events`
/// (upgraded to a WebSocket) — see `~/dev/code/wedo/go/balady-friends-service`'s
/// `internal/api/hub.go`. Messages are deliberately just invalidation hints
/// (`{"type": "friends_changed" | "requests_changed" | "meetups_changed"}`), never a full
/// payload: the client already trusts the REST endpoints for real data, so
/// there's no second schema to keep in sync.
///
/// Fixes a real gap found via two-device testing: without this, a friend
/// request's sender never learns their request was accepted (or that a
/// friend removed/blocked them) unless they close and reopen the relevant
/// screen — accept/remove/block only invalidate providers in the *other*
/// device's own provider container. See `features/friends_on_map/AGENTS.md`.
///
/// keepAlive + watched from `ui/friends_on_map_page.dart`'s `build()`: stays
/// connected for as long as that page (or anything pushed on top of it,
/// like the friend list/requests routes) remains mounted, same cascade
/// pattern as `friendMarkersProvider`/`friendsOnMapPositionReporterProvider`
/// elsewhere in this feature.
@Riverpod(keepAlive: true)
class FriendsOnMapEventsSocket extends _$FriendsOnMapEventsSocket {
  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;
  Duration _backoff = _kMinBackoff;

  @override
  void build() {
    ref.onDispose(_disconnect);
    unawaited(_connect());
  }

  Future<void> _connect() async {
    if (!ref.mounted) {
      return;
    }
    try {
      final token = await ref.read(friendsOnMapServiceTokenProvider.future);
      if (!ref.mounted) {
        return;
      }
      final socket = await WebSocket.connect(
        friendsOnMapEventsUri.toString(),
        headers: {'Authorization': 'Bearer $token'},
        customClient: createIpv4PreferringHttpClient(),
      );
      if (!ref.mounted) {
        unawaited(socket.close());
        return;
      }
      _socket = socket;
      _backoff = _kMinBackoff;
      _subscription = socket.listen(
        _onMessage,
        onError: (Object _) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );
    } on Object catch (e) {
      logger.log('friends_on_map: events socket connect failed: $e');
      _scheduleReconnect();
    }
  }

  void _onMessage(Object? raw) {
    if (!ref.mounted || raw is! String) {
      return;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      switch (json['type']) {
        case 'friends_changed':
          ref.invalidate(friendsListProvider);
        case 'requests_changed':
          ref
            ..invalidate(incomingFriendRequestsProvider)
            ..invalidate(outgoingFriendRequestsProvider);
        case 'meetups_changed':
          ref.invalidate(receivedMeetupsProvider);
      }
    } on Object catch (e) {
      logger.log('friends_on_map: events socket bad message: $e');
    }
  }

  void _scheduleReconnect() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    _socket = null;
    if (!ref.mounted) {
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_backoff, () => unawaited(_connect()));
    final doubled = _backoff * 2;
    _backoff = doubled > _kMaxBackoff ? _kMaxBackoff : doubled;
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_socket?.close());
  }

  /// Called from the app-resume hook (`ui/friends_on_map_page.dart`) since
  /// backgrounding can silently kill the socket (OS suspension, or the
  /// personal test server's Fly machine scaling to zero while idle) —
  /// forces an immediate reconnect attempt instead of waiting out whatever
  /// backoff was already in flight.
  void reconnectNow() {
    if (_socket != null) {
      return;
    }
    _reconnectTimer?.cancel();
    _backoff = _kMinBackoff;
    unawaited(_connect());
  }
}
