import 'package:mapness/features/friends_on_map/models/blocked_user.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_controller.g.dart';

/// Remove/block actions from the friend list and the friend card (R-43/R-44
/// on the card — see `ui/widgets/friend_card_sheet.dart`). Kept separate
/// from the plain `friendsListProvider` read, same split as
/// `friend_requests.dart`'s list providers vs. `FriendRequestsController`.
///
/// keepAlive: this notifier is only ever reached via `.notifier` from a
/// button/confirm-sheet callback, never `ref.watch`/`ref.listen`ed — with
/// nothing keeping a listener on it, auto-dispose would tear it down almost
/// immediately after that one read. Against the real backend, the
/// `await`ed repository call now takes real network time, long enough for
/// that disposal to land mid-flight and throw on the trailing
/// `ref.invalidate` (a bug this feature actually hit once real HTTP calls
/// replaced the instant in-memory fakes — see AGENTS.md's "Real backend
/// wiring" note).
@Riverpod(keepAlive: true)
class FriendsController extends _$FriendsController {
  @override
  void build() {}

  /// R-43: only ends visibility on this device — see
  /// `features/friends_on_map/AGENTS.md` for the single-device-mock
  /// limitation.
  Future<void> removeFriend(String id) async {
    await ref.read(friendsRepositoryProvider).removeFriend(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(friendsListProvider);
  }

  /// R-44: ends the friendship (same effect as [removeFriend]) and records
  /// the block so a future invite resolution using this identity's token is
  /// rejected — see `providers/invite_resolution_flow.dart`.
  ///
  /// Blocks before removing (not the other way around): against the real
  /// backend, blocking already removes the friendship server-side
  /// (`handleBlockUser`) by resolving the target from the still-current
  /// friendship — removing first would leave nothing for the block call to
  /// resolve against. The trailing `removeFriend` is then a harmless,
  /// already-applied no-op (see AGENTS.md's "Real backend wiring" note).
  Future<void> blockFriend(Friend friend) async {
    await ref
        .read(blockedUsersRepositoryProvider)
        .blockUser(
          BlockedUser(id: friend.id, displayName: friend.displayName, profilePictureUrl: friend.profilePictureUrl),
        );
    if (!ref.mounted) {
      return;
    }
    await ref.read(friendsRepositoryProvider).removeFriend(friend.id);
    if (!ref.mounted) {
      return;
    }
    ref
      ..invalidate(friendsListProvider)
      ..invalidate(blockedUsersProvider);
  }
}
