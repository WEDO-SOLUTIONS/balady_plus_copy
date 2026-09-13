import 'package:mapness/features/friends_on_map/data/blocked_users_repository.dart';
import 'package:mapness/features/friends_on_map/data/fake_blocked_users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_repository.g.dart';

// Backend mocked for this iteration — see AGENTS.md.
//
// keepAlive: the fake holds mutable state (blocked users) that must survive
// the blocked-users screen being unmounted — same reasoning as
// friendsRepositoryProvider.
@Riverpod(keepAlive: true)
BlockedUsersRepository blockedUsersRepository(Ref ref) => FakeBlockedUsersRepository();
