import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/providers/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/providers/shared_list_repository.dart';
import 'package:mapness/features/friends_on_map/providers/shared_lists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_lists_controller.g.dart';

/// Create/delete/membership/item actions, kept separate from the plain
/// [sharedLists]/[sharedListDetail] reads — same split as
/// `friends_controller.dart`/`friend_requests.dart`.
///
/// keepAlive from day one: only ever reached via `.notifier` from a button
/// callback, never watched — auto-dispose would tear it down mid-flight
/// against real network latency, the exact bug `FriendsController`/
/// `FriendRequestsController` had to be fixed for after shipping.
@Riverpod(keepAlive: true)
class SharedListsController extends _$SharedListsController {
  @override
  void build() {}

  /// R-71: creates a list with the caller as sole owner. Returns the
  /// created list so the caller can navigate straight into its detail page.
  Future<SharedList> create(String name) async {
    final list = await ref.read(sharedListRepositoryProvider).create(name);
    if (!ref.mounted) {
      return list;
    }
    ref.invalidate(sharedListsProvider);
    return list;
  }

  /// R-75/AC-10: owner-only.
  Future<void> delete(String listId) async {
    await ref.read(sharedListRepositoryProvider).delete(listId);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(sharedListsProvider);
  }

  /// R-72: owner-only.
  Future<void> addMembers(String listId, List<String> accountIds) async {
    await ref.read(sharedListRepositoryProvider).addMembers(listId, accountIds);
    if (!ref.mounted) {
      return;
    }
    _invalidateList(listId);
  }

  /// R-72: owner-only removal of another member.
  Future<void> removeMember(String listId, String accountId) async {
    await ref.read(sharedListRepositoryProvider).removeMember(listId, accountId);
    if (!ref.mounted) {
      return;
    }
    _invalidateList(listId);
  }

  /// R-75: the caller leaves a list they don't own.
  Future<void> leave(String listId) async {
    await ref.read(sharedListRepositoryProvider).leave(listId);
    if (!ref.mounted) {
      return;
    }
    _invalidateList(listId);
  }

  /// R-73: any member may add an entry.
  Future<void> addItem(String listId, {required double latitude, required double longitude, String? label}) async {
    await ref
        .read(sharedListRepositoryProvider)
        .addItem(listId, latitude: latitude, longitude: longitude, label: label);
    if (!ref.mounted) {
      return;
    }
    _invalidateList(listId);
  }

  /// R-73/AC-05: the adder, or the list's owner, may remove an entry.
  Future<void> removeItem(String listId, String itemId) async {
    await ref.read(sharedListRepositoryProvider).removeItem(listId, itemId);
    if (!ref.mounted) {
      return;
    }
    _invalidateList(listId);
  }

  // Index rows show live member/entry counts, so any detail mutation must
  // refresh both the specific detail instance and the index.
  void _invalidateList(String listId) {
    ref
      ..invalidate(sharedListDetailProvider(listId))
      ..invalidate(sharedListsProvider);
  }
}
