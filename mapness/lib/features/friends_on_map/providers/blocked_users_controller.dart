import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_controller.g.dart';

/// R-45: unblock, kept separate from the plain read above — same split as
/// `friend_requests.dart`'s list providers vs. `FriendRequestsController`.
@riverpod
class BlockedUsersController extends _$BlockedUsersController {
  @override
  void build() {}

  /// Does not restore any previous friendship (BR-03 of S-12).
  Future<void> unblock(String id) async {
    await ref.read(blockedUsersRepositoryProvider).unblockUser(id);
    ref.invalidate(blockedUsersProvider);
  }
}
