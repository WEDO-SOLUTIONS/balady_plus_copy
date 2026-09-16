import 'package:mapness/features/friends_on_map/providers/meetups_list.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meetups_controller.g.dart';

/// Create/dismiss actions, kept separate from the plain [receivedMeetups]
/// read — same split as `friends_controller.dart`/`friend_requests.dart`.
///
/// keepAlive from day one: only ever reached via `.notifier` from a button
/// callback, never watched — auto-dispose would tear it down mid-flight
/// against real network latency, exactly the bug `FriendsController`/
/// `FriendRequestsController` had to be fixed for after shipping.
@Riverpod(keepAlive: true)
class MeetupsController extends _$MeetupsController {
  @override
  void build() {}

  /// R-69: shares a place with one or more friends.
  Future<void> create({
    required List<String> recipientIds,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    await ref
        .read(meetupRepositoryProvider)
        .create(recipientIds: recipientIds, latitude: latitude, longitude: longitude, label: label);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(receivedMeetupsProvider);
  }

  Future<void> dismiss(String id) async {
    await ref.read(meetupRepositoryProvider).dismiss(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(receivedMeetupsProvider);
  }
}
