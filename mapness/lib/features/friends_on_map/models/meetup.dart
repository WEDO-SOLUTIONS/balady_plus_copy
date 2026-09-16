/// S-17 (reduced): a one-way "share a place with a friend" object, always
/// shown from the recipient's point of view — no [recipientId] field, same
/// as [Friend]/[BlockedUser] never carrying the caller's own id. No
/// delivery-status/read-receipt fields, matching this reduced story's scope.
class Meetup {
  final String id;
  final String senderId;
  final String senderDisplayName;
  final String? senderProfilePictureUrl;
  final double latitude;
  final double longitude;
  final String? label;
  final DateTime createdAt;

  const Meetup({
    required this.id,
    required this.senderId,
    required this.senderDisplayName,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.senderProfilePictureUrl,
    this.label,
  });
}
