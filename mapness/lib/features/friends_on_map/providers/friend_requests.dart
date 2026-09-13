import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/providers/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_requests.g.dart';

/// R-36: requests addressed to the current user.
@riverpod
Future<List<FriendRequest>> incomingFriendRequests(Ref ref) =>
    ref.watch(friendRequestRepositoryProvider).getIncomingRequests();

/// R-37: requests the current user has sent, still pending.
@riverpod
Future<List<FriendRequest>> outgoingFriendRequests(Ref ref) =>
    ref.watch(friendRequestRepositoryProvider).getOutgoingRequests();

/// Accept/decline/cancel actions, kept separate from the plain list reads
/// above so a screen that only displays requests doesn't need to depend on
/// the mutation surface.
@riverpod
class FriendRequestsController extends _$FriendRequestsController {
  @override
  void build() {}

  /// R-22/R-38: accepting adds the request's sender as a real friend and
  /// establishes mutual visibility. No notification — see
  /// `features/friends_on_map/AGENTS.md` for why R-38's "notify the sender"
  /// half can't be demonstrated in a single-device mock.
  Future<void> accept(String id) async {
    final friend = await ref.read(friendRequestRepositoryProvider).acceptRequest(id);
    await ref.read(friendsRepositoryProvider).addFriend(friend);
    ref
      ..invalidate(incomingFriendRequestsProvider)
      ..invalidate(friendsListProvider);
  }

  /// R-38: silent — no friend created, no notification.
  Future<void> decline(String id) async {
    await ref.read(friendRequestRepositoryProvider).declineRequest(id);
    ref.invalidate(incomingFriendRequestsProvider);
  }

  /// R-37: withdraws a request this user sent.
  Future<void> cancel(String id) async {
    await ref.read(friendRequestRepositoryProvider).cancelRequest(id);
    ref.invalidate(outgoingFriendRequestsProvider);
  }
}
