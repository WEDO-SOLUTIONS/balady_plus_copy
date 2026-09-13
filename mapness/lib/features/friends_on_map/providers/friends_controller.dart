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
@riverpod
class FriendsController extends _$FriendsController {
  @override
  void build() {}

  /// R-43: only ends visibility on this device — see
  /// `features/friends_on_map/AGENTS.md` for the single-device-mock
  /// limitation.
  Future<void> removeFriend(String id) async {
    await ref.read(friendsRepositoryProvider).removeFriend(id);
    ref.invalidate(friendsListProvider);
  }

  /// R-44: ends the friendship (same effect as [removeFriend]) and records
  /// the block so a future invite resolution using this identity's token is
  /// rejected — see `providers/invite_resolution_flow.dart`.
  Future<void> blockFriend(Friend friend) async {
    await ref.read(friendsRepositoryProvider).removeFriend(friend.id);
    await ref
        .read(blockedUsersRepositoryProvider)
        .blockUser(
          BlockedUser(id: friend.id, displayName: friend.displayName, profilePictureUrl: friend.profilePictureUrl),
        );
    ref
      ..invalidate(friendsListProvider)
      ..invalidate(blockedUsersProvider);
  }
}
