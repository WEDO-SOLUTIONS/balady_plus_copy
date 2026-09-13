import 'package:mapness/features/friends_on_map/models/blocked_user.dart';

/// Server-side counterpart of the blocked-users list (conceptually `GET/POST
/// /v1/blocked-users`). Mocked for this iteration — see
/// `features/friends_on_map/AGENTS.md`.
abstract class BlockedUsersRepository {
  Future<List<BlockedUser>> getBlockedUsers();

  /// R-44: called from both the friend card and an incoming friend request.
  Future<void> blockUser(BlockedUser user);

  /// R-45: does not restore any previous friendship (BR-03 of S-12).
  Future<void> unblockUser(String id);
}
