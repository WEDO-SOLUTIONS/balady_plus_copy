import 'package:mapness/features/friends_on_map/models/meetup.dart';

/// Server-side counterpart of the meetup share graph (`POST/GET /v1/meetups`,
/// `DELETE /v1/meetups/{id}`) — S-17 (reduced). Only `RemoteMeetupRepository`
/// implements this: unlike every earlier slice in this feature, the backend
/// work happened in the same pass as this client work, so there's no
/// pre-real-backend gap to bridge with a fake.
abstract class MeetupRepository {
  /// R-69: shares a place with one or more friends — one independent
  /// [Meetup] per recipient is returned.
  Future<List<Meetup>> create({
    required List<String> recipientIds,
    required double latitude,
    required double longitude,
    String? label,
  });

  /// Places shared with the current user, newest first.
  Future<List<Meetup>> getReceivedMeetups();

  /// Removes the current user's own copy. The sender has no "unsend" in this
  /// reduced design.
  Future<void> dismiss(String id);
}
