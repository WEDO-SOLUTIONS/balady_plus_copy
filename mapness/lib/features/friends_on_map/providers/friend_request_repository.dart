import 'package:mapness/features/friends_on_map/data/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_request_repository.g.dart';

// Wired to the real backend (see AGENTS.md's "Real backend wiring" note) —
// `FakeFriendRequestRepository` is kept in the repo, unreferenced, as an
// easy fallback if this personal test deployment is down.
@Riverpod(keepAlive: true)
FriendRequestRepository friendRequestRepository(Ref ref) =>
    RemoteFriendRequestRepository(ref.watch(friendsOnMapNetworkProvider));
