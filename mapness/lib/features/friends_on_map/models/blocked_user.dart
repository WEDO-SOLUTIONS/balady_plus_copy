/// A user blocked by the current user (S-12, R-44/R-45). Not necessarily a
/// former friend — an incoming friend request's sender can be blocked
/// without ever having been accepted.
class BlockedUser {
  final String id;
  final String displayName;
  final String? profilePictureUrl;

  const BlockedUser({required this.id, required this.displayName, this.profilePictureUrl});
}
