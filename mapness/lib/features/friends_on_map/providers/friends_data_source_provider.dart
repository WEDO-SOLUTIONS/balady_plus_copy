import 'package:mapness/features/friends_on_map/providers/data/friends_data_source.dart';
import 'package:mapness/features/friends_on_map/providers/data/mock/mock_friends_data_source.dart';
import 'package:mapness/features/friends_on_map/providers/friends_debug_settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_data_source_provider.g.dart';

// Watches the debug-panel settings so tweaking a slider recreates the mock
// (and everything downstream watching it, e.g. FriendsMarkers) immediately.
@riverpod
FriendsDataSource friendsDataSource(Ref ref) => MockFriendsDataSource(
  pointsCount: ref.watch(friendsDebugPointsCountProvider),
  tickInterval: Duration(seconds: ref.watch(friendsDebugUpdateIntervalSecondsProvider)),
);
