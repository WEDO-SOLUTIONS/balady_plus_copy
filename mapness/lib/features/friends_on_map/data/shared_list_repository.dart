import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';

/// Server-side counterpart of S-18's shared lists (`POST/GET /v1/lists`,
/// `GET/DELETE /v1/lists/{id}`, `POST /v1/lists/{id}/members`, `DELETE
/// /v1/lists/{id}/members/{accountId}`, `POST /v1/lists/{id}/leave`,
/// `POST/DELETE /v1/lists/{id}/places[/{placeId}]`). Only
/// `RemoteSharedListRepository` implements this — same reasoning as
/// `MeetupRepository`: the backend was built in the same pass, so there's
/// no pre-real-backend gap to bridge with a fake.
abstract class SharedListRepository {
  /// R-96: lists the current user owns or is a member of, newest-created
  /// first.
  Future<List<SharedList>> getLists();

  /// The full detail (members + items) of one list.
  Future<SharedListDetail> getList(String id);

  /// R-71: creates a list with the caller as its sole owner.
  Future<SharedList> create(String name);

  /// R-75/AC-10: owner-only, removes the list and everything in it.
  Future<void> delete(String id);

  /// R-72: owner-only, invites one or more accepted friends as members.
  Future<void> addMembers(String listId, List<String> accountIds);

  /// R-72: owner-only removal of another member.
  Future<void> removeMember(String listId, String accountId);

  /// R-75: the caller leaves a list they don't own.
  Future<void> leave(String listId);

  /// R-73: any member may add an entry.
  Future<SharedListItem> addItem(String listId, {required double latitude, required double longitude, String? label});

  /// R-73/AC-05: the adder, or the list's owner, may remove an entry.
  Future<void> removeItem(String listId, String itemId);
}
