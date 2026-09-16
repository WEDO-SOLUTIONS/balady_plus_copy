import 'package:mapness/features/friends_on_map/data/friends_on_map_position_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_friends_on_map_position_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_position_repository.g.dart';

// Wired to the real backend (see AGENTS.md's "Real backend wiring" note) —
// `FakeFriendsOnMapPositionRepository` is kept in the repo, unreferenced, as
// an easy fallback if this personal test deployment is down.
@riverpod
FriendsOnMapPositionRepository friendsOnMapPositionRepository(Ref ref) =>
    RemoteFriendsOnMapPositionRepository(ref.watch(friendsOnMapNetworkProvider));
