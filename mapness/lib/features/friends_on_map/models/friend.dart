/// A friend as shown in the friend list (S-11) and on the map (S-13).
/// [latitude]/[longitude] are null when there's no position to show — R-19
/// omits a friend's position entirely rather than showing a placeholder; no
/// presence/district/freshness fields yet, those need a timestamp model
/// decision not made yet (see `friends_on_map/AGENTS.md`).
class Friend {
  final String id;
  final String displayName;
  final String? profilePictureUrl;
  final double? latitude;
  final double? longitude;

  const Friend({
    required this.id,
    required this.displayName,
    this.profilePictureUrl,
    this.latitude,
    this.longitude,
  });
}
