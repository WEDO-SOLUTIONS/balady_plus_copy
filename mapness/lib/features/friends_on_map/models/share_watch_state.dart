import 'package:mapness/features/friends_on_map/models/share_mode.dart';

enum ShareWatchStatus { connecting, live, expired }

/// Recipient-side S-19 watch state — see `providers/share_watcher.dart`.
/// [stale] is the client-side belt-and-suspenders staleness flip (R-82),
/// separate from [status] going to [ShareWatchStatus.expired], which is the
/// server-authoritative end state (BR-04).
class ShareWatchState {
  final ShareWatchStatus status;
  final ShareMode? mode;
  final double? lat;
  final double? lon;
  final DateTime? at;
  final DateTime? expiresAt;
  final String? sharerDisplayName;
  // Lets the map marker pick the exact same themed illustration a friend
  // marker would show for this same person (`friend_marker_illustration.dart`
  // hashes off an identity string — display name alone doesn't match the
  // friend marker's own `friend.id` seed). Only ever sent on a `snapshot`
  // frame, same as [sharerDisplayName] — `copyWith`'s `??` fallback below
  // means a later `position` frame omitting it never clears an
  // already-known id.
  final String? sharerAccountId;
  final DateTime? etaArrivalAt;
  final double? etaDistanceMeters;
  final bool stale;

  const ShareWatchState({
    this.status = ShareWatchStatus.connecting,
    this.mode,
    this.lat,
    this.lon,
    this.at,
    this.expiresAt,
    this.sharerDisplayName,
    this.sharerAccountId,
    this.etaArrivalAt,
    this.etaDistanceMeters,
    this.stale = false,
  });

  bool get hasPosition => lat != null && lon != null;

  ShareWatchState copyWith({
    ShareWatchStatus? status,
    ShareMode? mode,
    double? lat,
    double? lon,
    DateTime? at,
    DateTime? expiresAt,
    String? sharerDisplayName,
    String? sharerAccountId,
    DateTime? etaArrivalAt,
    double? etaDistanceMeters,
    bool? stale,
  }) => ShareWatchState(
    status: status ?? this.status,
    mode: mode ?? this.mode,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    at: at ?? this.at,
    expiresAt: expiresAt ?? this.expiresAt,
    sharerDisplayName: sharerDisplayName ?? this.sharerDisplayName,
    sharerAccountId: sharerAccountId ?? this.sharerAccountId,
    etaArrivalAt: etaArrivalAt ?? this.etaArrivalAt,
    etaDistanceMeters: etaDistanceMeters ?? this.etaDistanceMeters,
    stale: stale ?? this.stale,
  );
}
