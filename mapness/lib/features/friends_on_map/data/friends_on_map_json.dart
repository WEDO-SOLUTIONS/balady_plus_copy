import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/models/blocked_user.dart';

/// Shared JSON decoding for the real backend's DTOs (see
/// `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md` /
/// `internal/model/model.go` in the server repo) — field names match the
/// client's own Dart models exactly, since the server's DTOs were written
/// against these models as the source of truth.
Friend friendFromJson(Map<String, dynamic> json) => Friend(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  lastPositionAt: json['lastPositionAt'] == null ? null : DateTime.parse(json['lastPositionAt'] as String),
);

FriendRequest friendRequestFromJson(Map<String, dynamic> json) => FriendRequest(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  direction: json['direction'] == 'incoming' ? FriendRequestDirection.incoming : FriendRequestDirection.outgoing,
);

BlockedUser blockedUserFromJson(Map<String, dynamic> json) => BlockedUser(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
);
