import 'package:mapness/features/friends_on_map/models/share_mode.dart';

/// A currently-active S-19 location/ETA share owned by this account (R-83).
/// [lastPositionLat]/[lastPositionLon]/[lastPositionAt] are null until the
/// first position push lands — see
/// `providers/active_shares_position_reporter.dart`. The recipient-facing
/// secret token is deliberately NOT a field here — it's only needed
/// transiently right after creation (see `data/active_shares_repository.dart`'s
/// `createShare`), kept out of the list/refresh shape so it never gets
/// echoed back through `GET /v1/shares` alongside the owner-facing [id].
class ActiveShare {
  final String id;
  final ShareMode mode;
  final DateTime createdAt;
  final DateTime expiresAt;
  final double? lastPositionLat;
  final double? lastPositionLon;
  final DateTime? lastPositionAt;

  const ActiveShare({
    required this.id,
    required this.mode,
    required this.createdAt,
    required this.expiresAt,
    this.lastPositionLat,
    this.lastPositionLon,
    this.lastPositionAt,
  });

  factory ActiveShare.fromJson(Map<String, dynamic> json) {
    final lastPosition = json['lastPosition'] as Map<String, dynamic>?;
    return ActiveShare(
      id: json['id'] as String,
      mode: ShareMode.fromWire(json['mode'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      lastPositionLat: (lastPosition?['lat'] as num?)?.toDouble(),
      lastPositionLon: (lastPosition?['lon'] as num?)?.toDouble(),
      lastPositionAt: lastPosition?['at'] == null ? null : DateTime.parse(lastPosition!['at'] as String),
    );
  }
}
