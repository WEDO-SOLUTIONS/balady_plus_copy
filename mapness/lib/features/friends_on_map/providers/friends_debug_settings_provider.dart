import 'package:mapness/features/friends_on_map/providers/data/mock/mock_friends_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_debug_settings_provider.g.dart';

/// Debug-panel controls for `MockFriendsDataSource` (see
/// `widgets/debug_overlay/friends_debug_panel.dart`). keepAlive so the
/// chosen values survive closing the debug sheet. Changing either rebuilds
/// `friendsDataSourceProvider`, which recreates the mock with the new point
/// count / tick interval — applied immediately.
@Riverpod(keepAlive: true)
class FriendsDebugPointsCount extends _$FriendsDebugPointsCount {
  @override
  int build() => kFriendsMockDefaultPoints;

  void setPointsCount(int value) => state = value.clamp(kFriendsMockMinPoints, kFriendsMockMaxPoints);
}

@Riverpod(keepAlive: true)
class FriendsDebugUpdateIntervalSeconds extends _$FriendsDebugUpdateIntervalSeconds {
  @override
  int build() => kFriendsMockDefaultIntervalSeconds;

  void setUpdateIntervalSeconds(int value) =>
      state = value.clamp(kFriendsMockMinIntervalSeconds, kFriendsMockMaxIntervalSeconds);
}
