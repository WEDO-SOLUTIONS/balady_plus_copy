import 'package:mapness/features/friends_on_map/models/blocked_user.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users.g.dart';

/// R-45: the blocked-users list. Also read by `invite_resolution_flow.dart`
/// (R-44/BR-02 of S-12) to reject resolving an invite whose token belongs to
/// a blocked identity.
@riverpod
Future<List<BlockedUser>> blockedUsers(Ref ref) => ref.watch(blockedUsersRepositoryProvider).getBlockedUsers();
