import 'package:mapness/features/friends_on_map/data/blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/models/blocked_user.dart';

/// In-memory stand-in for the blocked-users list. Starts empty — nobody is
/// blocked until the user blocks someone.
class FakeBlockedUsersRepository implements BlockedUsersRepository {
  final List<BlockedUser> _blockedUsers = [];

  @override
  Future<List<BlockedUser>> getBlockedUsers() async => List.unmodifiable(_blockedUsers);

  @override
  Future<void> blockUser(BlockedUser user) async {
    _blockedUsers.add(user);
  }

  @override
  Future<void> unblockUser(String id) async {
    _blockedUsers.removeWhere((u) => u.id == id);
  }
}
