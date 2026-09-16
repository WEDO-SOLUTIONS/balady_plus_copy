/// A place entry within a [SharedList] — same place shape as [Meetup]
/// (D-06 resolved pragmatically: free-text label + raw lat/lng, no POI
/// directory). [canRemove] is server-computed: the caller added it, or is
/// the list's owner (R-73/AC-05).
class SharedListItem {
  final String id;
  final String adderId;
  final String adderDisplayName;
  final String? adderProfilePictureUrl;
  final double latitude;
  final double longitude;
  final String? label;
  final DateTime createdAt;
  final bool canRemove;

  const SharedListItem({
    required this.id,
    required this.adderId,
    required this.adderDisplayName,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.canRemove,
    this.adderProfilePictureUrl,
    this.label,
  });
}
