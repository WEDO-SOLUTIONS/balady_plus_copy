import 'package:mapness/features/friends_on_map/data/blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_repository.g.dart';

// Wired to the real backend (see AGENTS.md's "Real backend wiring" note) —
// `FakeBlockedUsersRepository` is kept in the repo, unreferenced, as an easy
// fallback if this personal test deployment is down.
@Riverpod(keepAlive: true)
BlockedUsersRepository blockedUsersRepository(Ref ref) =>
    RemoteBlockedUsersRepository(ref.watch(friendsOnMapNetworkProvider));
