import 'package:mapness/features/friends_on_map/data/invite_link_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_invite_link_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invite_link_repository.g.dart';

// Wired to the real backend (see AGENTS.md's "Real backend wiring" note) —
// `FakeInviteLinkRepository` is kept in the repo, unreferenced, as an easy
// fallback if this personal test deployment is down.
@riverpod
InviteLinkRepository inviteLinkRepository(Ref ref) =>
    RemoteInviteLinkRepository(ref.watch(friendsOnMapNetworkProvider));
