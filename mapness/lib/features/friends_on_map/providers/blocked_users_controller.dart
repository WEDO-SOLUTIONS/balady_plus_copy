import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_controller.g.dart';

/// R-45: unblock, kept separate from the plain read above — same split as
/// `friend_requests.dart`'s list providers vs. `FriendRequestsController`.
///
/// keepAlive: this notifier is only ever reached via `.notifier` from a
/// confirm-sheet callback, never `ref.watch`/`ref.listen`ed — with nothing
/// keeping a listener on it, auto-dispose would tear it down almost
/// immediately after that one read. Against the real backend, the `await`ed
/// repository call now takes real network time, long enough for that
/// disposal to land mid-flight and throw on the trailing `ref.invalidate`
/// (see `providers/friends_controller.dart`'s matching note and AGENTS.md's
/// "Real backend wiring" section).
@Riverpod(keepAlive: true)
class BlockedUsersController extends _$BlockedUsersController {
  @override
  void build() {}

  /// Does not restore any previous friendship (BR-03 of S-12).
  Future<void> unblock(String id) async {
    await ref.read(blockedUsersRepositoryProvider).unblockUser(id);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(blockedUsersProvider);
  }
}
