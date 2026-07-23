import 'package:mapness/features/friends_on_map/model/friend_location.dart';
import 'package:mapness/features/friends_on_map/model/friend_location_event.dart';

abstract class FriendsDataSource {
  /// One-shot fetch of all currently known friend locations.
  Future<List<FriendLocation>> getFriendLocations();

  /// Streams incremental changes — one friend per event, either an upsert
  /// or a removal. Does not replay [getFriendLocations]; callers must fetch
  /// the initial snapshot separately before subscribing.
  Stream<FriendLocationEvent> watchFriendLocationUpdates();
}
