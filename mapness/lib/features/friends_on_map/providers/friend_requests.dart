import 'package:mapness/features/friends_on_map/models/blocked_user.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_repository.dart';
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
///
/// keepAlive: this notifier is only ever reached via `.notifier` from a
/// button/confirm-sheet callback, never `ref.watch`/`ref.listen`ed — with
/// nothing keeping a listener on it, auto-dispose would tear it down almost
/// immediately after that one read. Against the real backend, the
/// `await`ed repository calls now take real network time, long enough for
/// that disposal to land mid-flight and throw on a trailing
/// `ref.invalidate` (see `providers/friends_controller.dart`'s matching
/// note and AGENTS.md's "Real backend wiring" section).
@Riverpod(keepAlive: true)
class FriendRequestsController extends _$FriendRequestsController {
  @override
  void build() {}

  /// R-22/R-38: accepting adds the request's sender as a real friend and
  /// establishes mutual visibility. No notification — see
  /// `features/friends_on_map/AGENTS.md` for why R-38's "notify the sender"
  /// half can't be demonstrated in a single-device mock.
  Future<void> accept(String id) async {
    final friend = await ref.read(friendRequestRepositoryProvider).acceptRequest(id);
    if (!ref.mounted) {
      return;
    }
    await ref.read(friendsRepositoryProvider).addFriend(friend);
    if (!ref.mounted) {
      return;
    }
    ref
      ..invalidate(incomingFriendRequestsProvider)
      ..invalidate(friendsListProvider);
  }

  /// R-38: silent — no friend created, no notification.
  Future<void> decline(String id) async {
    await ref.read(friendRequestRepositoryProvider).declineRequest(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(incomingFriendRequestsProvider);
  }

  /// R-37: withdraws a request this user sent.
  Future<void> cancel(String id) async {
    await ref.read(friendRequestRepositoryProvider).cancelRequest(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(outgoingFriendRequestsProvider);
  }

  /// R-44: block on an incoming request — declines it (so it also leaves
  /// the incoming list) and records the block. Only genuinely prevents a
  /// future invite resolution for a request whose id is a real invite token
  /// (i.e. one that went through scan/link) — the two seeded fixture
  /// requests in `FakeFriendRequestRepository` have no such token, see
  /// `features/friends_on_map/AGENTS.md`.
  ///
  /// Blocks before declining (not the other way around): against the real
  /// backend, blocking resolves the token to the requester's account id via
  /// the still-pending request row (`handleBlockUser`) and already deletes
  /// that request as part of blocking — declining first would leave nothing
  /// for the block call to resolve against. The trailing `declineRequest`
  /// then legitimately 404s against the real backend; the remote repository
  /// treats that as an already-applied no-op (see AGENTS.md's "Real backend
  /// wiring" note).
  Future<void> blockIncoming(FriendRequest request) async {
    await ref
        .read(blockedUsersRepositoryProvider)
        .blockUser(
          BlockedUser(id: request.id, displayName: request.displayName, profilePictureUrl: request.profilePictureUrl),
        );
    if (!ref.mounted) {
      return;
    }
    await ref.read(friendRequestRepositoryProvider).declineRequest(request.id);
    if (!ref.mounted) {
      return;
    }
    ref
      ..invalidate(incomingFriendRequestsProvider)
      ..invalidate(blockedUsersProvider);
  }
}
