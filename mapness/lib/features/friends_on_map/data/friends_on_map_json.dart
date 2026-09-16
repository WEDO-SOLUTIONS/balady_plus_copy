import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/models/blocked_user.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_member.dart';

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

Meetup meetupFromJson(Map<String, dynamic> json) => Meetup(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  senderDisplayName: json['senderDisplayName'] as String,
  senderProfilePictureUrl: json['senderProfilePictureUrl'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  label: json['label'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

SharedList sharedListFromJson(Map<String, dynamic> json) => SharedList(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  memberCount: json['memberCount'] as int,
  itemCount: json['itemCount'] as int,
);

SharedListMember sharedListMemberFromJson(Map<String, dynamic> json) => SharedListMember(
  accountId: json['accountId'] as String,
  displayName: json['displayName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  isOwner: json['isOwner'] as bool,
  canRemove: json['canRemove'] as bool,
);

SharedListItem sharedListItemFromJson(Map<String, dynamic> json) => SharedListItem(
  id: json['id'] as String,
  adderId: json['adderId'] as String,
  adderDisplayName: json['adderDisplayName'] as String,
  adderProfilePictureUrl: json['adderProfilePictureUrl'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  label: json['label'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  canRemove: json['canRemove'] as bool,
);

SharedListDetail sharedListDetailFromJson(Map<String, dynamic> json) => SharedListDetail(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  callerRole: json['callerRole'] == 'owner' ? SharedListRole.owner : SharedListRole.member,
  members: (json['members'] as List<dynamic>).map((e) => sharedListMemberFromJson(e as Map<String, dynamic>)).toList(),
  items: (json['items'] as List<dynamic>).map((e) => sharedListItemFromJson(e as Map<String, dynamic>)).toList(),
);
