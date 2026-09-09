import 'package:mapness/features/friends_on_map/data/fake_invite_link_repository.dart';
import 'package:mapness/features/friends_on_map/data/invite_link_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invite_link_repository.g.dart';

// Backend mocked for this iteration — see AGENTS.md. This is the only seam
// a real Dio-backed implementation needs to replace.
@riverpod
InviteLinkRepository inviteLinkRepository(Ref ref) => FakeInviteLinkRepository();
