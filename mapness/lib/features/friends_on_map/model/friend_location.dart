import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_location.freezed.dart';
part 'friend_location.g.dart';

@freezed
abstract class FriendLocation with _$FriendLocation {
  const factory FriendLocation({
    required String userId,
    required double latitude,
    required double longitude,
    required DateTime lastUpdated,
    required int batteryLevel,
  }) = _FriendLocation;

  factory FriendLocation.fromJson(Map<String, dynamic> json) => _$FriendLocationFromJson(json);
}
