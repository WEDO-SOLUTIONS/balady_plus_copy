/// A friend as shown in the friend list (S-11) and on the map (S-13).
/// [latitude]/[longitude] are null when there's no position to show — R-19
/// omits a friend's position entirely rather than showing a placeholder.
/// [lastPositionAt] backs R-53's elapsed-time-on-the-card only (see
/// `friends_on_map/AGENTS.md` for why this isn't a real per-update server
/// timestamp) — no presence/district fields yet.
class Friend {
  final String id;
  final String displayName;
  final String? profilePictureUrl;
  final double? latitude;
  final double? longitude;
  final DateTime? lastPositionAt;

  const Friend({
    required this.id,
    required this.displayName,
    this.profilePictureUrl,
    this.latitude,
    this.longitude,
    this.lastPositionAt,
  });
}
