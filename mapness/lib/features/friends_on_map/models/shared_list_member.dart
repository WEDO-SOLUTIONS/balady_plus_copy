/// One member (or the owner) of a [SharedList]. [canRemove] is
/// server-computed relative to the caller (owner may remove any non-owner
/// row) — this client has no account id of its own to compare against, so
/// the server tells it directly rather than the client re-deriving it.
class SharedListMember {
  final String accountId;
  final String displayName;
  final String? profilePictureUrl;
  final bool isOwner;
  final bool canRemove;

  const SharedListMember({
    required this.accountId,
    required this.displayName,
    required this.isOwner,
    required this.canRemove,
    this.profilePictureUrl,
  });
}
