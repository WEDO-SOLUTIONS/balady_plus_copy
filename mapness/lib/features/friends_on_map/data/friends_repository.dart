import 'package:mapness/features/friends_on_map/models/friend.dart';

/// Server-side counterpart of the friend list (conceptually `GET
/// /v1/friends`). Mocked for this iteration — see
/// `features/friends_on_map/AGENTS.md`. No REST client exists yet for this
/// feature: there is nothing real to point one at until this repository's
/// real implementation is written.
abstract class FriendsRepository {
  Future<List<Friend>> getFriends();
}
