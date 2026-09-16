import 'package:mapness/features/friends_on_map/data/friends_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_friends_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_repository.g.dart';

// Wired to the real backend (see AGENTS.md's "Real backend wiring" note) —
// `FakeFriendsRepository` is kept in the repo, unreferenced, as an easy
// fallback if this personal test deployment is down.
//
// keepAlive: same reasoning as before the switch — an accepted friend must
// survive the friend list screen being unmounted and remounted.
@Riverpod(keepAlive: true)
FriendsRepository friendsRepository(Ref ref) => RemoteFriendsRepository(ref.watch(friendsOnMapNetworkProvider));
