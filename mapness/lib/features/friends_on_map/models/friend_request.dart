/// A friend request, either addressed to the current user
/// ([FriendRequestDirection.incoming], R-36) or sent by them
/// ([FriendRequestDirection.outgoing], R-37).
enum FriendRequestDirection { incoming, outgoing }

class FriendRequest {
  final String id;
  final String displayName;
  final String? profilePictureUrl;
  final FriendRequestDirection direction;

  const FriendRequest({
    required this.id,
    required this.displayName,
    required this.direction,
    this.profilePictureUrl,
  });
}
