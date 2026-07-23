import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/friends_on_map/model/friend_location.dart';

part 'friend_location_event.freezed.dart';

/// A single incremental change to one friend's location — either an
/// upsert (new/updated point) or a removal (friend stopped sharing).
@freezed
sealed class FriendLocationEvent with _$FriendLocationEvent {
  const factory FriendLocationEvent.updated(FriendLocation location) = FriendLocationUpdated;

  const factory FriendLocationEvent.removed(String userId) = FriendLocationRemoved;
}
