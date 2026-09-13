import 'package:mapness/features/friends_on_map/models/friend.dart';

/// Server-side counterpart of the friend list (conceptually `GET
/// /v1/friends`). Mocked for this iteration — see
/// `features/friends_on_map/AGENTS.md`. No REST client exists yet for this
/// feature: there is nothing real to point one at until this repository's
/// real implementation is written.
abstract class FriendsRepository {
  Future<List<Friend>> getFriends();

  /// R-22: called once a friend request is accepted, establishing mutual
  /// visibility. A mock-only convenience — a real backend wouldn't need a
  /// client-initiated "add to my list" call, since accepting a request
  /// already does that server-side; this only exists so the mocked friend
  /// list can reflect it locally. See `features/friends_on_map/AGENTS.md`.
  Future<void> addFriend(Friend friend);
}
