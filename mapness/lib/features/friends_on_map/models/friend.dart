/// A friend as shown in the friend list (S-11). Deliberately minimal: no
/// position, presence, or district fields yet — those need real data from a
/// backend this feature doesn't have (see `friends_on_map/AGENTS.md`).
class Friend {
  final String id;
  final String displayName;
  final String? profilePictureUrl;

  const Friend({required this.id, required this.displayName, this.profilePictureUrl});
}
